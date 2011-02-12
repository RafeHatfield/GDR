<cfoutput>

	<div id="left_column">

		<cfif request.qContent.con_leftMenuArea gt 0>

			#trim(application.menuObj.displayMenuMenuArea(myself=myFusebox.getMyself(),menuArea=request.qContent.con_leftMenuArea))#

		<cfelse>

			#application.villaObj.displayVillaAddress(class="location_address")#

		</cfif>

		<div class="content_images">

			<cfloop list="#application.ctaObj.randomCallToAction(quantity='2')#" index="thisCTA">

				<cfset qCTA = application.ctaObj.getCallToAction(cta_id=thisCTA) />

				<a href="#qCTA.cta_link#"><img src="#application.imagePathBase#upload/#qCTA.cta_image#" alt="#qCTA.cta_title#" /></a>

			</cfloop>

		</div>

	</div>


</cfoutput>