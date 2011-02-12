<cfif attributes.pfu_id gt 0>
	<cfquery name="updateFuse"  datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
		update processFuses set
			pfu_name = '#attributes.pfu_name#',
			pfu_path = '#attributes.pfu_path#',
			pfu_circuitXML = '#attributes.pfu_circuitXML#',
			pfu_process = #attributes.pro_id#,
			pfu_isMenu = #attributes.pfu_isMenu#,
			pfu_title = '#pfu_title#',
			pfu_menuOrder = <cfif attributes.pfu_menuOrder gt 0>#attributes.pfu_menuOrder#<cfelse>0</cfif>,
			pfu_menuSection = <cfif attributes.mse_id gt 0>#attributes.mse_id#<cfelse>NULL</cfif>
		where pfu_id = #attributes.pfu_id#
	</cfquery>
	
	<cfset thisFuse = attributes.pfu_id>
<cfelse>
	<cfquery name="addFuse"  datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
		insert into processFuses
			(
			pfu_name,
			pfu_path,
			pfu_circuitXML,
			pfu_process,
			pfu_isMenu,
			pfu_title,
			pfu_menuOrder,
			pfu_menuSection
			)
		values
			(
			'#attributes.pfu_name#',
			'#attributes.pfu_path#',
			'#attributes.pfu_circuitXML#',
			#attributes.pro_id#,
			#attributes.pfu_isMenu#,
			'#pfu_title#',
			<cfif attributes.pfu_menuOrder gt 0>#attributes.pfu_menuOrder#<cfelse>0</cfif>,
			<cfif attributes.mse_id gt 0>#attributes.mse_id#<cfelse>NULL</cfif>
			)
		select @@identity as newFuseID
	</cfquery>
	
	<cfset thisFuse = addFuse.newFuseID>
</cfif>

<!--- <cfquery name="removeOldPermissions" datasource="#request.dsn#">
	delete from profileFuses
	where pff_processFuse = #thisFuse#
</cfquery>

<cfloop list='#attributes.permissionsList#' index='thisPermission'>
	<cfquery name="addProfilePermissions" datasource="#request.dsn#">
		insert into profileFuses
			(
			pff_profile,
			pff_processFuse,
			pff_modifiedBy,
			pff_modifiedDate
			)
		values
			(
			#thisPermission#,
			#thisFuse#,
			613056, <!--- hardcoded to rafe for now --->
			#now()#
			)
	</cfquery>
</cfloop> --->