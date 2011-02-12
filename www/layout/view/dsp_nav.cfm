<cfcontent reset="true"><cfoutput><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
	<head>
		<cfparam name='request.pageTitle' default='FUSEACTION: #attributes.fuseAction#' />
		<title>#request.pageTitle#</title>
		<meta name="system-status" content="online" />

		<link rel="stylesheet" href="/admin/css/default.css" type="text/css" media="screen">

		<cfloop list="#request.styleSheetList#" index="styleSheet">
			<link href="/admin/css/#styleSheet#" rel="stylesheet" type="text/css" />
		</cfloop>

		<cfloop list="#request.jsList#" index="jsFile">
			<script language="JavaScript" type="text/javascript" src="/admin/js/#jsFile#"></script>
		</cfloop>

	</head>
	<body #request.bodyParams#>
		<table cellspacing='0' style="width:100%; padding-right:15px; collapse:collapse">
			<tr>
				<td colspan='3'>#content.headerBar#</td>
			</tr>
			<tr>
				<td width='180' valign='top'>#content.mainMenu#</td>
				<td valign='top'>&nbsp;</td>
				<td valign='top'>
					#content.mainContent#
					<br /><br /><br />
				</td>
			</tr>
			<tr>
				<td colspan='3'>#content.footerBar#</td>
			</tr>
		</table>
		<cfif len(request.footerJS)>
			<!--- strip tabs out  --->
			<cfset request.footerJS = Replace(request.footerJS,"#chr(9)#","","ALL")>
			#request.footerJS#
		</cfif>
	</body>
</html></cfoutput>