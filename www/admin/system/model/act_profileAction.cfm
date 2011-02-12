<cfif attributes.prf_id gt 0>

	<cfquery name="updateProfile" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
		UPDATE profiles SET
			prf_name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.prf_name#" list="false" />,
			prf_description = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.prf_description#" list="false" />
		WHERE prf_id = #attributes.prf_id#
	</cfquery>

<cfelse>

	<cfquery name="addProfile" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
		INSERT INTO profiles
			(
			prf_name,
			prf_description
			)
		VALUES
			(
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.prf_name#" list="false" />,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.prf_description#" list="false" />
			)
		<!--- select @@identity as newProID --->
	</cfquery>
	<!--- <cfset attributes.pro_id = addProcess.newProID> --->

</cfif>