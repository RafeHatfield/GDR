<cfquery name="getMenu" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
	SELECT mse_title, mse_order, pro_name, pfu_id, pfu_title, pfu_name, pfu_menuOrder
	FROM menuSection
		INNER JOIN processFuses on pfu_menuSection = mse_id
		INNER JOIN process on pro_id = pfu_process
	GROUP BY mse_title, mse_order, pro_name, pfu_id, pfu_title, pfu_name, pfu_menuOrder
	ORDER BY mse_order, pfu_menuOrder
</cfquery>