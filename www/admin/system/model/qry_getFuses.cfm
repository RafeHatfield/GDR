<cfparam name='attributes.pro_id' default='0'>
<cfquery name="getFuses"  datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
	select pfu_id, pfu_name, pfu_path, pfu_circuitXML, pro_id, pro_name, pfu_isMenu, pfu_title, pfu_menuSection, mse_title, pfu_menuOrder
	from processFuses
	inner join process on pro_id = pfu_process
	left outer join menuSection on mse_id = pfu_menuSection
	<cfif attributes.pro_id gt 0>
		where pro_id = <cfqueryparam value='#attributes.pro_id#' cfsqltype='cf_sql_integer' />
	</cfif> 
	order by pro_id, pfu_id
</cfquery>