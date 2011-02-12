<!--- FB40 plugin: SimpleSecurity --->
<!--- copyright: (c) 2003, by John Quarto-vonTivadar. You are free to use this FB40 plugin and to modify it as long as you leave my copyright notice intact. --->
<!--- use: during Phase "preProcess" --->
<!--- overview: a very simple approach to Security. Compare the user's security profile to the permission required for the requested fuseaction. If it fails, throw an exception --->

<cfparam name="request.prf_name" default="Visitor">

<cfset plugin = myFusebox.plugins[myFusebox.thisPlugin]>
<cfset userPermissions = request.prf_name>
<cfset requiredPermissions = application.fusebox.circuits[myFusebox.originalCircuit].fuseactions[myFusebox.originalFuseaction].permissions>

<cfif ListLen(requiredPermissions, ',')>
	<cfset plugin.isAllowed = FALSE>
	<cfloop list="#requiredPermissions#" index="aPermission">
		<cfif ListFindNoCase(userPermissions, aPermission, ',')>
			<cfset plugin.isAllowed = TRUE>
			<cfbreak>
		</cfif>
	</cfloop>
	
<cfelse>
	<cfset plugin.isAllowed = TRUE>
</cfif>

<cfif NOT plugin.isAllowed>
	<cfthrow type="SecurityException" message="The user does not have the required permission to access this fuseaction.">
</cfif>
