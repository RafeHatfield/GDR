<cfif attributes.pro_id gt 0>
	<cfquery name="updateProcess"  datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
		update process set
			pro_name = '#attributes.pro_name#',
			pro_path = '#attributes.pro_path#'
		where pro_id = #attributes.pro_id#
	</cfquery>
<cfelse>
	<cfquery name="addProcess"  datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
		insert into process
			(
			pro_name,
			pro_path
			)
		values
			(
			'#attributes.pro_name#',
			'#attributes.pro_path#'
			)
		<!--- select @@identity as newProID --->
	</cfquery>
	<!--- <cfset attributes.pro_id = addProcess.newProID> --->
</cfif>