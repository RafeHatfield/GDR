<cfcomponent hint="I hold the menu functions" output="false">

	<!--- Author: Rafe - Date: 9/26/2009 --->
	<cffunction name="displayMenu" output="false" access="public" returntype="string" hint="I return the main menu for the site">

		<cfargument name="myself" type="string" default="" required="true" />
		<cfargument name="menuArea" type="numeric" default="1" required="true" />

		<cfset var menu = "" />
		<cfset var qMenu = getMenu(menuArea=arguments.menuArea,active=1) />
		<!--- <cfset var qSubMenu = getSubMenu(val(request.qContent.con_parentID)) /> --->
		
		<cfquery name="mainMenu" dbtype="query">
			SELECT *
			FROM qMenu
			WHERE con_parentID = 0		
		</cfquery>

		<cfsaveContent variable="menu">
			<cfoutput>
				<ul class="menulist" id="listMenuRoot">
				
					<cfloop query="mainMenu">
					
						<li<cfif mainMenu.currentRow eq mainMenu.recordCount> class="noborder"</cfif>>
						
							<cfif mainMenu.con_type is "Content" and not len(mainMenu.con_fuseAction)>
								<a href="#arguments.myself#content.display&page=#mainMenu.con_sanitise#">#mainMenu.con_menuTitle#</a>
							<cfelseif mainMenu.con_type is "Content" and len(mainMenu.con_fuseAction)>
								<a href="#arguments.myself##mainMenu.con_fuseAction#&page=#mainMenu.con_sanitise#">#mainMenu.con_menuTitle#</a>
							<cfelseif mainMenu.con_type is "Link">
								<a href="#mainMenu.con_link#">#mainMenu.con_menuTitle#</a>
							</cfif>
								
							<cfquery name="subMenu" dbType="query">
								SELECT *
								FROM qMenu
								WHERE con_parentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#mainMenu.con_id#" list="false" />
							</cfquery>
							
							<cfif subMenu.recordCount>
								<ul>
									<cfloop query="subMenu">
										<li<cfif subMenu.currentRow eq subMenu.recordCount> class="last"</cfif>>
											
											<cfif subMenu.con_type is "Content" and not len(subMenu.con_fuseAction)>
												<a href="#arguments.myself#content.display&page=#subMenu.con_sanitise#">#subMenu.con_menuTitle#</a>
											<cfelseif subMenu.con_type is "Content" and len(subMenu.con_fuseAction)>
												<a href="#arguments.myself##subMenu.con_fuseAction#&page=#subMenu.con_sanitise#">#subMenu.con_menuTitle#</a>
											<cfelseif subMenu.con_type is "Link">
												<a href="#subMenu.con_link#">#subMenu.con_menuTitle#</a>
											</cfif>
								
										</li>	
									</cfloop>
								</ul>
							</cfif>
							
						</li>
						
					</cfloop>
					
				</ul>
			</cfoutput>
		</cfsaveContent>

		<cfreturn menu />

	</cffunction>

	<!--- Author: Rafe - Date: 9/27/2009 --->
	<cffunction name="getMenu" output="false" access="public" returntype="query" hint="I return all the items in the specified menu">

		<cfargument name="active" type="string" default="1" required="false" />

		<cfset var getMenu = "" />

