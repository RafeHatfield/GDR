<cfcomponent hint="I am the villa details function" output="false">

	<!--- Author: Rafe - Date: 9/26/2009 --->
	<cffunction name="displayVillaAddress" output="false" access="public" returntype="string" hint="I return the address for the villa">

		<cfargument name="feedbackFormSuccess" type="boolean" default="0" required="false" />

		<cfset var qVillaDetails = getVillaDetails() />
		<cfset var villaAddress = "" />
		<cfset var qContent = application.contentObj.getContent(fuseAction='contact.contactDetails') />

		<cfsaveContent variable="villaAddress">

			<cfoutput query="qVillaDetails">
				
				<div>
				<!--- 
					<div>
						<p><br /><br /><br /><br /></p>
						<h2>#ucase(vil_title)#</h2>
						
						<p>
							<span>#vil_address#</span>
							
							<cfif len(vil_phone)>
								<span>ph: #vil_phone#</span>
							</cfif>
							
							<cfif len(vil_fax)>
								<span>fax: #vil_fax#</span>
							</cfif>
	
							<cfif len(vil_email)>
								<span>email: #vil_email#</span>
							</cfif>
	
						</p>
						
						<p><br /></p>
					</div>
						
					 --->
					<div>
					
						<div class="register_box_left">
							
							<h2>#qContent.con_title#</h2>
							
							<cfif arguments.feedbackFormSuccess>
								<p>Thankyou for contacting us.  We will respond to your enquiry as soon as possible.</p>
							<cfelse>
								#qContent.con_body#
							</cfif>
						
							<cfform action="index.cfm?fuseaction=contact.contactDetails" name="contentForm">   
								  
								<p>
									<label>first name</label>
									<cfinput required="yes" message="Please provide your first name." name="mem_firstName" type="text">
								</p>
								<p>
									<label>surname</label>
									<cfinput required="yes" message="Please provide your last name." name="mem_surname" type="text">
								</p>
								<p>
									<label>email</label>
									<cfinput validate="email" required="yes" message="Please enter a valid email address" name="mem_email" type="text" />
								</p>
								<p>
									<label>phone</label>
									<cfinput required="yes" message="Please provide your phone number." name="mem_phone" type="text">
								</p>
								<p>
									<label>comments</label>
									<textarea name="mes_body" rows=" " cols=" "></textarea>
								</p>
								
                       			<p class="btn_register">
									<input type="submit" name="save" value="send" />
								</p>
								
							</cfform>
							
						</div>
						
              			<div class="register_box_right"><img src="#application.imagePath##qContent.img_name#" alt="#qContent.img_title#" width="347" height="560" /></div>
					
					</div>
					
				</div>
				
			</cfoutput>

		</cfsaveContent>

		<cfreturn villaAddress />

	</cffunction>

	<!--- Author: Rafe - Date: 10/4/2009 --->
	<cffunction name="getVillaDetails" output="false" access="public" returntype="query" hint="I return the details for the villa">

		<cfset var getVillaDetails = "" />

		<cfquery name="getVillaDetails" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT TOP(1) vil_title, vil_description, vil_address, vil_phone, vil_email, vil_otherContact, vil_approval, vil_fax
			FROM Villa
		</cfquery>

		<cfreturn getVillaDetails />

	</cffunction>

	<!--- Author: Rafe - Date: 10/4/2009 --->
	<cffunction name="villaDetailsSave" output="false" access="public" returntype="any" hint="I save the villas details">

		<cfset var deleteVillaDetails = "" />
		<cfset var addVillaDetails = "" />

		<cftransaction>

			<cfquery name="deleteVillaDetails" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
				DELETE FROM Villa
			</cfquery>

			<cfquery name="addVillaDetails" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
				INSERT INTO Villa (
					vil_title,
					vil_description,
					vil_address,
					vil_phone,
					vil_email,
					vil_otherContact,
					vil_fax
				) VALUES (
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.vil_title#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.vil_description#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.vil_address#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.vil_phone#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.vil_email#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.vil_otherContact#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.vil_fax#" list="false" />
				)
			</cfquery>

		</cftransaction>

	</cffunction>

	<!--- Author: Rafe - Date: 10/13/2009 --->
	<cffunction name="getPromotion" output="false" access="public" returntype="query" hint="I return a query with the given promotion">

		<cfargument name="prm_id" type="numeric" default="" required="true" />

		<cfset var getPromotion = "" />

		<cfquery name="getPromotion" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT prm_title, prm_body, prm_active
			FROM wwwPromotion
			WHERE prm_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.prm_id#" list="false" />
		</cfquery>

		<cfreturn getPromotion />

	</cffunction>

	<!--- Author: Rafe - Date: 10/17/2009 --->
	<cffunction name="getPromotionImage" output="false" access="public" returntype="query" hint="I return a promotion image based on the promotion ID and image type">

		<cfargument name="img_type" type="string" default="Promotion" required="false" />
		<cfargument name="prm_id" type="numeric" default="" required="true" />

		<cfset var getPromotionImage = "" />

		<cfquery name="getPromotionImage" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT img_id, img_title, img_name, img_title, img_altText
			FROM wwwImage
				INNER JOIN wwwPromotion_Image on pri_image = img_id
					AND pri_promotion = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.prm_id#" list="false" />
			WHERE img_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.img_type#" list="false" />
		</cfquery>

		<cfreturn getPromotionImage />

	</cffunction>

	<!--- Author: Rafe - Date: 10/13/2009 --->
	<cffunction name="getPromotions" output="false" access="public" returntype="query" hint="I return a query with all the promotions">

		<cfset var getPromotions = "" />

		<cfquery name="getPromotions" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT prm_id, prm_title, prm_body, prm_active,
				img_id, img_title, img_name, img_altText
			FROM wwwPromotion
				INNER JOIN wwwPromotion_Image ON prm_id = pri_promotion
				INNER JOIN wwwImage ON pri_image = img_id
					AND img_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="Promotion" list="false" />
			WHERE prm_active = 1
			ORDER BY prm_dateEntered DESC
		</cfquery>

		<cfreturn getPromotions />

	</cffunction>

	<!--- Author: Rafe - Date: 10/13/2009 --->
	<cffunction name="getPromotionsAdmin" output="false" access="public" returntype="query" hint="I return a query with all the promotions">

		<cfset var getPromotions = "" />

		<cfquery name="getPromotions" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT prm_id, prm_title, prm_body, prm_active
			FROM wwwPromotion
			ORDER BY prm_dateEntered DESC
		</cfquery>

		<cfreturn getPromotions />

	</cffunction>

	<!--- Author: Rafe - Date: 10/13/2009 --->
	<cffunction name="promotionSave" output="false" access="public" returntype="any" hint="i save the information for a promotion">

		<cfargument name="prm_active" type="string" default="" required="false" />

		<cfset var updatePromotion = "" />
		<cfset var addPromotion = "" />
		<Cfset var addImage = "" />
		<cfset var updateImage = "" />
		<cfset var removePromotionImage = "" />
		<cfset var addPromotionImage = "" />
		<cfset var imageInterpolation = "highPerformance" />

		<cfset arguments.prm_active = yesNoFormat(arguments.prm_active) />

		<cfif arguments.prm_id gt 0>

			<cfquery name="updatePromotion"  datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
				UPDATE wwwPromotion SET
					prm_title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.prm_title#" list="false" />,
					prm_body = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.prm_body#" list="false" />,
					prm_active = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.prm_active#" list="false" />
				WHERE prm_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.prm_id#" list="false" />
			</cfquery>

		<cfelse>

			<cfquery name="addPromotion"  datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
				INSERT INTO wwwPromotion	(
					prm_title,
					prm_body,
					prm_active
				) VALUES (
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.prm_title#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.prm_body#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.prm_active#" list="false" />
				)
				SELECT SCOPE_IDENTITY() AS promotionID
			</cfquery>

			<cfset arguments.prm_id = addPromotion.promotionID />

		</cfif>

		<!--- handle main image --->
		<cfif len(arguments.img_name)>

			<cffile action="upload" filefield="img_name" destination="#application.imageUploadPath#" nameconflict="makeUnique" accept="image/gif, image/jpeg, image/jpg, image/pjpeg">

			<cfset FileName = cffile.serverFileName & '.' & cffile.serverFileExt />
			<cfset fileNameSanitise = application.contentObj.sanitise(cffile.serverFileName) & '.' & cffile.serverFileExt />

			<cffile action="rename" source="#application.imageUploadPath##fileName#" destination="#application.imageUploadPath##fileNameSanitise#">

			<cfset newFileName = cffile.serverFileName & '_240.' & cffile.serverFileExt />
			<cfset newFileNameSanitise = application.contentObj.sanitise(cffile.serverFileName) & '_240.' & cffile.serverFileExt />

			<cfimage action="read" name="imageInMem" source="#application.imageUploadPath##FileNameSanitise#" />

			<cfset ImageResize(imageInMem, "600", "", imageInterpolation) />

			<cfimage source="#imageInMem#" action="write" destination="#application.imageUploadPath##fileNameSanitise#" overwrite="yes" />

			<cfimage action="info" source="#imageInMem#" structName="ImageCR" />

			<cfset origWidth = imageCR.width />
			<cfset origHeight = imageCR.height />

			<cfset ImageSetAntialiasing(imageInMem) />

			<!--- <cfif imageCR.width neq application.imageStandardWidth> --->

			<cfset ImageResize(imageInMem, application.imageStandardWidth, "", imageInterpolation) />

			<!--- </cfif> --->

			<cfimage action="info" source="#imageInMem#" structName="ImageCR" />

			<cfset finalWidth = imageCR.width />
			<cfset finalHeight = imageCR.height />

			<cfimage source="#imageInMem#" action="write" destination="#application.imageUploadPath##newFileNameSanitise#" overwrite="yes" />

			<!--- add new image to database for this content --->

			<cftransaction>

				<cfquery name="addImage" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
					INSERT INTO wwwImage (
						img_title,
						img_name,
						img_type,
						img_altText,
						img_height,
						img_width,
						img_origName,
						img_origHeight,
						img_origWidth
					) VALUES (
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.img_title#" list="false" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#newFileNameSanitise#" list="false" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="Promotion" list="false" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.img_altText#" list="false" />,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#finalHeight#" list="false" />,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#finalWidth#" list="false" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#fileNameSanitise#" list="false" />,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#origHeight#" list="false" />,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#origWidth#" list="false" />
					)

					SELECT SCOPE_IDENTITY() AS imageID
				</cfquery>

				<!--- remove any previous main image for this content --->
				<cfquery name="removePromotionImage" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
					DELETE FROM wwwPromotion_Image
					WHERE pri_promotion = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.prm_id#" list="false" />
						AND pri_image IN (
							SELECT img_id
							FROM wwwImage
							WHERE img_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="Promotion" list="false" />
						)
				</cfquery>

				<!--- add new image for this content --->
				<cfquery name="addPromotionImage" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
					INSERT INTO wwwPromotion_Image (
						pri_promotion,
						pri_image
					) VALUES (
						<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.prm_id#" list="false" />,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#addImage.imageID#" list="false" />
					)
				</cfquery>

			</cftransaction>

		<cfelseif val(arguments.img_id) gt 0>

			<!--- no new image, update details for existing image --->
			<cfquery name="updateImage" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
				UPDATE wwwImage SET
					img_title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.img_title#" list="false" />,
					img_altText = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.img_altText#" list="false" />
				WHERE img_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.img_id#" list="false" />
			</cfquery>

		</cfif>

		<!--- handle glory image --->
		<cfif len(arguments.img_nameGlory)>

			<cffile action="upload" filefield="img_nameGlory" destination="#application.imageUploadPath#" nameconflict="makeUnique" accept="image/gif, image/jpeg, image/jpg, image/pjpeg">

			<cfset FileName = cffile.serverFileName & '.' & cffile.serverFileExt />
			<cfset fileNameSanitise = application.contentObj.sanitise(cffile.serverFileName) & '.' & cffile.serverFileExt />

			<cffile action="rename" source="#application.imageUploadPath##fileName#" destination="#application.imageUploadPath##fileNameSanitise#">

			<cfimage action="read" name="imageInMem" source="#application.imageUploadPath##FileNameSanitise#" />

			<cfset ImageResize(imageInMem, "800", "", imageInterpolation) />

			<cfset ImageCrop(imageInMem, "0", "0", "800", "400") />

			<cfimage source="#imageInMem#" action="write" destination="#application.imageUploadPath##fileNameSanitise#" overwrite="yes" />

			<cfimage action="info" source="#imageInMem#" structName="ImageCR" />

			<cfset finalWidth = imageCR.width />
			<cfset finalHeight = imageCR.height />

			<cftransaction>

				<cfquery name="addImage" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
					INSERT INTO wwwImage (
						img_title,
						img_name,
						img_type,
						img_altText,
						img_height,
						img_width
					) VALUES (
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.img_title#" list="false" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#fileNameSanitise#" list="false" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="Promotion Glory" list="false" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.img_altText#" list="false" />,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#finalHeight#" list="false" />,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#finalWidth#" list="false" />
					)

					SELECT SCOPE_IDENTITY() AS imageID
				</cfquery>

				<!--- remove any previous main image for this content --->
				<cfquery name="removePromotionImage" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
					DELETE FROM wwwPromotion_Image
					WHERE pri_promotion = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.prm_id#" list="false" />
						AND pri_image IN (
							SELECT img_id
							FROM wwwImage
							WHERE img_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="Promotion Glory" list="false" />
						)
				</cfquery>

				<!--- add new image for this content --->
				<cfquery name="addPromotionImage" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
					INSERT INTO wwwPromotion_Image (
						pri_promotion,
						pri_image
					) VALUES (
						<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.prm_id#" list="false" />,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#addImage.imageID#" list="false" />
					)
				</cfquery>

			</cftransaction>

		<cfelseif val(arguments.img_idGlory) gt 0>

			<!--- no new image, update details for existing image --->
			<cfquery name="updateImage" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
				UPDATE wwwImage SET
					img_title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.img_title#" list="false" />,
					img_altText = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.img_altText#" list="false" />
				WHERE img_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.img_idGlory#" list="false" />
			</cfquery>

		</cfif>

	</cffunction>

	<!--- Author: Rafe - Date: 10/17/2009 --->
	<cffunction name="promotionContactSave" output="false" access="public" returntype="any" hint="">

		<cfargument name="newsletterSignup" type="string" default="" required="false" />

		<cfset var promotionContactSuccess = 0 />

		<cfset var memberID = application.memberObj.memberSave(argumentCollection=arguments) />

		<cfset var PromotionGroupSuccess = application.memberObj.memberGroupSave(mem_id=memberID, grp_id="8") />

		<cfif yesNoFormat(arguments.newsletterSignUp)>
			<cfset newsletterSignupSuccess = application.memberObj.memberGroupSave(mem_id=memberID, grp_id="1") />
		</cfif>

		<cfset qPromotion = application.villaObj.getPromotion(prm_id=arguments.prm_id) />

		<cfif len(arguments.mes_body)>
			<cfset messageSave = application.contactObj.messageSave(mem_id=memberID, mes_title="Booking Request for #qPromotion.prm_title#", mes_body=arguments.mes_body) />
		</cfif>

		<cfmail to="#application.feedbackEmail#" from="#application.feedbackEmail#" subject="Booking Request for #qPromotion.prm_title#">

Name: #arguments.mem_firstname# #arguments.mem_surname#
Email: #arguments.mem_email#
Phone: #arguments.mem_homePhone#
Preferred Date: #arguments.preferredDate#
Preferred Time: #arguments.preferredTime#
Notes: #mes_body#

		</cfmail>

		<cfset promotionContactSuccess = 1 />

		<cfreturn promotionContactSuccess />

	</cffunction>

</cfcomponent>


































