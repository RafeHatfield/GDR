<cfcomponent hint="I am the contact settings function" output="false">

	<!--- Author: Rafe - Date: 10/7/2009 --->
	<cffunction name="displayFeedbackForm" output="false" access="public" returntype="string" hint="I display the feedback form">

		<cfargument name="feedbackSuccess" type="boolean" default="0" required="false" />

		<cfset var feedbackForm = "" />

		<cfoutput>

			<cfsaveContent variable="feedbackForm">

				<cfif yesNoFormat(arguments.feedbackSuccess)>

					<div>
						<p><strong>Thank you for contacting us.</strong></p>

						<p><strong>We will respond to your enqiry as soon as possible.</strong></p>
					</div>

				</cfif>

				<div align="center">

					<cfform name="feedbackForm" method="post" action="index.cfm?fuseaction=contact.feedbackForm" style="font-size: 1.2em;">

						<table style="border: medium none ;" border="0" cellpadding="0" cellspacing="6" width="400">

							<tbody>

								<tr>
									<td align="left"><strong>Title:</strong><br>
										<select name="mem_title" style="width: 300px;">
											<option value=""></option>
											<option value="Mr">Mr</option>
											<option value="Mrs">Mrs</option>
											<option value="Miss">Miss</option>
											<option value="Ms">Ms</option>
											<option value="Dr">Dr</option>
										</select>
									</td>
								</tr>

								<tr>
									<td align="left"><strong>First Name*:</strong><br><cfinput required="yes" message="Please provide your first name." name="mem_firstName" style="width: 300px;" type="text"></td>
								</tr>

								<tr>
									<td align="left"><strong>Last Name*:</strong><br><cfinput required="yes" message="Please provide your last name." name="mem_surname" style="width: 300px;" type="text"></td>
								</tr>

								<tr>
									<td align="left">
										<strong>Email Address*:</strong>
										<br>
										<cfinput validate="email" required="yes" message="Please enter a valid email address" name="mem_email" style="width: 300px;" type="text" />
									</td>
								</tr>

								<tr>
									<td align="left"><strong>Feedback:</strong><br><textarea name="mes_body" style="width: 300px; height: 100px;"></textarea></td>
								</tr>

								<tr>
									<td align="left"><cfinput value="Submit" name="save" style="width: 100px;" type="submit">&nbsp;<cfinput name="clear" value="Clear Form" style="width: 100px;" type="reset"></td>
								</tr>

							</tbody>

						</table>

					</cfform>

				</div>

			</cfsaveContent>

			<cfreturn feedbackForm />

		</cfoutput>

	</cffunction>

	<!--- Author: Rafe - Date: 10/7/2009 --->
	<cffunction name="feedbackFormSave" output="false" access="public" returntype="any" hint="I save the results of submitting the feedback form on the website">

		<cfset var memberID = "" />
		<cfset var addMemberGroup = "" />
		<cfset var memberGroup = "" />
		<cfset var feedbackSuccess = "0" />
		<cfset var messageID = "" />

		<!--- <cftry> --->

			<cfset memberID = application.memberObj.memberSave(argumentCollection=arguments) />

			<cfset memberGroup = application.memberObj.memberGroupSave(mem_id=memberID, grp_id="2") />

			<cfset messageID = messageSave(mem_id=memberID,mes_title="Website Feedback Form Submission",mes_body=arguments.mes_body) />

			<cfset feedbackEmail = messageEmail(mes_id=messageID,toEmail=application.feedbackEmail) />

			<cfset feedbackSuccess = "1" />

		<!--- 	<cfcatch>
			</cfcatch>

		</cftry> --->

		<cfreturn feedbackSuccess />

	</cffunction>

	<!--- Author: Rafe - Date: 10/7/2009 --->
	<cffunction name="messageSave" output="false" access="public" returntype="any" hint="I save the feedback message into the database">

		<cfargument name="mem_id" type="numeric" default="0" required="false" />
		<cfargument name="mes_title" type="string" default="" required="false" />
		<cfargument name="mes_body" type="string" default="" required="false" />

		<cfset var addMessage = "" />

		<cfquery name="addMessage" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			INSERT INTO Message (
				mes_title,
				mes_body,
				mes_member
			) VALUES (
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mes_title#" list="false" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mes_body#" list="false" />,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.mem_id#" list="false" />
			)
			SELECT SCOPE_IDENTITY() AS messageID
		</cfquery>

		<cfreturn addMessage.messageID />

	</cffunction>

	<!--- Author: Rafe - Date: 10/7/2009 --->
	<cffunction name="messageEmail" output="false" access="public" returntype="any" hint="I email the feedback message to the site feedback email address">

		<cfargument name="mes_id" type="numeric" default="" required="false" />
		<cfargument name="toEmail" type="string" default="" required="false" />

		<cfset var emailSuccess = "0" />
		<cfset var getMessage = "" />

		<cfif len(arguments.toEmail)>

			<cfquery name="getMessage" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
				SELECT mes_title, mes_body, mes_member,
					mem_firstName, mem_surname, mem_email
				FROM Message
					INNER JOIN Member on mes_member = mem_id
				WHERE mes_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.mes_id#" list="false" />
			</cfquery>

			<cfmail to="#arguments.toEmail#" bcc="#application.adminEmail#" from="#arguments.toEmail#" subject="#getMessage.mes_title#">
				The following member has sent sent an email:
				
				#mem_firstname# #mem_surname# - #mem_email#
				
				Message Details:				
				
				#mes_body#
			</cfmail>

		</cfif>

		<cfset emailSuccess = "1" />

		<cfreturn emailSuccess />

	</cffunction>

	<!--- Author: Rafe - Date: 11/9/2009 --->
	<cffunction name="displayFacilitiesForm" output="false" access="public" returntype="any" hint="">

		<cfargument name="facilitiesSuccess" type="boolean" default="0" required="false" />

		<cfset var facilitiesForm = "" />

		<cfoutput>

			<cfsaveContent variable="facilitiesForm">

				<cfif yesNoFormat(arguments.facilitiesSuccess)>

					<div>
						<p><strong>Thank you for contacting us.</strong></p>

						<p><strong>We will respond to your enqiry as soon as possible.</strong></p>
					</div>

				</cfif>

				<div align="center">

					<cfform name="feedbackForm" method="post" action="index.cfm?fuseaction=#arguments.fuseAction#" style="font-size: 1.2em;">

						<table style="border: medium none ;" border="0" cellpadding="0" cellspacing="6" width="400">

							<tbody>

								<tr>
									<td align="left"><strong>Title:</strong><br>
										<select name="mem_title" style="width: 300px;">
											<option value=""></option>
											<option value="Mr">Mr</option>
											<option value="Mrs">Mrs</option>
											<option value="Miss">Miss</option>
											<option value="Ms">Ms</option>
											<option value="Dr">Dr</option>
										</select>
									</td>
								</tr>

								<tr>
									<td align="left"><strong>First Name*:</strong><br><cfinput required="yes" message="Please provide your first name." name="mem_firstName" style="width: 300px;" type="text"></td>
								</tr>

								<tr>
									<td align="left"><strong>Last Name*:</strong><br><cfinput required="yes" message="Please provide your last name." name="mem_surname" style="width: 300px;" type="text"></td>
								</tr>

								<tr>
									<td align="left"><strong>Email Address*:</strong><br><cfinput validate="email" required="yes" message="Please enter a valid email address" name="mem_email" style="width: 300px;" type="text"></td>
								</tr>

								<tr>
									<td align="left"><strong>Requirements:</strong><br><textarea name="mes_body" style="width: 300px; height: 100px;"></textarea></td>
								</tr>

								<tr>
									<td align="left"><input value="Submit" name="save" style="width: 100px;" type="submit">&nbsp;<input value="Clear Form" style="width: 100px;" type="reset"></td>
								</tr>

							</tbody>

						</table>

					</cfform>

				</div>

			</cfsaveContent>

			<cfreturn facilitiesForm />

		</cfoutput>

	</cffunction>

	<!--- Author: Rafe - Date: 12/9/2009 --->
	<cffunction name="facilitiesFormSave" output="false" access="public" returntype="any" hint="">

		<cfset var memberID = "" />
		<cfset var addMemberGroup = "" />
		<cfset var memberGroup = "" />
		<cfset var feedbackSuccess = "0" />
		<cfset var messageID = "" />

		<!--- <cftry> --->

			<cfset memberID = application.memberObj.memberSave(argumentCollection=arguments) />

			<cfset memberGroup = application.memberObj.memberGroupSave(mem_id=memberID, grp_id="10") />

			<cfset messageID = messageSave(mem_id=memberID,mes_title="Website Event Enquiry Form Submission",mes_body=arguments.mes_body) />

			<cfset facilitiesEmail = messageEmail(mes_id=messageID,toEmail=application.feedbackEmail) />

			<cfset feedbackSuccess = "1" />

		<!--- 	<cfcatch>
			</cfcatch>

		</cftry> --->

		<cfreturn feedbackSuccess />

	</cffunction>
	
	<!--- Author: Rafe - Date: 12/9/2009 --->
	<cffunction name="newsletterFormSave" output="false" access="public" returntype="any" hint="I save the results of submitting the feedback form on the website">

		<cfset var memberID = "" />
		<cfset var addMemberGroup = "" />
		<cfset var memberGroup = "" />
		<cfset var feedbackSuccess = "0" />
		<cfset var messageID = "" />

		<!--- <cftry> --->

			<cfset memberID = application.memberObj.memberSave(argumentCollection=arguments) />

			<cfset memberGroup = application.memberObj.memberGroupSave(mem_id=memberID, grp_id="2") />

			<cfset messageID = messageSave(mem_id=memberID,mes_title="Newsletter Sign-up") />

			<cfset feedbackEmail = messageEmail(mes_id=messageID,toEmail=application.feedbackEmail) />

			<cfset feedbackSuccess = "1" />

		<!--- 	<cfcatch>
			</cfcatch>

		</cftry> --->

		<cfreturn feedbackSuccess />

	</cffunction>

	<cffunction name="contactUs" output="false" access="public" returntype="string" hint="I return the contact us form">

		<cfargument name="feedbackFormSuccess" type="boolean" default="0" required="false" />

		<cfset var contactUs = "" />
		<cfset var qContent = application.contentObj.getContent(fuseAction='contact.contactDetails') />

		<cfsaveContent variable="contactUs">

			<cfoutput>
				
				<div>

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
									<cfinput required="yes" message="Please provide your phone number." name="mem_officePhone" type="text">
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

		<cfreturn contactUs />

	</cffunction>

	<cffunction name="register" output="false" access="public" returntype="string" hint="I return the registration form">

		<cfargument name="registerSuccess" type="boolean" default="0" required="false" />

		<cfset var register = "" />
		<cfset var qContent = application.contentObj.getContent(fuseAction='contact.register') />

		<cfsaveContent variable="register">

			<cfoutput>
				
				<div>

					<div>
					
						<div class="register_box_left">
							
							<h2>#qContent.con_title#</h2>
							
							<cfif arguments.registerSuccess>
								<p>Thankyou for registering.  We will respond to your application as soon as possible.</p>
								<br /><br />
							<cfelse>
								#qContent.con_body#
							</cfif>
						
							<cfform action="index.cfm?fuseaction=contact.register" name="contentForm">   
								  
								<p>
									<label>first name</label>
									<cfinput required="yes" message="Please provide your first name." name="mem_firstName" type="text">
								</p>
								<p>
									<label>surname</label>
									<cfinput required="yes" message="Please provide your last name." name="mem_surname" type="text">
								</p>
								<p>
									<label>company</label>
									<cfinput required="yes" message="Please provide your company." name="mem_company" type="text">
								</p>
								<p>
									<label>email</label>
									<cfinput validate="email" required="yes" message="Please enter a valid email address" name="mem_email" type="text" />
								</p>
								<p>
									<label>website</label>
									<cfinput required="no" name="mem_website" type="text" />
								</p>
								<p>
									<label>phone</label>
									<cfinput required="yes" message="Please provide your phone number." name="mem_officePhone" type="text">
								</p>
								<p>
									<label>country</label>
									<cfinput required="yes" message="Please provide your country." name="mem_countryName" type="text">
								</p>  
 
								<div class="selectbox">
									<label>line of business</label>
									<div class="noindent">
		                                <p>
			                                <select name="mem_business" class="styled">
				                                <option selected="selected" value="retailer">retailer</option>
				                                <option value="wholesaler">wholesaler</option>
				                                <option value="trading company">trading company</option>
				                                <option value="other">other</option>
		                                	</select>
										</p>
		                            </div> 
								</div>                            
							
								<p>
									<label>password</label>
									<cfinput required="yes" message="Please provide a password." name="mem_password" type="password">
								</p>
								
                       			<p class="btn_register">
									<input type="submit" name="save" value="register" />
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
	<cffunction name="registerSave" output="false" access="public" returntype="any" hint="I save the member registration details to the database">
		
		<cfset registerSuccess = "0" />
		
		<cfset memberID = application.memberObj.memberSave(argumentCollection=arguments) />
		
		<cfquery name="getMemberName" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT mem_firstName, mem_surname
			FROM member
			WHERE mem_id = #memberID#
		</cfquery>
		
		<cfmail from="info@gdrasia.com" bcc="rafe@asianvhm.com" to="info@gdrasia.com" subject="New Website Registration">A new user - #getMemberName.mem_firstName# #getMemberName.mem_surname# - has registered on the site.  Please review this application and grant permissions.
		</cfmail>
		
		<cfset registerSuccess = "1" />
		
		<cfreturn registerSuccess />

	</cffunction>

	<cffunction name="displayLoginForm" output="false" access="public" returntype="string" hint="I return the login form">

		<cfargument name="loginSuccess" type="boolean" default="0" required="false" />

		<cfset var displayLoginForm = "" />
		<cfset var qContent = application.contentObj.getContent(fuseAction='contact.login') />

		<cfsaveContent variable="displayLoginForm">

			<cfoutput>
				
				<div>

					<div>
					
						<div class="register_box_left">
							
							<h2>#qContent.con_title#</h2>
							
							<cfif cookie.gdrUserID gt 0>
								
								<cfquery name="getThisMember" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
									SELECT mem_firstname, mem_surname
									FROM member
									WHERE mem_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#cookie.gdrUserID#" list="false" />
								</cfquery>
								
								<p>You are currently logged in as #getThisMember.mem_firstName# #getThisMember.mem_surname#</p>
								<br /><br />
								
							<cfelse>
								#qContent.con_body#
						
								<cfform action="index.cfm" name="contentForm">   <!--- ?fuseaction=contact.login --->
									
									<input type="hidden" name="fuseAction" value="contact.login" />
									  
									<p>
										<label>email</label>
										<cfinput required="yes" message="Please provide your email." name="mem_email" type="text">
									</p>
									<p>
										<label>password</label>
										<cfinput required="yes" message="Please provide a password." name="mem_password" type="password">
									</p>
									
	                       			<p class="btn_register">
										<input type="submit" name="save" value="login" />
									</p>
									
								</cfform>
							
							</cfif>
						<!--- 
							<cfform action="index.cfm" name="contentForm">   <!--- ?fuseaction=contact.login --->
								
								<input type="hidden" name="fuseAction" value="contact.login" />
								  
								<p>
									<label>email</label>
									<cfinput required="yes" message="Please provide your email." name="mem_email" type="text">
								</p>
								<p>
									<label>password</label>
									<cfinput required="yes" message="Please provide a password." name="mem_password" type="password">
								</p>
								
                       			<p class="btn_register">
									<input type="submit" name="save" value="login" />
								</p>
								
							</cfform>
							 --->
						</div>
						
              			<div class="register_box_right"><img src="#application.imagePath##qContent.img_name#" alt="#qContent.img_title#" width="347" height="560" /></div>
					
					</div>
					
				</div>
				
			</cfoutput>

		</cfsaveContent>

		<cfreturn displayLoginForm />

	</cffunction>

	<!--- Author: rafe - Date: 1/17/2010 --->
	<cffunction name="loginCheck" output="false" access="public" returntype="any" hint="">
		
		<cfset var checkLogin = "" />
		<cfset var loginSuccess = "0" />
		
		<cfquery name="checkLogin" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT mem_id
			FROM member
			WHERE mem_email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mem_email#" list="false" />
				AND mem_password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mem_password#" list="false" />
				AND mem_approved = <cfqueryparam cfsqltype="cf_sql_bit" value="1" list="false" />
		</cfquery>
		
		<cfif checkLogin.recordCount>
			<cfcookie name="gdrUserID" value="#checkLogin.mem_id#" />
			<cfset loginSuccess = 1 />
		<cfelse>
			<cfset loginSuccess = 0 />
		</cfif>
		
		<cfreturn loginSuccess />
		
	</cffunction>
	
	<!--- Author: rafe - Date: 1/23/2010 --->
	<cffunction name="sendProductContact" output="false" access="public" returntype="any" hint="I send the contact email along with the products the member is interested in">
		
		<cfset var qMember = application.memberObj.getMember(mem_id=arguments.mem_id) />
		<cfset var qProducts = application.contentObj.getProducts(productList=arguments.prd_id) />

		<cfmail to="#application.feedbackEmail#" from="#application.feedbackEmail#" bcc="#application.adminEmail#" subject="Website Member Saved Items Enquiry - #qMember.mem_firstName# #qMember.mem_surname#" type="html">The member #qMember.mem_firstName# #qMember.mem_surname#, email address #qMember.mem_email# enquired about the following products - 
<cfloop query="qProducts">
	<div>
		<a href="http://www.gdrasia.com/index.cfm?fuseaction=products.view&prd_id=#prd_id#"><img src="http://www.gdrasia.com/assets/images/upload/products/#replaceNoCase(prd_code," ","","all")#_120.jpg" /> <br />
		#prd_code# - #prd_title#</a>
	</div>
</cfloop>
<br /><br />
Message:
#arguments.message#
		</cfmail>
		
	</cffunction>
	
	
</cfcomponent>















