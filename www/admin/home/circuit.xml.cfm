<?xml version="1.0" encoding="UTF-8"?>
<circuit access="public">
	
		
		<fuseaction name="home" permissions="1,2,3,4,5|">
			<set name="attributes.displayMode" overWrite="yes" value="Nav"/>

<set name="request.pageTitle" value="Home"/>

<do action="v_home.home" append="yes" contentVariable="content.mainContent"/>
		</fuseaction>
	
		
		<fuseaction name="villaDetails" permissions="1,2,3,4,5|">
			<xfa name="saveVillaDetails" value="home.villaDetails"/>
			
			<if condition="isDefined('attributes.save')">
				<true>
					<invoke methodcall="villaDetailsSave(argumentCollection=attributes)" object="application.villaObj"/>
				</true>
			</if>
			 
			<invoke methodcall="getVillaDetails()" object="application.villaObj" returnVariable="qVillaDetails"/>
			
			<if condition="qVillaDetails.recordCount gte 1">
			
				<true>
					<set name="attributes.vil_title" value="#qVillaDetails.vil_title#"/>
					<set name="attributes.vil_description" value="#qVillaDetails.vil_description#"/>
					<set name="attributes.vil_address" value="#qVillaDetails.vil_address#"/>
					<set name="attributes.vil_phone" value="#qVillaDetails.vil_phone#"/>
					<set name="attributes.vil_email" value="#qVillaDetails.vil_email#"/>
					<set name="attributes.vil_otherContact" value="#qVillaDetails.vil_otherContact#"/>
					<set name="attributes.vil_fax" value="#qVillaDetails.vil_fax#"/>
				</true>
				
				<false>
					<set name="attributes.vil_title" value=""/>
					<set name="attributes.vil_description" value=""/>
					<set name="attributes.vil_address" value=""/>
					<set name="attributes.vil_phone" value=""/>
					<set name="attributes.vil_email" value=""/>
					<set name="attributes.vil_otherContact" value=""/>
					<set name="attributes.vil_fax" value=""/>
				</false>
				
			</if>
			
			<do action="v_home.villaDetailsForm" append="yes" contentVariable="content.mainContent"/>
		</fuseaction>
	
	</circuit>
