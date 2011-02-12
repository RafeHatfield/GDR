<cfoutput>

	<form action="#myself##xfa.saveContent#" method="post" enctype="multipart/form-data">

		<table id="formTable">

			<input type="hidden" name="con_id" value="#attributes.con_id#">
			<input type="hidden" name="old_con_approved" value="#attributes.con_approved#" />
			<input type="hidden" name="contentImageCount" value="#qOtherContentImages.recordCount#" />

			<tr class="tableHeader">
				<td colspan='5'><div class="tableTitle">Content</div></td>
			</tr>

			<tr>
				<td class="leftForm">Content Type</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<select name="con_type" style='width:250px'>
						<option value="Content"<cfif attributes.con_type is "Content"> selected</cfif>>Content</option>
						<option value="Link"<cfif attributes.con_type is "Link"> selected</cfif>>Link</option>
						<option value="Newsletter"<cfif attributes.con_type is "Newsletter"> selected</cfif>>Newsletter</option>
					</select>
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>

			<tr>
				<td class="leftForm">Menu Title</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<input type="text" name="con_menuTitle" value="#attributes.con_menuTitle#" style='width:250px'>
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>

			<tr>
				<td class="leftForm">Link (for link type)</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<input type="text" name="con_link" value="#attributes.con_link#" style='width:250px'>
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>

			<tr>
				<td class="leftForm">Title</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<input type="text" name="con_title" value="#attributes.con_title#" style='width:250px'>
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>

			<tr>
				<td class="leftForm">Body</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>

					<cfmodule template="#application.assetsPath#tiny_mce/tinyMCE.cfm"
					  instanceName="con_body"
					  value="#attributes.con_body#"
					  width="600"
					  height="300"
					  toolbarset="Basic" />

				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>

<!--- 			<tr>
				<td class="leftForm">Body (Column 2)</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>

					<cfmodule template="#application.assetsPath#tiny_mce/tinyMCE.cfm"
					  instanceName="con_intro"
					  value="#attributes.con_intro#"
					  width="600"
					  height="300"
					  toolbarset="Basic" />

				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr> --->
