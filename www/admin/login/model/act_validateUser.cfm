<!--- <cfoutput>#cookie.id#</cfoutput>
<cfdump var="#cookie#" />
<cfabort> --->

<cfif isDefined('cookie.usr_id')>
	<cfset thisID = cookie.usr_id>
<cfelse>
	<cfset thisID = '0'>
</cfif>

<cfquery name="validateUser" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
	SELECT usr_id, usr_email, usr_firstName, usr_surname
	FROM users (NOLOCK)
	WHERE usr_id = '#thisID#'
</cfquery>