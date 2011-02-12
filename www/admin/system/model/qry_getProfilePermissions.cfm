<cfquery name="getProfilePermissions" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
	select pff_processFuse
	from profileFuses
	where pff_profile = <cfqueryparam value='#attributes.prf_id#' cfsqltype='cf_sql_integer' />
</cfquery>