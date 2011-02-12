<cfquery name="getProcesses"  datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
	select *
	from Process
	order by pro_id
</cfquery>