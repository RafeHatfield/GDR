<!---
	sample index.cfm if you use Application.cfm
	this should be empty if you use Application.cfc
--->


<!--- set application name based on the directory path --->
<!--- <cfapplication name="#right(REReplace(expandPath('.'),'[^A-Za-z]','','all'),64)#" /> --->

<!--- enable debugging --->
<!--- now done in app.cfc --->
<!---
<cfif listFind(cgi.SERVER_NAME,'local','.')>
	<cfset FUSEBOX_PARAMETERS.debug = true />
	<cfset FUSEBOX_PARAMETERS.mode = "development-full-load" />
</cfif>
 --->

<!--- include the core file runtime --->
<cfinclude template="/fusebox5/fusebox5.cfm" />