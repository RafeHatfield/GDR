<cfcontent reset="true"><cfoutput><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
	<head>
		<cfparam name='request.pageTitle' default='FUSEACTION: #attributes.fuseAction#' />
		<title>#request.pageTitle#</title>
		<meta name="system-status" content="online" />

		<link rel="stylesheet" href="css/default.css" type="text/css" media="screen">

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
<!--- 		application.imageUploadPath: #application.imageUploadPath#<br />
		application.flashUploadPath: #application.flashUploadPath#<br />
		application.path: #application.path#<br />
		application.rootPath: #application.rootPath#<br />
		application.rootDir: #application.rootDir#<br /> --->
	</body>
</html></cfoutput>


<cfparam name="attributes.memberExport" default="0" />

<cfif attributes.memberExport>

	<cfset qMembers = application.MemberObj.getMembers(argumentCollection=attributes) />
	
	<cfcontent reset="true"><cfoutput>#application.systemObj.generateExcelFromQuery(myQuery="#qMembers#",fileName="Members",orderedColumnList="mem_id, mem_title, mem_firstName, mem_surname, mem_email, mem_mobilePhone, mem_officePhone, mem_homePhone, mem_address1, mem_address2, mem_address3, mem_suburb, mem_state, mem_countryName, mem_postCode, mem_origin")#</cfoutput>

</cfif> 