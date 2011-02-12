<cftransaction>

	<cfquery name="deleteProfilePermissions" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
		DELETE FROM profileFuses
		WHERE pff_profile = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.prf_id#" list="false" />
	</cfquery>

	<cfloop list="#attributes.profilePermissionsList#" index="thisPermission">

		<cfquery name="addProfilePermission" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			INSERT INTO profileFuses (
				pff_profile,
				pff_processFuse
			) VALUES (
				<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.prf_id#" list="false" />,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#thisPermission#" list="false" />
			)
		</cfquery>

	</cfloop>

</cftransaction>