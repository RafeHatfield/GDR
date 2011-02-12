<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE fusebox>

<fusebox>

	<circuits>

		<circuit alias="contact" path="contact/" parent="" />
		<circuit alias="m_contact" path="contact/model/" parent="contact" />
		<circuit alias="v_contact" path="contact/view/" parent="contact" />

		<circuit alias="content" path="content/" parent="" />
		<circuit alias="m_content" path="content/model/" parent="content" />
		<circuit alias="v_content" path="content/view/" parent="content" />

		<circuit alias="layout" path="layout/" parent="" />
		<circuit alias="m_layout" path="layout/model/" parent="layout" />
		<circuit alias="v_layout" path="layout/view/" parent="layout" />

		<circuit alias="products" path="products/" parent="" />
		<circuit alias="m_products" path="products/model/" parent="products" />
		<circuit alias="v_products" path="products/view/" parent="products" />

	</circuits>

	<parameters>
		<parameter name="defaultFuseaction" value="content.display" />
		<!-- you may want to change this to development-full-load mode: -->
		<parameter name="mode" value="production" />
		<parameter name="conditionalParse" value="true" />
		<!-- change this to something more secure: -->
		<parameter name="password" value="gdrFB" />
		<parameter name="strictMode" value="true" />
		<parameter name="debug" value="false" />
		<!-- we use the core file error templates -->
		<parameter name="errortemplatesPath" value="/fusebox5/errortemplates/" />
		<!--
			These are all default values that can be overridden:
		<parameter name="fuseactionVariable" value="fuseaction" />
		<parameter name="precedenceFormOrUrl" value="form" />
		<parameter name="scriptFileDelimiter" value="cfm" />
		<parameter name="maskedFileDelimiters" value="htm,cfm,cfml,php,php4,asp,aspx" />
		<parameter name="characterEncoding" value="utf-8" />
		<parameter name="strictMode" value="false" />
		<parameter name="allowImplicitCircuits" value="false" />
		-->
	</parameters>

	<globalfuseactions>
		<appinit>
		</appinit>
		<preprocess>
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
		</phase>
	</plugins>

</fusebox>
