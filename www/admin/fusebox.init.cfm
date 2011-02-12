<!--- INIT the app --->
<cfsilent>
<!---
	<cfset self = "index.cfm">
	<cfset myself = "#self#?#application.fusebox.fuseactionVariable#=">
	 --->
	<cfset self = myFusebox.getSelf() />
	<cfset myself = myFusebox.getMyself() />
	<cfset attributes.self = self />
	<cfset attributes.myself = myself />
	<cfset request.self = myFusebox.getSelf() />
	<cfset request.myself = myFusebox.getMyself() />

	<!--- <cfinclude template="#application.rootPath#autoUpload/model/udf_stringparse.cfm" /> --->
</cfsilent>