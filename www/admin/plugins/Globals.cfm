<!--- FB40 plugin: Globals.cfm --->
<!--- copyright: (c) 2003, by John Quarto-vonTivadar. You are free to use this FB40 plugin and to modify it as long as you leave this copyright notice intact. --->
<!--- use: during Phase "preProcess" --->
<!--- overview: if the file specified by plugin.file exists in the app root, then load it --->
<!---            if isRequired is TRUE, and the file is not found, then an error message will be shown and processing aborted--->
<!---            if isRequired is FALSE, then try to include the file specified by plugin.file if it exists but silently continue if it doesn't exist --->

<cfset plugin = myFusebox.plugins[myFusebox.thisPlugin]>
<cfset plugin.file = "myGlobals.cfm">
<cfset plugin.isRequired = "false">

	<cftry>
		<cfinclude template="#application.fusebox.plugins[myFusebox.thisPlugin][myFusebox.thisPhase].rootpath##plugin.file#">		
		<cfcatch type="missingInclude">
			<cfif right( cfcatch.missingFileName, Len(plugin.file) ) NEQ plugin.file>
				<cfrethrow>
			<cfelse>
				<cfif plugin.isRequired>
					<cfthrow type="missingPluginInclude" message="The required plugin file #plugin.file# is missing.">
				<cfelse>
					<!--- if the file doesn't exist then do nothing --->		
				</cfif>
			</cfif>
		</cfcatch>
	</cftry>

