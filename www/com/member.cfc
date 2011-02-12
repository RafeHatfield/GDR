<cfcomponent hint="I am the system settings function" output="false">

	<!--- Author: Rafe - Date: 10/7/2009 --->
	<cffunction name="memberSave" output="false" access="public" returntype="any" hint="I save or update a member's details and return the member id">

		<cfargument name="mem_title" type="string" default="" required="false" />
		<cfargument name="mem_firstName" type="string" default="" required="false" />
		<cfargument name="mem_surname" type="string" default="" required="false" />
		<cfargument name="mem_email" type="string" default="" required="false" />
		<cfargument name="mem_website" type="string" default="" required="false" />
		<cfargument name="mem_salutation" type="string" default="" required="false" />
		<cfargument name="mem_password" type="string" default="" required="false" />
		<cfargument name="mem_mobilePhone" type="string" default="" required="false" />
		<cfargument name="mem_officePhone" type="string" default="" required="false" />
		<cfargument name="mem_homePhone" type="string" default="" required="false" />
		<cfargument name="mem_fax" type="string" default="" required="false" />
		<cfargument name="mem_business" type="string" default="" required="false" />
		<cfargument name="mem_address1" type="string" default="" required="false" />
		<cfargument name="mem_address2" type="string" default="" required="false" />
		<cfargument name="mem_address3" type="string" default="" required="false" />
		<cfargument name="mem_suburb" type="string" default="" required="false" />
		<cfargument name="mem_state" type="string" default="" required="false" />
		<cfargument name="mem_company" type="string" default="" required="false" />
		<cfargument name="mem_countryName" type="string" default="" required="false" />
		<cfargument name="cou_id" type="string" default="0" required="false" />
		<cfargument name="mem_postCode" type="string" default="" required="false" />
		<cfargument name="mem_origin" type="string" default="" required="false" />
		<cfargument name="grp_id" type="string" default="" required="false" />
		<cfargument name="not_body" type="string" default="" required="false" />
		<cfargument name="mem_numChildren" type="string" default="" required="false" />
		<cfargument name="mem_interests" type="string" default="" required="false" />
		<cfargument name="mem_childInformation" type="string" default="" required="false" />
		<cfargument name="mem_image" type="string" default="" required="false" />

		<cfargument name="partnerTitle" type="string" default="" required="false" />
		<cfargument name="partnerFirstName" type="string" default="" required="false" />
		<cfargument name="partnerSurname" type="string" default="" required="false" />
		<cfargument name="partnerSalutation" type="string" default="" required="false" />
		<cfargument name="partnerEmail" type="string" default="" required="false" />
		<cfargument name="partnerPassword" type="string" default="" required="false" />
		<cfargument name="partnerMobilePhone" type="string" default="" required="false" />
		<cfargument name="partnerOfficePhone" type="string" default="" required="false" />

		<cfargument name="int_id" type="string" default="" required="false" />
		<cfargument name="interestOther" type="string" default="" required="false" />
		
		<cfargument name="cat_id" type="string" default="" required="false" />

		<cfset var checkMemberExists = "" />
		<cfset var addMember = "" />
		<cfset var memberID = "" />
		<cfset var fileName = "" />
		<cfset var fileNameSanitise = "" />
		<cfset var newFileName = "" />
		<cfset var newFileNameSanitise = "" />
		<cfset var imageInterpolation = "highPerformance" />
		<cfset var partnerID = "0" />
		<Cfset var interestID = "" />

		<cftransaction>

			<cfif len(arguments.mem_image)>

				<cffile action="upload" filefield="mem_image" destination="#application.imageUploadPath#members" nameconflict="makeUnique" accept="image/gif, image/jpeg, image/jpg, image/pjpeg">

				<cfset FileName = cffile.serverFileName & '.' & cffile.serverFileExt />
				<cfset fileNameSanitise = application.contentObj.sanitise(cffile.serverFileName) & '.' & cffile.serverFileExt />

				<cfset newFileName = cffile.serverFileName & '_250.' & cffile.serverFileExt />
				<cfset newFileNameSanitise = application.contentObj.sanitise(cffile.serverFileName) & '_250.' & cffile.serverFileExt />

				<cfimage action="read" name="imageInMem" source="#application.imageUploadPath#members/#FileName#" />

				<cfimage action="info" source="#imageInMem#" structName="ImageCR" />

				<cfset origWidth = imageCR.width />
				<cfset origHeight = imageCR.height />

				<cfset ImageSetAntialiasing(imageInMem) />

				<cfset ImageResize(imageInMem, "250", "", imageInterpolation) />

				<cfimage action="info" source="#imageInMem#" structName="ImageCR" />

				<cfset finalWidth = imageCR.width />
				<cfset finalHeight = imageCR.height />

				<cfimage source="#imageInMem#" action="write" destination="#application.imageUploadPath#members/#newFileNameSanitise#" overwrite="yes" />

			</cfif>

			<!--- check if this person is already in the database --->
			<cfquery name="checkMemberExists" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
				SELECT mem_id
				FROM member
				<cfif len(trim(arguments.mem_email)) gt 5>
					WHERE mem_email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mem_email#" list="false" />
				<cfelse>
					WHERE mem_firstName + ' ' + mem_surname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mem_firstName# #arguments.mem_surname#" list="false" />
				</cfif>
			</cfquery>

			<cfif not checkMemberExists.recordCount>

				<cfquery name="addMember" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
					INSERT INTO member (
						mem_title,
						mem_firstName,
						mem_surname,
						mem_salutation,
						mem_email,
						mem_website,
						mem_password,
						mem_mobilePhone,
						mem_officePhone,
						mem_fax,
						mem_homePhone,
						mem_business,
						mem_address1,
						mem_address2,
						mem_address3,
						mem_suburb,
						mem_state,
						mem_countryName,
						mem_postCode,
						mem_company,
						mem_origin,
						mem_numChildren,
						mem_childInformation,
						mem_interests

						<cfif len(newFileNameSanitise)>
							, mem_image
						</cfif>

					) VALUES (
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mem_title#" list="false" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mem_firstName#" list="false" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mem_surname#" list="false" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mem_salutation#" list="false" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mem_email#" list="false" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mem_website#" list="false" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mem_password#" list="false" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mem_mobilePhone#" list="false" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mem_officePhone#" list="false" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mem_fax#" list="false" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mem_homePhone#" list="false" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mem_business#" list="false" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mem_address1#" list="false" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mem_address2#" list="false" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mem_address3#" list="false" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mem_suburb#" list="false" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mem_state#" list="false" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mem_countryName#" list="false" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mem_postCode#" list="false" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mem_company#" list="false" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mem_origin#" list="false" />,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.mem_numChildren)#" list="false" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mem_childInformation#" list="false" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mem_interests#" list="false" />

						<cfif len(newFileNameSanitise)>
							, <cfqueryparam cfsqltype="cf_sql_varchar" value="#newFileNameSanitise#" list="false" />
						</cfif>

					)
					SELECT SCOPE_IDENTITY() AS memberID
				</cfquery>

				<cfset memberID = addMember.memberID />

			<cfelse>

				<cfquery name="updateMember" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
					UPDATE member SET
						mem_title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mem_title#" list="false" />,
						mem_firstName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mem_firstName#" list="false" />,
						mem_surname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mem_surname#" list="false" />,
						mem_salutation = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mem_salutation#" list="false" />,
						mem_email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mem_email#" list="false" />,
						mem_website = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mem_website#" list="false" />,
						mem_password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mem_password#" list="false" />,
						mem_mobilePhone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mem_mobilePhone#" list="false" />,
						mem_officePhone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mem_officePhone#" list="false" />,
						mem_fax = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mem_fax#" list="false" />,
						mem_homePhone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mem_homePhone#" list="false" />,
						mem_business = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mem_business#" list="false" />,
						mem_address1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mem_address1#" list="false" />,
						mem_address2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mem_address2#" list="false" />,
						mem_address3 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mem_address3#" list="false" />,
						mem_suburb = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mem_suburb#" list="false" />,
						mem_state = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mem_state#" list="false" />,
						mem_countryName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mem_countryName#" list="false" />,
						mem_postCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mem_postCode#" list="false" />,
						mem_company = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mem_company#" list="false" />,
						mem_origin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mem_origin#" list="false" />,
						mem_numChildren = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.mem_numChildren)#" list="false" />,
						mem_childInformation = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mem_childInformation#" list="false" />,
						mem_interests = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mem_interests#" list="false" />

						<cfif len(newFileNameSanitise)>
							, mem_image = <cfqueryparam cfsqltype="cf_sql_varchar" value="#newFileNameSanitise#" list="false" />
						</cfif>

					WHERE mem_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#checkMemberExists.mem_id#" list="false" />
				</cfquery>

				<cfset memberID = checkMemberExists.mem_id />

			</cfif>

			<cfif len(arguments.not_body)>

				<cfquery name="addNote" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
					INSERT INTO memberNote (
						not_body,
						not_member,
						not_user
					) VALUES (
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.not_body#" list="false" />,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#memberID#" list="false" />,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#cookie.usr_id#" list="false" />
					)
				</cfquery>

			</cfif>
			
			<!--- permissions for viewing categories --->
			<cfquery name="removePermissions" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
				DELETE FROM member_category
				WHERE mca_member = <cfqueryparam cfsqltype="cf_sql_integer" value="#memberID#" list="false" />
			</cfquery>	
			
			<cfif listLen(arguments.cat_id) gte 1>
			
				<cfloop list="#arguments.cat_id#" index="thisCategory">
			
					<cfquery name="addPermission" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
						INSERT INTO member_category (
							mca_category,
							mca_member
						) VALUES (
							<cfqueryparam cfsqltype="cf_sql_integer" value="#thisCategory#" list="false" />,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#memberID#" list="false" />
						)
					</cfquery>		

				</cfloop>
				
			</cfif>

		</cftransaction>

		<cfif len(arguments.interestOther)>

			<cfloop list="#arguments.interestOther#" index="thisInterest">

				<cfset interestID = addNewInterest(thisInterest) />

				<cfif not listFind(arguments.int_id,interestID)>
					<cfset arguments.int_id = listAppend(arguments.int_id, interestID) />
				</cfif>

			</cfloop>

		</cfif>

		<cfif listLen(arguments.int_id)>

			<cfquery name="removeInterests" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
				DELETE FROM Member_Interest
				WHERE mei_member = <cfqueryparam cfsqltype="cf_sql_integer" value="#memberID#" list="false" />
			</cfquery>

			<cfloop list="#arguments.int_id#" index="thisInterestID">

				<cfquery name="addNewInterests" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
					INSERT INTO Member_Interest (
						mei_member,
						mei_interest
					) VALUES (
						<cfqueryparam cfsqltype="cf_sql_integer" value="#memberID#" list="false" />,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#thisInterestID#" list="false" />
					)
				</cfquery>

			</cfloop>

		</cfif>

		<cfif len(arguments.partnerFirstName) or len(arguments.partnerSurname)>

			<cfset partnerID = application.memberObj.memberSave(
				mem_title = trim(arguments.partnerTitle),
				mem_firstName = trim(arguments.partnerFirstName),
				mem_surname = trim(arguments.partnerSurname),
				mem_email = trim(arguments.partnerEmail),
				mem_password = trim(arguments.partnerPassword),
				mem_salutation = trim(arguments.partnerSalutation),
				mem_mobilePhone = trim(arguments.partnerMobilePhone),
				mem_officePhone = trim(arguments.partnerOfficePhone),
				mem_address1 = "#arguments.mem_address1#",
				mem_address2 = "#arguments.mem_address2#",
				mem_address3 = "#arguments.mem_address3#",
				mem_suburb = trim(arguments.mem_suburb),
				mem_state = trim(arguments.mem_state),
				mem_countryName = arguments.mem_countryName,
				mem_postCode = trim(arguments.mem_postCode),
				mem_origin = 'Partner Entry'
				) />

		</cfif>

		<cfif partnerID gt 0>

			<cfquery name="updatePartner1" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
				UPDATE member SET
					mem_partner = <cfqueryparam cfsqltype="cf_sql_integer" value="#partnerID#" list="false" />
				WHERE mem_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#memberID#" list="false" />
			</cfquery>

			<cfquery name="updatePartner2" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
				UPDATE member SET
					mem_partner = <cfqueryparam cfsqltype="cf_sql_integer" value="#memberID#" list="false" />
				WHERE mem_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#partnerID#" list="false" />
			</cfquery>

		</cfif>

		<cfreturn memberID />

	</cffunction>

	<!--- Author: Rafe - Date: 10/28/2009 --->
	<cffunction name="getMemberNotes" output="false" access="public" returntype="query" hint="I return all the notes for a given member">

		<cfargument name="mem_id" type="numeric" default="" required="true" />

		<cfset var getMemberNotes = "" />

		<cfquery name="getMemberNotes" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT not_id, not_body, not_dateEntered,
				usr_firstName, usr_surname
			FROM memberNote
				INNER JOIN Users on not_user = usr_id
			WHERE not_member = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.mem_id#" list="false" />
			ORDER BY not_dateEntered DESC
		</cfquery>

		<cfreturn getMemberNotes />

	</cffunction>

	<!--- Author: Rafe - Date: 10/7/2009 --->
	<cffunction name="memberGroupSave" output="false" access="public" returntype="any" hint="">

		<cfargument name="mem_id" type="numeric" default="0" required="true" />
		<cfargument name="grp_id" type="string" default="" required="false" />
		<cfargument name="groupOther" type="string" default="" required="false" />

		<cfset var removeGroup = "" />
		<cfset var addMemberGroup = "" />
		<cfset var memberGroupSuccess = "0" />
		<cfset var groupID = "" />

		<cfif len(arguments.groupOther)>

			<cfloop list="#arguments.groupOther#" index="thisGroup">

				<cfset groupID = addNewGroup(trim(thisGroup)) />

				<cfif not listFind(arguments.grp_id, groupID)>
					<cfset arguments.grp_id = listAppend(arguments.grp_id, groupID) />
				</cfif>

			</cfloop>

		</cfif>

		<cftry>

			<cftransaction>

				<cfquery name="removeGroup" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
					DELETE FROM member_group
					WHERE mgr_member = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.mem_id#" list="false" />
						AND mgr_group = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.grp_id#" list="false" />
				</cfquery>

				<cfloop list="#arguments.grp_id#" index="thisGroup">

					<cfquery name="addMemberGroup" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
						INSERT INTO member_group (
							mgr_member,
							mgr_group
						) VALUES (
							<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.mem_id#" list="false" />,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#thisGroup#" list="false" />
						)
					</cfquery>

				</cfloop>

			</cftransaction>

			<cfset memberGroupSuccess = "1" />

			<cfcatch>
			</cfcatch>

		</cftry>

		<cfreturn memberGroupSuccess />

	</cffunction>

	<!--- Author: Rafe - Date: 10/8/2009 --->
	<cffunction name="getMembers" output="false" access="public" returntype="query" hint="I return a list of members">

		<cfargument name="fastFind" type="string" default="" required="false" />
		<!--- <cfargument name="groupList" type="string" default="" required="false" /> --->
		<cfargument name="groupList" type="numeric" default="0" required="false" />
		<cfargument name="country" type="numeric" default="0" required="false" />
		<cfargument name="validEmail" type="boolean" default="0" required="false" />
		<cfargument name="interestList" type="string" default="" required="false" />
		<cfargument name="countryList" type="string" default="" required="false" />

		<cfset var getMembers = "" />

		<cfquery name="getMembers" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT mem_id, mem_title, mem_firstName, mem_surname, mem_email, mem_approved, mem_mobilePhone, mem_officePhone, mem_homePhone, mem_address1, mem_address2, mem_address3, mem_suburb, mem_state, mem_countryName, mem_postCode, mem_origin,
				(
					SELECT count(1)
					FROM message
					WHERE mes_member = mem_id
				) AS messageCount
			FROM member

			WHERE 1 = 1

				<cfif len(arguments.fastFind)>
					AND (
						mem_firstName + ' ' + mem_surname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.fastFind#%" list="false" />
						OR
						mem_email LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.fastFind#%" list="false" />
					)
				</cfif>

				<!--- <cfif listLen(arguments.groupList)>
					AND mem_id IN (
						SELECT mgr_member
						FROM member_group
						WHERE mgr_group IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.groupList#" list="true" />)
					)
				</cfif> --->
				<cfif arguments.groupList gt 0>
					AND mem_id IN (
						SELECT mgr_member
						FROM member_group
						WHERE mgr_group = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.groupList#" list="true" />
					)
				</cfif>

				<cfif arguments.validEmail>
					and len(mem_email) > 5
				</cfif>

			ORDER BY mem_firstName
		</cfquery>

		<cfreturn getMembers />

	</cffunction>

	<!--- Author: Rafe - Date: 10/8/2009 --->
	<cffunction name="displayMemberSearch" output="false" access="public" returntype="string" hint="I display the search form for members">

		<cfargument name="fastFind" type="string" default="" required="false" />
		<cfargument name="groupList" type="string" default="" required="false" />
		<cfargument name="country" type="numeric" default="0" required="false" />
		<cfargument name="interestList" type="string" default="" required="false" />

		<cfset var memberSearch = "" />
		<cfset var qGroups = getGroups() />
		<cfset var qCountries = getCountries() />
		<cfset var qInterests = getInterests() />

		<cfsaveContent variable="memberSearch">

			<cfoutput>

				<table id="formTable">

					<form action="#arguments.myself##arguments.fuseAction#" method="post">

						<tr class="tableHeader">
							<td colspan='5'><div class="tableTitle">Member Search</div></td>
						</tr>

						<tr>
							<td class="leftForm">Fast Find</td>
							<td class="whiteGutter">&nbsp;</td>
							<td>
								<input type="text" name="fastFind" value="#arguments.fastFind#" style="width:250px">
							</td>
							<td class="whiteGutter">&nbsp;</td>
							<td class="rightForm">&nbsp;</td>
						</tr>

						<tr>
							<td class="leftForm">Group</td>
							<td class="whiteGutter">&nbsp;</td>
							<td>
								<select name="groupList" style="width:250px">
									<option value="0">All</option>
									<cfloop query="qGroups">
										<option value="#qGroups.grp_id#"<cfif listFind(arguments.groupList,qGroups.grp_id)> selected</cfif>>#qGroups.grp_title#</option>
									</cfloop>
								</select>
							</td>
							<td class="whiteGutter">&nbsp;</td>
							<td class="rightForm">&nbsp;</td>
						</tr>
						
						<input type="hidden" name="country" value="0" />
						
