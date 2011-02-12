<cffunction name="canAccess" access="public" returntype="boolean">

	<cfargument name="fuseAction" type="string" required="yes">

	<cfset var hasAccess = false />

	<cfquery name="validateUser" dataSource="#Application.DataSource#" userName="#Application.DBUserName#" password="#Application.DBUserPwd#">
		SELECT 1
		FROM profileFuses
			INNER JOIN processFuses On pff_processFuse = pfu_id
			INNER JOIN users ON usr_profile = pff_profile
		WHERE pfu_name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fuseAction#" />
			AND usr_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.usr_id#" list="false" />
	</CFQUERY>

	<cfif validateuser.recordCount>
		<cfset hasAccess = true />
	</cfif>

	<cfreturn hasAccess />

</cffunction>