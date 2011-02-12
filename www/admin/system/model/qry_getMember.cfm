<cfquery name="getMember" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
	SELECT usr_id, usr_firstName, usr_surname, usr_email, usr_password, usr_profile
	FROM users
	WHERE usr_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.usr_id#" list="false" />
</cfquery>