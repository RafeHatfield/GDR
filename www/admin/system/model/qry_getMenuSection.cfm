<cfquery name="getMenuSection"  datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
	select *
	from menuSection
	where mse_id = <cfqueryparam value='#attributes.mse_id#' cfsqltype='cf_sql_integer' />
</cfquery>