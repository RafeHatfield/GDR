<cfquery name="getProfileFuses" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
	select pff_processFuse
	from profiles
		inner join profileFuses on pff_profile = prf_id
	order by pff_processFuse
</cfquery>