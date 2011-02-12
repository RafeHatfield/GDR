<cfquery name="getMenuSections" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
	SELECT mse_id, mse_title, mse_order
	FROM menuSection
	ORDER BY mse_order
</cfquery>