<!--- 						<tr>
							<td class="leftForm">Country</td>
							<td class="whiteGutter">&nbsp;</td>
							<td>
								<select name="country" style="width:250px">
									<option value="0"></option>
									<cfloop query="qCountries">
										<option value="#qCountries.cou_id#"<cfif qCountries.cou_id is arguments.country> selected</cfif>>#qCountries.cou_title#</option>
									</cfloop>
								</select>
							</td>
							<td class="whiteGutter">&nbsp;</td>
							<td class="rightForm">&nbsp;</td>
						</tr> --->
						
						<input type="hidden" name="interestList" value="" />
<!--- 

						<tr>
							<td class="leftForm">Select Interests</td>
							<td class="whiteGutter">&nbsp;</td>
							<td>
								<select name="interestList" multiple="true" size="8" style="width: 250px">
									<cfloop query="qInterests">
										<option value="#int_id#"<cfif listFind(arguments.interestList,qInterests.int_id)> selected</cfif>>#int_title#</option>
									</cfloop>
								</select>
							</td>
							<td class="whiteGutter">&nbsp;</td>
							<td class="rightForm">&nbsp;</td>
						</tr>
 --->

						<tr>
							<td class="leftForm">Return List of Emails?</td>
							<td class="whiteGutter">&nbsp;</td>
							<td>
								<input type="checkbox" name="emailsOnly" value="1" />
							</td>
							<td class="whiteGutter">&nbsp;</td>
							<td class="rightForm">&nbsp;</td>
						</tr>

						<tr>
							<td class="leftForm">Export Results?</td>
							<td class="whiteGutter">&nbsp;</td>
							<td>
								<input type="checkbox" name="memberExport" value="1" />
							</td>
							<td class="whiteGutter">&nbsp;</td>
							<td class="rightForm">&nbsp;</td>
						</tr>

						<tr>
							<td class="formFooter" colspan="5">
								<input type="submit" value="Search" name="search" class="button" onMouseOver="this.className='buttonOver';" onMouseOut="this.className='button';">
							</td>
						</tr>

					</form>

				</table>

			</cfoutput>

		</cfsaveContent>

		<cfreturn memberSearch />

	</cffunction>

	<!--- Author: Rafe - Date: 10/8/2009 --->
	<cffunction name="getGroups" output="false" access="public" returntype="query" hint="I return a query with all the groups in the database">

		<cfset var getGroups = "" />

		<cfquery name="getGroups" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT grp_id, grp_title
			FROM groups
			ORDER BY grp_title
		</cfquery>

		<cfreturn getGroups />

	</cffunction>

	<!--- Author: Rafe - Date: 10/8/2009 --->
	<cffunction name="getCountries" output="false" access="public" returntype="query" hint="I return a query with all the countries in the database">

		<cfset var getCountries = "" />

		<cfquery name="getCountries" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT cou_id, cou_title
			FROM country
			ORDER BY cou_title
		</cfquery>

		<cfreturn getCountries />

	</cffunction>

	<!--- Author: Rafe - Date: 10/8/2009 --->
	<cffunction name="displayMemberForm" output="false" access="public" returntype="string" hint="i display the form for editing member details">

		<cfargument name="mem_id" type="numeric" default="0" required="true" />

		<cfset var memberForm = "" />
		<cfset var qMember = getMember(arguments.mem_id) />
		<cfset var qGroups = getGroups() />
		<cfset var qMemberNotes = getMemberNotes(arguments.mem_id) />
		<cfset var qMemberInterests = getMemberInterests(arguments.mem_id) />
		<cfset var qMemberGroups = getMemberGroups(arguments.mem_id) />
		<cfset var qInterests = getInterests() />
		<cfset var memberInterestList = valueList(qMemberInterests.int_id) />
		<cfset var groupList = valueList(qMemberGroups.grp_id) />
		<cfset var qCategories = application.menuObj.getCategories() />
		<cfset var qSubCategories = application.menuObj.getAllSubCategories() />
		<cfset var qMemberPermissions = getMemberPermissions(arguments.mem_id) />
		<cfset var memberPermissionsList = valueList(qMemberPermissions.mca_category) />

		<cfsaveContent variable="memberForm">
			
			<cfoutput>

				<form action="index.cfm?fuseAction=member.memberForm" method="post" enctype="multipart/form-data">

					<input type="hidden" name="mem_id" value="#arguments.mem_id#" />

					<table id="formTable">

	<!--- 					<tr class="tableHeader">
							<td colspan="2"><div class="tableTitle">Member Details</div></td>
						</tr>

						<tr>

							<td>

								<table> --->

									<tr class="tableHeader">
										<td colspan='5'><div class="tableTitle">Member Information</div></td>
									</tr>

									<tr>
										<td class="leftForm">Title</td>
										<td class="whiteGutter">&nbsp;</td>
										<td>
											<select name="mem_title" style="width: 250px;">
												<option value=""></option>
												<option value="Mr"<cfif qMember.mem_title is "Mr"> selected</cfif>>Mr</option>
												<option value="Mrs"<cfif qMember.mem_title is "Mrs"> selected</cfif>>Mrs</option>
												<option value="Miss"<cfif qMember.mem_title is "Miss"> selected</cfif>>Miss</option>
												<option value="Ms"<cfif qMember.mem_title is "Ms"> selected</cfif>>Ms</option>
												<option value="Dr"<cfif qMember.mem_title is "Dr"> selected</cfif>>Dr</option>
											</select>
										</td>
										<td class="whiteGutter">&nbsp;</td>
										<td class="rightForm">&nbsp;</td>
									</tr>

									<tr>
										<td class="leftForm">First</td>
										<td class="whiteGutter">&nbsp;</td>
										<td>
											<input type="text" name="mem_firstName" value="#qMember.mem_firstName#" style="width:250px" />
										</td>
										<td class="whiteGutter">&nbsp;</td>
										<td class="rightForm">&nbsp;</td>
									</tr>

									<tr>
										<td class="leftForm">Last</td>
										<td class="whiteGutter">&nbsp;</td>
										<td>
											<input type="text" name="mem_surname" value="#qMember.mem_surname#" style="width:250px" />
										</td>
										<td class="whiteGutter">&nbsp;</td>
										<td class="rightForm">&nbsp;</td>
									</tr>

									<tr>
										<td class="leftForm">Salutation</td>
										<td class="whiteGutter">&nbsp;</td>
										<td>
											<input type="text" name="mem_salutation" value="#qMember.mem_salutation#" style="width:250px" />
										</td>
										<td class="whiteGutter">&nbsp;</td>
										<td class="rightForm">&nbsp;</td>
									</tr>

									<tr>
										<td class="leftForm">Email</td>
										<td class="whiteGutter">&nbsp;</td>
										<td>
											<input type="text" name="mem_email" value="#qMember.mem_email#" style="width:250px" />
										</td>
										<td class="whiteGutter">&nbsp;</td>
										<td class="rightForm">&nbsp;</td>
									</tr>

									<tr>
										<td class="leftForm">Company</td>
										<td class="whiteGutter">&nbsp;</td>
										<td>
											<input type="text" name="mem_company" value="#qMember.mem_company#" style="width:250px" />
										</td>
										<td class="whiteGutter">&nbsp;</td>
										<td class="rightForm">&nbsp;</td>
									</tr>

									<tr>
										<td class="leftForm">Business</td>
										<td class="whiteGutter">&nbsp;</td>
										<td>
											<input type="text" name="mem_business" value="#qMember.mem_business#" style="width:250px" />
										</td>
										<td class="whiteGutter">&nbsp;</td>
										<td class="rightForm">&nbsp;</td>
									</tr>

									<tr>
										<td class="leftForm">Website</td>
										<td class="whiteGutter">&nbsp;</td>
										<td>
											<input type="text" name="mem_website" value="#qMember.mem_website#" style="width:250px" />
										</td>
										<td class="whiteGutter">&nbsp;</td>
										<td class="rightForm">&nbsp;</td>
									</tr>

									<tr>
										<td class="leftForm">Password</td>
										<td class="whiteGutter">&nbsp;</td>
										<td>
											<input type="text" name="mem_password" value="#qMember.mem_password#" style="width:250px" />
										</td>
										<td class="whiteGutter">&nbsp;</td>
										<td class="rightForm">&nbsp;</td>
									</tr>

									<tr>
										<td class="leftForm">Mobile</td>
										<td class="whiteGutter">&nbsp;</td>
										<td>
											<input type="text" name="mem_mobilePhone" value="#qMember.mem_mobilePhone#" style="width:250px" />
										</td>
										<td class="whiteGutter">&nbsp;</td>
										<td class="rightForm">&nbsp;</td>
									</tr>

									<tr>
										<td class="leftForm">Office</td>
										<td class="whiteGutter">&nbsp;</td>
										<td>
											<input type="text" name="mem_officePhone" value="#qMember.mem_officePhone#" style="width:250px" />
										</td>
										<td class="whiteGutter">&nbsp;</td>
										<td class="rightForm">&nbsp;</td>
									</tr>

									<tr>
										<td class="leftForm">Home</td>
										<td class="whiteGutter">&nbsp;</td>
										<td>
											<input type="text" name="mem_homePhone" value="#qMember.mem_homePhone#" style="width:250px" />
										</td>
										<td class="whiteGutter">&nbsp;</td>
										<td class="rightForm">&nbsp;</td>
									</tr>

									<tr>
										<td class="leftForm">Address</td>
										<td class="whiteGutter">&nbsp;</td>
										<td>
											<input type="text" name="mem_address1" value="#qMember.mem_address1#" style="width:250px" /><br />
											<input type="text" name="mem_address2" value="#qMember.mem_address2#" style="width:250px" /><br />
											<input type="text" name="mem_address3" value="#qMember.mem_address3#" style="width:250px" />
										</td>
										<td class="whiteGutter">&nbsp;</td>
										<td class="rightForm">&nbsp;</td>
									</tr>

									<tr>
										<td class="leftForm">Suburb</td>
										<td class="whiteGutter">&nbsp;</td>
										<td>
											<input type="text" name="mem_suburb" value="#qMember.mem_suburb#" style="width:250px" />
										</td>
										<td class="whiteGutter">&nbsp;</td>
										<td class="rightForm">&nbsp;</td>
									</tr>

									<tr>
										<td class="leftForm">State</td>
										<td class="whiteGutter">&nbsp;</td>
										<td>
											<input type="text" name="mem_state" value="#qMember.mem_state#" style="width:250px" />
										</td>
										<td class="whiteGutter">&nbsp;</td>
										<td class="rightForm">&nbsp;</td>
									</tr>

									<tr>
										<td class="leftForm">Country</td>
										<td class="whiteGutter">&nbsp;</td>
										<td>
											<input type="text" name="mem_countryName" value="#qMember.mem_countryName#" style="width:250px" />
										</td>
										<td class="whiteGutter">&nbsp;</td>
										<td class="rightForm">&nbsp;</td>
									</tr>

									<tr>
										<td class="leftForm">Postcode</td>
										<td class="whiteGutter">&nbsp;</td>
										<td>
											<input type="text" name="mem_postCode" value="#qMember.mem_postCode#" style="width:250px" />
										</td>
										<td class="whiteGutter">&nbsp;</td>
										<td class="rightForm">&nbsp;</td>
									</tr>

									<tr>
										<td class="leftForm">Origin</td>
										<td class="whiteGutter">&nbsp;</td>
										<td>
											<input type="text" name="mem_origin" value="#qMember.mem_origin#" style="width:250px" />
										</td>
										<td class="whiteGutter">&nbsp;</td>
										<td class="rightForm">&nbsp;</td>
									</tr>
									
									<input type="hidden" name="mem_image" value="" />
									<!--- 

									<tr>
										<td class="leftForm">Image</td>
										<td class="whiteGutter">&nbsp;</td>
										<td>
											<cfif len(qMember.mem_image)>
												<img src="#application.imagePath#members/#qMember.mem_image#" /><br />
											</cfif>
											<input type="file" name="mem_image" value="" style="width:250px" /><br />
											<em>This image will be resized to 250px wide.</em>
										</td>
										<td class="whiteGutter">&nbsp;</td>
										<td class="rightForm">&nbsp;</td>
									</tr>
 --->

									<tr>
										<td class="leftForm">Group</td>
										<td class="whiteGutter">&nbsp;</td>
										<td>
											<select name="grp_id" multiple="true" style="width:250px">
												<cfloop query="qGroups">
													<option value="#qGroups.grp_id#"<cfif listFind(groupList,qGroups.grp_id)> selected</cfif>>#qGroups.grp_title#</option>
												</cfloop>
											</select>

											<br />

											<input type="text" name="groupOther" value="" style="width:250px" />

											<br />

											<em>Enter any new groups not in the list above here, separated by a comma</em>

										</td>
										<td class="whiteGutter">&nbsp;</td>
										<td class="rightForm">&nbsp;</td>
									</tr>

									<tr>
										<td class="leftForm">Category Permissions</td>
										<td class="whiteGutter">&nbsp;</td>
										<td>
											<select name="cat_id" multiple="true" style="width:250px" size="5">
												<cfloop query="qCategories">
													<option value="#qCategories.cat_id#"<cfif listFind(memberPermissionsList,qCategories.cat_id)> selected</cfif>>#qCategories.cat_title#</option>
												</cfloop>
											</select>
										</td>
										<td class="whiteGutter">&nbsp;</td>
										<td class="rightForm">&nbsp;</td>
									</tr>

									<tr>
										<td class="leftForm">Sub-Category Permissions</td>
										<td class="whiteGutter">&nbsp;</td>
										<td>
											<select name="cat_id" multiple="true" style="width:250px" size="5">
												<cfloop query="qSubCategories">
													<option value="#qSubCategories.cat_id#"<cfif listFind(memberPermissionsList,qSubCategories.cat_id)> selected</cfif>>#qSubCategories.cat_title#</option>
												</cfloop>
											</select>
										</td>
										<td class="whiteGutter">&nbsp;</td>
										<td class="rightForm">&nbsp;</td>
									</tr>
									
									<input type="hidden" name="partnerTitle" value="" />
									<input type="hidden" name="partnerFirstName" value="" />
									<input type="hidden" name="partnerSurname" value="" />
									<input type="hidden" name="partnerSalutation" value="" />
									<input type="hidden" name="partnerEmail" value="" />
									<input type="hidden" name="partnerPassword" value="" />
									<input type="hidden" name="partnerMobilePhone" value="" />
									<input type="hidden" name="partnerOfficePhone" value="" />
									<input type="hidden" name="mem_numChildren" value="0" />
									<input type="hidden" name="mem_childInformation" value="" />
									<input type="hidden" name="int_id" value="" />
									<input type="hidden" name="interestOther" value="" />
