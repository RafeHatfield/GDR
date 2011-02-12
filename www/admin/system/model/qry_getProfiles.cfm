<cfquery name="getProfiles" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
	select prf_id, prf_name, prf_description
	from Profiles
	order by prf_id
</cfquery>