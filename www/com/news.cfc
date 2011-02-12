<cfcomponent hint="I am the news functions" output="false">

	<!--- Author: Rafe - Date: 10/5/2009 --->
	<cffunction name="displayNewsletterForm" output="false" access="public" returntype="string" hint="I display the newsletter form">

		<cfargument name="newsletterSuccess" type="boolean" default="0" required="false" />

		<cfset var newsForm = "" />

		<cfoutput>

			<cfsaveContent variable="newsForm">

<!--- 				<cfif yesNoFormat(arguments.newsletterSuccess)>

					<div>

						<p><strong>Your sign up for the newsletter was successful!</strong></p>

						<p><strong>Please contact us if you have any questions.</strong></p>

					</div>

				</cfif>		 --->			
					<div class="contact_left">
						
						<h2>NEWSLETTER SIGN-UP</h2>
						
						<p>
							Register with us today to receive our regular newsletter, featuring all the latest deals at Sentosa and other information.
	
						</p>
						
					</div>
					<div class="contact_right">
					
				
						<div class="formbox">
							<cfform action="index.cfm?fuseaction=news.newsletterForm" name="newsletterForm">
								<p><label>Title</label><select><option>Mr</option><option>Mrs</option><option>Ms</option><option>Dr</option></select></p>
								<p><label>First Name*</label><cfinput required="yes" message="Please provide your first name." name="mem_firstName" style="width: 300px;" type="text"></p>
								<p><label>Last Name*</label><cfinput required="yes" message="Please provide your last name." name="mem_surname" style="width: 300px;" type="text"></p>
								<p><label>Email Address*</label><cfinput validate="email" required="yes" message="Please enter a valid email address" name="mem_email" style="width: 300px;" type="text" /></p>
								<p class="btn_submit"><input type="submit" value="submit" name="save" /></p>
							</cfform>
						</div>
					</div>
						<!--- 
				<div align="center">

					<form name="frmFeedback" method="post" action="index.cfm?fuseaction=news.newsletterForm" style="font-size: 1.2em;">

						<table style="border: medium none ;" border="0" cellpadding="0" cellspacing="6" width="400">

							<tbody>

								<tr>
									<td align="left">
										<strong>Title*:</strong>

										<br>

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
									<td align="left"><strong>First Name*:</strong><br><input name="mem_firstName" style="width: 300px;" type="text"></td>
								</tr>

								<tr>
									<td align="left"><strong>Last Name*:</strong><br><input name="mem_surname" style="width: 300px;" type="text"></td>
								</tr>

								<tr>
									<td align="left"><strong>Email Address*:</strong><br><input name="mem_email" style="width: 300px;" type="text"></td>
								</tr>

								<tr>
									<td align="left"><input value="Submit" name="save" style="width: 100px;" type="submit">&nbsp;<input value="Clear Form" style="width: 100px;" type="reset"></td>
								</tr>

							</tbody>

						</table>

					</form>

				</div> --->

			</cfsaveContent>

			<cfreturn newsForm />

		</cfoutput>

	</cffunction>

	<!--- Author: Rafe - Date: 10/6/2009 --->
	<cffunction name="newsletterFormSave" output="false" access="public" returntype="any" hint="I save the results of submitting the newsletter sign up form">

		<cfset var addNewsletterSignup = "" />
		<cfset var memberID = "" />
		<cfset var addMemberGroup = "" />
		<cfset var newsletterSuccess = "0" />

		<cfset memberID = application.memberObj.memberSave(argumentCollection=arguments) />

		<cfset memberGroup = application.memberObj.memberGroupSave(mem_id=memberID, grp_id="1") />
<cfabort>
		<cfset newsletterSuccess = application.memberObj.memberGroupSave(mem_id=memberID, grp_id="1") />

		<cfreturn newsletterSuccess />

	</cffunction>

</cfcomponent>