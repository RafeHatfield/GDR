<cfprocessingdirective suppresswhitespace="yes">

	<cfif listFirst(attributes.fuseAction, '.') NEQ "Login">

		<cfquery name="checkPermission" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT pfu_id
			FROM ProcessFuses
				INNER JOIN profileFuses ON pfu_id= pff_processFuse
				INNER JOIN users on pff_profile = usr_profile
			WHERE usr_id = <cfqueryparam cfsqltype="cf_sql_idstamp" value="#cookie.usr_id#">
				AND pfu_name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listLast(attributes.fuseAction, '.')#">
		</cfquery>

		<cfif not checkPermission.recordCount>

			<cfthrow type="SecurityException" message="The user does not have the required permission to access this fuseaction." />

		</cfif>

	</cfif>

</cfprocessingdirective>