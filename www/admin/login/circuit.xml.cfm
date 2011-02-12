<circuit access="public">
	<prefuseaction callsuper="true">
	</prefuseaction>

	<fuseaction name="form">
		<set name="attributes.displaymode" value="nonav" />
		<xfa name="dologin" value="login.doLogin" />
		<do action="v_login.showLoginForm" contentvariable="content.maincontent" />
	</fuseaction>

	<fuseaction name="doLogin">

		<do action="m_login.checkUser" />

		<if condition="checkUser.recordcount is 1">
			<true>
				<do action="m_login.setLoginDetails" />
				<relocate url="#myself#home.home" addtoken="false" type="client" />
			</true>
			<false>
				<set name="message" value="Incorrect Username or Password." />
				<relocate url="#myself#login.form&amp;message=#message#" addtoken="false" type="client" />
			</false>
		</if>

	</fuseaction>

	<fuseaction name="doLogout">
		<do action="m_login.logOut" />
		<relocate url="#myself#home.home" addtoken="false" type="client" />
	</fuseaction>

	<fuseaction name="permissionFunctions">
		<do action="m_login.permissionFunctions" />
	</fuseaction>

	<fuseaction name="validateUser">
		<do action="m_login.validateUser" />

		<if condition="validateUser.recordCount gt 0">
			<false>
				<do action="login.form" />
			</false>
		</if>
	</fuseaction>

	<fuseaction name="checkFusePermissions">
		<do action="m_login.checkFusePermissions" />
	</fuseaction>

	<postfuseaction>
	</postfuseaction>
</circuit>