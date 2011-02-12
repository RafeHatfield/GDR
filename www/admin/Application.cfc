<cfcomponent name="Application" extends="fusebox5.Application" output="false">
<!--- <cfcomponent name="Application"> --->
	<cfscript>
		this.name="gdrAdmin_ii";
		this.sessionManagement = true;
		this.sessionTimeout = CreateTimeSpan(0, 0, 30, 0);
	</cfscript>

	<!--- enable debugging --->
	<!--- <cfset FUSEBOX_PARAMETERS.debug = true /> --->

	<!--- enable debugging --->
	<cfif listFind(cgi.SERVER_NAME,'local','.')>
		<cfset FUSEBOX_PARAMETERS.debug = true />
		<cfset FUSEBOX_PARAMETERS.mode = "development-full-load" />
	</cfif>

	<!--- force the directory in which we start to ensure CFC initialization works: --->
	<cfset FUSEBOX_CALLER_PATH = getDirectoryFromPath(getCurrentTemplatePath()) />

	<cfset application.rootPath = "/" />
	<cfset application.rootDir = GetDirectoryFromPath(GetTemplatePath()) />

	<cfsetting requesttimeout="60" />

	<cffunction name="onApplicationStart" returntype="boolean" output="false" access="public" hint="I am executed when the application starts">

		<cfset application.path = ExpandPath('/')>

		<!--- development --->
		<cfif listFindNoCase(cgi.SERVER_NAME,"local",".")>

			<cfset application.imageUploadPath = application.path & "assets/images/upload/" />
			<cfset application.downloadPath = application.path & "assets/download/" />
			<cfset application.flashUploadPath = application.path & "assets/flash/" />

			<cfset application.DBDSN = "gdrdsn" />
			<cfset application.DBUserName = "sa" />
			<cfset application.DBPassword = "g3t0ut" />
			<cfset application.wwwURL = "http://" & cgi.server_name & "/" />
			<cfset application.adminURL = "http://" & cgi.server_name & "/admin/" />

			<cfset application.assetsPath = "/assets/" />
			<cfset application.flashPath = "/assets/flash/" />
			<cfset application.imagePath = "/assets/images/upload/" />
			<cfset application.imagePathBase = "/assets/images/" />

			<cfset application.reservationObj = createObject( 'component', 'gdr.com.reservation' ) />
			<cfset application.menuObj = createObject( 'component', 'gdr.com.menu' ) />
			<cfset application.villaObj = createObject( 'component', 'gdr.com.villa' ) />
			<cfset application.contentObj = createObject( 'component', 'gdr.com.content' ) />
			<cfset application.imageObj = createObject( 'component', 'gdr.com.image' ) />
			<cfset application.newsObj = createObject( 'component', 'gdr.com.news' ) />
			<cfset application.memberObj = createObject( 'component', 'gdr.com.member' ) />
			<cfset application.contactObj = createObject( 'component', 'gdr.com.contact' ) />
			<cfset application.systemObj = createObject( 'component', 'gdr.com.system' ) />
			<cfset application.ctaObj = createObject( 'component', 'gdr.com.cta' ) />

		<cfelse>
		<!--- live ---><!--- application.rootDir &  --->
			<cfset application.imageUploadPath = "C:\Websites\200079bj6\assets\images\upload\" />
			<cfset application.flashUploadPath = "C:\Websites\200079bj6\assets\flash\" />
			<cfset application.downloadPath = "C:\Websites\200079bj6\assets\download\" />

			<cfset application.DBDSN = "gdrDSN" />
			<cfset application.DBUserName = "gdrDBUser" />
			<cfset application.DBPassword = "gdrDB2010" />

			<cfset application.wwwURL = "http://" & cgi.server_name & "/" />
			<cfset application.adminURL = "http://" & cgi.server_name & "/admin/" />

			<cfset application.assetsPath = "/assets/" />
			<cfset application.flashPath = "/assets/flash/" />
			<cfset application.imagePath = "/assets/images/upload/" />
			<cfset application.imagePathBase = "/assets/images/" />

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

		</cfif>

		<cfset application.imageStandardWidth = "240" />

		<cfinclude template="system/model/act_createCircuits.cfm" />

		<cfset super.onApplicationStart() />

		<cfset application.systemSettings = application.systemObj.getSystemSettings() />

		<cfreturn True />

	</cffunction>

	<cffunction name="onSessionStart" output="false" access="public" returntype="boolean" hint="I am executed when the session starts">
		
		<cfparam name="session.prd_category" default="0" />
		<cfparam name="session.prd_subcategory" default="0" />
		<cfparam name="session.prd_category3" default="0" />
			
		<cfreturn True />

	</cffunction>

	<cffunction name="onRequestStart" returntype="boolean" output="false" access="public" hint="I am executed at the start of each request">

		<cfargument name="targetPage" />

		<cfset super.onRequestStart(argumentCollection=arguments) />

		<cfif StructKeyExists(URL, "appReload")>
			<!--- reinitialise the application scope --->
			<cfset onApplicationStart() />
		</cfif>

		<cfset tickBegin = GetTickCount()>

		<cfparam name="session.prd_category" default="0" />
		<cfparam name="session.prd_subcategory" default="0" />
		<cfparam name="session.prd_category3" default="0" />
			
		<!--- these vars are used in the layout files --->
		<cfparam name='request.styleSheetList' default='' />
		<cfparam name='request.jsList' default='' />
		<cfparam name='request.bodyParams' default='' />
		<cfparam name='request.footerJS' default='' />
		
		<cfset request.memberCategoryList = "" />
		<cfset request.memberSubCategoryList = "" />
		
		<cfset request.pathInfo = cgi.script_name & cgi.path_info />

		<cfset request.TinyMCEIncluded="false"/>
		<cfset request.url = "http://" & cgi.http_host />

		<cfset tickBegin = GetTickCount()>
<!---

		<cfparam name="url.circuitRewrite" default='0' />

		<cfif url.circuitRewrite is 1>
			<cfinclude template="system/model/act_createCircuits.cfm" />
		</cfif>
 --->

		<cfif ListFirst(attributes.fuseaction,".") neq "login" AND (not isDefined("cookie.usr_id"))>
			<cflocation url="#myself#login.form&gotofa=#attributes.fuseaction#" addtoken="no" />
		</cfif>

		<cfreturn True />

	</cffunction>

	<cffunction name="onRequestEnd" returntype="void" output="true" access="public" hint="I am executed when all pages in the request have finished processing">

		<cfargument name="targetPage" />
		<!--- Pass request to Fusebox. --->
		<cfset super.onRequestEnd(arguments.targetPage) />

		<cfset tickEnd = GetTickCount()>
		<cfset executionTime = tickEnd - tickBegin>
		<cfoutput>executionTime: #executionTime# ms</cfoutput>

	</cffunction>

</cfcomponent>