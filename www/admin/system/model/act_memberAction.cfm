<cfif attributes.usr_id gt 0>
	<cfquery name="updateMember" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
		UPDATE users SET
			usr_firstName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.usr_firstName#" list="false" />,
			usr_surname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.usr_surname#" list="false" />,
			usr_email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.usr_email#" list="false" />,
			usr_password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.usr_password#" list="false" />,
			usr_profile = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.prf_id#" list="false" />
		WHERE usr_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.usr_id#" list="false" />
	</cfquery>
<cfelse>
	<cfquery name="addMember" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
		INSERT INTO users (
			usr_firstName,
			usr_surname,
			usr_email,
			usr_password,
			usr_profile
		) VALUES (
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.usr_firstName#" list="false" />,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.usr_surname#" list="false" />,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.usr_email#" list="false" />,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.usr_password#" list="false" />,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.prf_id#" list="false" />
		)
	</cfquery>
</cfif>