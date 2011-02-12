<cfquery name="getFuse"  datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
	select *
	from processFuses
	inner join Process on pro_id = pfu_process
	left outer join menuSection on pfu_menuSection = mse_id
	where pfu_id = <cfqueryparam value='#attributes.pfu_id#' cfsqltype='cf_sql_integer' />
</cfquery>