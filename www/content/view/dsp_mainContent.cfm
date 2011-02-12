<cfoutput>

	<cfparam name="attributes.page" default="home" />

	<cfswitch expression="#attributes.fuseAction#">

		<cfdefaultCase>

			#trim(application.contentObj.displayContent(page=attributes.page))#

		</cfdefaultCase>

	</cfswitch>

</cfoutput>