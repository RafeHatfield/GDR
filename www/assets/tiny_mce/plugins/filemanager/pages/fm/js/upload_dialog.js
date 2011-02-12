/**
 * $Id: dialog.js 91 2006-10-02 14:53:22Z spocke $
 *
 * @author Moxiecode
 * @copyright Copyright © 2004-2006, Moxiecode Systems AB, All rights reserved.
 */

mox.require([
	'mox.lang.LangPack',
	'mox.Event',
	'mox.DOM',
	'mox.tpl.Template',
	'mox.data.ResultSet',
	'mox.dom.Form',
	'moxiecode.manager.FileManager',
	'mox.List',
	'mox.geom.Point',
	'mox.geom.Rect',
	'moxiecode.manager.BaseManager',
	'mox.util.Dispatcher',
	'mox.net.JSON'
], function() {
	// Shorten class names
	var Event = mox.Event;
	var DOM = mox.DOM;
	var LangPack = mox.lang.LangPack;
	var Template = mox.tpl.Template;
	var ResultSet = mox.data.ResultSet;
	var Form = mox.dom.Form;
	var List = mox.List;

	// Class that contains all theme specific logic
	mox.create('static UploadDialog', {
		lastWin : null,
		demo : false,
		swfu : null,

		init : function() {
			this.lastWin = this.getWindowManager().getLastWindow();
			this.args = this.lastWin.getArgs();

			Event.add(window, 'DOMContentLoaded', this.onDOMContentLoaded, this);
			Event.add(window, 'focus', this.lastWin.focus, this.lastWin);

			mcFileManager.onError.add(this.onError, this);

			// Hide body until translation
			//document.write('<style>body {display: none;}</style>');
		},

		onError : function(m, e, r, co, text) {
			var doc, WindowManager = this.getWindowManager();

			if (typeof(e) == 'object') {
				doc = this.getParent().document;

				if (e.level == 'AUTH') {
					if (r.login_url.indexOf('://') == -1)
						doc.location = mox.baseURL + "/../" + r.login_url + "?return_url=" + escape(doc.location);
					else
						doc.location = r.login_url + "?return_url=" + escape(doc.location);

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

		getParent : function() {
			return parent || opener;
		},

		refreshList : function() {
			this.getParent().setTimeout('FileManagerTheme.refresh()', 100);
		},

		getWindowManager : function() {
			return this.getParent().mox.ui.WindowManager;
		},

		onDOMContentLoaded : function() {
			LangPack.translatePage();

			Event.add('cancel', 'click', function() {
				this.close();
			}, this);

			this.lastWin.setTitle(document.title);
			this.uploadInit();
		},

		close : function() {
			// Fix for odd focus bug in IE6
			try {document.body.appendChild(document.createElement('input')).focus();} catch (e) {}
			this.getWindowManager().closeAll();
		},

		uploadInit : function() {
			var win = this.getParent(), t = this;

			mcFileManager.execRPC('fm.getConfig', {path : win.FileManagerTheme.path}, function(r) {
				var config = r.result, maxSize, upExt, fsExt, outExt = [], i, x, found, swfExts = '', useFlash, maxSizeNum;

				DOM.show('content');

				maxSize = config['upload.maxsize'];
				useFlash = config['upload.use_flash'] != 'false';
				fsExt = config['filesystem.extensions'].split(',');
				upExt = config['upload.extensions'].split(',');

				maxSize = maxSize.replace(/\s+/, '');
				maxSize = maxSize.replace(/([0-9]+)/g, '$1 ');

				for (i=0; i<upExt.length; i++) {
					found = false;

					for (x=0; x<fsExt.length; x++) {
						if (upExt[i] == fsExt[x]) {
							found = true;
							break;
						}
					}

					if (found)
						outExt.push(upExt[i]);
				}

				new Template('facts', 'facts_template').process({extensions : outExt.join(', '), maxsize : maxSize, path : win.FileManagerTheme.visualPath});

				List.each(outExt, function(i, v) {
					swfExts += '*.' + v + ";";
				});

				maxSizeNum = parseInt(maxSize.replace(/[^0-9]+/, ''));

				// Mb multipel
				if (maxSize.toLowerCase().indexOf('m') != -1)
					maxSizeNum *= 1024;

				DOM.get('uploadForm').action = '../../stream/' + mox.defaultDoc;

				if (useFlash) {
					t.swfu = new SWFUpload({
						upload_script : "../../../stream/" + mox.defaultDoc + "?cmd=fm.upload&path="+ encodeURIComponent(win.FileManagerTheme.path) +"&format=flash",
						target : "SWFUploadTarget",
						flash_path : "img/SWFUpload.swf",
						allowed_filesize : maxSizeNum,
						allowed_filetypes : swfExts,
						allowed_filetypes_description : swfExts,
						browse_link_innerhtml : LangPack.get("upload", "browse"),
						upload_link_innerhtml : LangPack.get("upload", "button_upload"),
						browse_link_class : "uploadbrowse button",
						upload_link_class : "uploadque button disabled",
						flash_loaded_callback : 'UploadDialog.flashLoaded',
						upload_file_queued_callback : "UploadDialog.fileQueued",
						upload_file_start_callback : 'UploadDialog.uploadFileStart',
						upload_progress_callback : 'UploadDialog.uploadProgress',
						upload_file_complete_callback : 'UploadDialog.uploadFileComplete',
						upload_file_cancel_callback : 'UploadDialog.uploadFileCancelled',
						upload_queue_complete_callback : 'UploadDialog.uploadQueueComplete',
						upload_file_error_callback : 'UploadDialog.uploadError',
						upload_file_cancel_callback : 'UploadDialog.uploadCancel'
					});

					// Patch in upload check
					t.swfu.oldUpload = t.swfu.upload;
					t.swfu.upload = function() {
						if (!t.getParent().FileManagerTheme.checkDemo())
							t.swfu.oldUpload();
					};
				}
			});

			DOM.setStyle('SWFUploadTarget', 'display', 'block');

			if (document.forms[0])
				document.forms[0].path.value = win.FileManagerTheme.path;
		},

		/* SWFUpload callbacks */

		flashLoaded : function() {
			DOM.setStyle('SWFUploadQue', 'display', 'block');
			DOM.setStyle('SWFUploadTarget', 'display', 'block');

			this.swfu.flashLoaded();
		},

		fileQueued : function(file, ql) {
			DOM.removeClass('SWFUpload_0UploadBtn', 'disabled');

			List.each(DOM.select('#SWFUploadQue div.file'), function(i, n) {
				if (DOM.getAttrib(n, 'title') == file.name)
					n.parentNode.removeChild(n);
			});

			DOM.addTags('SWFUploadQue',
				['div', {id : file.id, 'class' : 'file', title : file.name}, 
					['div', {id : file.id, 'class' : 'name'}, file.name],
					['div', {id : file.id + '_status', 'class' : 'status'}, '0%']
				]
			);
		},

		uploadFileStart : function(file, pos, ql) {
		},

		uploadProgress : function(file, bl) {
			DOM.get(file.id + '_status').innerHTML = Math.ceil((bl / file.size) * 100) + ' %';
		},

		uploadFileComplete : function(file) {
			DOM.get(file.id + '_status').innerHTML = '100%';
			DOM.addClass(file.id, 'success');
		},

		uploadFileCancelled : function(file, ql) {
			DOM.addClass(file.id, 'canceled');
		},

		uploadQueueComplete : function(file) {
		},

		uploadError : function(err, file, msg) {
			DOM.addClass(file.id, 'failed');

			switch (msg) {
				case 405:
					msg = LangPack.get("error", "no_access");
					break;

				case 409:
					msg = LangPack.get("error", "file_exists");
					break;

				case 412:
					msg = LangPack.get("error", "no_write_access");
					break;

				case 414:
					msg = LangPack.get("error", "error_to_large");
					break;

				default:
					msg = LangPack.get("error", "upload_failed");
			}

			DOM.get(file.id + '_status').innerHTML = msg;
		},

		uploadCancel : function() {
		},

		/* End */

		handleJSONResponse : function(o) {
			var t = this;

			this.getWindowManager().hideProgress();

			if (!this.getParent().FileManagerTheme.showStatusDialog(LangPack.get('error', 'upload_failed'), new ResultSet(o.result))) {
				t.refreshList();
				t.close();
			}
		},

		onUploadSubmit : function(f) {
			if (this.getParent().FileManagerTheme.checkDemo())
				return false;

			if (!DOM.get('file0').value)
				return false;

			this.getWindowManager().showProgress(LangPack.get('upload', 'progress'));

			return true;
		},

		onUploadChangeFile : function(e) {
			var f = e.form, p;

			p = '' + e.value.replace(/\\/g, '/');
			p = p.substring(p.lastIndexOf('/') + 1);
			p = p.substring(0, p.lastIndexOf('.'));
			f.name0.value = p;
		},

		splitNameValue : function(s, f) {
			var o = {}, i, c;

			s = s.split(',');

			for (i=0; i<s.length; i++) {
				c = s[i].split('=');

				// If no key, then call function to create one
				if (c.length < 2)
					f && (o[f(c[0])] = c[0]);
				else
					o[c[0]] = c[1];
			}

			return o;
		}
	});

	// Setup global file manager
	window.mcFileManager = new moxiecode.manager.FileManager();

	UploadDialog.init();
});

function handleJSON(o) {
	UploadDialog.handleJSONResponse(o);
}
