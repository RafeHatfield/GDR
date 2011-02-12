<cfquery name="getProfile" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
	SELECT prf_id, prf_name, prf_description
	FROM Profiles
	WHERE prf_id = <cfqueryparam value='#attributes.prf_id#' cfsqltype='cf_sql_integer' />
</cfquery>