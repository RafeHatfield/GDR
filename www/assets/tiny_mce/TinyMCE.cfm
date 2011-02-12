<cfsetting enablecfoutputonly="yes">
<cfparam name="attributes.instanceName" type="string">
<cfparam name="attributes.width" type="string" default="95%">
<cfparam name="attributes.height" type="string" default="200">
<cfparam name="attributes.toolbarSet" type="string" default="Basic">
<cfparam name="attributes.value" type="string" default="">
<cfparam name="attributes.stylesheet" type="string" default="/css/editor_styles.css">
<cfparam name="attributes.tabindex" type="string" default="">
<cfparam name="attributes.onFocus" type="string" default="counter=0">
<cfparam name="attributes.pathToTinyMCE" default="#application.assetsPath#tiny_mce/tiny_mce.js" />
<cfparam name="request.TinyMCEIncluded" default="false" />
<!--- Welcome to the tiny magical world of TinyMCE! --->

<!---

In order to get this tag to work, install the directory in
which this file resides and all subdirectories into a jscripts
or such directory in the root of your site.

You can call this custom tag like so:

<cfmodule template="/scripts/tiny_mce/tinyMCE.cfm"
	instanceName="Intro"
	value="#qContent.Intro#"
	width="681"
	height="200"
	toolbarset="Basic|Advanced">

Documentation for tinyMCE can be found at http://tinymce.moxiecode.com

--->

<cfoutput>
<cfif NOT request.TinyMCEIncluded>
	<script type="text/javascript" src="<cfoutput>#attributes.pathToTinyMCE#</cfoutput>"></script>
	<cfset request.TinyMCEIncluded = true />
</cfif>


<cfif attributes.toolbarset eq 'Basic'>
<script type="text/javascript">
tinyMCE.init({
		mode : "textareas",
		editor_selector	: "mce_#attributes.instanceName#",
		theme : "advanced",
		width: "#attributes.width#",
		height: "#attributes.height#",
		content_css: "#attributes.stylesheet#",
		dialog_type : "modal",
		theme_advanced_toolbar_location : "top",
		theme_advanced_toolbar_align : "left",
		theme_advanced_blockformats : "p,h2,h3,h4,h5,h6",
		plugins : "advlink,paste,spellchecker,inlinepopups,media",<!--- template --->
		theme_advanced_buttons1 : "spellchecker,formatselect,bold,italic,<!--- bold,italic,underline,strikethrough, --->bullist,numlist,<!--- charmap, --->separator,link,unlink,separator,image,media,separator,cut,copy,pastetext,pasteword,removeformat,selectall,undo,redo,separator,code",
		<!--- theme_advanced_buttons2 : "template", --->
		theme_advanced_buttons2 : "",
		theme_advanced_buttons3 : "",
		theme_advanced_resizing : true,
		theme_advanced_resizing_use_cookie : false,
		theme_advanced_resize_horizontal : false,
		theme_advanced_statusbar_location: "bottom",
		paste_auto_cleanup_on_paste : true,
		paste_convert_headers_to_strong : true,
		relative_urls : false,
		remove_script_host : true,
		document_base_url : "#request.url#/"<!--- ,
		convert_urls : false,
			template_templates : [
				{
					title : "Test 1",
					src : "scripts/tiny_mce/plugins/template/test1.htm",
					description : "I am a Test"
				},

			] --->
	});
</script>
<cfelseif  attributes.toolbarset eq 'Forum'>
<script type="text/javascript">
tinyMCE.init({
		mode : "textareas",
		editor_selector	: "mce_#attributes.instanceName#",
		theme : "advanced",
		width: "#attributes.width#",
		height: "#attributes.height#",
		content_css: "#attributes.stylesheet#",
		theme_advanced_toolbar_location : "top",
		theme_advanced_blockformats : "p,h2,h3,h4,h5,h6",
		plugins : "advlink,paste,emotions,spellchecker,media",
		theme_advanced_buttons1 : "spellchecker,formatselect,<!--- bold,italic,underline,strikethrough,charmap,emotions,separator, --->cut,copy,pastetext,pasteword,removeformat,selectall,undo,redo,separator,code",
		theme_advanced_buttons2 : "",
		theme_advanced_buttons3 : "",
		paste_auto_cleanup_on_paste : true,
		paste_convert_headers_to_strong : true,
		relative_urls : false,
		remove_script_host : true,
		document_base_url : "#request.url#/",
		convert_urls : false
	});
