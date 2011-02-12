<?xml version="1.0" encoding="UTF-8"?>
<circuit access="public">

	<fuseaction name="contactDetails">
	
		<if condition="isDefined('attributes.save')">
			<true>
				<invoke object="application.contactObj" methodcall="feedbackFormSave(argumentCollection=attributes)" returnVariable="attributes.feedbackFormSuccess" />
			</true>
		</if>
		
		<set name="attributes.feedbackFormSuccess" value="0" overwrite="no" />

		<invoke object="application.contactObj" methodcall="contactUs(attributes.feedbackFormSuccess)" returnVariable="content.mainContent" />

	</fuseaction>

	<fuseaction name="register">
	
		<if condition="isDefined('attributes.save')">
			<true>
				<invoke object="application.contactObj" methodcall="registerSave(argumentCollection=attributes)" returnVariable="attributes.registerSuccess" />
			</true>
		</if>
		
		<set name="attributes.registerSuccess" value="0" overwrite="no" />

		<invoke object="application.contactObj" methodcall="register(attributes.registerSuccess)" returnVariable="content.mainContent" />

	</fuseaction>

	<fuseaction name="login">
	
		<if condition="isDefined('attributes.save')">
			<true>
				<invoke object="application.contactObj" methodcall="loginCheck(argumentCollection=attributes)" returnVariable="attributes.loginSuccess" />
			</true>
		</if>
		
		<set name="attributes.loginSuccess" value="0" overwrite="no" />

		<invoke object="application.contactObj" methodcall="displayLoginForm(attributes.loginSuccess)" returnVariable="content.mainContent" />
	
	</fuseaction>

</circuit>
