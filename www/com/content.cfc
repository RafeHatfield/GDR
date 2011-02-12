<cfcomponent hint="I am the compontent that holds the content functions" output="false">

	<!--- Author: Rafe - Date: 9/26/2009 --->
	<cffunction name="displayContent" output="false" access="public" returntype="string" hint="I return the content based on the fuseAction">

		<cfargument name="page" type="string" default="" required="false" />
		<cfargument name="fuseAction" type="string" default="" required="false" />

		<cfset var content = "" />
		<cfset var qContent = "" />

		<cfif len(arguments.page)>
			<cfset qContent = getContent(page=arguments.page) />
		<cfelseif len(arguments.fuseAction)>
			<cfset qContent = getContent(fuseAction=arguments.fuseAction) />
		</cfif>

		<cfsaveContent variable="content">

			<cfoutput query="qContent">
		
				<div class="about_box_left">
					
					<h2>#con_title#</h2>
					
					#con_body#
															
					<cfif len(con_link)>
						<p><a href="#con_link#">Click here for more information.</a></p>
					</cfif>
							
				</div>
				
				<cfif len(img_name)>
					<div class="about_box_right">
						<img src="#application.imagePath##img_name#" alt="#img_title#" width="347" height="560" />
					</div>
				</cfif>

			</cfoutput>

		</cfsaveContent>

		<cfreturn content />

	</cffunction>

	<!--- Author: Rafe - Date: 9/27/2009 --->
	<cffunction name="getContent" output="false" access="public" returntype="query" hint="I return all the content based on either ID or the unique page string">

		<cfargument name="page" type="string" default="" required="false" />
		<cfargument name="con_id" type="numeric" default="0" required="false" />
		<cfargument name="fuseAction" type="string" default="" required="false" />

		<cfset var getContent = "" />

		<cfquery name="getContent" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT top (1) con_id, con_menuTitle, con_title, con_intro, con_body, con_fuseAction, con_isMenu, con_menuArea, con_menuOrder, con_active, con_type, con_gloryBox, con_leftMenuArea, con_approved, con_link, con_metaDescription, con_metaKeywords, con_parentID,
				img_id, img_name, img_title, img_altText, img_height, img_width,
				gbx_title, gbx_name
			FROM wwwContent
				LEFT OUTER JOIN wwwGloryBox on con_gloryBox = gbx_id
				LEFT OUTER JOIN wwwContent_Image on con_id = coi_content
				LEFT OUTER JOIN wwwImage on coi_image = img_id
					AND img_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="Main" list="false" />
			WHERE 1 = 1

				<cfif arguments.con_id is 0 and not len(arguments.page) and not len(arguments.fuseAction)>
					AND 1 = 0
				</cfif>

				<cfif arguments.con_id gt 0>
					AND con_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.con_id#" list="false" />
				<cfelseif len(arguments.page)>
					AND con_sanitise = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.page#" list="false" />
				<cfelseif len(arguments.fuseAction)>
					AND con_fuseAction = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fuseAction#" list="false" />
				</cfif>

		</cfquery>

		<cfreturn getContent />

	</cffunction>

	<!--- Author: Rafe - Date: 10/2/2009 --->
	<cffunction name="getAllContent" output="false" access="public" returntype="any" hint="I return all the content in the system, grouped by their menu area">

		<cfargument name="mna_id" type="numeric" default="0" required="false" />
		<cfargument name="showUnapprovedOnly" type="string" default="0" required="false" />
		<cfargument name="approved" type="string" default="" required="false" />
		<cfargument name="con_type" type="string" default="" required="false" />
		<cfargument name="excludeContent" type="string" default="" required="false" />
		<cfargument name="fastFind" type="string" default="" required="false" />
		<cfargument name="menuArea" type="string" default="" required="false" />

		<cfset var getAllContent = "" />

		<cfquery name="getAllContent" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT mna_id, mna_title,
				con_id, con_type, con_menuTitle, con_title, con_isMenu, con_menuOrder, con_fuseAction, con_active, con_approved
			FROM wwwContent
				LEFT OUTER JOIN wwwMenuArea on con_menuArea = mna_id
			WHERE 1 = 1

				<cfif arguments.mna_id gt 0>
					AND mna_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.mna_id#" list="false" />
				</cfif>

				<cfif yesNoFormat(arguments.approved)>
					AND con_approved = 1
				</cfif>

				<cfif yesNoFormat(arguments.showUnapprovedOnly)>
					AND con_approved = 0
				</cfif>

				<cfif listLen(arguments.con_type)>
					AND con_type in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.con_type#" list="true" />)
				</cfif>

				<cfif listLen(arguments.excludeContent)>
					AND con_id NOT IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.excludeContent#" list="true" />)
				</cfif>

				<cfif len(arguments.fastFind)>
					AND (
						con_title like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.fastFind#%" list="false" />
						OR
						con_body like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.fastFind#%" list="false" />
					)
				</cfif>

				<cfif val(arguments.menuArea) gt 0>
					AND mna_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.menuArea#" list="false" />
				</cfif>

			<!--- GROUP BY mna_id, mna_title, con_id, con_menuTitle, con_title, con_isMenu, con_menuOrder, con_fuseAction, con_active, con_approved, con_type --->
			ORDER BY con_type, mna_title, con_parentID, con_menuOrder
		</cfquery>

		<cfreturn getAllContent />

	</cffunction>

	<!--- Author: Rafe - Date: 10/3/2009 --->
	<cffunction name="contentSave" output="false" access="public" returntype="any" hint="I save the details of the edited content page, including the image upload mechanism">

		<cfargument name="con_isMenu" type="string" default="0" required="false" />
		<cfargument name="con_active" type="string" default="0" required="false" />
		<cfargument name="con_approved" type="string" default="0" required="false" />
		<cfargument name="old_con_approved" type="string" default="0" required="false" />

		<cfset var fileName = "" />
		<cfset var newFileName = "" />
		<cfset var fileNameSanitise = "" />
		<cfset var newFileNameSanitise = "" />
		<cfset var imageInterpolation = "highestQuality" />
		<cfset var imageCounter = arguments.contentImageCount />
		<cfset var img_id = "" />
		<cfset var img_title = "" />
		<cfset var img_altText = "" />
		<cfset var updateImage = "" />
		<cfset var updateImageOrder = "" />
		<cfset var updateContent = "" />
		<cfset var addContent = "" />

		<cfset arguments.con_isMenu = yesNoFormat(arguments.con_isMenu) />
		<cfset arguments.con_active = yesNoFormat(arguments.con_active) />
		<cfset arguments.con_approved = yesNoFormat(arguments.con_approved) />
		<cfset arguments.old_con_approved = yesNoFormat(arguments.old_con_approved) />

		<cfif arguments.con_id gt 0>

			<cfquery name="updateContent"  datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
				UPDATE wwwContent SET
					con_menuTitle = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.con_menuTitle#" list="false" />,
					con_title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.con_title#" list="false" />,
					con_body = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.con_body#" list="false" />,
					<!--- con_intro = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.con_intro#" list="false" />, --->
					con_isMenu = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.con_isMenu#" list="false" />,
					con_menuArea = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.con_menuArea#" list="false" />,
					con_menuOrder = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.con_menuOrder#" list="false" />,
					con_parentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.con_parentID)#" list="false" />,
					con_active = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.con_active#" list="false" />,
					con_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.con_type#" list="false" />,
