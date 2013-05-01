<cfparam name="url.readonly" default="0">

<cfif url.readonly is 1>
	<cfset application.readonlymode = 1 />
	Site is now in read only mode.
<celse>
	<cfset application.readonlymode = 0 />
	Site is NOT in read only mode.
</cfif>