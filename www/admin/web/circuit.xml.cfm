<?xml version="1.0" encoding="UTF-8"?>
<circuit access="public">
	
		
		<fuseaction name="categoryForm" permissions="1,2,3,4,5|">
			<set name="attributes.cat_id" overwrite="false" value="0"/>
			
			<if condition="isDefined('attributes.save')">
				<true>
					<invoke methodcall="categorySave(argumentCollection=attributes)" object="application.contentObj"/>
					<relocate addtoken="false" type="client" url="#myself#web.categoryList"/>
				</true>
			</if>
			 
			<invoke methodcall="displayCategoryForm(cat_id=attributes.cat_id)" object="application.contentObj" returnVariable="content.mainContent"/>
		</fuseaction>
	
		
		<fuseaction name="categoryList" permissions="1,2,3,4,5|">
			<set name="attributes.cat_level" overwrite="no" value="0"/>
			
			<set name="categorySearchForm" overwrite="yes" value=""/>
			<set name="categoryOrderForm" overwrite="yes" value=""/>
			
			<invoke methodcall="categorySearchForm(attributes.cat_level)" object="application.contentObj" returnVariable="categorySearchForm"/>
			
			<if condition="isDefined('attributes.save')">
				<true>
					<invoke methodCall="categoryOrderSave(argumentCollection=attributes)" object="application.contentObj"/>
				</true>
			</if>
			
			<if condition="isDefined('attributes.search')">
				<true>
					<invoke methodcall="categoryOrderListForm(attributes.cat_level)" object="application.contentObj" returnVariable="categoryOrderForm"/>
				</true>
			</if>
			 
			<set name="content.mainContent" overwrite="yes" value="#categorySearchForm##categoryOrderForm#"/>
		</fuseaction>
	
		
		<fuseaction name="contentForm" permissions="1,2,3,4,5|">
			<xfa name="saveContent" value="web.contentForm"/>
			
			<set name="attributes.con_id" overwrite="false" value="0"/>
			
			<if condition="isDefined('attributes.save')">
				<true>
					<invoke methodcall="contentSave(argumentCollection=attributes)" object="application.contentObj"/>
					<relocate addtoken="false" type="client" url="#myself#web.contentList"/>
				</true>
			</if>
			 
			<invoke methodcall="getContent(con_id=attributes.con_id)" object="application.contentObj" returnVariable="qContent"/>
			<invoke methodcall="getContentParents()" object="application.contentObj" returnVariable="qContentParents"/>
			<invoke methodcall="getContentImages(con_id=attributes.con_id)" object="application.imageObj" returnVariable="qOtherContentImages"/>
			
			<if condition="(#application.systemSettings.sys_approval# is 1 AND #listFind('1,2',cookie.prf_id)#) OR #application.systemSettings.sys_approval# is 0">
				<true>
					<set name="NewContentApproveState" value="1"/>
				</true>
				<false>
					<set name="NewContentApproveState" value="0"/>
				</false>
			</if>
			
			<if condition="qContent.recordCount gte 1">
			
				<true>
					<set name="attributes.con_menuTitle" value="#qContent.con_menuTitle#"/>
					<set name="attributes.con_title" value="#qContent.con_title#"/>
					<set name="attributes.con_intro" value="#qContent.con_intro#"/>
					<set name="attributes.con_body" value="#qContent.con_body#"/>
					<set name="attributes.con_isMenu" value="#qContent.con_isMenu#"/>
					<set name="attributes.con_menuArea" value="#qContent.con_menuArea#"/>
					<set name="attributes.con_menuOrder" value="#qContent.con_menuOrder#"/>
					<set name="attributes.con_parentID" value="#qContent.con_parentID#"/>
					<set name="attributes.con_active" value="#qContent.con_active#"/>
					<set name="attributes.con_type" value="#qContent.con_type#"/>
					<set name="attributes.con_approved" value="#qContent.con_approved#"/>
					<set name="attributes.con_link" value="#qContent.con_link#"/>
					<set name="attributes.con_metaDescription" value="#qContent.con_metaDescription#"/>
					<set name="attributes.con_metaKeywords" value="#qContent.con_metaKeywords#"/>
					<set name="attributes.img_id" value="#qContent.img_id#"/>
					<set name="attributes.img_name" value="#qContent.img_name#"/>
					<set name="attributes.img_title" value="#qContent.img_title#"/>
					<set name="attributes.img_altText" value="#qContent.img_altText#"/>
				</true>
				
				<false>
					<set name="attributes.con_menuTitle" value=""/>
					<set name="attributes.con_title" value=""/>
					<set name="attributes.con_intro" value=""/>
					<set name="attributes.con_body" value=""/>
					<set name="attributes.con_isMenu" value="0"/>
					<set name="attributes.con_menuArea" value="0"/>
					<set name="attributes.con_menuOrder" value="1"/>
					<set name="attributes.con_parentID" value="0"/>
					<set name="attributes.con_active" value="1"/>
					<set name="attributes.con_type" value="Content"/>
					<set name="attributes.con_approved" value="#NewContentApproveState#"/>
					<set name="attributes.con_link" value=""/>
					<set name="attributes.con_metaDescription" value=""/>
					<set name="attributes.con_metaKeywords" value=""/>
					<set name="attributes.img_id" value=""/>
					<set name="attributes.img_name" value=""/>
					<set name="attributes.img_title" value=""/>
					<set name="attributes.img_altText" value=""/>
				</false>
				
			</if>
			
			<invoke methodcall="getMenuAreas()" object="application.menuObj" returnVariable="qMenuAreas"/>
			<invoke methodcall="getGloryBoxes()" object="application.contentObj" returnVariable="qGloryBoxes"/>
			
			<do action="v_web.contentForm" append="yes" contentVariable="content.mainContent"/>
		</fuseaction>
	
		
		<fuseaction name="contentList" permissions="1,2,3,4,5|">
			<xfa name="editContent" value="web.contentForm"/>
			<xfa name="searchContent" value="web.contentList"/>
			
			<set name="attributes.mna_id" overwrite="false" value="0"/>
			<set name="attributes.searchContentType" overwrite="false" value="Content"/>
			<set name="attributes.searchMenuArea" overwrite="false" value="0"/>
			<set name="attributes.fastFind" overwrite="false" value=""/>
			
			<invoke methodcall="getMenuAreas()" object="application.menuObj" returnVariable="qMenuAreas"/>
			  
			<invoke methodcall="getAllContent(mna_id=attributes.mna_id,con_type=attributes.searchContentType,menuArea=attributes.searchMenuArea,fastFind=attributes.fastFind)" object="application.contentObj" returnVariable="qAllContent"/>
			
			<do action="v_web.contentSearchForm" append="yes" contentVariable="content.mainContent"/>
			
			<do action="v_web.contentList" append="yes" contentVariable="content.mainContent"/>
		</fuseaction>
	
		
		<fuseaction name="ctaList" permissions="1,2,3,4,5|">
			<xfa name="saveCTA" value="web.ctaList"/>
			<xfa name="editCTA" value="web.ctaList"/>
			
			<set name="attributes.cta_id" overwrite="no" value="0"/>
			
			<if condition="isDefined('attributes.save')">
				<true>
					<invoke methodcall="ctaSave(argumentCollection=attributes)" object="application.ctaObj"/>
				</true>
			</if>
			 
			<invoke methodcall="getCTA(cta_id=attributes.cta_id)" object="application.ctaObj" returnVariable="qCTA"/>
			 
			<if condition="qCTA.recordCount gte 1">
				<true>
					<set name="attributes.cta_title" value="#qCTA.cta_title#"/>
					<set name="attributes.cta_image" value="#qCTA.cta_image#"/>
					<set name="attributes.cta_link" value="#qCTA.cta_link#"/>
					<set name="attributes.cta_active" value="#qCTA.cta_active#"/>
					<set name="attributes.cta_random" value="#qCTA.cta_random#"/>
				</true>
				
				<false>
					<set name="attributes.cta_title" value=""/>
					<set name="attributes.cta_image" value=""/>
					<set name="attributes.cta_link" value=""/>
					<set name="attributes.cta_active" value="0"/>
					<set name="attributes.cta_random" value="0"/>
				</false>
				
			</if> 
			 
			<do action="v_web.ctaForm" append="yes" contentVariable="content.mainContent"/> 
			 
			<invoke methodcall="getCTAs()" object="application.ctaObj" returnVariable="qCTAs"/>
			
			<do action="v_web.ctaList" append="yes" contentVariable="content.mainContent"/>
		</fuseaction>
	
		
		<fuseaction name="galleryImagesForm" permissions="1,2,3,4,5|">
			<xfa name="saveGalleryImages" value="web.galleryImagesForm"/>
			
			<set name="attributes.gal_id" overwrite="no" value="0"/>
			
			<if condition="isDefined('attributes.save')">
				<true>
					<invoke methodcall="galleryImagesSave(argumentCollection=attributes)" object="application.imageObj"/>
				</true>
			</if>
			 
			<invoke methodcall="getGalleryImages(gal_id=attributes.gal_id)" object="application.imageObj" returnVariable="qGalleryImages"/>
			
			<do action="v_web.galleryImagesForm" append="yes" contentVariable="content.mainContent"/> 
		</fuseaction>
	
		
		<fuseaction name="galleryList" permissions="1,2,3,4,5|">
			<xfa name="saveGallery" value="web.galleryList"/>
			<xfa name="editGallery" value="web.galleryList"/>
			<xfa name="editGalleryImages" value="web.galleryImagesForm"/>
			
			<set name="attributes.gal_id" overwrite="no" value="0"/>
			
			<if condition="isDefined('attributes.save')">
				<true>
					<invoke methodcall="gallerySave(argumentCollection=attributes)" object="application.imageObj"/>
				</true>
			</if>
			 
			<invoke methodcall="getGallery(gal_id=attributes.gal_id)" object="application.imageObj" returnVariable="qGallery"/>
			 
			<if condition="qGallery.recordCount gte 1">
			
				<true>
					<set name="attributes.gal_title" value="#qGallery.gal_title#"/>
					<set name="attributes.gal_image" value="#qGallery.gal_image#"/>
					<set name="attributes.gal_active" value="#qGallery.gal_active#"/>
				</true>
				
				<false>
					<set name="attributes.gal_title" value=""/>
					<set name="attributes.gal_image" value=""/>
					<set name="attributes.gal_active" value="1"/>
				</false>
				
			</if> 
			 
			<do action="v_web.galleryForm" append="yes" contentVariable="content.mainContent"/> 
			 
			<invoke methodcall="getGalleries()" object="application.imageObj" returnVariable="qGalleries"/>
			
			<do action="v_web.galleryList" append="yes" contentVariable="content.mainContent"/>
		</fuseaction>
	
		
		<fuseaction name="gloryBoxList" permissions="1,2,3,4,5|">
			<xfa name="saveGloryBox" value="web.gloryBoxList"/>
			<xfa name="editGloryBox" value="web.gloryBoxList"/>
			
			<set name="attributes.gbx_id" overwrite="false" value="0"/>
			
			<if condition="isDefined('attributes.save')">
				<true>
					<invoke methodcall="gloryBoxSave(argumentCollection=attributes)" object="application.contentObj"/>
				</true>
			</if>
			 
			<invoke methodcall="getGloryBox(attributes.gbx_id)" object="application.contentObj" returnVariable="qGloryBox"/>
			
			<if condition="qGloryBox.recordCount gte 1">
				<true>
					<set name="attributes.gbx_title" value="#qGloryBox.gbx_title#"/>
					<set name="attributes.gbx_name" value="#qGloryBox.gbx_name#"/>
					<set name="attributes.gbx_type" value="#qGloryBox.gbx_type#"/>
					<set name="attributes.gbx_active" value="#qGloryBox.gbx_active#"/>
				</true>
				<false>
					<set name="attributes.gbx_title" value=""/>
					<set name="attributes.gbx_name" value=""/>
					<set name="attributes.gbx_type" value=""/>
					<set name="attributes.gbx_active" value="1"/>
				</false>
			</if>
			
			<do action="v_web.gloryBoxForm" append="yes" contentVariable="content.mainContent"/>
			
			<invoke methodcall="getGloryBoxes(gbx_active=0)" object="application.contentObj" returnVariable="qGloryBoxes"/>
			
			<do action="v_web.gloryBoxList" append="yes" contentVariable="content.mainContent"/>
		</fuseaction>
	
		
		<fuseaction name="homePageImages" permissions="1,2,3,4,5|">
			<if condition="isDefined('attributes.save')">
				<true>
					<invoke methodcall="homePageImagesSave(argumentCollection=attributes)" object="application.imageObj"/>
				</true>
			</if>
			 
			<invoke methodcall="homePageImagesForm()" object="application.imageObj" returnVariable="content.mainContent"/>
		</fuseaction>
	
		
		<fuseaction name="menuAreaList" permissions="1,2,3,4,5|">
			<xfa name="saveMenuArea" value="web.menuAreaList"/>
			<xfa name="editMenuArea" value="web.menuAreaList"/>
			
			<set name="attributes.mna_id" overwrite="false" value="0"/>
			
			<if condition="isDefined('attributes.save')">
				<true>
					<invoke methodcall="menuAreaSave(argumentCollection=attributes)" object="application.menuObj"/>
				</true>
			</if>
			 
			<invoke methodcall="getMenuArea(attributes.mna_id)" object="application.menuObj" returnVariable="qMenuArea"/>
			
			<if condition="qMenuArea.recordCount gte 1">
				<true>
					<set name="attributes.mna_title" value="#qMenuArea.mna_title#"/>
					<set name="attributes.mna_active" value="#qMenuArea.mna_active#"/>
				</true>
				<false>
					<set name="attributes.mna_title" value=""/>
					<set name="attributes.mna_active" value="0"/>
				</false>
			</if>
			
			<do action="v_web.menuAreaForm" append="yes" contentVariable="content.mainContent"/>
			
			<invoke methodcall="getMenuAreas()" object="application.menuObj" returnVariable="qMenuAreas"/>
			
			<do action="v_web.menuAreaList" append="yes" contentVariable="content.mainContent"/>
		</fuseaction>
	
		
		<fuseaction name="productForm" permissions="1,2,3,4,5|">
			<xfa name="saveProduct" value="web.productForm"/>
			
			<set name="attributes.prd_id" overwrite="false" value="0"/>
			
			<if condition="isDefined('attributes.save')">
				<true>
					<invoke methodcall="productSave(argumentCollection=attributes)" object="application.contentObj"/>
					<relocate addtoken="false" type="client" url="#myself#web.productList&amp;cat_id=#attributes.prd_category#&amp;subcat_id=#prd_subCategory#"/>
				</true>
			</if>
			 
			<invoke methodcall="getProduct(prd_id=attributes.prd_id)" object="application.contentObj" returnVariable="qProduct"/>
			<invoke methodcall="getCategories()" object="application.menuObj" returnVariable="qCategories"/>
			<invoke methodcall="getAllSubCategories()" object="application.menuObj" returnVariable="qSubCategories"/>
			<invoke methodcall="getAllCategories3()" object="application.menuObj" returnVariable="qCategories3"/>
			
			<if condition="qProduct.recordCount gte 1">
			
				<true>
					<set name="attributes.prd_title" value="#qProduct.prd_title#"/>
					<set name="attributes.prd_code" value="#qProduct.prd_code#"/>
					<set name="attributes.prd_desc" value="#qProduct.prd_desc#"/>
					<set name="attributes.prd_colour" value="#qProduct.prd_colour#"/>
					<set name="attributes.prd_order" value="#qProduct.prd_order#"/>
					<set name="attributes.prd_active" value="#qProduct.prd_active#"/>
					<set name="attributes.prd_dimension" value="#qProduct.prd_dimension#"/>
					<set name="attributes.prd_category" value="#qProduct.prd_category#"/>
					<set name="attributes.prd_subcategory" value="#qProduct.prd_subcategory#"/>
					<set name="attributes.prd_category3" value="#qProduct.prd_category3#"/>
				</true>
				
				<false>
					<set name="attributes.prd_title" value=""/>
					<set name="attributes.prd_code" value=""/>
					<set name="attributes.prd_desc" value=""/>
					<set name="attributes.prd_colour" value=""/>
					<set name="attributes.prd_order" value=""/>
					<set name="attributes.prd_active" value="1"/>
					<set name="attributes.prd_dimension" value=""/>
					<set name="attributes.prd_category" value="0"/>
					<set name="attributes.prd_subcategory" value="0"/>
					<set name="attributes.prd_category3" value="0"/>
				</false>
				
			</if>
			
			<do action="v_web.productForm" append="yes" contentVariable="content.mainContent"/>
		</fuseaction>
	
		
		<fuseaction name="productList" permissions="1,2,3,4,5|">
			<xfa name="saveProducts" value="web.productList"/>
			<xfa name="searchProducts" value="web.productList"/>
			<xfa name="editProduct" value="web.productForm"/>
			
			<set name="attributes.cat_id" overwrite="no" value="0"/>
			<set name="attributes.subcat_id" overwrite="no" value="0"/>
			<set name="attributes.cat3_id" overwrite="no" value="0"/>
			<set name="attributes.keyword" overwrite="no" value=""/>
			
			<set name="productOrderForm" overwrite="yes" value=""/>
			
			<if condition="isDefined('attributes.save')">
				<true>
					<invoke methodcall="productsOrderSave(argumentCollection=attributes)" object="application.contentObj"/>
				</true>
			</if>
			
			<invoke methodcall="getCategories()" object="application.menuObj" returnVariable="qCategories"/>
			<invoke methodcall="getAllSubCategories()" object="application.menuObj" returnVariable="qSubCategories"/>
			<invoke methodcall="getAllCategories3()" object="application.menuObj" returnVariable="qCategories3"/>
			
			<do action="v_web.productSearchForm" append="yes" contentVariable="content.mainContent"/>
			
			<if condition="attributes.cat_id gt 0 OR attributes.subcat_id gt 0 or attributes.cat3_id gt 0 OR len(attributes.keyword) gt 0">
			
				<true>
					<invoke methodcall="productOrderListForm(cat_id=attributes.cat_id,subcat_id=attributes.subcat_id,cat3_id=attributes.cat3_id,keyword=attributes.keyword)" object="application.contentObj" returnVariable="productOrderForm"/>
				</true>
			
			</if>
			 
			<set name="content.mainContent" overwrite="yes" value="#content.mainContent##productOrderForm#"/>
		</fuseaction>
	
	</circuit>