<!--- 					con_gloryBox = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.con_gloryBox#" list="false" />,
					con_leftMenuArea = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.con_leftMenuArea#" list="false" />, --->
					con_link = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.con_link#" list="false" />,
					con_metaDescription = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.con_metaDescription#" list="false" />,
					con_metaKeywords = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.con_metaKeywords#" list="false" />

					<cfif arguments.old_con_approved neq arguments.con_approved>
						, con_approved = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.con_approved#" list="false" />
						<cfif arguments.con_approved>
							, con_approvedBy = <cfqueryparam cfsqltype="cf_sql_integer" value="#cookie.usr_id#" list="false" />
							, con_approvedDate = getDate()
						</cfif>
					</cfif>

				WHERE con_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.con_id#" list="false" />
			</cfquery>

		<cfelse>

			<cfquery name="addContent"  datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
				INSERT INTO wwwContent	(
					con_menuTitle,
					con_title,
					con_body,
					<!--- con_intro, --->
					con_isMenu,
					con_menuArea,
					con_menuOrder,
					con_active,
					con_type,
					con_sanitise,
					con_parentID,
<!--- 					con_gloryBox,
					con_leftMenuArea, --->
					con_link,
					con_approved,
					con_metaDescription,
					con_metaKeywords

					<cfif arguments.con_approved>
						, con_approvedBy
						, con_approvedDate
					</cfif>

				) VALUES (
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.con_menuTitle#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.con_title#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.con_body#" list="false" />,
					<!--- <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.con_intro#" list="false" />, --->
					<cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.con_isMenu#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.con_menuArea#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.con_menuOrder#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.con_active#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.con_type#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#sanitise(arguments.con_title)#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.con_parentID)#" list="false" />,
<!--- 					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.con_gloryBox#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.con_leftMenuArea#" list="false" />, --->
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.con_link#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.con_approved#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.con_metaDescription#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.con_metaKeywords#" list="false" />

					<cfif arguments.con_approved>
						, <cfqueryparam cfsqltype="cf_sql_integer" value="#cookie.usr_id#" list="false" />
						, getDate()
					</cfif>
				)
				SELECT SCOPE_IDENTITY() AS contentID
			</cfquery>

			<cfset arguments.con_id = addContent.contentID />

		</cfif>


		<cfif len(arguments.img_name)>

			<cffile action="upload" filefield="img_name" destination="#application.imageUploadPath#" nameconflict="makeUnique" accept="image/gif, image/jpeg, image/jpg, image/pjpeg">

			<cfset FileName = cffile.serverFileName & '.' & cffile.serverFileExt />
			<cfset newFileName = cffile.serverFileName & '_347.' & cffile.serverFileExt />

			<cfimage action="read" name="imageInMem" source="#application.imageUploadPath#/#FileName#" />

			<cfimage action="info" source="#imageInMem#" structName="ImageCR" />

			<cfset origWidth = imageCR.width />
			<cfset origHeight = imageCR.height />

			<cfset ImageSetAntialiasing(imageInMem) />

			<!--- <cfif imageCR.width neq application.imageStandardWidth> --->

				<cfset ImageResize(imageInMem, 347, "", imageInterpolation) />
				
				<cfset ImageCrop(imageInMem, "0", "0", "347", "560") />

			<!--- </cfif> --->

			<cfimage action="info" source="#imageInMem#" structName="ImageCR" />

			<cfset finalWidth = imageCR.width />
			<cfset finalHeight = imageCR.height />

			<cfimage source="#imageInMem#" action="write" destination="#application.imageUploadPath#/#newFileName#" overwrite="yes" />

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
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#newFileName#" list="false" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="Main" list="false" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.img_altText#" list="false" />,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#finalHeight#" list="false" />,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#finalWidth#" list="false" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#fileName#" list="false" />,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#origHeight#" list="false" />,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#origWidth#" list="false" />
					)

					SELECT SCOPE_IDENTITY() AS imageID
				</cfquery>

				<!--- remove any previous main image for this content --->
				<cfquery name="removeContentImage" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
					DELETE FROM wwwContent_Image
					WHERE coi_content = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.con_id#" list="false" />
						AND coi_image IN (
							SELECT img_id
							FROM wwwImage
							WHERE img_type = 'Main'
						)
				</cfquery>

				<!--- add new image for this content --->
				<cfquery name="addContentImage" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
					INSERT INTO wwwContent_Image (
						coi_content,
						coi_image
					) VALUES (
						<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.con_id#" list="false" />,
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

	</cffunction>

	<!--- Author: Rafe - Date: 10/3/2009 --->
	<cffunction name="sanitise" returntype="string" output="false" hint="I remove all non-alphnumeric characters from a string">

		<cfargument name="String" type="string" required="yes"/>

		<cfset var ResultString = arguments.String/>

		<cfset ResultString = ReReplace(LCase(ResultString), "[^a-z0-9]+", "-", "all")/>
		<cfset ResultString = ReReplace(ResultString, "^[\-]+", "")/>
		<cfset ResultString = ReReplace(ResultString, "[\-]+$", "")/>

		<cfreturn ResultString/>

	</cffunction>

	<!--- Author: Rafe - Date: 10/3/2009 --->
	<cffunction name="getGloryBoxes" output="false" access="public" returntype="query" hint="I return all the glory box files in the system">

		<cfargument name="gbx_active" type="boolean" default="0" required="false" />
		<cfargument name="gbx_type" type="string" default="" required="false" />

		<cfset var getGloryBoxes = "" />

		<cfquery name="getGloryBoxes" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT gbx_id, gbx_title, gbx_name, gbx_type, gbx_type, gbx_active
			FROM wwwGloryBox
			WHERE 1 = 1
			
				<cfif arguments.gbx_active>
					AND gbx_active = 1
				</cfif>
				
				<cfif len(arguments.gbx_type)>
					AND gbx_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.gbx_type#" list="false" />
				</cfif>
				
			ORDER BY gbx_title
		</cfquery>

		<cfreturn getGloryBoxes />

	</cffunction>

	<!--- Author: Rafe - Date: 10/3/2009 --->
	<cffunction name="getGloryBoxesDefault" output="false" access="public" returntype="query" hint="I return all the glory box files in the system">

		<cfargument name="gbx_active" type="boolean" default="0" required="false" />
		<cfargument name="gbx_type" type="string" default="" required="false" />

		<cfset var getGloryBoxes = "" />

		<cfquery name="getGloryBoxes" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT gbx_title as imageTitle, gbx_name as imageName
			FROM wwwGloryBox
			WHERE 1 = 1
			
				<cfif arguments.gbx_active>
					AND gbx_active = 1
				</cfif>
				
				<cfif len(arguments.gbx_type)>
					AND gbx_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.gbx_type#" list="false" />
				</cfif>
				
			ORDER BY gbx_title
		</cfquery>

		<cfreturn getGloryBoxes />

	</cffunction>

	<!--- Author: Rafe - Date: 10/3/2009 --->
	<cffunction name="getGloryBox" output="false" access="public" returntype="query" hint="I return a glory box based on id">

		<cfargument name="gbx_id" type="numeric" default="0" required="true" />

		<cfset var getGloryBox = "" />

		<cfquery name="getGloryBox" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT gbx_id, gbx_title, gbx_name, gbx_type
			FROM wwwGloryBox
			WHERE gbx_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.gbx_id#" list="false" />
			ORDER BY gbx_title
		</cfquery>

		<cfreturn getGloryBox />

	</cffunction>

	<!--- Author: Rafe - Date: 10/4/2009 --->
	<cffunction name="gloryBoxSave" output="false" access="public" returntype="any" hint="I save the details about the glory box">

		<cfargument name="gbx_active" type="boolean" default="0" required="false" />

		<cfset var updateGloryBox = "" />
		<cfset var addGloryBox = "" />
		<cfset var fileName = "" />
		<cfset var imageInterpolation = "highPerformance" />

		<cfif arguments.gbx_id gt 0>

			<cfquery name="updateGloryBox"  datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
				UPDATE wwwGloryBox SET
					gbx_title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.gbx_title#" list="false" />,
					gbx_name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.gbx_name#" list="false" />,
					gbx_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.gbx_type#" list="false" />,
					gbx_active = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.gbx_active#" list="false" />
				WHERE gbx_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.gbx_id#" list="false" />
			</cfquery>

		<cfelseif len(arguments.gbx_name)>

			<cffile action="upload" filefield="gbx_name" destination="#application.imageUploadPath#gloryBox/" nameconflict="makeUnique">

			<cfset FileName = cffile.serverFileName & '.' & cffile.serverFileExt />
			<cfset fileNameSanitise = application.contentObj.sanitise(cffile.serverFileName) & '.' & cffile.serverFileExt />

			<cffile action="rename" source="#application.imageUploadPath#gloryBox/#fileName#" destination="#application.imageUploadPath#gloryBox/#fileNameSanitise#">

			<cfset newFileName = cffile.serverFileName & '_837.' & cffile.serverFileExt />
			<cfset newFileNameSanitise = application.contentObj.sanitise(cffile.serverFileName) & '_837.' & cffile.serverFileExt />

			<cfimage action="read" name="imageInMem" source="#application.imageUploadPath#gloryBox/#FileNameSanitise#" />

			<cfimage action="info" source="#imageInMem#" structName="ImageCR" />

			<cfset origWidth = imageCR.width />
			<cfset origHeight = imageCR.height />

			<cfset ImageSetAntialiasing(imageInMem) />

			<cfset ImageResize(imageInMem, 837, "", imageInterpolation) />

			<cfset ImageCrop(imageInMem, "0", "0", "837", "418") />

			<cfimage action="info" source="#imageInMem#" structName="ImageCR" />

			<cfset finalWidth = imageCR.width />
			<cfset finalHeight = imageCR.height />

			<cfimage source="#imageInMem#" action="write" destination="#application.imageUploadPath#gloryBox/#newFileNameSanitise#" overwrite="yes" />


<!--- 

			<cffile action="upload" filefield="gbx_name" destination="#application.imageUploadPath#gloryBox/" nameconflict="makeUnique" accept="application/x-shockwave-flash">

			<cfset FileName = cffile.serverFileName & '.' & cffile.serverFileExt />
 --->

			<cfquery name="addGloryBox"  datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
				INSERT INTO wwwGloryBox	(
					gbx_title,
					gbx_name,
					gbx_type
				) VALUES (
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.gbx_title#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#newFileNameSanitise#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.gbx_type#" list="false" />
				)
			</cfquery>

		</cfif>

	</cffunction>

	<!--- Author: Rafe - Date: 10/8/2009 --->
	<cffunction name="getNewsletters" output="false" access="public" returntype="query" hint="i return all of the newsletters in the system">

		<cfset var getNewsletters = "" />

		<cfquery name="getNewsletters" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT nsl_id, nsl_title, nsl_dateEntered
			FROM wwwNewsletter
			ORDER BY nsl_dateEntered DESC
		</cfquery>

		<cfreturn getNewsletters />

	</cffunction>

	<!--- Author: Rafe - Date: 10/8/2009 --->
	<cffunction name="getNewsletter" output="false" access="public" returntype="query" hint="i return all of the newsletters in the system">

		<cfargument name="nsl_id" type="numeric" default="0" required="true" />

		<cfset var getNewsletter = "" />

		<cfquery name="getNewsletter" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT nsl_id, nsl_title, nsl_body, nsl_dateEntered
			FROM wwwNewsletter
			WHERE nsl_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.nsl_id#" list="false" />
		</cfquery>

		<cfreturn getNewsletter />

	</cffunction>

	<!--- Author: Rafe - Date: 10/8/2009 --->
	<cffunction name="getNewsletterContent" output="false" access="public" returntype="query" hint="I return the content that is attached to a newsletter">

		<cfargument name="nsl_id" type="numeric" default="0" required="true" />

		<cfset var getNewsletterContent = "" />

		<cfquery name="getNewsletterContent" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT con_id, con_title, con_body, con_menuOrder, con_type, con_sanitise, con_fuseAction, con_link,
				img_id, img_name, img_title, img_altText, img_height, img_width
			FROM wwwContent
				INNER JOIN wwwNewsletter_Content ON con_id = nlc_content
				LEFT OUTER JOIN wwwContent_Image on con_id = coi_content
				LEFT OUTER JOIN wwwImage on coi_image = img_id
			WHERE nlc_newsletter = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.nsl_id#" list="false" />
			ORDER BY nlc_order
		</cfquery>

		<cfreturn getNewsletterContent />

	</cffunction>

	<!--- Author: Rafe - Date: 10/8/2009 --->
	<cffunction name="newsletterSave" output="false" access="public" returntype="numeric" hint="I save the newsletter and send back the ID">

		<cfargument name="nsl_id" type="numeric" default="0" required="true" />

		<cfset var addNewsletter = "" />
		<cfset var updateNewsletter = "" />
		<cfset var newsletterID = arguments.nsl_id />

		<cfif arguments.nsl_id gt 0>

			<cfquery name="updateNewsletter" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
				UPDATE wwwNewsletter SET
					nsl_title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.nsl_title#" list="false" />,
					nsl_body = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.nsl_body#" list="false" />
				WHERE nsl_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.nsl_id#" list="false" />
			</cfquery>

		<cfelse>

			<cfquery name="addNewsletter" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
				INSERT INTO wwwNewsletter (
					nsl_title,
					nsl_body
				) VALUES (
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.nsl_title#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.nsl_body#" list="false" />
				)
				SELECT SCOPE_IDENTITY() AS newsletterID
			</cfquery>

			<cfset newsletterID = addNewsletter.newsletterID />

		</cfif>

		<cfif arguments.con_id gt 0>

			<cfquery name="addNewsletterContent" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
				INSERT INTO wwwNewsletter_Content (
					nlc_newsletter,
					nlc_content
					<cfif isNumeric(nlc_order)>
						, nlc_order
					</cfif>
				) VALUES (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#newsletterID#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.con_id#" list="false" />
					<cfif isNumeric(nlc_order)>
						, <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.nlc_order#" list="false" />
					</cfif>
				)
			</cfquery>

		</cfif>

		<cfreturn newsletterID />

	</cffunction>

	<!--- Author: Rafe - Date: 10/13/2009 --->
	<cffunction name="newsletterSend" output="false" access="public" returntype="any" hint="I send a newsletter to the select group">

		<cfargument name="nsl_id" type="numeric" default="" required="true" />
		<cfargument name="grp_id" type="string" default="" required="true" />
		<cfargument name="int_id" type="string" default="" required="false" />
		<cfargument name="cou_id" type="string" default="" required="false" />

		<cfset var addSentNewsletter = "" />
		<cfset var getMembers = application.memberObj.getMembers(groupList=arguments.grp_id,validEmail=1,interestList=arguments.int_id,countryList=arguments.cou_id) />
		<cfset var thisGroup = "" />

		<cfloop query="getMembers">

			<cfquery name="addSentNewsletter" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
				INSERT INTO member_newsletter (
					mnl_member,
					mnl_newsletter
				) VALUES (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#mem_id#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.nsl_id#" list="false" />
				)
			</cfquery>

		</cfloop>

		<cfreturn getMembers.recordCount />

	</cffunction>

	<!--- Author: rafe - Date: 12/7/2009 --->
	<cffunction name="getContentParents" output="false" access="public" returntype="query" hint="I return a query with the content that can be parents">
		
		<cfset var getContentParents = "" />
		
		<cfquery name="getContentParents" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT con_id, con_menuTitle
			FROM wwwContent
			WHERE con_menuArea = 1
				AND con_parentID = 0
		</cfquery>
		
		<cfreturn getContentParents />
		
	</cffunction>

	<!--- Author: rafe - Date: 1/10/2010 --->
	<cffunction name="displayProductList" output="false" access="public" returntype="string" hint="I return the list of products based on category and subcategory">
		
		<cfargument name="cat_id" type="numeric" default="0" required="false" />
		<cfargument name="subcat_id" type="numeric" default="0" required="false" />	
		<cfargument name="cat3_id" type="numeric" default="0" required="false" />
		<cfargument name="keyword" type="string" default="" required="false" />
	
		<cfset var productList = "" />
		<cfset var catTitle = "" />
		<!--- <cfset var subCatTitle = "" /> --->
		<cfset var qProducts = getProducts(cat_id=arguments.cat_id,subcat_id=arguments.subcat_id,cat3_id=arguments.cat3_id,keyword=arguments.keyword) />
		<cfset var qCategory = "" />
		<cfset var qSubCategory = "" />
		<cfset var qCategory3 = "" />
		
		<cfset var newRow = "1" />
		<cfset var lastSubCat = "" /><!--- qProducts.prd_subCategory --->
		<cfset var counter = "1" />
		<cfset var lastCat3 = "" />
		
		<cfset qCategory = getCategory(arguments.cat_id) />
		<cfset qSubCategory = getCategory(arguments.subcat_id) />
		<cfset qCategory3 = getCategory(arguments.cat3_id) />
		
		<cfsaveContent variable="productList">
			

				<cfoutput>
					<div class="flexcroll_wrapper"<cfif qProducts.recordCount eq 0 or (arguments.cat_id is 0 AND not len(arguments.keyword))> style="background:##9e9fa1; padding-left:0px; padding-bottom:0px"</cfif>>
				</cfoutput>
					<cfif qProducts.recordCount gt 0 AND (arguments.cat_id neq 0 OR len(arguments.keyword))>

						<cfoutput><h3>#qCategory.cat_title# <span>#qSubCategory.cat_title#<cfif qCategory3.recordCount> - #qCategory3.cat_title#</cfif></span></h3>
						
						<div id="crol1" class="flexcroll">

							<table width="485" border="0" cellspacing="0" cellpadding="2"></cfoutput>
								
								<cfoutput query="qProducts" group="subCatTitle">
								
									<tr>
										<td colspan="4">#lcase(subCatTitle)#</td>
									</tr>
									
									<cfoutput group="cat3Title">
										
										<cfif len(cat3Title)>
											<tr>
												<td colspan="4">#lcase(cat3Title)#</td>
											</tr>
										</cfif>
										
										<cfset counter = 1 />

										<cfoutput>
											
											<cfif counter mod 4 is 1>
												<tr>
											</cfif>
											
											<td width="120" height="120" align="center" style="border-bottom:##9e9fa1 1px solid; padding:20px 0 10px 0;">
												<a href="#request.myself#products.view&prd_id=#prd_id#">
													<img src="#application.imagePath#products/#replaceNoCase(prd_code," ","","all")#_120.jpg" alt="#prd_title# - #prd_code#" />
												</a>
											</td>
											
											<cfif counter mod 4 is 0>
												</tr>
											</cfif>
											
											<cfset counter = counter + 1 />
											
										</cfoutput>

									</cfoutput>
									
								</cfoutput>
								
							<cfoutput></table>
<!--- 							<table width="485" border="0" cellspacing="0" cellpadding="2">
								
								<cfloop query="qProducts">

									<cfif counter mod 4 is 1 or qProducts.prd_subCategory neq lastSubCat>
										<cfif qProducts.prd_subCategory neq lastSubCat and arguments.subcat_id eq 0>
											<tr><td colspan="4">#lcase(qProducts.subCatTitle)#</td></tr>
										</cfif>
										<tr>
										<cfset counter = 1 />
									</cfif>
		
									<cfif qProducts.prd_category3 neq lastCat3>
										<cfif qProducts.prd_subCategory neq lastSubCat and arguments.subcat_id eq 0>
											<tr><td colspan="4">#lcase(qProducts.cat3Title)#</td></tr>
										</cfif>
										<tr>
										<cfset counter = 1 />
									</cfif>
		
									<td width="120" height="120" align="center" style="border-bottom:##9e9fa1 1px solid; padding:20px 0 10px 0;">
										<a href="#request.myself#products.view&prd_id=#qProducts.prd_id#">
											<img src="#application.imagePath#products/#replaceNoCase(qProducts.prd_code," ","","all")#_120.jpg" alt="#qProducts.prd_title# - #qProducts.prd_code#" />
										</a><br />#lcase(qProducts.cat3Title)#
									</td>
									
									<cfset lastSubCat = qProducts.prd_subCategory />
									<cfset lastCat3 = qProducts.prd_category3 />
									
									<cfif counter mod 4 is 0 OR qProducts.currentRow eq qProducts.recordCount>
										</tr>
										<cfset counter = 0 />
									</cfif>
									
									<cfset counter = counter + 1 />
									
								</cfloop>
								
							</table> --->
							
						</div></cfoutput>
						
					<cfelse>
					
						<cfoutput><div id="crol1" class="flexcrollimage">
							<img src="#application.imagePathBase#pic_products.jpg" width="510" />
						</div></cfoutput>
						
					</cfif>
					
				<cfoutput></div>
				
                <div class="pages">

                </div></cfoutput>
				 
			<!--- </cfoutput> --->
			
		</cfsaveContent>	
		
		<cfreturn productList />

	</cffunction>

	<!--- Author: rafe - Date: 1/10/2010 --->
	<cffunction name="getCategory" output="false" access="public" returntype="query" hint="I return a query with the selected category">
		
		<cfargument name="cat_id" type="numeric" default="0" required="false" />
	
		<cfset var getCategory = "" />
		
		<cfquery name="getCategory" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT top(1) cat_id, cat_title
			FROM category
			WHERE cat_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cat_id#" list="false" />
		</cfquery>
		
		<cfreturn getCategory />
		
	</cffunction>
	
	<!--- Author: rafe - Date: 1/11/2010 --->
	<cffunction name="getProducts" output="false" access="public" returntype="query" hint="I return a query with the products based on categories and subcategories">
		
		<cfargument name="cat_id" type="string" default="0" required="false" />
		<cfargument name="subcat_id" type="string" default="0" required="false" />
		<cfargument name="cat3_id" type="string" default="0" required="false" />
		<cfargument name="productList" type="string" default="" required="false" />
		<cfargument name="keyword" type="string" default="" required="false" />
		<cfargument name="prd_active" type="boolean" default="1" required="false" />
	
		<cfset var getProducts = "" />
		
		<cfparam name="request.memberCategoryList" default="" />
		<cfparam name="request.memberSubCategoryList" default="" />
		
		<cfquery name="getProducts" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT prd_id, prd_title, prd_code, prd_colour, prd_dimension, prd_active, prd_order, prd_category, prd_subCategory, prd_category3,
				cat.cat_title as catTitle,
				subcat.cat_title as subCatTitle,
				cat3.cat_title as cat3Title
			FROM product
				INNER JOIN category cat ON prd_category = cat.cat_id
				INNER JOIN category subcat ON prd_subCategory = subcat.cat_id
				LEFT OUTER JOIN category cat3 ON prd_category3 = cat3.cat_id
			WHERE 1 = 1
			
				<cfif val(arguments.cat_id) gt 0>
					AND prd_category = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.cat_id)#" list="false" />
				</cfif>
				
				<cfif val(arguments.subcat_id) gt 0>
					AND prd_subCategory = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.subcat_id)#" list="false" />
				</cfif>
				
				<cfif val(arguments.cat3_id) gt 0>
					AND prd_category3 = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.cat3_id)#" list="false" />
				</cfif>
				
				<cfif listLen(arguments.productList) gt 0>
					AND prd_id in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.productList#" list="true" />)
				</cfif>
				
				<cfif len(arguments.keyword)>
					AND (
						prd_title like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(arguments.keyword)#%" list="false" />
						OR
						prd_code like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(arguments.keyword)#%" list="false" />
						OR 
						prd_desc like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(arguments.keyword)#%" list="false" />
						OR
						prd_colour like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(arguments.keyword)#%" list="false" />
					)
				</cfif>
				
				<cfif listLen(request.memberCategoryList) gte 1>
					AND prd_category IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#request.memberCategoryList#" list="true" />)
				</cfif>
				
				<cfif listLen(request.memberSubCategoryList) gte 1>
					AND prd_subcategory IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#request.memberSubCategoryList#" list="true" />)
				</cfif>
				
				AND prd_active = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.prd_active#" list="false" />
				
			ORDER BY subcat.cat_order, subcat.cat_title, cat3.cat_order, cat3.cat_title, prd_subcategory, prd_category, prd_order, prd_title
		</cfquery>
		
		<cfreturn getProducts />
		
	</cffunction>
	
	<!--- Author: rafe - Date: 1/11/2010 --->
	<cffunction name="productSearch" output="false" access="public" returntype="string" hint="I return the registration form">

		<cfset var productSearch = "" />
		<cfset var qCategories = application.menuObj.getCategories() />
		<cfset var qContent = application.contentObj.getContent(fuseAction='products.search') />

		<cfsaveContent variable="register">

			<cfoutput>
				
				<div>

					<div>
					
						<div class="register_box_left">
							
							<h2>#qContent.con_title#</h2>
						
							<cfform action="index.cfm?fuseaction=products.list" name="contentForm">   
								  
								<p>
									<label>keyword</label>
									<cfinput required="no" message="" name="keyword" type="text">
								</p>

								<div class="selectbox">
									<label>category</label>
									<div class="noindent">
		                                <p>
			                                <select name="cat_id" class="styled">
				                                <option selected="selected" value="0">category</option>
				                                <cfloop query="qCategories">
					                                <option value="#qCategories.cat_id#">#qCategories.cat_title#</option>
					                            </cfloop>
		                                	</select>
										</p>
		                            </div> 
								</div>                            

                       			<p class="btn_register">
									<input type="submit" name="save" value="search" />
								</p>
								
							</cfform>
							
						</div>
						
              			<div class="register_box_right"><img src="#application.imagePath##qContent.img_name#" alt="#qContent.img_title#" width="347" height="560" /></div>
					
					</div>
					
				</div>
				
			</cfoutput>

		</cfsaveContent>

		<cfreturn register />

	</cffunction>

	<!--- Author: rafe - Date: 1/17/2010 --->
	<cffunction name="getProduct" output="false" access="public" returntype="query" hint="returns a query with the product">
		
		<cfargument name="prd_id" type="numeric" default="0" required="true" />
	
		<cfset var getProduct = "" />
	
		<cfquery name="getProduct" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT prd_title, prd_code, prd_colour, prd_dimension, prd_category, prd_subCategory, prd_desc, prd_order, prd_active, prd_category3
			FROM product
			WHERE prd_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.prd_id#" list="false" />
		</cfquery>
		
		<cfreturn getProduct />
		
	</cffunction>

	<!--- Author: rafe - Date: 1/17/2010 --->
	<cffunction name="displayProduct" output="false" access="public" returntype="string" hint="I return the list of products based on category and subcategory">
		
		<cfargument name="prd_id" type="numeric" default="0" required="false" />
		
		<cfset var productText = "" />
		<cfset var cat_id = "" />
		<cfset var subcat_id = "" />
		<cfset var catTitle = "" />
		<cfset var subCatTitle = "" />
		
		<cfset var qProduct = "" />
		<cfset var qCategory = "" />
		<cfset var qSubCategory = "" />
		
		<cfset qProduct = getProduct(arguments.prd_id) />
		<cfset qCategory = getCategory(val(qProduct.prd_category)) />
		<cfset qSubCategory = getCategory(val(qProduct.prd_subCategory)) />
		
		<cfsaveContent variable="productText">
			
			<cfoutput>
				
				<div class="flexcroll_wrapper">

					<h3>#qCategory.cat_title# <span>#qSubCategory.cat_title#</span></h3>
					
					<div id="crol1" class="flexcroll">
						
						<img style="margin-top: 20px; margin-left: 15px" src="#application.imagePath#products/#replaceNoCase(qProduct.prd_code," ","","all")#_main.jpg" alt="#qProduct.prd_title# - #qProduct.prd_code#" />
						
						<h2 style="margin-top: 20px; margin-left: 15px">
							#qProduct.prd_title#
						</h2>
						<br />
						<p style="margin-left: 15px"><strong>Code:</strong> ###qProduct.prd_code# <strong>Colour:</strong> #qProduct.prd_colour#</p>
						<p style="margin-left: 15px"><strong>Dimensions:</strong> #qProduct.prd_dimension#</p>
						<cfif len(trim(qProduct.prd_desc))>
							<p style="margin-left: 15px">#qProduct.prd_desc#</p>
						</cfif>
						
					</div>
				
				</div>
					 
                <div class="pages">
                   <div class="pages_left">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#request.myself#products.list&cat_id=#val(qProduct.prd_category)#&subcat_id=#val(qProduct.prd_subcategory)#">back to search results</a></div>
                   <cfif not listFind(cookie.gdrProductList,arguments.prd_id)>
						<a href="#request.myself#products.view&prd_id=#arguments.prd_id#&addSaved=1">add to saved items</a>
					</cfif>
                </div>
				  
			</cfoutput>
			
		</cfsaveContent>	
		
		<cfreturn productText />

	</cffunction>

	<!--- Author: rafe - Date: 1/17/2010 --->
	<cffunction name="addSavedProduct" output="false" access="public" returntype="any" hint="">
		
		<cfargument name="prd_id" type="numeric" default="0" required="true" />
	
		<cfif not listFind(cookie.gdrProductList,arguments.prd_id)>
			<cfcookie name="gdrProductList" value="#listAppend(cookie.gdrProductList,arguments.prd_id)#" />
		</cfif>
		
		<cfreturn cookie.gdrProductList />
		
	</cffunction>

	<!--- Author: rafe - Date: 1/17/2010 --->
	<cffunction name="deleteSavedProduct" output="false" access="public" returntype="any" hint="">
		
		<cfargument name="prd_id" type="string" default="0" required="true" />
		
		<cfset var savedList = cookie.gdrProductList />

		<cfloop list="#arguments.prd_id#" index="thisProduct">

			<cfif listFind(savedList,thisProduct)>
				<cfset savedList = listDeleteAt(savedList,listFind(savedList,thisProduct)) />
			</cfif>
		
		</cfloop>

		<cfcookie name="gdrProductList" value="#savedList#" />
		
		<cfreturn cookie.gdrProductList />
		
	</cffunction>

	<!--- Author: rafe - Date: 1/23/2010 --->
	<cffunction name="productsSaved" output="false" access="public" returntype="any" hint="">
		
		<cfargument name="productList" type="string" default="" required="true" />
	
		<cfset var productsSaved = "" />
		<cfset var qProducts = getProducts(productList=arguments.productList) />
		
		<cfif not listLen(arguments.productList)>
			<cfset qProducts = getProducts(productList='-1') />
		</cfif>
		
		<cfsaveContent variable="productsSaved">
			<cfoutput>
				
				<h2>my saved items</h2>
				
				<table cellspacing="0" border="0">
					
					<form action="#request.myself#products.saved" method="post">
						
						<input type="hidden" name="mem_id" value="#cookie.gdrUserID#" />
					
						<cfloop query="qProducts">
							
							<cfif qProducts.currentRow mod 6 is 1>
								<tr>
							</cfif>
							
							<td width="150" height="130" align="center" valign="bottom" style="padding:20px 0 10px 0;">
								<a href="#request.myself#products.view&prd_id=#qProducts.prd_id#">
									<img src="#application.imagePath#products/#replaceNoCase(qProducts.prd_code," ","","all")#_120.jpg" alt="#qProducts.prd_title# - #qProducts.prd_code#" />
								</a>
								
								<br />
								
								 ###prd_code# <input type="checkbox" value="#prd_id#" name="prd_id" />
								
							</td>
							
							<cfif qProducts.currentRow mod 6 is 0 or qProducts.currentRow is qProducts.recordCount>
								</tr>
							</cfif>
							
						</cfloop>
						<style>
							.btn_register input{
							width:350px;
							height:26px;
							color:##fff;
							font-weight:bold;
							font-size:16px;
							font-family:Arial, Helvetica, sans-serif;
							background:##58595b;
							cursor:pointer;
							padding:0;
							margin:0;
							border:0;
							}
						</style>

				</table>
	
					message:<br />
					
					<textarea name="message" style="width: 600px; height: 150px"></textarea>
					<br /><br />
                    <p class="btn_register">
						<input type="submit" name="save" value="confirm and submit product enquiry" />
					<!--- </p>
					<br /><br />
                    <p class="btn_register"> --->
						<input type="submit" name="delete" value="remove selected products" />
					</p>
								
						
				</form>
			
			</cfoutput>
		</cfsaveContent>
		
		<cfreturn productsSaved />
		
	</cffunction>

	<!--- Author: rafe - Date: 1/24/2010 --->
	<cffunction name="productOrderListForm" output="false" access="public" returntype="string" hint="I return the list of products in a category, and allow for reordering">
		
		<cfargument name="cat_id" type="numeric" default="0" required="false" />
		<cfargument name="subcat_id" type="numeric" default="0" required="false" />
		<cfargument name="cat3_id" type="numeric" default="0" required="false" />
		<cfargument name="keyword" type="string" default="" required="false" />
	
		<cfset var productList = "" />
		<cfset var qProducts = getProducts(cat_id=arguments.cat_id,subcat_id=arguments.subcat_id,cat3_id=arguments.cat3_id,keyword=arguments.keyword) />
		
		<cfsaveContent variable="productList">
			<cfoutput>
				<br /><br />
				<form name="productOrder" action="#request.myself#web.productList" method="post">
					
					<input type="hidden" name="productCount" value="#qProducts.recordCount#" />
					
					<table id="dataTable">
					
						<tr class="tableHeader">
							<td colspan="7">
								<div class="tableTitle">Product List</div>
								<div class="showAll"><cfoutput>#qProducts.recordCount#</cfoutput> products</div>
							</td>
						</tr>
					
						<tr>
							<th></th>
							<th style="text-align:center;">ID</th>
							<th>Code</th>
							<th>Title</th>
							<th>Colour</th>
							<th>Dimension</th>
							<th>Order</th>
						</tr>
					
						<cfloop query="qProducts">
				
							<tr<cfif currentRow mod 2 eq 0> class="darkData"<cfelse> class="lightData"</cfif>>
								<td align="center"><img src="#application.imagePath#products/#replaceNoCase(qProducts.prd_code," ","","all")#_120.jpg" height="40" /></td>
								<td align="center"><a href="#request.myself#web.productForm&prd_id=#qProducts.prd_id#">#qProducts.prd_id#</a></td>
								<td><a href="#request.myself#web.productForm&prd_id=#qProducts.prd_id#">#qProducts.prd_code#</a></td>
								<td>#qProducts.prd_title#</td>
								<td>#qProducts.prd_colour#</td>
								<td>#qProducts.prd_dimension#</td>
								<td>
									<cfif arguments.subcat_id eq 0>
										#qProducts.prd_order#
									<cfelse>
										<input type="hidden" name="prdID#currentRow#" value="#prd_id#" />
										<select name="prdOrder#currentRow#">
											<cfloop from="1" to="#recordCount#" index="thisCount">
												<option value="#thisCount#"<cfif thisCount is currentRow> selected</cfif>>#thisCount#</option>
											</cfloop>
										</select>
									</cfif>
								</td>
							</tr>
				
						</cfloop>
						
						<cfif arguments.subcat_id neq 0>
							<tr>
								<td class="formFooter" colspan="7">
									<input type="submit" value="save" name='save' onMouseOver="this.className='buttonOver'" onMouseOut="this.className='button'" class="button">
								</td>
							</tr>
						</cfif>
						
					</table>
					
				</form>

			</cfoutput>
		</cfsaveContent>
		
		<cfreturn productList />
		
	</cffunction>

	<!--- Author: rafe - Date: 1/24/2010 --->
	<cffunction name="productsOrderSave" output="false" access="public" returntype="any" hint="I save the order of the products">
		
		<cfset var ProductOrder = "" />
		<cfset var prd_id = "" />
		<Cfset var prd_order = "" />
		
		<cfloop from="1" to="#arguments.productCount#" index="thisProduct">
		
			<cfset prd_id = evaluate("arguments.prdID#thisProduct#") />
			<cfset prd_order = evaluate("arguments.prdOrder#thisProduct#") />
		
			<cfquery name="productOrder" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
				UPDATE product SET 
					prd_order = <cfqueryparam cfsqltype="cf_sql_integer" value="#prd_order#" list="false" />
				WHERE prd_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#prd_id#" list="false" />
			</cfquery>
		
		</cfloop>
		
	</cffunction>

	<!--- Author: rafe - Date: 1/31/2010 --->
	<cffunction name="productSave" output="false" access="public" returntype="any" hint="I save the details of a product and upload any image included">
		
		<cfargument name="prd_active" type="boolean" default="0" required="false" />
		
		<cfset var productSave = "" />
		<cfset var productCode = replaceNoCase(arguments.prd_code," ","","all") />
		<cfset var imageInterpolation = "highPerformance" />
		<cfset var fileName = "" />
		<cfset var fileNameSanitise = "" />
		<cfset var newFileNameTN = "" />
		<cfset var newFileNameMain = "" />
		<cfset var origWidth = "" />
		<cfset var origHeight = "" />
				
		<cfif arguments.prd_id eq 0>
			
			<cfquery name="productSave" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
				INSERT INTO product (
					prd_title,
					prd_code,
					prd_colour,
					prd_dimension,
					prd_desc,
					prd_order,
					prd_active,
					prd_category,
					prd_subcategory,
					prd_category3
				) VALUES (
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.prd_title#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.prd_code#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.prd_colour#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.prd_dimension#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.prd_desc#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.prd_order)#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.prd_active#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.prd_category#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.prd_subcategory)#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.prd_category3)#" list="false" />
				)
			</cfquery>
			
			<cfset session.prd_category = arguments.prd_category />
			<cfset session.prd_subcategory = arguments.prd_subcategory />
			<cfset session.prd_category3 = arguments.prd_category3 />
			
		<cfelse>
		
			<cfquery name="productSave" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
				UPDATE product SET					
					prd_title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.prd_title#" list="false" />,
					prd_code = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.prd_code#" list="false" />,
					prd_colour = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.prd_colour#" list="false" />,
					prd_dimension = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.prd_dimension#" list="false" />,
					prd_desc = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.prd_desc#" list="false" />,
					prd_order = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.prd_order)#" list="false" />,
					prd_active = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.prd_active#" list="false" />,
					prd_category = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.prd_category#" list="false" />,
					prd_subcategory = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.prd_subcategory#" list="false" />,
					prd_category3 = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.prd_category3)#" list="false" />
				WHERE prd_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.prd_id#" list="false" />
			</cfquery>
		
		</cfif>
		
		<cfif len(arguments.prdImage)>
			
			<cffile action="upload" filefield="prdImage" destination="#application.imageUploadPath#products/" nameconflict="overwrite" accept="image/jpeg, image/jpg, image/pjpeg">

			<cfset FileName = cffile.serverFileName & '.' & cffile.serverFileExt />
			<cfset fileNameSanitise = application.contentObj.sanitise(cffile.serverFileName) & '.' & cffile.serverFileExt />

			<cffile action="rename" source="#application.imageUploadPath#products/#fileName#" destination="#application.imageUploadPath#products/#fileNameSanitise#">

			<cfset newFileNameTN = productCode & '_120.' & cffile.serverFileExt />
			<cfset newFileNameMain = productCode & '_main.' & cffile.serverFileExt />
			
			<cfimage action="read" name="imageInMem" source="#application.imageUploadPath#products/#FileNameSanitise#" />

			<cfimage action="info" source="#imageInMem#" structName="ImageCR" />

			<cfset origWidth = imageCR.width />
			<cfset origHeight = imageCR.height />

			<cfset ImageSetAntialiasing(imageInMem) />
			
			<cfif origWidth gt origHeight>
				
				<cfset ImageResize(imageInMem, "120", "", imageInterpolation) />
				<cfset ImageCrop(imageInMem, "0", "0", "120", "120") />
			
			<cfelse>
			
				<cfset ImageResize(imageInMem, "", "120", imageInterpolation) />
				<cfset ImageCrop(imageInMem, "0", "0", "120", "120") />
			
			</cfif>
	
			<cfimage source="#imageInMem#" action="write" destination="#application.imageUploadPath#products/#newFileNameTN#" overwrite="yes" />


			<cfimage action="read" name="imageInMem" source="#application.imageUploadPath#products/#FileNameSanitise#" />

			<cfimage action="info" source="#imageInMem#" structName="ImageCR" />

			<cfset origWidth = imageCR.width />
			<cfset origHeight = imageCR.height />

			<cfset ImageSetAntialiasing(imageInMem) />
			
			<cfif origWidth gt origHeight>
				
				<cfset ImageResize(imageInMem, "350", "", imageInterpolation) />
			
			<cfelse>
			
				<cfset ImageResize(imageInMem, "", "350", imageInterpolation) />
			
			</cfif>
	
			<cfimage source="#imageInMem#" action="write" destination="#application.imageUploadPath#products/#newFileNameMain#" overwrite="yes" />

		</cfif>
		
	</cffunction>

	<!--- Author: rafe - Date: 2/12/2010 --->
	<cffunction name="categorySearchForm" output="false" access="public" returntype="string" hint="I return the search form for categories">
		
		<cfargument name="cat_level" type="numeric" default="0" required="false" />
		
		<cfset var categorySearch = "" />
		<cfset var qCategoryLevel = application.menuObj.getCategoryLevels() />
		
		<cfsaveContent variable="categorySearch">
			<cfoutput>
								
				<table id="formTable">
					
					<form action="#request.myself#web.categoryList" method="post">

						<tr class="tableHeader">
							<td colspan='5'><div class="tableTitle">Categories</div></td>
						</tr>
	
						<tr>
							<td class="leftForm">Category Level</td>
							<td class="whiteGutter">&nbsp;</td>
							<td>
								<select name="cat_level" style="width:250px">
									<option value="0">-</option>
									<cfloop from="1" to="3" index="thisLevel">
										<option value="#thisLevel#"<cfif thisLevel is arguments.cat_level> selected</cfif>>#thisLevel#</option>
									</cfloop>
								</select>
							</td>
							<td class="whiteGutter">&nbsp;</td>
							<td class="rightForm">&nbsp;</td>
						</tr>
		
						<tr>
							<td class="formFooter" colspan="5">
								<input type="submit" value="Submit" name="search" class="button" onMouseOver="this.className='buttonOver';" onMouseOut="this.className='button';">
							</td>
						</tr>

					</form>

				</table>

			</cfoutput>
		</cfsaveContent>
		
		<cfreturn categorySearch />
		
	</cffunction>

	<!--- Author: rafe - Date: 2/12/2010 --->
	<cffunction name="categoryOrderListForm" output="false" access="public" returntype="string" hint="I return a list of categories and allow for reordering">
		
		<cfargument name="cat_level" type="numeric" default="0" required="false" />

		<cfset var productList = "" />
		<cfset var qCategories = application.menuObj.getCategoriesByLevel(arguments.cat_level) />
		
		<cfsaveContent variable="categoryOrderList">
			<cfoutput>
				<br /><br />
				<form name="categoryOrder" action="#request.myself#web.categoryList" method="post">
					
					<input type="hidden" name="categoryCount" value="#qCategories.recordCount#" />
					
					<table id="dataTable">
					
						<tr class="tableHeader">
							<td colspan="4">
								<div class="tableTitle">Category List</div>
								<div class="showAll"><cfoutput>#qCategories.recordCount#</cfoutput> categories</div>
							</td>
						</tr>
					
						<tr>
							<th style="text-align:center;">ID</th>
							<th>Title</th>
							<th>Active</th>
							<th>Order</th>
						</tr>
					
						<cfloop query="qCategories">
				
							<tr<cfif currentRow mod 2 eq 0> class="darkData"<cfelse> class="lightData"</cfif>>
								<td align="center"><a href="#request.myself#web.categoryForm&cat_id=#qCategories.cat_id#">#qCategories.cat_id#</td>
								<td>#qCategories.cat_title#</td>
								<td><cfif qCategories.cat_active>True<cfelse>False</cfif></td>
								<td>
									
									<input type="hidden" name="catID#currentRow#" value="#cat_id#" />
									
									<select name="catOrder#currentRow#">
										<cfloop from="1" to="#recordCount#" index="thisCount">
											<option value="#thisCount#"<cfif thisCount is currentRow> selected</cfif>>#thisCount#</option>
										</cfloop>
									</select>
								
								</td>

							</tr>
				
						</cfloop>
						
						<tr>
							<td class="formFooter" colspan="6">
								<input type="submit" value="save" name='save' onMouseOver="this.className='buttonOver'" onMouseOut="this.className='button'" class="button">
							</td>
						</tr>

					</table>
					
				</form>

			</cfoutput>
		</cfsaveContent>
		
		<cfreturn categoryOrderList />
		
	</cffunction>

	<!--- Author: rafe - Date: 2/12/2010 --->
	<cffunction name="categoryOrderSave" output="false" access="public" returntype="any" hint="I save the order of the categories">
		
		<cfset var categoryOrder = "" />
		<cfset var cat_id = "" />
		<Cfset var cat_order = "" />
		
		<cfloop from="1" to="#arguments.categoryCount#" index="thisCategory">
		
			<cfset cat_id = evaluate("arguments.catID#thisCategory#") />
			<cfset cat_order = evaluate("arguments.catOrder#thisCategory#") />
		
			<cfquery name="categoryOrder" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
				UPDATE category SET 
					cat_order = <cfqueryparam cfsqltype="cf_sql_integer" value="#cat_order#" list="false" />
				WHERE cat_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#cat_id#" list="false" />
			</cfquery>
		
		</cfloop>
		
	</cffunction>
	
	<!--- Author: rafe - Date: 2/12/2010 --->
	<cffunction name="displayCategoryForm" output="false" access="public" returntype="string" hint="I return the category form">
		
		<cfargument name="cat_id" type="numeric" default="0" required="false" />
	
		<cfset categoryForm = "" />
		<cfset qCategory = application.menuObj.getCategory(cat_id=arguments.cat_id) />
		
		<cfsaveContent variable="categoryForm">
			<cfoutput>
												
				<table id="formTable">
					
					<form action="#request.myself#web.categoryForm" method="post">
						
						<input type="hidden" name="cat_id" value="#arguments.cat_id#" />

						<tr class="tableHeader">
							<td colspan='5'><div class="tableTitle">Categories</div></td>
						</tr>

						<tr>
							<td class="leftForm">Title</td>
							<td class="whiteGutter">&nbsp;</td>
							<td>
								<input type="text" name="cat_title" value="#qCategory.cat_title#" style="width:250px" />
							</td>
							<td class="whiteGutter">&nbsp;</td>
							<td class="rightForm">&nbsp;</td>
						</tr>
						
						<tr>
							<td class="leftForm">Order</td>
							<td class="whiteGutter">&nbsp;</td>
							<td>
								<input type="text" name="cat_order" value="#qCategory.cat_order#" style="width:250px" />
							</td>
							<td class="whiteGutter">&nbsp;</td>
							<td class="rightForm">&nbsp;</td>
						</tr>
						
						<tr>
							<td class="leftForm">Active</td>
							<td class="whiteGutter">&nbsp;</td>
							<td>
								<input type="checkbox" name="cat_active" value="1"<cfif qCategory.cat_active is 1> checked</cfif> />
							</td>
							<td class="whiteGutter">&nbsp;</td>
							<td class="rightForm">&nbsp;</td>
						</tr>
						
						<tr>
							<td class="leftForm">Level</td>
							<td class="whiteGutter">&nbsp;</td>
							<td>
								<select name="cat_level" style="width:250px">
									<cfloop from="1" to="3" index="thisLevel">
										<option value="#thisLevel#"<cfif thisLevel is qCategory.cat_level> selected</cfif>>#thisLevel#</option>
									</cfloop>
								</select>
							</td>
							<td class="whiteGutter">&nbsp;</td>
							<td class="rightForm">&nbsp;</td>
						</tr>
		
						<tr>
							<td class="formFooter" colspan="5">
								<input type="submit" value="Save" name="save" class="button" onMouseOver="this.className='buttonOver';" onMouseOut="this.className='button';">
							</td>
						</tr>

					</form>

				</table>

			</cfoutput>
		</cfsaveContent>
		
		<cfreturn categoryForm />
		
	</cffunction>

	<!--- Author: rafe - Date: 2/12/2010 --->
	<cffunction name="categorySave" output="false" access="public" returntype="any" hint="I save the details about the category">
		
		<cfargument name="cat_active" type="boolean" default="0" required="false" />
		
		<cfset var categorySave = "" />
		
		<cfif arguments.cat_id gt 0>
			
			<cfquery name="categorySave" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
				UPDATE category SET
					cat_title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.cat_title#" list="false" />,
					cat_order = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cat_order#" list="false" />,
					cat_active = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.cat_active#" list="false" />,
					cat_level = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cat_level#" list="false" />
				WHERE cat_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cat_id#" list="false" />
			</cfquery>
			
		<cfelse>
		
			<cfquery name="categorySave" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
				INSERT INTO category (
					cat_title,
					cat_order,
					cat_active,
					cat_level
				) VALUES (
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.cat_title#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cat_order#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.cat_active#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cat_level#" list="false" />
				)
			</cfquery>
		
		</cfif>
		
	</cffunction>

</cfcomponent>