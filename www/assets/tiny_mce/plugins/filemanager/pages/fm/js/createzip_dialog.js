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
	'mox.List',
	'mox.tpl.Template',
	'mox.data.ResultSet',
	'mox.dom.Form',
	'moxiecode.manager.FileManager',
	'mox.geom.Point',
	'mox.geom.Rect',
	'moxiecode.manager.BaseManager',
	'mox.util.Dispatcher',
	'mox.net.JSON'
], function() {
	// Shorten class names
	var Event = mox.Event;
	var DOM = mox.DOM;
	var List = mox.List;
	var LangPack = mox.lang.LangPack;
	var Template = mox.tpl.Template;
	var ResultSet = mox.data.ResultSet;
	var Form = mox.dom.Form;

	// Class that contains all theme specific logic
	mox.create('static CreateZipDialog', {
		lastWin : null,
		selectedRows : null,

		init : function() {
			this.lastWin = this.getWindowManager().getLastWindow();
			this.args = this.lastWin.getArgs();
			this.selectedRows = this.args.rows;

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
			var win = this.getParent(), t = this;

			LangPack.translatePage();

			this.lastWin.setTitle(document.title);

			DOM.get('createin').innerHTML = win.FileManagerTheme.visualPath;

			Event.add('cancel', 'click', function() {
				this.close();
			}, this);
		},

		createZipAction : function(f) {
			var t = this, args = {}, c = 0;

			if (t.getParent().FileManagerTheme.checkDemo())
				return false;

			if (!f.zipname.value)
				return false;

			List.map(this.selectedRows, function(i, r) {
				args['frompath' + c++] = r.path;
			});

			args.topath = this.args.path;
			args.toname = f.zipname.value;

			mcFileManager.execRPC('fm.createZip', args, function (d) {
				if (!t.getParent().FileManagerTheme.showStatusDialog(LangPack.get('error', 'createzip_failed'), new ResultSet(d.result))) {
					t.refreshList();
					t.close();
				}
			});

			return false;
		},

		close : function() {
			// Fix for odd focus bug in IE6
			try {document.body.appendChild(document.createElement('input')).focus();} catch (e) {}
			this.getWindowManager().closeAll();
		}
	});

	// Setup global file manager
	window.mcFileManager = new moxiecode.manager.FileManager();

	CreateZipDialog.init();
});
