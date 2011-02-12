<cfcomponent hint="I am the CTA function" output="false">

	<!--- Author: Rafe - Date: 10/13/2009 --->
	<cffunction name="getCTA" output="false" access="public" returntype="query" hint="I return a query with the given cta">

		<cfargument name="cta_id" type="numeric" default="" required="true" />

		<cfset var getCTA = "" />

		<cfquery name="getCTA" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT cta_title, cta_link, cta_image, cta_active, cta_random
			FROM wwwCallToAction
			WHERE cta_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cta_id#" list="false" />
		</cfquery>

		<cfreturn getCTA />

	</cffunction>

	<!--- Author: Rafe - Date: 10/13/2009 --->
	<cffunction name="getCTAs" output="false" access="public" returntype="query" hint="I return a query with all the ctas">

		<cfset var getCTAs = "" />

		<cfquery name="getCTAs" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT cta_id, cta_title, cta_link, cta_image, cta_active, cta_random
			FROM wwwCallToAction
			WHERE cta_active = 1
			ORDER BY cta_dateEntered DESC
		</cfquery>

		<cfreturn getCTAs />

	</cffunction>

	<!--- Author: Rafe - Date: 10/13/2009 --->
	<cffunction name="ctaSave" output="false" access="public" returntype="any" hint="i save the information for a cta">

		<cfargument name="cta_active" type="string" default="0" required="false" />

		<cfset var updateCTA = "" />
		<cfset var addCTA = "" />

		<cfset var imageInterpolation = "highPerformance" />

		<cfset arguments.cta_active = yesNoFormat(arguments.cta_active) />

		<cfif len(arguments.cta_image)>

			<cffile action="upload" filefield="cta_image" destination="#application.imageUploadPath#" nameconflict="makeUnique" accept="image/gif, image/jpeg, image/jpg, image/pjpeg">

			<cfset FileName = cffile.serverFileName & '.' & cffile.serverFileExt />
			<cfset newFileName = cffile.serverFileName & '_cta.' & cffile.serverFileExt />

			<cfimage action="read" name="imageInMem" source="#application.imageUploadPath#/#FileName#" />

			<cfimage action="info" source="#imageInMem#" structName="ImageCR" />

			<cfset origWidth = imageCR.width />
			<cfset origHeight = imageCR.height />

			<cfset ImageSetAntialiasing(imageInMem) />

			<cfset ImageResize(imageInMem, "200", "", imageInterpolation) />

			<cfset ImageCrop(imageInMem, "0", "0", "200", "100") />

			<cfimage action="info" source="#imageInMem#" structName="ImageCR" />

			<cfset finalWidth = imageCR.width />
			<cfset finalHeight = imageCR.height />

			<cfimage source="#imageInMem#" action="write" destination="#application.imageUploadPath#/#newFileName#" overwrite="yes" />

		</cfif>



		<cfif arguments.cta_id gt 0>

			<cfquery name="updateCTA"  datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
				UPDATE wwwCallToAction SET
					cta_title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.cta_title#" list="false" />,
					cta_link = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.cta_link#" list="false" />,
					cta_active = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.cta_active#" list="false" />,
					cta_random = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.cta_random#" list="false" />

					<cfif len(arguments.cta_image)>
						, cta_image = <cfqueryparam cfsqltype="cf_sql_varchar" value="#newFileName#" list="false" />
					</cfif>

				WHERE cta_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cta_id#" list="false" />
			</cfquery>

		<cfelse>

			<cfquery name="addCTA"  datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
				INSERT INTO wwwCallToAction	(
					cta_title,
					cta_link,
					cta_active,
					cta_random

					<cfif len(arguments.cta_image)>
						, cta_image
					</cfif>

				) VALUES (
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.cta_title#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.cta_link#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.cta_active#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.cta_random#" list="false" />

					<cfif len(arguments.cta_image)>
						, <cfqueryparam cfsqltype="cf_sql_varchar" value="#newFileName#" list="false" />
					</cfif>

				)
				SELECT SCOPE_IDENTITY() AS ctaID
			</cfquery>

			<cfset arguments.cta_id = addCTA.ctaID />

		</cfif>

	</cffunction>

	<!--- Author: Rafe - Date: 10/15/2009 --->
	<cffunction name="RandomCallToAction" returntype="string" output="false" hint="Returns a list of CallToActionIDs on a selected number of random Call To Actions">

		<cfargument name="Quantity" type="numeric" default="1"/>
		<cfargument name="ExcludeIDs" type="string" default=""/>

		<cfset var temp = StructNew()/>
		<cfset var i = "" />

		<cfquery name="temp.qAllCallToActions" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT cta_id, cta_image, cta_title, cta_link
			FROM wwwCallToAction
			WHERE cta_active = 1

				<cfif ListLen(arguments.ExcludeIDs)>
					AND cta_id NOT IN (
						<cfqueryparam cfsqltype="cf_sql_integer" value="#ListChangeDelims(arguments.ExcludeIDs, ',')#" list="true">
					)
				</cfif>

		</cfquery>

		<cfset temp.Result = ""/>

		<cfloop from="1" to="#temp.qAllCallToActions.RecordCount#" index="i">

			<cfset temp.TestCTAID = temp.qAllCallToActions.cta_id[RandRange(1, temp.qAllCallToActions.recordCount)]/>

			<cfif not listFind(temp.Result, temp.TestCTAID)>
				<cfset temp.Result = listAppend(temp.Result, temp.TestCTAID)/>
			</cfif>

			<cfif ListLen(temp.Result) gte Min(arguments.Quantity, temp.qAllCallToActions.recordCount)>
				<cfbreak/>
			</cfif>

		</cfloop>

		<cfreturn temp.Result/>

	</cffunction>

	<!--- Author: Rafe - Date: 10/15/2009 --->
	<cffunction name="getCallToAction" returntype="query" output="false">

		<cfargument name="cta_id" type="numeric" default="" required="true" />

		<cfset var getCallToAction = "" />

		<cfquery name="getCallToAction" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT cta_id, cta_image, cta_title, cta_link
			FROM wwwCallToAction
			WHERE cta_active = 1
				AND cta_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cta_id#" list="false">
		</cfquery>

		<cfreturn getCallToAction />

	</cffunction>

</cfcomponent>


































