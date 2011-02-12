mox.require([
	'mox.lang.LangPack',
	'mox.Event',
	'mox.DOM',
	'mox.List',
	'mox.tpl.Template',
	'mox.data.SelectableResultSet',
	'mox.ui.WindowManager',
	'mox.dom.Layer',
	'mox.dom.Tween',
	'moxiecode.manager.FileManager',
	'mox.geom.Point',
	'mox.geom.Rect',
	'mox.data.ResultSet',
	'mox.String',
	'mox.ui.Menu',
	'mox.ui.MenuItem',
	'mox.ui.DropMenu',
	'mox.ui.DropMenuItem',
	'mox.ui.ContextMenu',
	'moxiecode.manager.BaseManager',
	'mox.dom.Drag',
	'mox.util.Dispatcher',
	'mox.net.JSON',
	'mox.net.Cookie',
	'moxiecode.manager.DevKit'
], function() {
	// Shorten class names
	var Event = mox.Event;
	var Template = mox.tpl.Template;
	var SelectableResultSet = mox.data.SelectableResultSet;
	var DOM = mox.DOM;
	var WindowManager = mox.ui.WindowManager;
	var Layer = mox.dom.Layer;
	var LangPack = mox.lang.LangPack;
	var Tween = mox.dom.Tween;
	var List = mox.List;
	var DevKit = moxiecode.manager.DevKit;
	var ContextMenu = mox.ui.ContextMenu;
	var Cookie = mox.net.Cookie;

	// Class that contains all theme specific logic
	mox.create('static mox.manager.FileManagerDefaultTheme', {
		path : '',
		rootpath : null,
		fileListTpl : null,
		listFilesResult : null,
		sortBy : 'name',
		sortDir : false,
		lastSort : null,
		lastIdx : -1,
		renameIdx : -1,
		clipboard : null,
		clipAction : null,
		imageManagerURL : null,
		visualPath : null,
		demoMode : false,
		rememberPath : 'auto',

		init : function() {
			var win;

			mcFileManager.onError.add(this.onError);

			this.fileListTpl = new Template('filelist', 'filelist_item_template');

			this.fileListTpl.addEncoder('sizefix', this.fixSize);

			this.path = "{default}";

			// Get parent args
			win = this.getParentWin();

			try {
				if (win && win.mcFileManager) {
					args = win.mcFileManager.getArgs();

					if (args.path)
						this.path = args.path;

					if (args.rootpath)
						this.rootpath = args.rootpath;

					if (args.remember_last_path != null)
						this.rememberPath = args.remember_last_path;

					if (args.url && this.path == '{default}') {
						this.listURL = args.url.substring(0, args.url.lastIndexOf('/'));
						this.listFile = args.url.substring(args.url.lastIndexOf('/') + 1);
					}
				}
			} catch (ex) {
				// Ignore
			}

			Event.add(window, 'DOMContentLoaded', this.onDOMContentLoaded, this);
			Event.add(window, 'mousedown', function(e) {
				if (DOM.getParent(e.target, function(n) {return n.nodeName == 'INPUT';}))
					return true;

				FileManagerTheme.endRename();

				return true;
			});
		},

		getParentWin : function() {
			var w = opener || parent;

			return w != window ? w : null;
		},

		onError : function(m, e, r, co, text) {
			if (typeof(e) == 'object') {
				if (e.level == 'AUTH') {
					if (r.login_url.indexOf('://') == -1)
						document.location = mox.baseURL + "/../" + r.login_url + "?return_url=" + escape(document.location);
					else
						document.location = r.login_url + "?return_url=" + escape(document.location);

					return;
				}

				WindowManager.error('Fatal error: ' + e.errstr + "\n" + e.errfile + (e.errline ? "\nLine: " + e.errline : ''));
			} else {
				if (e.indexOf('JSON failure') != -1)
					WindowManager.status(e, mox.String.xmlEncode(mox.String.stripTags('' + text)));
				else
					WindowManager.error(e);
			}
		},

		checkDemo : function() {
			if (this.demoMode)
				WindowManager.error(LangPack.get('error', 'demo'));

			return this.demoMode;
		},

		fixSize : function(val, row) {
			val = parseInt(val);

			if (row.type == 'folder' || row.type == 'parent')
				return '';

			// MB
			if (val > 1048576)
				return Math.round(val / 1048576, 1) + " MB";

			// KB
			if (val > 1024)
				return Math.round(val / 1024, 1) + " KB";

			return val + " b";
		},

		onDOMContentLoaded : function() {
			var m;

			LangPack.translatePage();

			DevKit.init('fm');
			//DevKit.show();

			this.loadSettings();
			this.listRoots();
			this.listFiles();

			Event.add(DOM.get('filelist'), 'click', this.rowEvent, this);
			Event.add(DOM.get('filelist'), 'dblclick', this.rowEvent, this);
			Event.add(DOM.get('filelist'), 'contextmenu', this.rowEvent, this);
			Event.add(DOM.get('filelist'), 'selectstart', Event.cancel, this); // Remove text selections

			this.resizeView();
			Event.add(window, 'resize', this.resizeView, this);

			// Setup context menu
			m = this.menu = new ContextMenu();

			m.appendItem(m.createItem(LangPack.get('actions', 'addfavorites'), 'javascript:FileManagerTheme.addFavorites();', {id : 'menu_addfavorite'}));
			m.appendItem(m.createItem(LangPack.get('actions', 'removefavorites'), 'javascript:FileManagerTheme.removeFavorites();', {id : 'menu_removefavorite'}));
			m.appendItem(m.createItem(LangPack.get('actions', 'cut'), 'javascript:FileManagerTheme.cut();', {id : 'menu_cut'}));
			m.appendItem(m.createItem(LangPack.get('actions', 'copy'), 'javascript:FileManagerTheme.copy();', {id : 'menu_copy'}));
			m.appendItem(m.createItem(LangPack.get('actions', 'paste'), 'javascript:FileManagerTheme.paste();', {id : 'menu_paste'}));
			m.appendItem(m.createItem(LangPack.get('actions', 'rename'), 'javascript:FileManagerTheme.renameFiles();', {id : 'menu_rename'}));
			m.appendItem(m.createItem(LangPack.get('actions', 'deleteit'), 'javascript:FileManagerTheme.deleteFiles();', {id : 'menu_delete'}));
			m.appendItem(m.createItem(LangPack.get('actions', 'zip'), 'javascript:FileManagerTheme.zipFiles();', {id : 'menu_zip'}));

			m.render();

			var fadeIn = new Tween(m._id, {
				opacity : {from : 3, to : 90}
			},{
				time : 300
			});

			var fadeOut = new Tween(m._id, {
				opacity : {from : 90, to : 3}
			},{
				time : 300
			});

			fadeOut.onEnd.add(function() {
				DOM.hide(m._id);
			});

			m.onContextMenu.add(function(e, p) {
				if (!DOM.getParent(e.target, function(n) {return n.id == 'filelist';})) {
					m.hide();
					return false;
				}

				return true;
			});

			m.onShow.add(function(e, p) {
				fadeOut.stop();
				fadeIn.start();
			});

			m.onHide.add(function(e, p) {
				if (!DOM.isHidden(m._id)) {
					fadeIn.stop();
					fadeOut.start();
				}

				return false;
			});
		},

		resizeView : function() {
			DOM.setStyle('filemanagerlist', 'height', (DOM.getViewPort().h - 140) + 'px');
		},

		toggleAllRows : function(s) {
			var rs = this.listFilesResult;

			if (s) {
				rs.unselectAll();
				rs.selectRows(0, rs.getRowCount() - 1);

				if (rs.getRow(0).type == 'parent')
					rs.unselectRow(0);
			}

			if ((s && rs.selected.length > 0) || (!s && this.lastIdx == -1))
				this.setToolsActive(s);

			List.map(rs.selected, function(i, v) {
				if (DOM.get('file_' + v)) {
					if (s)
						DOM.addClass('file_' + v, 'selected');
					else
						DOM.removeClass('file_' + v, 'selected');
				}
			});

			if (!s)
				rs.unselectAll();
		},

		endRename : function() {
			var nl;

			if (this.renameIdx != -1) {
				nl = DOM.select('#file_' + this.renameIdx + " input");

				if (nl.length > 0) {
					Event.removeAll(nl[0]);
					nl[0].parentNode.removeChild(nl[0]);
				}

				DOM.removeClass('file_' + this.renameIdx, 'rename');
				this.renameIdx = -1;
			}
		},

		rowClick : function(tr, id, idx, e) {
			var td, row, rs = this.listFilesResult, nl, cmc = e.type == 'contextmenu', p;

			if (mox.isOpera && e.altKey) {
				cmc = true;
				p = Event.getPageXY(e);
				this.menu.show(p.x, p.y);
			};

			if (!cmc)
				this.menu.hide();

			td = DOM.getParent(e.target, function(n) {
				return n.nodeName == 'TD';
			});

			row = rs.getRow(idx);
			if (!row)
				return;

			if (cmc && List.indexOf(rs.getSelectedIndexes(), idx) != -1)
				return;

			if (DOM.hasClass(tr, 'rename'))
				return;

			if (DOM.hasClass(td, 'check') || cmc || (row.type != 'folder' && row.type != 'parent' && row.type != 'zip') || e.type == 'dblclick') {
				this.endRename();

				if (!DOM.hasClass(td, 'check')) {
					List.map(rs.selected, function(i, v) {
						if (DOM.get('file_' + v))
							DOM.removeClass('file_' + v, 'selected');
					});

					rs.unselectAll();
				}

				if (e.shiftKey && this.lastIdx != -1) {
					if (idx == 0)
						idx = rs.getRow(0).type == 'parent' ? 1 : 0;

					rs.selectRows(this.lastIdx, idx);

					List.map(rs.selected, function(i, v) {
						if (DOM.get('file_' + v))
							DOM.addClass('file_' + v, 'selected');
					});
				}

				if (row.type != 'parent') {
					if (this.lastIdx != -1)
						DOM.removeClass('file_' + this.lastIdx, 'focused');

					if (!e.shiftKey) {
						if (!DOM.hasClass(tr, 'selected')) {
							rs.selectRow(idx);
							DOM.addClass(tr, 'selected');
						} else
							DOM.removeClass(tr, 'selected');
					}

					this.lastIdx = idx;
					DOM.addClass(tr, 'focused');
					this.setToolsActive(1);
				}

				// Is file or folder type
				if (row.type != 'folder' && row.type != 'parent' && row.type != 'zip' && !DOM.hasClass(td, 'check')) {
					if (row.custom && row.custom.previewable === false)
						this.preview(row.path, row.type, true);
					else
						this.open(row.path, row.type);
				} else
					this.preview(row.path, row.type, true);
			} else
				this.open(row.path, row.type);

			if (!DOM.hasClass(td, 'check') && e.type == 'dblclick')
				this.insert();
		},

		rowEvent : function(e) {
			var id, idx = -1, tr;

			tr = DOM.getParent(e.target, function(n) {
				return n.nodeName == 'TR' || n.nodeName == 'TH';
			});

			if (!tr || tr.nodeName == 'TH')
				return true;

			id = DOM.getAttrib(tr, 'id');

			if (id)
				idx = parseInt(id.split('_')[1]);

			switch (e.type) {
				case 'click':
				case 'contextmenu':
				case 'dblclick':
					this.rowClick(tr, id, idx, e);
					break;
			}

			if (!DOM.hasClass(tr, 'rename') && e.type != 'contextmenu')
				return Event.cancel(e);
		},

		cut : function() {
			var t = this, rs = t.listFilesResult;

			if (rs.getSelectedIndexes().length == 0 || DOM.hasClass('cut', 'disabled'))
				return;

			WindowManager.confirm(LangPack.get("message", "confirm_cut"), function() {
				if (rs.getSelectedIndexes().length == 0 || DOM.hasClass('cut', 'disabled'))
					return;

				t.clipboard = rs.getSelectedRows();
				t.clipAction = 'cut';

				if (!DOM.hasClass('paste', 'disabled'))
					DOM.addClass('paste', 'active');
			});
		},

		copy : function() {
			var t = this, rs = t.listFilesResult;

			if (rs.getSelectedIndexes().length == 0 || DOM.hasClass('copy', 'disabled'))
				return;

			WindowManager.confirm(LangPack.get("message", "confirm_copy"), function() {
				if (rs.getSelectedIndexes().length == 0 || DOM.hasClass('copy', 'disabled'))
					return;

				t.clipboard = rs.getSelectedRows();
				t.clipAction = 'copy';

				if (!DOM.hasClass('paste', 'disabled'))
					DOM.addClass('paste', 'active');
			});
		},

		paste : function() {
			var args = {}, i, cb = this.clipboard, fm = this;

			if (DOM.hasClass('paste', 'disabled') || !fm.clipAction)
				return;

			WindowManager.confirm(LangPack.get("message", "confirm_paste"), function() {
				switch (fm.clipAction) {
					case 'cut':
						args.topath = fm.path;

						for (i=0; i<cb.length; i++)
							args['frompath' + i] = cb[i].path;

						WindowManager.showProgress(LangPack.get("message", "paste_in_progress"));
						mcFileManager.execRPC('fm.moveFiles', args, function (d) {
							WindowManager.hideProgress();
							fm.refresh();
							fm.showStatusDialog(LangPack.get('error', 'move_failed'), new SelectableResultSet(d.result));
						});

						fm.clipAction = fm.clipboard = null;
					break;

					case 'copy':
						args.topath = fm.path;

						for (i=0; i<cb.length; i++)
							args['frompath' + i] = cb[i].path;

						WindowManager.showProgress(LangPack.get("message", "paste_in_progress"));
						mcFileManager.execRPC('fm.copyFiles', args, function (d) {
							WindowManager.hideProgress();
							fm.refresh();
							fm.showStatusDialog(LangPack.get('error', 'copy_failed'), new SelectableResultSet(d.result));
						});

						fm.clipAction = fm.clipboard = null;
					break;
				}
			});
		},

		addFavorites : function() {
			var c = 0, args = {};

			if (!DOM.hasClass('menu_addfavorite', 'disabled')) {
				List.each(this.listFilesResult.getSelectedRows(), function(i, r) {
					args['path' + (c++)] = r.path;
				});

				mcFileManager.execRPC('fm.addFavorites', args);
			}
		},

		removeFavorites : function() {
			var c = 0, args = {}, t = this;

			if (!DOM.hasClass('menu_removefavorite', 'disabled')) {
				List.each(this.listFilesResult.getSelectedRows(), function(i, r) {
					args['path' + (c++)] = r.path;
				});

				mcFileManager.execRPC('fm.removeFavorites', args, function() {
					t.refresh();
				});
			}
		},

		renameFiles : function() {
			var tr, nl, row, t = this, inp, rs = this.listFilesResult;

			if (this.lastIdx != -1 && !DOM.hasClass('rename', 'disabled')) {
				row = rs.getRow(this.lastIdx);
				tr = DOM.get('file_' + this.lastIdx);

				DOM.addClass(tr, 'rename');
				this.renameIdx = this.lastIdx;

				nl = DOM.getByClass(tr, 'td', 'file');

				if (DOM.select('#file_' + this.renameIdx + " input").length == 0) {
					inp = nl[0].appendChild(DOM.createTag('input', {type : 'text', 'class' : 'text', style : 'width: 75%', value : row.name}));
					inp.focus();

					Event.add(inp, 'keyup', function(e) {
						if (e.keyCode == 13) {
							if (t.checkDemo()) {
								t.endRename();
								return;
							}

							mcFileManager.execRPC('fm.moveFiles', {frompath0 : row.path, toname0 : inp.value}, function (d) {
								if (!t.showStatusDialog(LangPack.get('error', 'rename_failed'), new SelectableResultSet(d.result)))
									t.refresh();
							});

							t.endRename();
						}

						if (e.keyCode == 27)
							t.endRename();

						return Event.cancel(e);
					});
				}
			}
		},

		showStatusDialog : function(msg, rs) {
			var h = '', t = this;

			rs.each(function(r, i) {
				var n, root;

				root = t.visualPath;
				root = root.substring(1);
				root = t.visualPath.replace(/^\/([^\/]+)\/.*$/, '$1');

				if (r.fromfile) {
					r.fromfile = r.fromfile.replace(/\{[0-9]+\}/, root);
					r.tofile = r.tofile.replace(/\{[0-9]+\}/, root);

					if (r.status.toLowerCase() != 'ok')
						h += '<div class="statusrow"><div class="statuscol1">' + r.fromfile + " -> " + r.tofile + '</div><div class="statuscol2">' + r.message + '</div></div>';
				}

				if (r.file) {
					r.file = r.file.replace(/\{[0-9]+\}/, root);
					r.file = r.file.replace(/\/+/, '/');

					if (r.status.toLowerCase() != 'ok')
						h += '<div class="statusrow"><div class="statuscol1">' + r.file + '</div><div class="statuscol2">' + r.message + '</div></div>';
				}
			});

			if (h)
				mox.ui.WindowManager.status(msg, h);

			return h != '';
		},

		zipFiles : function() {
			if (this.lastIdx != -1)
				WindowManager.open('createzip.html?rnd=' + new Date().getTime(),'ZipWin','top=center,left=center,width=350,height=200', {path : this.path, rows : this.listFilesResult.getSelectedRows()}); 
		},

		preview : function(p, t, nv) {
			var name;

			if (p == null || t == 'folder' || t == 'parent') {
				if (this.listFilesResult)
					sr = this.listFilesResult.getRow(this.lastIdx);

				if (this.previewURL != p)
					DOM.setAttrib('preview', 'src', 'blank.html');

				DOM.setStyle('preview', 'visibility', 'hidden');
				DOM.get("previewpath").innerHTML = '&nbsp;';
				DOM.setAttrib('previewpath', 'title', '');

				List.each(DOM.select('#view_actions a'), function(i, n) {
					DOM.removeClass(n, 'active');
				});

				return;
			}

			List.each(DOM.select('#view_actions a'), function(i, n) {
				DOM.addClass(n, 'active');
			});

			name = p.substring(p.lastIndexOf('/') + 1);

			DOM.setStyle('preview', 'visibility', 'visible');

			if (!nv && t != 'zip')
				DOM.setAttrib('preview', 'src', '../../stream/?cmd=fm.streamFile&path=' + encodeURIComponent(p));
			else
				DOM.setAttrib('preview', 'src', 'blank.html');

			DOM.setAttrib('previewpath', 'title', name);
			DOM.get("previewpath").innerHTML = name;

			if (t == 'zip')
				DOM.removeClass(DOM.select('#view a')[0], 'active');

			this.previewURL = p;
		},

		open : function(p, t) {
			if (t == "zip")
				p = 'zip://' + p;

			this.preview(p, t);

			if (t == "folder" || t == "parent" || t == "zip")
				this.listFiles(p);
		},

		insert : function() {
			var sr = this.listFilesResult.getRow(this.lastIdx);
			var win = opener || parent;

			if (!sr || sr.type == 'folder' || DOM.hasClass('insert', 'disabled'))
				return;

			if (win && win.mcFileManager && win != window) {
				WindowManager.showProgress(LangPack.get("message", "insert"));

				mcFileManager.execRPC('fm.insertFiles', {path0 : sr.path},  function (data) {
					var rs, r;

					WindowManager.hideProgress();

					rs = new SelectableResultSet(data.result);

					if (rs.getRowCount() > 0) {
						r = rs.getRow(0);

						win.mcFileManager.selectFile({
							name : r.name,
							path : r.path,
							url : r.url,
							size : r.size,
							type : r.type,
							created : r.created,
							modified : r.modified,
							attribs : r.attribs,
							custom : r.custom
						});
					}

					window.close();
				});
			}
		},

		saveSettings : function () {
			var d;

			d = new Date();
			d.setYear(2030);

			Cookie.setJSON("MCFileManagerSettings", { sortby : this.sortBy, sortdir : this.sortDir }, d);
		},

		loadSettings : function () {
			var sv;

			sv = Cookie.getJSON("MCFileManagerSettings");

			if (sv) {
				if (sv.sortby)
					this.sortBy = sv.sortby;

				if (sv.sortdir)
					this.sortDir = sv.sortdir;
			}
		},

		imagemanager : function() {
			if (!DOM.hasClass('imagemanager', 'disabled'))
				document.location = this.imageManagerURL;
		},

		download : function(p) {
			var sr = this.listFilesResult.getRow(this.lastIdx);

			if (!sr || sr.type == 'folder' || DOM.hasClass('download', 'disabled'))
				return;

			p = !p ? sr.path : p;

			var ifr = DOM.get("preview");
			ifr.src = '../../stream/?cmd=fm.download&path=' + p;
		},

		view : function(p) {
			var sr = this.listFilesResult.getRow(this.lastIdx);

			if (!sr || sr.type == 'folder' || sr.type == 'zip' || DOM.hasClass('view', 'disabled'))
				return;

			p = !p ? sr.path : p;

			window.open('../../stream/?cmd=fm.streamFile&path=' + encodeURIComponent(p), 'View');
		},

		deleteFiles : function() {
			var fm = this, rs = this.listFilesResult, sel = rs.getSelectedRows(), i, args = {};

			if (this.checkDemo())
				return;

			if (rs.getSelectedIndexes().length == 0 || DOM.hasClass('delete', 'disabled'))
				return;

			WindowManager.confirm(LangPack.get("message", "confirm_delete"), function() {
				for (i=0; i<sel.length; i++)
					args['path' + i] = sel[i].path;

				mcFileManager.execRPC('fm.deleteFiles', args, function (d) {
					fm.showStatusDialog(LangPack.get('error', 'delete_failed'), new SelectableResultSet(d.result));
					fm.refresh();
				});
			});
		},

		upload : function() {
			if (!DOM.hasClass('upload', 'disabled'))
				WindowManager.open('upload.html?rnd=' + new Date().getTime(),'UploadWin','top=center,left=center,width=420,height=340', {path : this.path}); 
		},

		createDir : function() {
			if (!DOM.hasClass('createdir', 'disabled'))
				WindowManager.open('createdir.html?rnd=' + new Date().getTime(),'CreateDirWin','top=center,left=center,width=320,height=240', {path : this.path}); 
		},

		createDoc : function() {
			if (!DOM.hasClass('createdoc', 'disabled'))
				WindowManager.open('createdoc.html?rnd=' + new Date().getTime(),'CreateDocWin','top=center,left=center,width=320,height=240', {path : this.path}); 
		},

		listRoots : function() {
			if (this.rootpath) {
				new Template('category_list', 'folders_template').process({
					path : '/',
					name : '/',
					type : 'folder'
				});
			} else {
				mcFileManager.execRPC('fm.listFiles', {path : "root:///", only_dirs : true, root_path : this.rootpath}, function(d) {
					new Template('category_list', 'folders_template').processTable(d);
				});
			}
		},

		listFiles : function(path, cb) {
			var t = this;

			if (path)
				this.path = path;

			DOM.show('progress');
			DOM.hide('dirinfo');

			// IE produces error in innerHTML
			List.each(DOM.select('#filelist tr'), function (i, tr) {
				tr.parentNode.removeChild(tr);
			});

			mcFileManager.execRPC('fm.listFiles', {
				path : this.path,
				root_path : this.rootpath,
				config : 'general,filesystem,imagemanager',
				url : this.listURL,
				remember_last_path : this.rememberPath
			}, function(d) {
				var numFiles = 0, numDirs = 0, fileSize = 0, tpl, cfg = d.result.config;

				t.imageManagerURL = cfg['imagemanager.urlprefix'];
				t.demoMode = cfg['general.demo'] == "true";

				if (d.result.header) {
					t.path = d.result.header.path;
					t.visualPath = d.result.header.visual_path;
					DOM.get('curpath').innerHTML = t.visualPath;
				}

				t.listFilesResult = new SelectableResultSet(d.result);
				t.setupToolbars(cfg);
				t.lastIdx = -1;
				t.renameIdx = -1;

				t.listFilesResult.each(function(v, i) {
					if (v.type == 'parent') {
						//t.listFilesResult.data[i][0] = LangPack.get('filelist', 'parent');
						return;
					}

					if (v.type == 'folder') {
						numDirs++;
						return;
					}

					numFiles++;
					fileSize += v.size;
				});

				tpl = new Template('dirinfo', 'dirinfo_template');

				tpl.addEncoder('sizefix', t.fixSize);

				tpl.process({
					dirs : numDirs,
					files : numFiles,
					filesize : fileSize,
					access : t.listFilesResult.header.attribs
				});

				DOM.show('dirinfo');
				DOM.hide('progress');

				t.updateFileList();

				cb && cb(d);
			});
		},

		setupToolbars : function(cfg) {
			var tools = ['imagemanager', 'selectall', 'unselectall', 'refresh', 'view', 'insert', 'download', 'addfavorite', 'removefavorite'];
			var editTools = ['cut', 'copy', 'paste', 'rename', 'delete', 'zip' , 'upload', 'createdir', 'createdoc'];
			var cfgTools;

			List.each(DOM.select('div.icon', DOM.get('topnav')), function(i, v) {
				DOM.removeClass(v, 'disabled');
				DOM.removeClass(v, 'hidden');
			});

			List.each(DOM.select('#selection_actions li'), function(i, v) {
				DOM.removeClass(v, 'disabled');
				DOM.removeClass(v, 'active');
			});
	
			List.each(DOM.select('#selection_actions li'), function(i, v) {
				DOM.removeClass(v, 'disabled');
				DOM.removeClass(v, 'hidden');
			});

			List.each(editTools, function(i, v) {
				DOM.removeClass('menu_' + v, 'disabled');
				DOM.removeClass('menu_' + v, 'hidden');
			});

			DOM.addClass('selectall', 'active');
			DOM.addClass('unselectall', 'active');

			if (cfg) {
				cfgTools = cfg['general.tools'].split(',');

				List.each(tools.concat(editTools), function(i, v) {
					if (List.indexOf(cfgTools, v) == -1) {
						DOM.addClass(v, 'hidden');
						DOM.addClass('menu_' + v, 'hidden');
					} else {
						DOM.removeClass(v, 'hidden');
						DOM.removeClass('menu_' + v, 'hidden');
					}
				});

				List.each(cfg['general.disabled_tools'].split(','), function(i, v) {
					DOM.addClass(v, 'disabled');
					DOM.addClass('menu_' + v, 'disabled');
				});
			}

			if (this.path.indexOf('favorite://') != -1 || this.path.indexOf('history://') != -1) {
				List.each(editTools, function (i, v) {
					DOM.addClass(v, 'disabled');
					DOM.addClass('menu_' + v, 'disabled');
				});
			}

			if (this.path.indexOf('favorite://') == -1)
				DOM.addClass('menu_removefavorite', 'hidden');
			else
				DOM.addClass('menu_addfavorite', 'hidden');

			if (this.clipboard != null && !DOM.hasClass('paste', 'disabled'))
				DOM.addClass('paste', 'active');
		},

		setToolsActive : function(s) {
			List.each(DOM.select('#selection_actions li'), function(i, v) {
				DOM.removeClass(v, 'active');
			});

			DOM.addClass('selectall', 'active');
			DOM.addClass('unselectall', 'active');

			if (!s)
				return;

			if (!DOM.hasClass('cut', 'disabled'))
				DOM.addClass('cut', 'active');

			if (!DOM.hasClass('copy', 'disabled'))
				DOM.addClass('copy', 'active');

			if (!DOM.hasClass('rename', 'disabled'))
				DOM.addClass('rename', 'active');

			if (!DOM.hasClass('delete', 'disabled'))
				DOM.addClass('delete', 'active');

			if (!DOM.hasClass('zip', 'disabled'))
				DOM.addClass('zip', 'active');
		},

		refresh : function() {
			this.preview(null);
			this.listFiles(this.path);
		},

		updateFileList : function(by) {
			var files, folders, d;

			if (this.listFilesResult) {
				d = this.listFilesResult;

				if (this.sortBy == by)
					this.sortDir = !this.sortDir; 

				if (!by)
					by = this.sortBy ? this.sortBy : 'name';

				this.sortBy = by;

				this.saveSettings();

				// Get files and folders
				folders = List.filter(d.data, function(i, v) {
					v = d.getColByName(v, 'type');

					return v == 'folder' || v == 'parent';
				});

				files = List.filter(d.data, function(i, v) {
					v = d.getColByName(v, 'type');

					return v != 'folder' && v != 'parent';
				});

				// Sort folders
/*				d.data = folders;
				this._orderFiles(d, by);*/

				// Sort files
				d.data = files;
				this._orderFiles(d, by);

				// Glue back
				d.data = folders.concat(d.data);

				this.fileListTpl.processResultSet(d);

				if (this.lastSort)
					DOM.setAttrib(this.lastSort, 'class', 'sort');

				DOM.setAttrib('sort' + by, 'class', 'sort' + (this.sortDir ? 'desc' : 'asc'));
				this.lastSort = 'sort' + by;
			}
		},

		_orderFiles : function(d, by) {
			switch (by) {
				case 'name':
					d.orderBy('name', false, this.sortDir);
				break;

				case 'size':
					d.orderBy('size', true, this.sortDir);
				break;

				case 'type':
					d.orderBy('type', false, this.sortDir);
				break;

				case 'modified':
					d.orderBy('modified', false, this.sortDir);
				break;
			}
		}
	});

	// Setup short named version of manager
	window.FileManagerTheme = mox.manager.FileManagerDefaultTheme;
	window.mcFileManager = new moxiecode.manager.FileManager();

	// Init theme
	FileManagerTheme.init();
});
