<?xml version="1.0" encoding="UTF-8"?>
<fusebox>
	<circuits>

		<circuit alias="home" path="/home/" parent=""/>
		<circuit alias="m_home" path="/home/model/" parent="home"/>
		<circuit alias="v_home" path="/home/view/" parent="home"/>

		<circuit alias="layout" path="/layout/" parent=""/>
		<circuit alias="m_layout" path="/layout/model/" parent="layout"/>
		<circuit alias="v_layout" path="/layout/view/" parent="layout"/>

		<circuit alias="login" path="/login/" parent=""/>
		<circuit alias="m_login" path="/login/model/" parent="layout"/>
		<circuit alias="v_login" path="/login/view/" parent="layout"/>

		<circuit alias="member" path="/member/" parent=""/>
		<circuit alias="m_member" path="/member/model/" parent="member"/>
		<circuit alias="v_member" path="/member/view/" parent="member"/>

		<circuit alias="shared" path="/shared/" parent=""/>
		<circuit alias="m_shared" path="/shared/model/" parent="shared"/>
		<circuit alias="v_shared" path="/shared/view/" parent="shared"/>

		<circuit alias="system" path="/system/" parent=""/>
		<circuit alias="m_system" path="/system/model/" parent="system"/>
		<circuit alias="v_system" path="/system/view/" parent="system"/>

		<circuit alias="villa" path="/villa/" parent=""/>
		<circuit alias="m_villa" path="/villa/model/" parent="villa"/>
		<circuit alias="v_villa" path="/villa/view/" parent="villa"/>

		<circuit alias="web" path="/web/" parent=""/>
		<circuit alias="m_web" path="/web/model/" parent="system"/>
		<circuit alias="v_web" path="/web/view/" parent="system"/>

	</circuits>

	<!--
	<classes>
		<class alias="MyClass" type="component" classpath="path.to.SomeCFC" constructor="init" />
	</classes>
	-->

	<parameters>
		<parameter name="defaultFuseaction" value="home.home" />
		<!-- you may want to change this to development-full-load mode: development-circuit-load production-->
		<parameter name="mode" value="production" />
		<!-- ignored in fusebox 5; can remove conditionalParse -->
		<parameter name="conditionalParse" value="false" />
		<!-- change this to something more secure: -->
		<parameter name="password" value="avhm" />
		<!-- <parameter name="strictMode" value="true" /> -->
		<parameter name="debug" value="false" />
		<!-- we use the core file error templates -->
		<parameter name="errortemplatesPath" value="/fusebox5/errortemplates/" />

		<parameter name="fuseactionVariable" value="fuseaction" />
		<parameter name="precedenceFormOrUrl" value="form" />
		<parameter name="scriptFileDelimiter" value="cfm" />
		<parameter name="maskedFileDelimiters" value="htm,cfm,cfml,php,php4,asp,aspx" />
		<parameter name="characterEncoding" value="utf-8" />
		<parameter name="strictMode" value="false" />
		<parameter name="allowImplicitCircuits" value="false" />

	</parameters>

	<globalfuseactions>
		<preprocess>
			<fuseaction action="login.validateUser" />
			<fuseaction action="login.checkFusePermissions" />
			<fuseaction action="login.permissionFunctions" />
		</preprocess>
		<postprocess>
			<fuseaction action="layout.choose" />
		</postprocess>
	</globalfuseactions>

	<plugins>
		<phase name="preProcess">
		</phase>
		<phase name="preFuseaction">
		</phase>
		<phase name="postFuseaction">
		</phase>
		<phase name="fuseactionException">
		</phase>
		<phase name="postProcess">
		</phase>
		<phase name="processError">
			<plugin name="SecurityException" template="SecurityException.cfm"/>
		</phase>
	</plugins>

</fusebox>