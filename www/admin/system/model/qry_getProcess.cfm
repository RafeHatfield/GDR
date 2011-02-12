<cfquery name="getProcess"  datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
	SELECT *
	FROM Process (NOLOCK)
	WHERE pro_id = <cfqueryparam value='#attributes.pro_id#' cfsqltype='cf_sql_integer' />
</cfquery>