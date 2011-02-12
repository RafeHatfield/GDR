<cfoutput>

<table cellpadding="0" cellspacing="0">

	<tr>
		<td align="center" colspan="2"><img src="/assets/images/upload/newsletter.jpg" width="780" height="400" class="gloryShot" /></td>
	</tr>

	<tr>
		<td class="contentCell" colspan="2"><h1>#qNewsletter.nsl_title#</h1></td>
	</tr>

	<tr>
		<td class="contentCell" colspan="2"><div class="contentText">#qNewsletter.nsl_body#</div></td>
	</tr>

	<tr>
		<td>

			<table cellpadding="0" cellspacing="0">

				<cfloop query="qNewsletterContent">

					<tr>
						<td class="contentCell whiteRight"><h2>#con_title#</h2></td>
					</tr>

					<tr>
						<td class="whiteRight">

							<cfif val(img_id) gt 0>
								#application.imageObj.showImage(img_id=img_id, class="content_image", showLink="0")#
							</cfif>

							<cfif val(img_height) gt 0>
								<cfset thisHeight = img_height + 5 />
							<cfelse>
								<cfset thisHeight = "120" />
							</cfif>

							<div class="contentText" style="max-height: #thisHeight#px; overflow:hidden">#con_body#</div>

							<cfif len(con_link)>
								<div class="contentText"><a href="#con_link#">Click here for more information.</a></div>
							<cfelse>
								<div class="contentText">
									<cfif con_type is "Content" and not len(con_fuseAction)>
										<li style="margin-left: 15px"><a href="#application.wwwURL#index.cfm?fuseaction=content.display&page=#con_sanitise#">Click here for more information.</a>
									<cfelseif con_type is "Content" and len(con_fuseAction)>
										<li style="margin-left: 15px"><a href="#application.wwwURL#index.cfm?fuseaction=#con_fuseAction#&page=#con_sanitise#">Click here for more information.</a>
									</cfif>
								</div>
							</cfif>

						</td>
					</tr>

				</cfloop>

			</table>

		</td>

		<td style="width:240px;" class="contentCell" valign="top">

			<div style="margin-left: 15px !important;">
				#application.villaObj.displayVillaAddress(class="location_address")#
			</div>


			<div class="content_images" style="margin-left: 15px !important;">

				<cfloop list="#application.ctaObj.randomCallToAction(quantity='5')#" index="thisCTA">

					<cfset qCTA = application.ctaObj.getCallToAction(cta_id=thisCTA) />
					<br />
					<a href="#qCTA.cta_link#"><img src="#application.imagePathBase#upload/#qCTA.cta_image#" border="0" /></a>
					<br />

				</cfloop>

			</div>


		</td>

	</tr>


	<tr>
		<td class="contentCell" colspan="2"></td>
	</tr>


</table>
<!--- <cfdump var="#qNewsletter#">
<cfdump var="#qNewsletterContent#"> --->

<!--- <cfdump var="#application#"> --->



</cfoutput>