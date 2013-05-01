<?xml version="1.0" encoding="UTF-8"?>
<circuit access="public">

	<fuseaction name="list">
	
		<set name="attributes.cat_id" value="0" overwrite="no" /> 
		<set name="attributes.subcat_id" value="0" overwrite="no" />
		<set name="attributes.cat3_id" value="0" overwrite="no" /> 
		<set name="attributes.keyword" value="" overwrite="no" />
	
		<set name="attributes.displayMode" value="product" overwrite="yes" />

		<invoke object="application.menuObj" methodcall="displayCategoryMenu(cat_id=attributes.cat_id)" returnVariable="content.categoryMenu" />
		
		<invoke object="application.menuObj" methodcall="displaySubCategoryMenu(cat_id=attributes.cat_id,subcat_id=attributes.subcat_id)" returnVariable="content.subCategoryMenu" />
		
		<invoke object="application.contentObj" methodcall="displayProductList(cat_id=attributes.cat_id,subcat_id=attributes.subcat_id,cat3_id=attributes.cat3_id,keyword=attributes.keyword)" returnVariable="content.mainContent" />

	</fuseaction>

	<fuseaction name="view">
	
		<set name="attributes.prd_id" value="0" overwrite="no" />
		<set name="attributes.addSaved" value="0" overwrite="no" />
		
		<invoke object="application.contentObj" methodcall="getProduct(prd_id=attributes.prd_id)" returnVariable="qProduct" />
		
		<if condition="qProduct.recordCount is 0">
			<true>
				<relocate url="index.cfm?fuseaction=products.list" />
			</true>
		</if>
	
		<if condition="attributes.addSaved is 1">
			<true>
				<invoke object="application.contentObj" methodcall="addSavedProduct(prd_id=attributes.prd_id)" returnVariable="cookieList" />
			</true>
		</if>
	
		<set name="attributes.cat_id" value="#val(qProduct.prd_category)#" overwrite="no" /> 
		<set name="attributes.subcat_id" value="#val(qProduct.prd_subcategory)#" overwrite="no" /> 
	
		<set name="attributes.displayMode" value="product" overwrite="yes" />

		<invoke object="application.menuObj" methodcall="displayCategoryMenu(cat_id=attributes.cat_id)" returnVariable="content.categoryMenu" />
		
		<invoke object="application.menuObj" methodcall="displaySubCategoryMenu(cat_id=attributes.cat_id)" returnVariable="content.subCategoryMenu" />
		
		<invoke object="application.contentObj" methodcall="displayProduct(prd_id=attributes.prd_id)" returnVariable="content.mainContent" />

	</fuseaction>

	<fuseaction name="search">
		
		<invoke object="application.contentObj" methodcall="productSearch()" returnVariable="content.mainContent" />

	</fuseaction>

	<fuseaction name="saved">
	
		<if condition="isDefined('attributes.save')">
			<true>
				<invoke object="application.contactObj" methodcall="sendProductContact(argumentCollection=attributes)" />
			</true>
		</if> 
		
		<if condition="isDefined('attributes.delete')">
			<true>
				<invoke object="application.contentObj" methodcall="deleteSavedProduct(argumentCollection=attributes)" />
			</true>
		</if> 
		
		<invoke object="application.contentObj" methodcall="productsSaved(cookie.gdrProductList)" returnVariable="content.mainContent" />

	</fuseaction>

	<fuseaction name="gallery">
	
		<set name="attributes.gal_id" value="9" overwrite="yes" />
		<set name="attributes.img_id" value="0" overwrite="no" />
		
		<set name="attributes.displayMode" value="gallery" overwrite="yes" />

		<invoke object="application.imageObj" methodcall="galleryImageView(attributes.gal_id,attributes.img_id)" returnVariable="content.mainContent" />

	</fuseaction>

</circuit>
