<cfif attributes.mse_id gt 0>
	<cfquery name="updateMenuSection"  datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
		update menuSection set
			mse_title = '#attributes.mse_title#',
			mse_order = #attributes.mse_order#
		where mse_id = #attributes.mse_id#
	</cfquery>
<cfelse>
	<cfquery name="addMenuSection"  datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
		insert into menuSection
			(
			mse_title,
			mse_order
			)
		values
			(
			'#attributes.mse_title#',
			'#attributes.mse_order#'
			)
		<!--- select @@identity as newProID --->
	</cfquery>
	<!--- <cfset attributes.pro_id = addProcess.newProID> --->
</cfif>