<!--- 
			<tr>
				<td class="leftForm">Glory Box</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<select name="con_gloryBox" style='width:250px'>
						<cfloop query="qGloryBoxes">
							<option value="#gbx_id#"<cfif attributes.con_gloryBox is gbx_id> selected</cfif>>#gbx_title#</option>
						</cfloop>
					</select>
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>

			<tr>
				<td class="leftForm">Left Hand Menu</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<select name="con_leftMenuArea" style='width:250px'>
						<option value="0">Default</option>
						<cfloop query="qMenuAreas">
							<option value="#mna_id#"<cfif attributes.con_leftMenuArea is mna_id> selected</cfif>>#mna_title#</option>
						</cfloop>
					</select>
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>
 --->

			<tr>
				<td class="leftForm">Menu Link?</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<input type="checkbox" name="con_isMenu" value="1" <cfif attributes.con_isMenu> checked</cfif>>
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>

			<tr>
				<td class="leftForm">Menu Area</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<select name="con_menuArea" style='width:250px'>
						<option value="0"></option>
						<cfloop query="qMenuAreas">
							<option value="#mna_id#"<cfif attributes.con_menuArea is mna_id> selected</cfif>>#mna_title#</option>
						</cfloop>
					</select>
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>

			<tr>
				<td class="leftForm">Parent Content</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<select name="con_parentID" style="width:250px">
						<option value="0"></option>
						<cfloop query="qContentParents">
							<option value="#qContentParents.con_id#"<cfif attributes.con_parentID is qContentParents.con_id> selected</cfif>>#qContentParents.con_menuTitle#</option>
						</cfloop>
					</select>
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>

			<tr>
				<td class="leftForm">Menu Order</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<input type="text" name="con_menuOrder" value="#attributes.con_menuOrder#" style='width:250px'>
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>

			<tr>
				<td class="leftForm">Active</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<input type="checkbox" name="con_active" value="1"<cfif attributes.con_active> checked</cfif>>
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>

			<tr>
				<td class="leftForm">Meta Description</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<textarea name="con_metaDescription" style="width: 400px">#attributes.con_metaDescription#</textarea>
					<br />
					<em>This will overwrite the site default.</em>
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>

			<tr>
				<td class="leftForm">Meta Keywords</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<textarea name="con_metaKeywords" style="width: 400px">#attributes.con_metaKeywords#</textarea>
					<br />
					<em>This will overwrite the site default.</em>
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>

			<cfif #application.systemSettings.sys_approval# eq 1>

				<tr>
					<td class="leftForm">Approved</td>
					<td class="whiteGutter">&nbsp;</td>
					<td>
						<cfif (#application.systemSettings.sys_approval# is 1 AND #listFind('1,2',cookie.prf_id)# AND NOT attributes.con_approved)>
							<input type="checkbox" name="con_approved" value="1"<cfif attributes.con_approved> checked</cfif>>
						<cfelse>
							<cfif attributes.con_approved>Yes<cfelse>No</cfif>
							<input type="hidden" name="con_approved" value="#attributes.con_approved#" />
						</cfif>
					</td>
					<td class="whiteGutter">&nbsp;</td>
					<td class="rightForm">&nbsp;</td>
				</tr>

			<cfelse>

				<input type="hidden" name="con_approved" value="1" />

			</cfif>

			<tr>
				<td class="formFooter" colspan="5">
					<input type="submit" value="Save" name='save' onMouseOver="this.className='buttonOver'" onMouseOut="this.className='button'" class="button">
				</td>
			</tr>

		</table>


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


<!--- 

		<table id="formTable">

			<tr class="tableHeader">
				<td colspan='5'><div class="tableTitle">Content Images</div></td>
			</tr>

			<tr>
				<td class="leftForm">Image 1</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<input type="file" name="img_name1" value="" style="width:250px">
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>

			<tr>
				<td class="leftForm">Title 1</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<input type="text" name="img_title1" value="" style="width:250px" />
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>

			<tr>
				<td class="leftForm">Alt Text 1</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<input type="text" name="img_altText1" value="" style="width:250px" />
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>

			<tr>
				<td class="leftForm">Image 2</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<input type="file" name="img_name2" value="" style="width:250px">
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>

			<tr>
				<td class="leftForm">Title 2</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<input type="text" name="img_title2" value="" style="width:250px" />
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>

			<tr>
				<td class="leftForm">Alt Text 2</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<input type="text" name="img_altText2" value="" style="width:250px" />
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>

			<tr>
				<td class="leftForm">Image 3</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<input type="file" name="img_name3" value="" style="width:250px">
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>

			<tr>
				<td class="leftForm">Title 3</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<input type="text" name="img_title3" value="" style="width:250px" />
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>

			<tr>
				<td class="leftForm">Alt Text 3</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<input type="text" name="img_altText3" value="" style="width:250px" />
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


		<table id="dataTable">

			<tr class="tableHeader">
				<td colspan="3">
					<div class="tableTitle">Images</div>
					<div class="showAll">#qOtherContentImages.recordCount# Records</div>
				</td>
			</tr>

			<cfloop query="qOtherContentImages">
			
				<cfif qOtherContentImages.currentRow mod 3 is 1>
					<tr>
				</cfif>

				<td align="center">
					<input type="hidden" name="imgID#qOtherContentImages.currentRow#" value="#qOtherContentImages.img_id#" />
					<img src="#application.imagePath##img_name#" alt="#img_altText#" width="240" /><br />
					Title:<br />
					<input type="text" name="imgTitle#qOtherContentImages.currentRow#" value="#qOtherContentImages.img_title#" style="width: 200px"/><br />
					Alt Text:<br />
					<input type="text" name="imgAltText#qOtherContentImages.currentRow#" value="#qOtherContentImages.img_altText#" style="width: 200px" /><br />
					Order:
					<select name="imgOrder#qOtherContentImages.currentRow#">
						<cfloop from="1" to="#qOtherContentImages.recordCount#" index="thisOrder">
							<option value="#thisOrder#"<cfif thisOrder is qOtherContentImages.currentRow> selected</cfif>>#thisOrder#</option>
						</cfloop>
					</select><br />

					<input type="checkbox" name="imgDelete#qOtherContentImages.currentRow#" value="1" /> Delete?
					<br /><br />
				</td>

				<cfif qOtherContentImages.currentRow mod 3 is 0 OR qOtherContentImages.recordCount eq qOtherContentImages.currentRow>
					</tr>
				</cfif>

			</cfloop>

		</table>
 --->

	</form>

</cfoutput>