<!--- 		<cfquery name="getMenu" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT mna_title, 
				con_id, con_fuseAction, con_menuTitle, con_sanitise, con_type, con_link, con_parentID
			FROM wwwContent
				INNER JOIN wwwMenuArea ON con_menuArea = mna_id
					AND con_menuArea = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.menuArea#" list="false" />
			WHERE 1 = 1
				AND con_parentID = 0
			
				<cfif yesNoFormat(arguments.active)>
					AND con_active = 1
				</cfif>
			
			ORDER BY con_menuOrder
		</cfquery> --->

		<cfquery name="getMenu" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT mna_title, 
				con_id, con_fuseAction, con_menuTitle, con_sanitise, con_type, con_link, con_parentID
			FROM wwwContent
				INNER JOIN wwwMenuArea ON con_menuArea = mna_id
					AND con_menuArea = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.menuArea#" list="false" />
			WHERE 1 = 1
				<!--- AND con_parentID = 0 --->
			
				<cfif yesNoFormat(arguments.active)>
					AND con_active = 1
				</cfif>
			
			ORDER BY con_menuOrder
		</cfquery>

		<cfreturn getMenu />

	</cffunction>
	
	<!--- Author: rafe - Date: 12/6/2009 --->
	<cffunction name="getSubMenu" output="false" access="public" returntype="query" hint="I return a query with the corrent submenu displayed">
		
		<cfargument name="parentID" type="numeric" default="#val(request.qContent.con_parentID)#" required="false" />
		<cfargument name="contentID" type="numeric" default="#request.qContent.con_id#" required="false" />
	
		<cfset var getSubMenu = "" />
		
		<cfquery name="getSubMenu" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT con_id, con_fuseAction, con_menuTitle, con_sanitise, con_type, con_link, con_parentID
			FROM wwwContent
			WHERE (
				con_parentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.parentID#" list="false" />
				OR 
				con_parentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.contentID#" list="false" />
			)
				AND con_parentID != 0
			ORDER BY con_menuOrder
		</cfquery>
		
		<cfreturn getSubMenu />
		
	</cffunction>

	<!--- Author: Rafe - Date: 9/27/2009 --->
	<cffunction name="displayMenuMenuArea" output="false" access="public" returntype="any" hint="">

		<cfargument name="myself" type="string" default="" required="true" />
		<cfargument name="menuArea" type="numeric" default="1" required="true" />
		<cfargument name="showMenuArea" type="boolean" default="1" required="false" />

		<cfset var menuMenuArea = "" />
		<cfset var qMenu = getMenu(menuArea=arguments.menuArea) />

		<cfsaveContent variable = "menuMenuArea">
			<cfif qMenu.recordCount>

				<cfoutput query="qMenu" group="mna_title">

					<cfif arguments.showMenuArea>
						<h2>#mna_title#</h2>
					</cfif>

					<ul>
						<cfoutput>
							<li>
								<cfif con_type is "Content" and not len(con_fuseAction)>
									<a href="#arguments.myself#content.display&page=#con_sanitise#">#con_menuTitle#</a>
								<cfelseif con_type is "Content" and len(con_fuseAction)>
									<a href="#arguments.myself##con_fuseAction#&page=#con_sanitise#">#con_menuTitle#</a>
								<cfelseif con_type is "Link">
									<a href="#con_link#">#con_menuTitle#</a>
								</cfif>
							</li>
						</cfoutput>
					</ul>

				</cfoutput>

			<cfelseif request.qContent.con_leftMenuArea is 10>

				<cfset qMenu = application.villaObj.getPromotions() />

				<cfif arguments.showMenuArea>
					<h2>Promotions</h2>
				</cfif>

					<ul>
						<cfoutput query="qMenu">

							<li>
								<a href="#arguments.myself#rates.promotionView&prm_id=#prm_id#">#prm_title#</a>
							</li>

						</cfoutput>

					</ul>

			</cfif>

		</cfsaveContent>

		<cfreturn menuMenuArea />

	</cffunction>

	<!--- Author: Rafe - Date: 10/2/2009 --->
	<cffunction name="getMenuArea" output="false" access="public" returntype="query" hint="I return the specific menu area">

		<cfargument name="mna_id" type="numeric" default="0" required="true" />

		<cfset var getMenuArea = "" />

		<cfquery name="getMenuArea" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT mna_title, mna_active
			FROM wwwMenuArea
			WHERE mna_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.mna_id#" list="false" />
		</cfquery>

		<cfreturn getMenuArea />

	</cffunction>

	<!--- Author: Rafe - Date: 10/2/2009 --->
	<cffunction name="getMenuAreas" output="false" access="public" returntype="query" hint="I return the specific menu area">

		<cfset var getMenuAreas = "" />

		<cfquery name="getMenuAreas" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT mna_id, mna_title, mna_active
			FROM wwwMenuArea
			ORDER BY mna_title
		</cfquery>

		<cfreturn getMenuAreas />

	</cffunction>

	<!--- Author: Rafe - Date: 10/02/2009 --->
	<cffunction name="getMenuItem" output="false" access="public" returntype="query" hint="I return all the items in the specified menu">

		<cfargument name="mnu_id" type="numeric" default="0" required="false" />

		<cfset var getMenuItem = "" />

		<cfquery name="getMenuItem" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT mnu_title, mnu_fuseAction, mnu_order, mnu_active, mnu_menuArea
			FROM wwwMenu
			WHERE mnu_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.mnu_id#" list="false" />
			ORDER BY mnu_order
		</cfquery>

		<cfreturn getMenuItem />

	</cffunction>

	<!--- Author: Rafe - Date: 10/4/2009 --->
	<cffunction name="menuAreaSave" output="false" access="public" returntype="any" hint="I save the details about the menu area">

		<cfargument name="mna_active" type="boolean" default="0" required="false" />

		<cfset var updateMenuArea = "" />
		<cfset var addMenuArea = "" />

		<cfif arguments.mna_id gt 0>

			<cfquery name="updateMenuArea"  datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
				UPDATE wwwMenuArea SET
					mna_title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mna_title#" list="false" />,
					mna_active = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.mna_active#" list="false" />
				WHERE mna_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.mna_id#" list="false" />
			</cfquery>

		<cfelse>

			<cfquery name="addMenuArea"  datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
				INSERT INTO wwwMenuArea	(
					mna_title,
					mna_active
				) VALUES (
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mna_title#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.mna_active#" list="false" />
				)
			</cfquery>

		</cfif>

	</cffunction>

	<!--- Author: rafe - Date: 1/10/2010 --->
	<cffunction name="displayCategoryMenu" output="false" access="public" returntype="string" hint="I display the category menu">
		
		<cfargument name="cat_id" type="numeric" default="0" required="false" />
	
		<cfset var categoryMenu = "" />
		<cfset var qCategories = "" />
		
		<cfset qCategories = getCategories() />
		
		<cfsaveContent variable="categoryMenu">
			<cfoutput>
				<ul id="menu">
					<cfloop query="qCategories">
						<li>
							<a href="#request.myself#products.list&cat_id=#qCategories.cat_id#"<cfif arguments.cat_id is qCategories.cat_id> class="selected"</cfif>>#lcase(qCategories.cat_title)#</a>
							#displaySubCategoryMenu(cat_id=qCategories.cat_id)#
						</li>
					</cfloop>
				</ul>
			</cfoutput>
		</cfsaveContent>
		
		<cfreturn categoryMenu />
		
	</cffunction>
	
	<!--- Author: rafe - Date: 1/10/2010 --->
	<cffunction name="getCategories" output="false" access="public" returntype="query" hint="I return a query with the categories for products">
		
		<cfset var getCategories = "" />
		
		<cfparam name="request.memberCategoryList" default="" />
		
		<cfquery name="getCategories" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT cat_id, cat_title, cat_order
			FROM category
			WHERE cat_active = 1
				AND cat_level = 1
				<cfif listLen(request.memberCategoryList) gte 1>
					AND cat_id IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#request.memberCategoryList#" list="true" />)
				</cfif>
			ORDER BY cat_order
		</cfquery>
		
		<cfreturn getCategories />
		
	</cffunction>

	<!--- Author: rafe - Date: 1/10/2010 --->
	<cffunction name="displaySubCategoryMenu" output="false" access="public" returntype="string" hint="I display a menu of the subcategories based on the category chosen">
		
		<cfargument name="cat_id" type="numeric" default="0" required="false" />
		<cfargument name="subcat_id" type="numeric" default="0" required="false" />
		
		<cfset var subCategoryMenu = "" />
		<cfset var qSubCategories = "" />
		<cfset var qCategories3 = "" />
		
		<cfset qSubCategories = getSubCategories(cat_id=arguments.cat_id) />
		
		<cfsaveContent variable="subCategoryMenu">
			<cfoutput>
				<ul>
					<cfif qSubCategories.recordCount gt 1>
						<li><a href="#request.myself#products.list&cat_id=#arguments.cat_id#">show all</a></li>
					</cfif>
					<cfloop query="qSubCategories">
						<li<cfif qSubCategories.currentRow eq qSubCategories.recordCount> class="last"</cfif>><a href="#request.myself#products.list&cat_id=#arguments.cat_id#&subcat_id=#qSubCategories.cat_id#">#lcase(qSubCategories.cat_title)#</a></li>
						
						<cfif qSubCategories.cat_id is arguments.subcat_id>
							<cfset qCategories3 = getCategories3(arguments.cat_id,arguments.subcat_id) />
							<cfif qCategories3.recordCount>
								<cfloop query="qCategories3">
									<li class="cat3"><a href="#request.myself#products.list&cat_id=#arguments.cat_id#&subcat_id=#qSubCategories.cat_id#&cat3_id=#qCategories3.cat_id#"><div style="padding-left:10px">- #lcase(cat_title)#</div></a></li>
								</cfloop>
							</cfif>
						</cfif>
						
					</cfloop>
				</ul>
			</cfoutput>
		</cfsaveContent>
		
		<cfreturn subCategoryMenu />	
		
	</cffunction>
	
	<!--- Author: rafe - Date: 1/10/2010 --->
	<cffunction name="getSubCategories" output="false" access="public" returntype="query" hint="I return a query with the subcategories for a category that has products">
		
		<cfargument name="cat_id" type="numeric" default="0" required="false" />
		
		<cfset var getSubCategories = "" />
		
		<cfparam name="request.memberSubCategoryList" default="" />
		
		<cfquery name="getSubCategories" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT cat_id, cat_title
			FROM category
			WHERE cat_id IN (
				SELECT prd_subCategory
				FROM product
				WHERE prd_category = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cat_id#" list="false" />
			)
				<cfif listLen(request.memberCategoryList) gte 1>
					AND cat_id IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#request.memberSubCategoryList#" list="true" />)
				</cfif>
			ORDER BY cat_order, cat_title
		</cfquery>
		
		<cfreturn getSubCategories />
		
	</cffunction>
	
	<!--- Author: rafe - Date: 2/20/2010 --->
	<cffunction name="getCategories3" output="false" access="public" returntype="query" hint="I return the 3rd level categories based on cat & subcatcat and subcat">
		
		<cfargument name="cat_id" type="numeric" default="0" required="false" />
		<cfargument name="subcat_id" type="numeric" default="0" required="false" />
	
		<cfset var getCategories3 = "" />
		
		<cfquery name="getCategories3" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT cat_id, cat_title
			FROM category
			WHERE cat_id IN (
				SELECT prd_category3
				FROM product
				WHERE prd_category = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cat_id#" list="false" />
					AND prd_subCategory = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.subcat_id#" list="false" />
			)
			ORDER BY cat_title
		</cfquery>
		
		<cfreturn getCategories3 />	
		
			
	</cffunction>

	<!--- Author: rafe - Date: 1/24/2010 --->
	<cffunction name="getAllSubCategories" output="false" access="public" returntype="query" hint="I return all the subcategories, and only the subcategories">
		
		<cfset getAllSubCategories = "" />
		
		<cfquery name="getAllSubCategories" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT cat_id, cat_title
			FROM category
			WHERE cat_active = 1
				AND cat_level = 2
			ORDER BY cat_title
		</cfquery>
		
		<cfreturn getAllSubCategories />
		
	</cffunction>

	<!--- Author: rafe - Date: 1/24/2010 --->
	<cffunction name="getAllCategories3" output="false" access="public" returntype="query" hint="I return all the subcategories, and only the subcategories">
		
		<cfset getAllCategories3 = "" />
		
		<cfquery name="getAllCategories3" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT cat_id, cat_title
			FROM category
			WHERE cat_active = 1
				AND cat_level = 3
			ORDER BY cat_title
		</cfquery>
		
		<cfreturn getAllCategories3 />
		
	</cffunction>

	<!--- Author: rafe - Date: 2/12/2010 --->
	<cffunction name="getCategoryLevels" output="false" access="public" returntype="query" hint="I return the levels of categories in the database">
		
		<cfset var getCategoryLevels = "" />
		
		<cfquery name="getCategoryLevels" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT DISTINCT cat_level
			FROM category
			ORDER BY cat_level
		</cfquery>
		
		<cfreturn getCategoryLevels />
		
	</cffunction>
	
	<!--- Author: rafe - Date: 2/12/2010 --->
	<cffunction name="getCategoriesByLevel" output="false" access="public" returntype="query" hint="I return a query with the categories according to the level passed in">
		
		<cfargument name="cat_level" type="numeric" default="0" required="false" />
	
		<cfset var getCategoriesByLevel = "" />
		
		<cfquery name="getCategoriesByLevel" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT cat_id, cat_title, cat_order, cat_active, cat_level
			FROM category
			WHERE cat_level = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cat_level#" list="false" />
				AND cat_active = 1
			ORDER BY cat_order, cat_title
		</cfquery>
		
		<cfreturn getCategoriesByLevel />
		
	</cffunction>

	<!--- Author: rafe - Date: 2/12/2010 --->
	<cffunction name="getCategory" output="false" access="public" returntype="query" hint="I return a category based on cat_id">
		
		<cfargument name="cat_id" type="numeric" default="0" required="false" />
		
		<cfset var getCategory = "" />
		
		<cfquery name="getCategory" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT cat_id, cat_title, cat_order, cat_active, cat_level
			FROM category
			WHERE cat_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cat_id#" list="false" />
		</cfquery>
		
		<cfreturn getCategory />
		
	</cffunction>
	
</cfcomponent>












