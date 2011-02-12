<cfquery name="getMembers" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
	SELECT usr_id, usr_firstName, usr_surname, usr_email, usr_password,
		prf_name
	FROM users
		INNER JOIN profiles on usr_profile = prf_id
	WHERE 1 = 1

		<cfif len(attributes.fastFind)>
			AND (
				usr_firstName + ' ' + usr_surname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.fastFind#%" list="false" />
				OR
				usr_email LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.fastFind#%" list="false" />
			)
		</cfif>

		<cfif attributes.prf_id gt 0>
			AND usr_profile = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.prf_id#" list="false" />
		</cfif>

	ORDER BY usr_firstName
</cfquery>