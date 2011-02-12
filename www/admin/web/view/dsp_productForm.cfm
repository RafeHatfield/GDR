<cfoutput>
	
	<cfif attributes.prd_id is 0>

		<cfset attributes.prd_category = session.prd_category />
		<cfset attributes.prd_subcategory = session.prd_subcategory />
		<cfset attributes.prd_category3 = session.prd_category3 />
			
	</cfif>

	<form action="#myself##xfa.saveProduct#" method="post" enctype="multipart/form-data">

		<table id="formTable">

			<input type="hidden" name="prd_id" value="#attributes.prd_id#">

			<tr class="tableHeader">
				<td colspan='5'><div class="tableTitle">Product</div></td>
			</tr>

			<tr>
				<td class="leftForm">Category</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<select name="prd_category" style='width:250px'>
						<cfloop query="qCategories">
							<option value="#qCategories.cat_id#"<cfif attributes.prd_category is qCategories.cat_id> selected</cfif>>#qCategories.cat_title#</option>
						</cfloop>
					</select>
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>

			<tr>
				<td class="leftForm">Sub-category</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<select name="prd_subcategory" style='width:250px'>
						<cfloop query="qSubCategories">
							<option value="#qSubCategories.cat_id#"<cfif attributes.prd_subcategory is qSubCategories.cat_id> selected</cfif>>#qSubCategories.cat_title#</option>
						</cfloop>
					</select>
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>

			<tr>
				<td class="leftForm">Category 3</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<select name="prd_category3" style='width:250px'>
						<option value="">-</option>
						<cfloop query="qCategories3">
							<option value="#qCategories3.cat_id#"<cfif attributes.prd_category3 is qCategories3.cat_id> selected</cfif>>#qCategories3.cat_title#</option>
						</cfloop>
					</select>
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>

			<tr>
				<td class="leftForm">Title</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<input type="text" name="prd_title" value="#attributes.prd_title#" style='width:250px'>
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>

			<tr>
				<td class="leftForm">Code</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<input type="text" name="prd_code" value="#attributes.prd_code#" style='width:250px'>
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>

			<tr>
				<td class="leftForm">Colour</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<input type="text" name="prd_colour" value="#attributes.prd_colour#" style='width:250px'>
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>

			<tr>
				<td class="leftForm">Dimensions</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<input type="text" name="prd_dimension" value="#attributes.prd_dimension#" style='width:250px'>
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>

			<tr>
				<td class="leftForm">Description</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<input type="text" name="prd_desc" value="#attributes.prd_desc#" style='width:250px'>
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>

			<tr>
				<td class="leftForm">Order</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<input type="text" name="prd_order" value="#attributes.prd_order#" style='width:250px'>
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>

			<tr>
				<td class="leftForm">Active</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<input type="checkbox" name="prd_active" value="1"<cfif attributes.prd_active> checked</cfif>>
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>

			<tr>
				<td class="leftForm">Image</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<cfif len(qProduct.prd_code)>
						<img src="#application.imagePath#products/#replaceNoCase(qProduct.prd_code," ","","all")#_120.jpg" />
					</cfif>
					<br />
					<input type="file" name="prdImage" value="" style='width:250px'>
					<br />
					Note: Image will be resized to max dim 120px for a thumbnail, and 350px for the main view.  <br />
					For best performance, don't upload images larger than 800px.
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>

			<tr>
				<td class="formFooter" colspan="5">
					<input type="submit" value="Save" name='save' onMouseOver="this.className='buttonOver'" onMouseOut="this.className='button'" class="button">
				</td>
			</tr>

		</table>
<!--- 

		<table id="formTable">

			<input type="hidden" name="img_id" value="#attributes.img_id#" />

			<tr class="tableHeader">
				<td colspan='5'><div class="tableTitle">Main Image</div></td>
			</tr>

			<tr>
				<td class="leftForm">Image</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<cfif val(attributes.img_id) gt 0>
						#application.imageObj.showImage(img_id=attributes.img_id)#
						<br />
					</cfif>
					<input type="file" name="img_name" value="" style="width:250px">
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>

			<tr>
				<td class="leftForm">Title</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<input type="text" name="img_title" value="#attributes.img_title#" style='width:250px'>
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>

			<tr>
				<td class="leftForm">Alt Text</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<input type="text" name="img_altText" value="#attributes.img_altText#" style='width:250px'>
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>

			<tr>
				<td class="formFooter" colspan="5">
					<input type="submit" value="Save" name="save" class="button" onMouseOver="this.className='buttonOver';" onMouseOut="this.className='button';">
				</td>
			</tr>

		</table>
 --->

	</form>

</cfoutput>