<cfcomponent hint="I hold the image functions" output="false">

	<!--- Author: Rafe - Date: 10/4/2009 --->
	<cffunction name="showImage" output="false" access="public" returntype="string" hint="I return the html for an image tag, including a link to a larger image">

		<cfargument name="img_id" type="numeric" default="0" required="true" />
		<cfargument name="class" type="string" default="" required="false" />
		<cfargument name="showLink" type="boolean" default="1" required="false" />
		<cfargument name="path" type="string" default="" required="false" />
		<cfargument name="forceWidth" type="string" default="0" required="false" />

		<cfset var imgString = "" />
		<cfset var getImage = "" />

		<cfset getImage = getImageByID(img_id=arguments.img_id) />

		<cfoutput query="getImage">

			<cfsaveContent variable="imgString">

				<cfif len(getImage.img_origName) and arguments.showLink>
					<a href="#request.myself#content.showImage&img_id=#arguments.img_id#" target="_blank">
				</cfif>

				<img src="#application.imagePath##arguments.path#/#img_name#" target="_new" alt="#img_altText#"<cfif val(img_width)gt 0 and arguments.forceWidth is 0> width="#img_width#"<cfelseif arguments.forceWidth is 0> width="#arguments.forceWidth#"</cfif><cfif val(img_height)gt 0> width="#img_height#"</cfif><cfif len(arguments.class)> class="#arguments.class#"</cfif> />

				<cfif len(getImage.img_origName) and arguments.showLink>
					</a>
				</cfif>

			</cfsaveContent>

		</cfoutput>

		<cfreturn imgString />

	</cffunction>

	<!--- Author: Rafe - Date: 10/4/2009 --->
	<cffunction name="getImageByID" output="false" access="public" returntype="query" hint="I return a query with details for an image">

		<cfargument name="img_id" type="numeric" default="0" required="true" />

		<cfset var getImage = "" />

		<cfquery name="getImage" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT img_id, img_name, img_title, img_type, img_altText, img_height, img_width, img_origName, img_origHeight, img_origWidth
			FROM wwwImage
			WHERE img_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.img_id#" list="false" />
		</cfquery>

		<cfreturn getImage />

	</cffunction>

	<!--- Author: Rafe - Date: 10/16/2009 --->
	<cffunction name="getGalleries" output="false" access="public" returntype="query" hint="I return all the galleries">

		<cfargument name="active" type="string" default="1" required="false" />

		<cfset var getGalleries = "" />

		<cfquery name="getGalleries" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT gal_id, gal_title, gal_active, gal_image,
				(
					SELECT COUNT(1)
					FROM wwwGallery_Image
					WHERE gai_gallery = gal_id
				) AS imageCount
			FROM wwwGallery
				<cfif yesNoFormat(arguments.active)>
					WHERE gal_active = 1
				</cfif>
			ORDER BY gal_order, gal_title
		</cfquery>

		<cfreturn getGalleries />

	</cffunction>

	<!--- Author: Rafe - Date: 10/16/2009 --->
	<cffunction name="getGallery" output="false" access="public" returntype="query" hint="I return a gallery based on the ID">

		<cfargument name="gal_id" type="numeric" default="0" required="true" />

		<cfset var getGallery = "" />

		<cfquery name="getGallery" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT TOP(1) gal_id, gal_title, gal_active, gal_image
			FROM wwwGallery
				<cfif arguments.gal_id gt 0>
					WHERE gal_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.gal_id#" list="false" />
				</cfif>
			ORDER BY gal_order
		</cfquery>

		<cfreturn getGallery />

	</cffunction>

	<!--- Author: Rafe - Date: 10/16/2009 --->
	<cffunction name="gallerySave" output="false" access="public" returntype="any" hint="i save the information for a cta">

		<cfargument name="gal_active" type="string" default="0" required="false" />

		<cfset var updateGallery = "" />
		<cfset var addGallery = "" />

		<cfset var imageInterpolation = "highQuality" />

		<cfset arguments.gal_active = yesNoFormat(arguments.gal_active) />

		<cfif len(arguments.gal_image)>

			<cffile action="upload" filefield="gal_image" destination="#application.imageUploadPath#" nameconflict="makeUnique" accept="image/gif, image/jpeg, image/jpg, image/pjpeg">

			<cfset FileName = cffile.serverFileName & '.' & cffile.serverFileExt />
			<cfset newFileName = cffile.serverFileName & '_cta.' & cffile.serverFileExt />

			<cfimage action="read" name="imageInMem" source="#application.imageUploadPath#/#FileName#" />

			<cfimage action="info" source="#imageInMem#" structName="ImageCR" />

			<cfset origWidth = imageCR.width />
			<cfset origHeight = imageCR.height />

			<cfset ImageSetAntialiasing(imageInMem) />

			<cfset ImageResize(imageInMem, "200", "", imageInterpolation) />

			<cfset ImageCrop(imageInMem, "0", "0", "200", "150") />

			<cfimage action="info" source="#imageInMem#" structName="ImageCR" />

			<cfset finalWidth = imageCR.width />
			<cfset finalHeight = imageCR.height />

			<cfimage source="#imageInMem#" action="write" destination="#application.imageUploadPath#/#newFileName#" overwrite="yes" />

		</cfif>

		<cfif arguments.gal_id gt 0>

			<cfquery name="updateGallery"  datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
				UPDATE wwwGallery SET
					gal_title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.gal_title#" list="false" />,
					gal_active = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.gal_active#" list="false" />

					<cfif len(arguments.gal_image)>
						, gal_image = <cfqueryparam cfsqltype="cf_sql_varchar" value="#newFileName#" list="false" />
					</cfif>

				WHERE gal_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.gal_id#" list="false" />
			</cfquery>

		<cfelse>

			<cfquery name="addGallery"  datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
				INSERT INTO wwwGallery	(
					gal_title,
					gal_active

					<cfif len(arguments.gal_image)>
						, gal_image
					</cfif>

				) VALUES (
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.gal_title#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.gal_active#" list="false" />

					<cfif len(arguments.gal_image)>
						, <cfqueryparam cfsqltype="cf_sql_varchar" value="#newFileName#" list="false" />
					</cfif>

				)
				SELECT SCOPE_IDENTITY() AS galleryID
			</cfquery>

			<cfset arguments.gal_id = addGallery.galleryID />

		</cfif>

	</cffunction>

	<!--- Author: Rafe - Date: 10/16/2009 --->
	<cffunction name="getGalleryImages" output="false" access="public" returntype="query" hint="I get all the images in a gallery">

		<cfargument name="gal_id" type="numeric" default="" required="true" />

		<cfset var getGalleryImages = "" />

		<cfquery name="getGalleryImages" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT gal_title,
				gai_order,
				img_id, img_title, img_name, img_height, img_width, img_altText, img_type, img_origName, img_origHeight, img_origWidth
			FROM wwwGallery
				INNER JOIN wwwGallery_Image ON gal_id = gai_gallery
					<cfif arguments.gal_id gt 0>
						AND gal_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.gal_id#" list="false" />
					<cfelse>
						AND gal_order = 1
					</cfif>
				INNER JOIN wwwImage ON gai_image = img_id
			ORDER BY gai_order
		</cfquery>

		<cfreturn getGalleryImages />

	</cffunction>

	<!--- Author: Rafe - Date: 10/16/2009 --->
	<cffunction name="galleryImagesSave" output="false" access="public" returntype="any" hint="I save and update the images in a gallery">

		<cfset var fileName = "" />
		<cfset var newFileName = "" />
		<cfset var fileNameSanitise = "" />
		<cfset var newFileNameSanitise = "" />
		<cfset var imageInterpolation = "highQuality" />
		<cfset var imageCounter = arguments.galleryImageCount />
		<cfset var img_id = "" />
		<cfset var img_title = "" />
		<cfset var img_altText = "" />
		<cfset var updateImage = "" />
		<cfset var updateImageOrder = "" />

		<cfloop from="1" to="3" index="thisLoop">

			<cfif len(evaluate("arguments.img_name#thisLoop#"))>

				<cffile action="upload" filefield="img_name#thisLoop#" destination="#application.imageUploadPath#slideshow/" nameconflict="makeUnique" accept="image/gif, image/jpeg, image/jpg, image/pjpeg">

				<cfset FileName = cffile.serverFileName & '.' & cffile.serverFileExt />
				<cfset fileNameSanitise = application.contentObj.sanitise(cffile.serverFileName) & '.' & cffile.serverFileExt />

				<cffile action="rename" source="#application.imageUploadPath#slideshow/#fileName#" destination="#application.imageUploadPath#slideshow/#fileNameSanitise#">

				<cfset newFileName = cffile.serverFileName & '_712.' & cffile.serverFileExt />
				<cfset newFileNameSanitise = application.contentObj.sanitise(cffile.serverFileName) & '_712.' & cffile.serverFileExt />

				<cfimage action="read" name="imageInMem" source="#application.imageUploadPath#slideshow/#FileNameSanitise#" />

				<cfimage action="info" source="#imageInMem#" structName="ImageCR" />

				<cfset origWidth = imageCR.width />
				<cfset origHeight = imageCR.height />

				<cfset ImageSetAntialiasing(imageInMem) />

				<cfset ImageResize(imageInMem, 712, "", imageInterpolation) />

				<cfset ImageCrop(imageInMem, "0", "0", "712", "534") />

				<cfimage action="info" source="#imageInMem#" structName="ImageCR" />

				<cfset finalWidth = imageCR.width />
				<cfset finalHeight = imageCR.height />

				<cfimage source="#imageInMem#" action="write" destination="#application.imageUploadPath#slideshow/#newFileNameSanitise#" overwrite="yes" />

				<!--- add new image to database for this content --->

				<cftransaction>

					<cfset imageCounter = imageCounter + 1 />

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
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('arguments.img_title#thisLoop#')#" list="false" />,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#newFileNameSanitise#" list="false" />,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="Slideshow" list="false" />,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('arguments.img_altText#thisLoop#')#" list="false" />,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#finalHeight#" list="false" />,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#finalWidth#" list="false" />,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#fileNameSanitise#" list="false" />,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#origHeight#" list="false" />,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#origWidth#" list="false" />
						)

						SELECT SCOPE_IDENTITY() AS imageID
					</cfquery>

					<cfquery name="addGalleryImage" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
						INSERT INTO wwwGallery_Image (
							gai_gallery,
							gai_image,
							gai_order
						) VALUES (
							<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.gal_id#" list="false" />,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#addImage.imageID#" list="false" />,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#imageCounter#" list="false" />
						)
					</cfquery>

				</cftransaction>

			</cfif>

		</cfloop>

		<cfloop from="1" to="#arguments.galleryImageCount#" index="thisImage">

			<cfif isDefined("arguments.imgDelete#thisImage#")>

				<cfset img_id = evaluate("arguments.imgID#thisImage#") />

				<cfquery name="deleteGalleryImage" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
					DELETE FROM wwwGallery_Image
					WHERE gai_image = <cfqueryparam cfsqltype="cf_sql_integer" value="#img_id#" list="false" />
						AND gai_gallery = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.gal_id#" list="false" />
				</cfquery>

			<cfelse>

				<cfset img_id = evaluate("arguments.imgID#thisImage#") />
				<cfset img_title = evaluate("arguments.imgTitle#thisImage#") />
				<cfset img_altText = evaluate("arguments.imgAltText#thisImage#") />
				<cfset img_order = evaluate("arguments.imgOrder#thisImage#") />

				<cfquery name="updateImage" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
					UPDATE wwwImage SET
						img_title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#img_title#" list="false" />,
						img_altText = <cfqueryparam cfsqltype="cf_sql_varchar" value="#img_altText#" list="false" />
					WHERE img_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#img_id#" list="false" />
				</cfquery>

				<cfquery name="updateImageOrder" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
					UPDATE wwwGallery_Image SET
						gai_order = <cfqueryparam cfsqltype="cf_sql_integer" value="#img_order#" list="false" />
					WHERE gai_image = <cfqueryparam cfsqltype="cf_sql_integer" value="#img_id#" list="false" />
						AND gai_gallery = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.gal_id#" list="false" />
				</cfquery>

			</cfif>

		</cfloop>

	</cffunction>

	<!--- Author: Rafe - Date: 10/22/2009 --->
	<cffunction name="getContentImages" output="false" access="public" returntype="query" hint="I return all the images for a content ID, optionally excluding a type (eg all except Main for putting at the bottom of a content page)">

		<cfargument name="con_id" type="numeric" default="" required="true" />
		<cfargument name="excludeType" type="string" default="Main" required="false" />

		<cfset var getContentImages = "" />

		<cfquery name="getContentImages" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT coi_order,
				img_id, img_title, img_name, img_height, img_width, img_altText, img_type, img_origName, img_origHeight, img_origWidth
			FROM wwwContent_Image
				INNER JOIN wwwContent ON coi_content = con_id
				INNER JOIN wwwImage ON coi_image = img_id
			WHERE con_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.con_id#" list="false" />

				<cfif len(arguments.excludeType)>
					AND img_type NOT IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.excludeType#" list="true" />)
				</cfif>

		</cfquery>

		<cfreturn getContentImages />

	</cffunction>

	<!--- Author: Rafe - Date: 10/22/2009 --->
	<cffunction name="getContentImagesWeb" output="false" access="public" returntype="query" hint="I return all the images for a content ID, optionally excluding a type (eg all except Main for putting at the bottom of a content page)">

		<cfargument name="con_id" type="numeric" default="" required="true" />
		<cfargument name="excludeType" type="string" default="Main" required="false" />

		<cfset var getContentImages = "" />

		<cfquery name="getContentImages" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT img_title as imageTitle, img_name as imageName
			FROM wwwContent_Image
				INNER JOIN wwwContent ON coi_content = con_id
				INNER JOIN wwwImage ON coi_image = img_id
			WHERE con_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.con_id#" list="false" />

				<cfif len(arguments.excludeType)>
					AND img_type NOT IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.excludeType#" list="true" />)
				</cfif>

		</cfquery>

		<cfreturn getContentImages />

	</cffunction>

	<!--- Author: rafe - Date: 2/20/2010 --->
	<cffunction name="galleryImageView" output="false" access="public" returntype="any" hint="">
		
		<cfargument name="gal_id" type="numeric" default="0" required="true" />
		<cfargument name="img_id" type="string" default="0" required="false" />
	
		<cfset var qImages = getGalleryImages(arguments.gal_id) />
		<cfset var galleryImageView = "" />
		
		<cfsaveContent variable="galleryImageView">
			<cfoutput>
				<div id="slideshow" class="pics">
					<cfloop query="qImages">
		            	<img src="#application.imagePath#slideshow/#qImages.img_name#" title="#qImages.img_title#" alt="#qImages.img_altText#" width="712" height="534" />
		            </cfloop>
		        </div>
		        
			</cfoutput>
		</cfsaveContent>
		
		<cfreturn galleryImageView />

	</cffunction>

	<!--- Author: rafe - Date: 3/6/2010 --->
	<cffunction name="homePageImagesForm" output="false" access="public" returntype="string" hint="I return the form for replacing the home page images">
		
		<cfset var homeImageForm="" />
		
		<cfsaveContent variable="homeImageForm">
			<cfoutput>
				
				<form action="#request.myself#web.homePageImages" method="post" enctype="multipart/form-data">
					
					<table id="formTable">
			
						<tr class="tableHeader">
							<td colspan='5'><div class="tableTitle">Home Image</div></td>
						</tr>
			
						<tr>
							<td class="leftForm">Image</td>
							<td class="whiteGutter">&nbsp;</td>
							<td>
								<input type="file" name="img_name" value="" style="width:250px"><br />
								Note: please make sure the image you upload is square; final size of this image on the website will be 182px x 182px
							</td>
							<td class="whiteGutter">&nbsp;</td>
							<td class="rightForm">&nbsp;</td>
						</tr>
						
						<tr>
							<td class="leftForm">Position</td>
							<td class="whiteGutter">&nbsp;</td>
							<td>
								<select name="imagePos" style="width:250px">
									<option value="1">1</option>
									<option value="3">3</option>
									<option value="5">5</option>
									<option value="6">6</option>
									<option value="7">7</option>
									<option value="9">9</option>
									<option value="10">10</option>
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

					</table>
					
				</form>

			</cfoutput>
		</cfsaveContent>
		
		<cfreturn homeImageForm />
		
	</cffunction>

	<!--- Author: rafe - Date: 3/17/2010 --->
	<cffunction name="homePageImagesSave" output="false" access="public" returntype="any" hint="I upload and save the home page images">
		
		<cfset var fileName = "" />
		<cfset var fileNameSanitise = "" />
		<cfset var imageInterpolation = "highQuality" />
		
		<cffile action="upload" filefield="img_name" destination="#application.imageUploadPath#homepage/" nameconflict="makeUnique" accept="image/jpeg, image/jpg, image/pjpeg">

		<cfset FileName = cffile.serverFile />
		<cfset newFileName = "pic_featured" & arguments.imagePos & ".jpg" />

		<cfimage action="read" name="imageInMem" source="#application.imageUploadPath#homepage/#FileName#" />

		<cfimage action="info" source="#imageInMem#" structName="ImageCR" />

		<cfset ImageSetAntialiasing(imageInMem) />

		<cfset ImageResize(imageInMem, 182, "", imageInterpolation) />

		<cfset ImageCrop(imageInMem, "0", "0", "182", "182") />

		<cfimage source="#imageInMem#" action="write" destination="#application.imageUploadPath#homepage/#newFileName#" overwrite="yes" />

	</cffunction>

</cfcomponent>




















