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
	'mox.geom.Rect',
	'mox.dom.Form',
	'moxiecode.manager.FileManager',
	'mox.List',
	'mox.geom.Point',
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
	var Rect = mox.geom.Rect;
	var Form = mox.dom.Form;

	// Class that contains all theme specific logic
	mox.create('static CreateDocDialog', {
		lastWin : null,

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
			var win = this.getParent(), t = this;

			LangPack.translatePage();

			this.lastWin.setTitle(document.title);

			DOM.get('template').disabled = true;
			DOM.get('createin').innerHTML = win.FileManagerTheme.visualPath;

			mcFileManager.execRPC('fm.getConfig', {path : win.FileManagerTheme.path}, function(r) {
				var config = r.result, templates, n, vp;

				templates = config['filesystem.file_templates'];
				t.fields = t.splitNameValue(config['createdoc.fields'], function(v) {
					return v;
				});

				new Template('fields', 'field_template').processNameValue(t.fields);

				if (templates.replace(/\s+/g, '') != '')
					DOM.get('template').disabled = false;

				templates = t.splitNameValue(templates, function(v) {
					return v.substring(v.lastIndexOf('/') + 1);
				});

				new Template('template', 'template_template', '<option value="">' + mox.lang.LangPack.get('createdoc', 'select_template') + '</option>').processNameValue(templates);

				DOM.show('content');

				vp = DOM.getViewPort();
				t.lastWin.resizeBy(0, document.body.scrollHeight - vp.h);
			});

			Event.add('cancel', 'click', function() {
				this.close();
			}, this);
		},

		close : function() {
			// Fix for odd focus bug in IE6
			try {document.body.appendChild(document.createElement('input')).focus();} catch (e) {}
			this.getWindowManager().closeAll();
		},

		showPreview : function() {
			var u = DOM.get('template').value;

			if (u)
				window.open('../../stream/?cmd=fm.streamFile&path=' + escape(u), 'previewdoc');
		},

		createDocAction : function(f) {
			var theme = this.getParent().FileManagerTheme, args, t = this;

			if (t.getParent().FileManagerTheme.checkDemo())
				return false;

			if (!f.docname.value)
				return false;

			args = {
				frompath0 : f.template.options[f.template.selectedIndex].value,
				topath0 : theme.path,
				toname0 : f.docname.value
			};

			args.fields = {};

			for (n in this.fields) {
				if (typeof(this.fields[n]) != 'function')
					args.fields[this.fields[n]] = document.forms[0].elements[this.fields[n]].value;
			}

			mcFileManager.execRPC('fm.createDocs', args, function (d) {
				if (!t.getParent().FileManagerTheme.showStatusDialog(LangPack.get('error', 'createdoc_failed'), new ResultSet(d.result))) {
					t.refreshList();
					t.close();
				}
			});

			return false;
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

	CreateDocDialog.init();
});
