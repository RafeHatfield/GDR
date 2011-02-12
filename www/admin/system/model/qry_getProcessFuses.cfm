<cfquery name="getProcessFuses"  datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
	select pro_id, pro_name, pfu_id, pfu_name
	from processFuses
	inner join process on pro_id = pfu_process
	left outer join menuSection on mse_id = pfu_menuSection
	group by pro_id, pro_name, pfu_id, pfu_name
	order by pro_id, pfu_id
</cfquery>