<!--- 

								</table>

							</td>

							<td>

								<table>

									<tr class="tableHeader">
										<td colspan='5'><div class="tableTitle">Partner & Family Information</div></td>
									</tr>

									<tr>
										<td class="leftForm">Title</td>
										<td class="whiteGutter">&nbsp;</td>
										<td>
											<select name="partnerTitle" style="width: 250px;">
												<option value=""></option>
												<option value="Mr"<cfif qMember.partnerTitle is "Mr"> selected</cfif>>Mr</option>
												<option value="Mrs"<cfif qMember.partnerTitle is "Mrs"> selected</cfif>>Mrs</option>
												<option value="Miss"<cfif qMember.partnerTitle is "Miss"> selected</cfif>>Miss</option>
												<option value="Ms"<cfif qMember.partnerTitle is "Ms"> selected</cfif>>Ms</option>
												<option value="Dr"<cfif qMember.partnerTitle is "Dr"> selected</cfif>>Dr</option>
											</select>
										</td>
										<td class="whiteGutter">&nbsp;</td>
										<td class="rightForm">&nbsp;</td>
									</tr>

									<tr>
										<td class="leftForm">First</td>
										<td class="whiteGutter">&nbsp;</td>
										<td>
											<input type="text" name="partnerFirstName" value="#qMember.partnerFirstName#" style="width:250px" />
										</td>
										<td class="whiteGutter">&nbsp;</td>
										<td class="rightForm">&nbsp;</td>
									</tr>

									<tr>
										<td class="leftForm">Last</td>
										<td class="whiteGutter">&nbsp;</td>
										<td>
											<input type="text" name="partnerSurname" value="#qMember.partnerSurname#" style="width:250px" />
										</td>
										<td class="whiteGutter">&nbsp;</td>
										<td class="rightForm">&nbsp;</td>
									</tr>

									<tr>
										<td class="leftForm">Salutation</td>
										<td class="whiteGutter">&nbsp;</td>
										<td>
											<input type="text" name="partnerSalutation" value="#qMember.partnerSalutation#" style="width:250px" />
										</td>
										<td class="whiteGutter">&nbsp;</td>
										<td class="rightForm">&nbsp;</td>
									</tr>

									<tr>
										<td class="leftForm">Email</td>
										<td class="whiteGutter">&nbsp;</td>
										<td>
											<input type="text" name="partnerEmail" value="#qMember.partnerEmail#" style="width:250px" />
										</td>
										<td class="whiteGutter">&nbsp;</td>
										<td class="rightForm">&nbsp;</td>
									</tr>

									<tr>
										<td class="leftForm">Password</td>
										<td class="whiteGutter">&nbsp;</td>
										<td>
											<input type="text" name="partnerPassword" value="#qMember.partnerPassword#" style="width:250px" />
										</td>
										<td class="whiteGutter">&nbsp;</td>
										<td class="rightForm">&nbsp;</td>
									</tr>

									<tr>
										<td class="leftForm">Mobile</td>
										<td class="whiteGutter">&nbsp;</td>
										<td>
											<input type="text" name="partnerMobilePhone" value="#qMember.partnerMobilePhone#" style="width:250px" />
										</td>
										<td class="whiteGutter">&nbsp;</td>
										<td class="rightForm">&nbsp;</td>
									</tr>

									<tr>
										<td class="leftForm">Office</td>
										<td class="whiteGutter">&nbsp;</td>
										<td>
											<input type="text" name="partnerOfficePhone" value="#qMember.partnerOfficePhone#" style="width:250px" />
										</td>
										<td class="whiteGutter">&nbsp;</td>
										<td class="rightForm">&nbsp;</td>
									</tr>

									<tr>
										<td class="leftForm">Children</td>
										<td class="whiteGutter">&nbsp;</td>
										<td>
											<select name="mem_numChildren" style="width: 250px;">
												<Cfloop from="0" to="10" index="thisChild">
													<option value="#thisChild#"<cfif qMember.mem_numChildren eq thisChild> selected</cfif>>#thisChild#</option>
												</cfloop>
											</select>
										</td>
										<td class="whiteGutter">&nbsp;</td>
										<td class="rightForm">&nbsp;</td>
									</tr>

									<tr>
										<td class="leftForm">Child Notes</td>
										<td class="whiteGutter">&nbsp;</td>
										<td>
											<textarea name="mem_childInformation" style="width: 250px; height: 100px">#qMember.mem_childInformation#</textarea><br />
											<em>Include names and ages</em>
										</td>
										<td class="whiteGutter">&nbsp;</td>
										<td class="rightForm">&nbsp;</td>
									</tr>

									<tr>
										<td class="leftForm">Special Interest</td>
										<td class="whiteGutter">&nbsp;</td>
										<td>

											<select name="int_id" multiple="true" style="width: 250px">
												<cfloop query="qInterests">
													<option value="#int_id#"<cfif listFind(memberInterestList,int_id)> selected</cfif>>#int_title#</option>
												</cfloop>
											</select>

											<br />

											<input type="text" name="interestOther" value="" style="width:250px" />

											<br />

											<em>Enter any new interests not in the list above here, separated by a comma</em>

										</td>
										<td class="whiteGutter">&nbsp;</td>
										<td class="rightForm">&nbsp;</td>
									</tr>

								</table>

							</td>

						</tr>
 --->

						<tr>
							<td class="formFooter" colspan="5">
								<input type="submit" value="Save" name="save" class="button" onMouseOver="this.className='buttonOver';" onMouseOut="this.className='button';">
							</td>
						</tr>

					</table>


					<table id="formTable">

						<tr class="tableHeader">
							<td colspan='5'><div class="tableTitle">Notes</div></td>
						</tr>

						<tr>
							<td class="leftForm">Notes</td>
							<td class="whiteGutter">&nbsp;</td>
							<td>
								<textarea name="not_body" style="width: 250px; height: 100px"></textarea>
							</td>
							<td class="whiteGutter">&nbsp;</td>
							<td class="rightForm">&nbsp;</td>
						</tr>

						<cfif qMemberNotes.recordCount>

							<cfloop query="qMemberNotes">

								<tr>
									<td class="leftForm">#dateFormat(not_dateEntered)# - #usr_firstName# #usr_surname#</td>
									<td class="whiteGutter">&nbsp;</td>
									<td>
										#not_body#
									</td>
									<td class="whiteGutter">&nbsp;</td>
									<td class="rightForm">&nbsp;</td>
								</tr>

							</cfloop>

						</cfif>

						<tr>
							<td class="formFooter" colspan="5">
								<input type="submit" value="Save" name="save" class="button" onMouseOver="this.className='buttonOver';" onMouseOut="this.className='button';">
							</td>
						</tr>

					</table>

				</form>

			</cfoutput>

		</cfsaveContent>

		<cfreturn memberForm />

	</cffunction>

	<!--- Author: Rafe - Date: 10/8/2009 --->
	<cffunction name="getMember" output="false" access="public" returntype="query" hint="i return the query with details for one member">

		<cfargument name="mem_id" type="numeric" default="0" required="true" />

		<cfset var getMember = "" />

		<cfquery name="getMember" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT m.mem_id, m.mem_title, m.mem_firstName, m.mem_surname, m.mem_salutation, m.mem_email, m.mem_company, m.mem_business, m.mem_website, m.mem_password, m.mem_mobilePhone, m.mem_officePhone, m.mem_homePhone, m.mem_address1, m.mem_address2, m.mem_address3, m.mem_suburb, m.mem_state, m.mem_countryName, m.mem_postCode, m.mem_origin, m.mem_image, m.mem_partner, m.mem_numChildren, m.mem_childInformation, m.mem_interests,
				cou_id, cou_title,
				grp_id, grp_title,
				p.mem_title as partnerTitle, p.mem_firstName as partnerFirstName, p.mem_surname as partnerSurname, p.mem_salutation as partnerSalutation, p.mem_email as partnerEmail, p.mem_password as partnerPassword, p.mem_mobilePhone as partnerMobilePhone, p.mem_officePhone as partnerOfficePhone
			FROM member m
				LEFT OUTER JOIN country on m.mem_country = cou_id
				LEFT OUTER JOIN member_group on m.mem_id = mgr_member
				LEFT OUTER JOIN groups on mgr_group = grp_id
				LEFT OUTER JOIN member p ON m.mem_partner = p.mem_id
			WHERE m.mem_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.mem_id#" list="false" />
			GROUP BY m.mem_id, m.mem_title, m.mem_firstName, m.mem_surname, m.mem_salutation, m.mem_email, m.mem_company, m.mem_business, m.mem_website, m.mem_password, m.mem_mobilePhone, m.mem_officePhone, m.mem_homePhone, m.mem_address1, m.mem_address2, m.mem_address3, m.mem_suburb, m.mem_state, m.mem_countryName, m.mem_postCode, m.mem_origin, m.mem_image, m.mem_partner, m.mem_numChildren, m.mem_childInformation, m.mem_interests,
				cou_id, cou_title,
				grp_id, grp_title,
				p.mem_title, p.mem_firstName, p.mem_surname, p.mem_salutation, p.mem_email, p.mem_password, p.mem_mobilePhone, p.mem_officePhone
		</cfquery>

		<cfreturn getMember />

	</cffunction>

	<!--- Author: Rafe - Date: 10/8/2009 --->
	<cffunction name="getMemberMessages" output="false" access="public" returntype="query" hint="I return all the messages for a given member">

		<cfargument name="mem_id" type="numeric" default="0" required="true" />

		<cfset getMemberMessages = "" />

		<cfquery name="getMemberMessages" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT mem_id, mem_firstName, mem_surname,
				mes_id, mes_title, mes_body, mes_dateEntered
			FROM member
				INNER JOIN message on mem_id = mes_member
			WHERE mes_member = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.mem_id#" list="false" />
			ORDER BY mes_dateEntered DESC
		</cfquery>

		<cfreturn getMemberMessages />

	</cffunction>

	<!--- Author: Rafe - Date: 10/13/2009 --->
	<cffunction name="getMemberNewsletter" output="false" access="public" returntype="query" hint="I return all the members that have received a newsletter">

		<cfargument name="nsl_id" type="numeric" default="" required="true" />

		<cfset var getMemberNewsletter = "" />

		<cfquery name="getMemberNewsletter" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT mem_id, mem_firstName, mem_surname, mem_email,
				mnl_dateEntered
			FROM member
				INNER JOIN member_newsletter ON mem_id = mnl_member
			WHERE mnl_newsletter = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.nsl_id#" list="false" />
		</cfquery>

		<cfreturn getMemberNewsletter />

	</cffunction>

	<!--- Author: Rafe - Date: 11/4/2009 --->
	<cffunction name="getInterests" output="false" access="public" returntype="query" hint="I return the full set of interests in the db">

		<cfset var getInterests = "" />

		<cfquery name="getInterests" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT int_id, int_title
			FROM Interest
			ORDER BY int_title
		</cfquery>

		<cfreturn getInterests />

	</cffunction>

	<!--- Author: Rafe - Date: 11/4/2009 --->
	<cffunction name="getMemberInterests" output="false" access="public" returntype="query" hint="I return all the interests for a particular member">

		<cfargument name="mem_id" type="numeric" default="0" required="true" />

		<cfset var getMemberInterests = "" />

		<cfquery name="getMemberInterests" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT int_id, int_title
			FROM Member_Interest
				INNER JOIN Interest on mei_interest = int_id
			WHERE mei_member = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.mem_id#" list="false" />
		</cfquery>

		<cfreturn getMemberInterests />

	</cffunction>

	<!--- Author: Rafe - Date: 11/4/2009 --->
	<cffunction name="addNewInterest" output="false" access="public" returntype="numeric" hint="I add an interest into the database and return the ID of the new (or existing) interest">

		<cfargument name="newInterest" type="string" default="" required="true" />

		<cfset var interestID = "" />
		<cfset var addInterest = "" />
		<cfset var checkInterest = "" />

		<cfquery name="checkInterest" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT int_id, int_title
			FROM Interest
			WHERE int_title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.newInterest)#" list="false" />
		</cfquery>

		<cfif checkInterest.recordCount gte 1>

			<cfset interestID = checkInterest.int_id />

		<cfelse>

			<cfquery name="addInterest" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
				INSERT INTO Interest(
					int_title
				) VALUES (
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.newInterest)#" list="false" />
				)
				SELECT SCOPE_IDENTITY() AS newInterestID
			</cfquery>

			<cfset interestID = addInterest.newInterestID />

		</cfif>

		<cfreturn interestID />

	</cffunction>

	<!--- Author: Rafe - Date: 11/4/2009 --->
	<cffunction name="addNewGroup" output="false" access="public" returntype="numeric" hint="I add a group into the database and return the ID of the new (or existing) interest">

		<cfargument name="newGroup" type="string" default="" required="true" />

		<cfset var groupID = "" />
		<cfset var addGroup = "" />
		<cfset var checkGroup = "" />

		<cfquery name="checkGroup" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT grp_id, grp_title
			FROM Groups
			WHERE grp_title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.newGroup)#" list="false" />
		</cfquery>

		<cfif checkGroup.recordCount gte 1>

			<cfset groupID = checkGroup.grp_id />

		<cfelse>

			<cfquery name="addGroup" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
				INSERT INTO Groups(
					grp_title
				) VALUES (
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.newGroup)#" list="false" />
				)
				SELECT SCOPE_IDENTITY() AS newGroupID
			</cfquery>

			<cfset groupID = addGroup.newGroupID />

		</cfif>

		<cfreturn groupID />

	</cffunction>

	<!--- Author: rafe - Date: 11/25/2009 --->
	<cffunction name="getMemberGroups" output="false" access="public" returntype="query" hint="I return the groups this member is in">
		
		<cfargument name="mem_id" type="numeric" default="0" required="true" />
	
		<cfset var getMemberGroups = "" />
		
		<cfquery name="getMemberGroups" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT grp_id, grp_title
			FROM Member_Group
				INNER JOIN Groups ON mgr_group = grp_id
			WHERE mgr_member = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.mem_id#" list="false" />
		</cfquery>
		
		<cfreturn getMemberGroups />
		
	</cffunction>

	<!--- Author: rafe - Date: 1/26/2010 --->
	<cffunction name="approveMembers" output="false" access="public" returntype="any" hint="I approve members, or remove approval from members, based on a list of member id's">
		
		<cfargument name="approvedMembers" type="string" default="" required="true" />
		
		<cfset var updateMember = "" />
		<cfset var thisMemberID = "" />
		<cfset var removeGroupMembers = "" />
		<cfset var memberGroup = "" />
				
		<cfquery name="updateMember" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			UPDATE member SET
				mem_approved = 1
			WHERE mem_id IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.approvedMembers#" list="true" />)
		</cfquery>
		
		<cfquery name="updateMember" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			UPDATE member SET
				mem_approved = 0
			WHERE mem_id NOT IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.approvedMembers#" list="true" />)
		</cfquery>
		
		<cftransaction>
			<!--- update registration group --->
			<cfquery name="removeGroupMembers" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
				DELETE FROM member_group
				WHERE mgr_group = 13
			</cfquery>
			
			<cfloop list="#arguments.approvedMembers#" index="thisMemberID">
				<cfset memberGroup = memberGroupSave(mem_id=thisMemberID, grp_id="13") />
			</cfloop>
			
		</cftransaction>
		
		
	</cffunction>

	<!--- Author: rafe - Date: 1/31/2010 --->
	<cffunction name="getMemberPermissions" output="false" access="public" returntype="query" hint="I return a query with the given member's permissions to view categories">
		
		<cfargument name="mem_id" type="numeric" default="0" required="true" />
		
		<cfset var getMemberPermissions = "" />
		
		<cfquery name="getMemberPermissions" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT mca_category,
				cat_level
			FROM member_category
				INNER JOIN category on mca_category = cat_id
			WHERE mca_member = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.mem_id#" list="false" />
		</cfquery>	
		
		<cfreturn getMemberPermissions />
		
	</cffunction>

</cfcomponent>















