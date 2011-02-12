<cfquery name="checkUser" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
	SELECT usr_id, usr_firstName, usr_surname, usr_email, usr_profile
	FROM users
	WHERE usr_email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.username#" list="false" />
		AND usr_password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.password#" list="false" />
</cfquery>