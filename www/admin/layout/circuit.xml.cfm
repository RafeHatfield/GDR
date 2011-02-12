<?xml version="1.0" encoding="UTF-8"?>
<circuit access="internal">

	<fuseaction name="choose">

		<set name="attributes.displayMode" value="nav" overwrite="no" />

		<if condition="attributes.displayMode eq 'nav'">
			<true>
				<do action="m_layout.getMenu" />
				<do action="v_layout.headerBar" contentVariable="content.headerBar" append='true' />
				<do action="v_layout.footerBar" contentVariable="content.footerBar" append='true' />
				<do action="v_layout.mainMenu" contentVariable="content.mainMenu" append='true' />
				<include template="view/dsp_nav" />
			</true>
		</if>

		<if condition="attributes.displayMode eq 'newsletter'">
			<true>
				<do action="m_layout.getMenu" />
				<do action="v_layout.headerBar" contentVariable="content.headerBar" append='true' />
				<do action="v_layout.newsletterFooter" contentVariable="content.newsletterFooter" append='true' />
				<include template="view/dsp_newsletter" />
			</true>
		</if>

		<if condition="attributes.displayMode eq 'noNav'">
			<true>
				<do action="v_layout.headerBar" contentVariable="content.headerBar" append='true' />
				<do action="v_layout.footerBar" contentVariable="content.footerBar" append='true' />
				<include template="view/dsp_noNav" />
			</true>
		</if>

		<if condition="attributes.displayMode eq 'print'">
			<true>
				<include template="view/dsp_blank.cfm" />
			</true>
		</if>

		<if condition="attributes.displayMode eq 'docType'">
			<true>
				<set name="attributes.docType" value="application/vnd.ms-excel" overwrite="false" />
				<set name="attributes.fileName" value="index.xls" overwrite="false" />
				<include template="view/dsp_docType" />
			</true>
		</if>
	</fuseaction>
</circuit>