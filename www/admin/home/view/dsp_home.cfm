<div align="center">

	<cfset quoteMeThis = randRange(1,12) />

	<cfswitch expression="#quoteMeThis#">

		<cfcase value="1">
			Happiness is just not enough for me. I demand Euphoria." <br />- Calvin
		</cfcase>

		<cfcase value="2">
			"Anything is possible if you don't know what you're talking about."<br />
			- Green's Law of Debate
		</cfcase>

		<cfcase value="3">
			"Clothes make the man. Naked people have little or no influence on society."<br />
			- Mark Twain
		</cfcase>

		<cfcase value="4">
			"I have not failed. I've just found 10,000 ways that won't work."<br />
			- Thomas A. Edison
		</cfcase>

		<cfcase value="5">
			"The most exciting phrase to hear in science, the one that heralds the most discoveries, is not 'Eureka!' (I found it!) but 'That's funny...'"<br />
			- Isaac Asimov
		</cfcase>

		<cfcase value="6">
			"Never attempt to teach a pig to sing; it wastes your time and annoys the pig."<br />
			- Lazarus Long
		</cfcase>

		<cfcase value="7">
			"Debugging is twice as hard as writing the code in the first place. Therefore, if you write the code as cleverly as possible, you are, by definition, not smart enough to debug it."<br />
			- Brian W. Kernighan
		</cfcase>

		<cfcase value="8">
			"There is no such thing as bad weather, only inappropriate clothing."<br />
			- Sir Rannulph Fiennes
		</cfcase>

		<cfcase value="9">
			"Beauty is in the eye of the beholder, and it may be necessary from time to time to give a stupid or misinformed beholder a black eye."<br />
			- Miss Piggy
		</cfcase>

		<cfcase value="10">
			"Perfection is achieved, not when there is nothing more to add, but when there is nothing left to take away."<br />
			- Antoine de Saint-Exupery
		</cfcase>

		<cfcase value="11">
			"Time you enjoyed wasting is not wasted time."<br />
			- T.S. Elliot
		</cfcase>

		<cfcase value="12">
			"OK brain, I don't like you and you don't like me, so let's just do this so I can get back to killing you with beer!"<br />
			- Homer J. Simpson
		</cfcase>

	</cfswitch>

</div>
<!---
<cfparam name="url.cid" default="0" />

<cfif url.cid is 1>
	<cfquery name="getNewContacts" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
		SELECT *
		FROM tmpFastBooking
	</cfquery>

	<cfoutput query="getNewContacts">

		<cfif len(trim(country))>
			<cfset countryID = application.systemObj.countrySave(trim(country)) />
		<cfelse>
			<cfset countryID = 0 />
		</cfif>

		<cfset memberID = application.memberObj.memberSave(
			mem_title = trim(title),
			mem_firstName = trim(firstName),
			mem_surname = trim(lastName),
			mem_email = trim(email),
			mem_salutation = trim(salutation),
			mem_mobilePhone = trim(mobilePhone),
			mem_fax = trim(fax),
			mem_homePhone = trim(homePhone),
			mem_address1 = "#trim(streetNumber)# #trim(streetName)#",
			mem_suburb = trim(city),
			mem_state = trim(state),
			cou_id = countryID,
			mem_postCode = trim(postCode),
			mem_origin = 'Initial Sentosa DB Import'
			) />

		<cfset memberGroup = application.memberObj.memberGroupSave(mem_id=memberID,grp_id="3") />

		#memberID# - #firstName# #lastName# successfully added.<br />

	</cfoutput>

<cfelseif url.cid is 2>

	<cfquery name="getNewContacts" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
		SELECT *
		FROM tmpVIPParty
	</cfquery>

	<cfoutput query="getNewContacts">
		<cfif len(trim(country))>
			<cfset countryID = application.systemObj.countrySave(trim(country)) />
		<cfelse>
			<cfset countryID = 0 />
		</cfif>

		<cfset memberID = application.memberObj.memberSave(
			mem_title = trim(title),
			mem_firstName = trim(firstName),
			mem_surname = trim(lastName),
			mem_email = trim(email),
			mem_salutation = trim(salutation),
			mem_mobilePhone = trim(mobilePhone),
			mem_officePhone = trim(officePhone),
			mem_homePhone = trim(homePhone),
			mem_address1 = "#trim(streetNumber)# #trim(streetName)#",
			mem_suburb = trim(suburb),
			mem_state = trim(state),
			cou_id = countryID,
			mem_postCode = trim(postCode),
			mem_origin = 'Initial Sentosa DB Import'
			) />

		<cfset memberGroup = application.memberObj.memberGroupSave(mem_id=memberID,grp_id="4") />

		#memberID# - #firstName# #lastName# successfully added.<br />

	</cfoutput>