</script>

<cfelseif  attributes.toolbarset eq 'Advanced'>
<script type="text/javascript">
tinyMCE.init({
		mode : "textareas",
		editor_selector	: "mce_#attributes.instanceName#",
		theme : "advanced",
		width: "#attributes.width#",
		height: "#attributes.height#",
		content_css: "#attributes.stylesheet#",
		dialog_type : "modal",
		theme_advanced_toolbar_location : "top",
		theme_advanced_toolbar_align : "left",
		theme_advanced_blockformats : "p,h2,h3,h4,h5,h6",
		plugins : "advlink,paste,table,advhr,imagemanager,filemanager,spellchecker,inlinepopups,media",
		theme_advanced_buttons1 : "spellchecker,formatselect,bold,italic,<!--- fontsizeselect,forecolor,bold,italic,underline,strikethrough,charmap,removeformat, --->separator,justifyleft,justifycenter,justifyright,justifyfull,separator,cut,copy,paste,pasteword,removeformat,selectall,separator,undo,redo",
		theme_advanced_buttons2 : "bullist,numlist,outdent,indent,separator,image,media,link,unlink,anchor,separator,<!--- advhr, --->sup,sub,tablecontrols,separator,code",
		theme_advanced_buttons3 : "",
		theme_advanced_resizing : true,
		theme_advanced_resize_horizontal : false,
		theme_advanced_statusbar_location: "bottom",
		paste_auto_cleanup_on_paste : true,
		paste_convert_headers_to_strong : true,
		relative_urls : false,
		remove_script_host : true,
		document_base_url : "#request.url#/",
		convert_urls : false

	});
</script>

<cfelseif  attributes.toolbarset eq 'AdvancedEmail'>
<script type="text/javascript">
tinyMCE.init({
		mode : "textareas",
		editor_selector	: "mce_#attributes.instanceName#",
		theme : "advanced",
		width: "#attributes.width#",
		height: "#attributes.height#",
		content_css: "#attributes.stylesheet#",
		dialog_type : "modal",
		theme_advanced_toolbar_location : "top",
		theme_advanced_toolbar_align : "left",
		theme_advanced_blockformats : "p,h2,h3,h4,h5,h6",
		plugins : "advlink,paste,table,advhr,imagemanager,filemanager,spellchecker,inlinepopups,media",
		theme_advanced_buttons1 : "spellchecker,formatselect,<!--- fontsizeselect,forecolor,bold,italic,underline,strikethrough,charmap,removeformat, --->separator,justifyleft,justifycenter,justifyright,justifyfull,separator,cut,copy,paste,pasteword,removeformat,selectall,separator,undo,redo",
		theme_advanced_buttons2 : "bullist,numlist,outdent,indent,separator,image,media,link,unlink,anchor,separator,tablecontrols,separator,code",
		theme_advanced_buttons3 : "",
		theme_advanced_resizing : true,
		theme_advanced_resize_horizontal : false,
		theme_advanced_statusbar_location: "bottom",
		paste_auto_cleanup_on_paste : true,
		paste_convert_headers_to_strong : true,
		relative_urls : false,
		remove_script_host : false,
		document_base_url : "#request.url#/",
		convert_urls : false
	});
</script>
</cfif>

<div>
<!--- textarea name="#attributes.instanceName#" class="mce_#attributes.instanceName#" id="#attributes.instanceName#" tabindex="#attributes.tabindex#">#HTMLEditFormat(attributes.value)#</textarea --->
<textarea name="#attributes.instanceName#" class="mce_#attributes.instanceName#" id="#attributes.instanceName#" tabindex="#attributes.tabindex#">#HTMLEditFormat(attributes.value)#</textarea>

</div>
</cfoutput>

<cfsetting enablecfoutputonly="no">
<cfexit method="exittag">