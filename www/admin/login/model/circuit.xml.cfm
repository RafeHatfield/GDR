<circuit access="public">
	<prefuseaction callsuper="true">
	</prefuseaction>
	
	<fuseaction name="checkFusePermissions">
		<include template="act_checkFusePermissions" />
	</fuseaction>
	
	<fuseaction name="checkUser">
		<include template="qry_checkUser"/>
	</fuseaction>
	
	<fuseaction name="logOut">
		<include template="act_logOut" />
	</fuseaction>
	
	<fuseaction name="permissionFunctions">
		<include template="act_permissionFunctions" />
	</fuseaction>
	
	<fuseaction name="setLoginDetails">
		<include template="act_setLoginDetails" />
	</fuseaction>
	
	<fuseaction name="validateUser">
		<include template="act_validateUser" />
	</fuseaction>
	
	<postfuseaction>
	</postfuseaction>
</circuit>