<cfelseif url.cid is 3>

	<cfquery name="getNewContacts" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
		SELECT *
		FROM tmpVillaOwners
	</cfquery>

	<cfoutput query="getNewContacts">
		<cfif len(trim(country))>
			<cfset countryID = application.systemObj.countrySave(trim(country)) />
		<cfelse>
			<cfset countryID = 0 />
		</cfif>

		<cfset memberID = application.memberObj.memberSave(
			mem_title = trim(title),
			mem_firstName = trim(firstName),
			mem_surname = trim(lastName),
			mem_email = trim(email),
			mem_salutation = trim(salutation),
			mem_mobilePhone = trim(mobilePhone),
			mem_officePhone = trim(officePhone),
			mem_homePhone = trim(homePhone),
			mem_address1 = "#trim(streetNumber)# #trim(streetName)#",
			mem_suburb = trim(suburb),
			mem_state = trim(stateProvince),
			cou_id = countryID,
			mem_postCode = trim(postCode),
			mem_origin = 'Initial Sentosa DB Import'
			) />

		<cfset memberGroup = application.memberObj.memberGroupSave(mem_id=memberID,grp_id="5") />

		#memberID# - #firstName# #lastName# successfully added.<br />

	</cfoutput>

<cfelseif url.cid is 4>

	<cfquery name="getNewContacts" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
		SELECT *
		FROM tmpSpaandGym
	</cfquery>

	<cfoutput query="getNewContacts">
		<cfif len(trim(country))>
			<cfset countryID = application.systemObj.countrySave(trim(country)) />
		<cfelse>
			<cfset countryID = 0 />
		</cfif>

		<cfset memberID = application.memberObj.memberSave(
			mem_title = trim(title),
			mem_firstName = trim(firstName),
			mem_surname = trim(lastName),
			mem_email = trim(email),
			mem_salutation = trim(salutation),
			mem_mobilePhone = trim(mobilePhone),
			mem_officePhone = trim(officePhone),
			mem_homePhone = trim(homePhone),
			mem_address1 = "#trim(streetNumber)# #trim(streetName)#",
			mem_suburb = trim(suburb),
			mem_state = trim(stateProvince),
			cou_id = countryID,
			mem_postCode = trim(postCode),
			mem_origin = 'Initial Sentosa DB Import'
			) />

		<cfset memberGroup = application.memberObj.memberGroupSave(mem_id=memberID,grp_id="6") />

		#memberID# - #firstName# #lastName# successfully added.<br />

	</cfoutput>

<cfelseif url.cid is 5>


	<cfquery name="getNewContacts" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
		SELECT *
		FROM tmpSaxonContacts
	</cfquery>

	<cfoutput query="getNewContacts">
		<cfif len(trim(country))>
			<cfset countryID = application.systemObj.countrySave(trim(country)) />
		<cfelse>
			<cfset countryID = 0 />
		</cfif>

		<cfset memberID = application.memberObj.memberSave(
			mem_title = trim(title),
			mem_firstName = trim(firstName),
			mem_surname = trim(lastName),
			mem_email = trim(email),
			mem_salutation = trim(salutation),
			mem_mobilePhone = trim(mobilePhone),
			mem_officePhone = trim(officePhone),
			mem_homePhone = trim(homePhone),
			mem_address1 = "#trim(streetNumber)# #trim(streetName)#",
			mem_suburb = trim(suburb),
			mem_state = trim(stateProvince),
			cou_id = countryID,
			mem_postCode = trim(postCode),
			mem_origin = 'Initial Sentosa DB Import'
			) />

		<cfset memberGroup = application.memberObj.memberGroupSave(mem_id=memberID,grp_id="7") />

		#memberID# - #firstName# #lastName# successfully added.<br />

	</cfoutput>

</cfif>
 --->


































