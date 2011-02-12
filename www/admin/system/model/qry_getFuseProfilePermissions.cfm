<cfquery name="getFuseProfilePermissions"  datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
	select *
	from profileFuses
	where pff_processFuse = <cfqueryparam value='#attributes.pfu_id#' cfsqltype='cf_sql_integer' />
</cfquery>