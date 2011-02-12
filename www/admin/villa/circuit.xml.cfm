<?xml version="1.0" encoding="UTF-8"?>
<circuit access="public">
	
		
		<fuseaction name="promotionsList" permissions="1,2,3,4,5|">
			<xfa name="savePromotion" value="villa.promotionsList"/>
			<xfa name="editPromotion" value="villa.promotionForm"/>
			
			<set name="attributes.prm_id" overwrite="no" value="0"/>
			
			<if condition="isDefined('attributes.save')">
				<true>
					<invoke methodcall="promotionSave(argumentCollection=attributes)" object="application.villaObj"/>
				</true>
			</if>
			 
			<invoke methodcall="getPromotion(prm_id=attributes.prm_id)" object="application.villaObj" returnVariable="qPromotion"/>
			 
			<if condition="qPromotion.recordCount gte 1">
				<true>
					<set name="attributes.prm_title" value="#qPromotion.prm_title#"/>
					<set name="attributes.prm_body" value="#qPromotion.prm_body#"/>
					<set name="attributes.prm_active" value="#qPromotion.prm_active#"/>
				</true>
				
				<false>
					<set name="attributes.prm_title" value=""/>
					<set name="attributes.prm_body" value=""/>
					<set name="attributes.prm_active" value=""/>
				</false>
				
			</if> 
			 
			<do action="v_villa.promotionForm" append="yes" contentVariable="content.mainContent"/> 
			 
			<invoke methodcall="getPromotionsAdmin()" object="application.villaObj" returnVariable="qPromotions"/>
			
			<do action="v_villa.promotionsList" append="yes" contentVariable="content.mainContent"/>
		</fuseaction>
	
	</circuit>
