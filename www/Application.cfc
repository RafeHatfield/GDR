<cfcomponent extends="fusebox5.Application" output="false">

	<!--- set application name based on the directory path --->
	<cfset this.name = "gdr_i" />

	<!--- enable debugging --->
	<cfif listFind(cgi.SERVER_NAME,'local','.')>
		<cfset FUSEBOX_PARAMETERS.debug = true />
	</cfif>
		<cfset FUSEBOX_PARAMETERS.mode = "development-full-load" />

	<cfparam name="application.seoURL" default="0" />

	<cfif application.seoURL>

		<cfset FUSEBOX_PARAMETERS.queryStringStart ="/" /><!---  // default: ? --->
		<cfset FUSEBOX_PARAMETERS.queryStringSeparator ="/" /><!---  // default: & --->
		<cfset FUSEBOX_PARAMETERS.queryStringEqual = "/" /><!---  // default: = --->

	</cfif>

	<!--- force the directory in which we start to ensure CFC initialization works: --->
	<cfset FUSEBOX_CALLER_PATH = getDirectoryFromPath(getCurrentTemplatePath()) />

	<cffunction name="onApplicationStart" returntype="boolean" output="false" access="public" hint="I am executed when the application starts">

		<cfset super.onApplicationStart() />

		<!--- development --->
		<cfif listFindNoCase(cgi.SERVER_NAME,"local",".")>
			<cfset application.DBDSN = "gdrdsn" />
			<cfset application.DBUserName = "sa" />
			<cfset application.DBPassword = "g3t0ut" />

			<cfset application.reservationObj = createObject( 'component', 'gdr.com.reservation' ) />
			<cfset application.menuObj = createObject( 'component', 'gdr.com.menu' ) />
			<cfset application.villaObj = createObject( 'component', 'gdr.com.villa' ) />
			<cfset application.contentObj = createObject( 'component', 'gdr.com.content' ) />
			<cfset application.imageObj = createObject( 'component', 'gdr.com.image' ) />
			<cfset application.newsObj = createObject( 'component', 'gdr.com.news' ) />
			<cfset application.memberObj = createObject( 'component', 'gdr.com.member' ) />
			<cfset application.contactObj = createObject( 'component', 'gdr.com.contact' ) />
			<cfset application.ctaObj = createObject( 'component', 'gdr.com.cta' ) />
			<cfset application.systemObj = createObject( 'component', 'gdr.com.system' ) />

			<cfset application.googleKey = "ABQIAAAA-QoBVtFL2SWaVJEUzeBfOhS4XlV8aCYfyEDn6ioBu6pqZAo3wBTEDh6NuH6dIH9OKONPB5YuVNLdgw" />

			<cfset application.flashPath = "assets/flash/" />
			<cfset application.imagePath = "assets/images/upload/" />
			<cfset application.imagePathBase = "assets/images/" />
			<cfset application.path = ExpandPath('/')>
			<cfset application.imageUploadPath = application.path & "assets/images/upload/" />
			<cfset application.flashUploadPath = application.path & "assets/flash/" />

			<cfset application.online = "0" />
