<cfset secureKey = "someSecretKey">

<cfif client.AdminLoginID gt 0>

	<cfoutput>
	<html>
	<body onload="document.forms[0].submit();">
	<form method="post" action="#attributes.RETURN_URL#">
		<input type="hidden" name="key" value="#lcase(hash(secureKey))#" />
		<!--- <input type="hidden" name="<%= htmlEncode(key.replaceAll("\\.", "__")) %>" value="<%= htmlEncode((String) configuration.get(key)) %>" /> --->
	</form>
	</body>
	</html>
	</cfoutput>

<cfelseif client.MemberID gt 0>

	<!--- TODO for members to use the file uploader --->

<cfelse>

	<h1>Forbidden</h1>
	<cfoutput>#session.AdminLoginID#</cfoutput>

</cfif>