<!--- 
		<cfelseif listFindNoCase(cgi.SERVER_NAME,"asianvhm",".") AND NOT listFindNoCase(cgi.SERVER_NAME,"seagdr",".")>

			<cfset application.DBDSN = "avhmDSN" />
			<cfset application.DBUserName = "avhm" />
			<cfset application.DBPassword = "myVilla5" />

			<cfset application.reservationObj = createObject( 'component', 'gdrH197792.com.reservation' ) />
			<cfset application.menuObj = createObject( 'component', 'gdrH197792.com.menu' ) />
			<cfset application.villaObj = createObject( 'component', 'gdrH197792.com.villa' ) />
			<cfset application.contentObj = createObject( 'component', 'gdrH197792.com.content' ) />
			<cfset application.imageObj = createObject( 'component', 'gdrH197792.com.image' ) />
			<cfset application.newsObj = createObject( 'component', 'gdrH197792.com.news' ) />
			<cfset application.memberObj = createObject( 'component', 'gdrH197792.com.member' ) />
			<cfset application.contactObj = createObject( 'component', 'gdrH197792.com.contact' ) />
			<cfset application.ctaObj = createObject( 'component', 'gdrH197792.com.cta' ) />
			<cfset application.systemObj = createObject( 'component', 'gdrH197792.com.system' ) />

			<cfset application.googleKey = "ABQIAAAA-QoBVtFL2SWaVJEUzeBfOhThXwDjVDH96rWIUZNBUUHFNxydUxRicd42qKdHfHFAPAHREPaexotF-A" />

			<cfset application.online = "0" />
 --->
		<cfelse>

		<!--- live --->
			<cfset application.DBDSN = "gdrDSN" />
			<cfset application.DBUserName = "gdrDBUser" />
			<cfset application.DBPassword = "gdrDB2010" />

			<cfset application.reservationObj = createObject( 'component', 'gdrH200079.com.reservation' ) />
			<cfset application.menuObj = createObject( 'component', 'gdrH200079.com.menu' ) />
			<cfset application.villaObj = createObject( 'component', 'gdrH200079.com.villa' ) />
			<cfset application.contentObj = createObject( 'component', 'gdrH200079.com.content' ) />
			<cfset application.imageObj = createObject( 'component', 'gdrH200079.com.image' ) />
			<cfset application.newsObj = createObject( 'component', 'gdrH200079.com.news' ) />
			<cfset application.memberObj = createObject( 'component', 'gdrH200079.com.member' ) />
			<cfset application.contactObj = createObject( 'component', 'gdrH200079.com.contact' ) />
			<cfset application.systemObj = createObject( 'component', 'gdrH200079.com.system' ) />
			<cfset application.ctaObj = createObject( 'component', 'gdrH200079.com.cta' ) />

			<!--- this key is for seagdr.asianvhm.com --->
			<!--- <cfset application.googleKey = "ABQIAAAA-QoBVtFL2SWaVJEUzeBfOhT6Z1grzXIAr9CQeNPy8sD9XSooIRQMBdAmeetYxNgvVBuf3f_8TtmraA" /> --->

			<!--- this key is for seagdr.com --->
			 <cfset application.googleKey = "ABQIAAAA-QoBVtFL2SWaVJEUzeBfOhSilBdtqJvktMyh6laD05YMvGjYahSwa0G8dyxRGk5jPQDqHyffU0ejkQ" />

			<cfset application.online = "1" />

			<cfset application.flashPath = "assets/flash/" />
			<cfset application.imagePath = "assets/images/upload/" />
			<cfset application.imagePathBase = "assets/images/" />
			<cfset application.path = ExpandPath('/')>
			<cfset application.imageUploadPath = application.path & "assets\images\upload\" />
			<cfset application.flashUploadPath = application.path & "assets\flash\" />

		</cfif>

		<cfset application.feedbackEmail = "info@gdrasia.com" />
		<cfset application.adminEmail = "rafe@asianvhm.com" />

		<cfset application.appInitialized = true />

		<cfset application.systemSettings = application.systemObj.getSystemSettings() />

		<cfreturn True />

	</cffunction>

	<cffunction name="onFuseboxApplicationStart">

		<cfset super.onFuseboxApplicationStart() />

		<!--- code formerly in fusebox.appinit.cfm or the appinit global fuseaction --->
		<cfset myFusebox.getApplicationData().startTime = now() />

	</cffunction>

	<cffunction name="onRequestStart" returntype="boolean" output="false" access="public" hint="I am executed at the atart of each request">

		<cfargument name="targetPage" />
		
		<cfset super.onRequestStart(argumentCollection=arguments) />
		
		<!--- if we are not on a development server and a www. is not prefixed into the url --->
		<cfif not ReFind("(\.local)$", cgi.http_host) and not ReFind("^www\.", cgi.http_host)>

			<!--- admending - if the application.adminSubDomainPrefix has a length, we need to allow it to not trip this condition ie allow that subdomain request to go thru without being redirected --->
			<!--- <cfif len(application.adminSubDomainPrefix) and not ReFind('^#application.adminSubDomainPrefix#\.', CGI.HTTP_HOST)> --->

				<!--- url location --->
				<cfset urlloc = "http://www." & cgi.http_host & ReReplace(cgi.script_name, "Index\.cfm$", "") & iif(Len(Trim(cgi.query_string)), de("?"&cgi.query_string), de(""))>

				<!--- force refresh with the www. present in the url --->
				<cflocation url="#urlloc#" addtoken="no" statusCode="301" />

			<!--- </cfif> --->

		</cfif>

		<cfif not isDefined("cookie.gdrProductList")>
			<cfcookie name="gdrProductList" value="" />
		</cfif>
		
		<cfif not isDefined("cookie.gdrUserID")>
			<cfcookie name="gdrUserID" value="0" />
		</cfif>
		
<!--- <cfif cookie.gdrUserID is 0>
	gdruserid is 0<br />
</cfif>

<cfif attributes.fuseAction neq 'contact.login'>
	fa neq login<br />
</cfif>

<cfdump var="#attributes#"><cfabort> --->

<!--- 		<cfif cookie.gdrUserID is 0 and attributes.fuseAction neq 'contact.login'>
			<cflocation url="index.cfm?fuseAction=contact.login" />
		</cfif> --->
		
		<cfif cookie.gdrUserID is 0 and (attributes.fuseAction eq 'products.list' OR attributes.fuseAction eq 'products.view' OR attributes.fuseAction eq 'products.saved') >
			<cflocation url="index.cfm?fuseAction=contact.login" />
		</cfif>
		
		<cfif StructKeyExists(URL, "appReload")>
			<!--- reinitialise the application scope --->
			<cfset onApplicationStart() />
		</cfif>

		<cfset request.memberPermissions = application.memberObj.getMemberPermissions(cookie.gdrUserID) />
		
		<cfquery name="getCats" dbType="query">
			SELECT mca_category
			FROM request.memberPermissions
			WHERE cat_level = 1
		</cfquery>
		
		<cfquery name="getSubCats" dbType="query">
			SELECT mca_category
			FROM request.memberPermissions
			WHERE cat_level = 2
		</cfquery>
		
		<cfset request.memberCategoryList = valueList(getCats.mca_category) />
		<cfset request.memberSubCategoryList = valueList(getSubCats.mca_category) />
		
		<!--- these vars are used in the layout files --->
		<cfparam name='request.styleSheetList' default='' />
		<cfparam name='request.jsList' default='' />
		<cfparam name='request.bodyParams' default='' />
		<cfparam name='request.footerJS' default='' />

		<cfset request.pathInfo = cgi.script_name & cgi.path_info />

		<cfset request.TinyMCEIncluded = "false" />
		<cfset request.url = "http://" & cgi.http_host />
		<cfset request.fullURL = request.url & cgi.script_name & "?" & cgi.query_string />

		<!--- get the page content, store it in a request var for later use --->
		<cfparam name="attributes.page" default="" />

		<cfif not len(attributes.page)>
			<cfset request.qContent = application.contentObj.getContent(fuseAction=attributes.fuseAction) />
			<cfif not request.qContent.recordCount>
				<cfset attributes.page = "home" />
				<cfset request.qContent = application.contentObj.getContent(page=attributes.page) />
			</cfif>
		<cfelse>
			<cfset request.qContent = application.contentObj.getContent(page=attributes.page) />
		</cfif>
		
		<cfset request.qContentImages = application.imageObj.getContentImagesWeb(con_id=request.qContent.con_id) />

		<cfif not request.qContentImages.recordCount>
			<cfset request.qContentImages = application.contentObj.getGloryBoxesDefault(gbx_active=1, gbx_type='Image') />
		</cfif>

		<cfif len(request.qContent.con_title)>
			<cfset request.pageTitle = "Great Dividing Range" & ' - ' & request.qContent.con_title />
		<cfelse>
			<cfset request.pageTitle = "Great Dividing Range" & ' - ' & application.systemSettings.sys_pageTitle />
		</cfif>

		<cfif len(request.qContent.con_metaDescription)>
			<cfset request.metaDescription = request.qContent.con_metaDescription />
		<cfelse>
			<cfset request.metaDescription = application.systemSettings.sys_metaDescription />
		</cfif>

		<cfif len(request.qContent.con_metaKeywords)>
			<cfset request.metaKeywords = request.qContent.con_metaKeywords />
		<cfelse>
			<cfset request.metaKeywords = application.systemSettings.sys_metaKeywords />
		</cfif>

		<cfreturn True />

	</cffunction>

	<cffunction name="onRequestEnd" returntype="void" output="true" access="public" hint="I am executed when all pages in the request have finished processing">

		<cfargument name="targetPage" />
		<!--- Pass request to Fusebox. --->
		<cfset super.onRequestEnd(arguments.targetPage) />

	</cffunction>

</cfcomponent>