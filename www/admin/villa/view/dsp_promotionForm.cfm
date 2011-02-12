<table id="formTable">

	<cfset qPromotionImage = application.villaObj.getPromotionImage(prm_id=attributes.prm_id, img_type='Promotion') />
	<cfset qPromotionGloryImage = application.villaObj.getPromotionImage(prm_id=attributes.prm_id, img_type='Promotion Glory') />

	<cfoutput>
		<form action="#myself##xfa.savePromotion#" method="post" enctype="multipart/form-data">

			<input type="hidden" name="prm_id" value="#attributes.prm_id#">
			<input type="hidden" name="img_id" value="#qPromotionImage.img_id#">
			<input type="hidden" name="img_idGlory" value="#qPromotionGloryImage.img_id#">

			<tr class="tableHeader">
				<td colspan='5'><div class="tableTitle">Promotion</div></td>
			</tr>

			<tr>
				<td class="leftForm">Title</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<input type="text" name="prm_title" value="#attributes.prm_title#" style="width:250px" />
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>

			<tr>
				<td class="leftForm">Body</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>

					<cfmodule template="#application.assetsPath#tiny_mce/tinyMCE.cfm"
					  instanceName="prm_body"
					  value="#attributes.prm_body#"
					  width="680"
					  height="200"
					  toolbarset="Basic" />

				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>

			<tr>
				<td class="leftForm">Active</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<input type="checkbox" name="prm_active" value="1"<cfif yesNoFormat(attributes.prm_active)> checked</cfif>>
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>

			<tr>
				<td class="leftForm">Image<br /><em>This image will be resized to 240px wide for the promotions list page, and 600px wide for a full view.</em></td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<cfif val(qPromotionImage.img_id) gt 0>
						#application.imageObj.showImage(img_id=qPromotionImage.img_id)#
						<br />
					</cfif>
					<input type="file" name="img_name" value="" style="width:250px" />
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>

			<tr>
				<td class="leftForm">Image Title</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<input type="text" name="img_title" value="#qPromotionImage.img_title#" style='width:250px'>
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>

			<tr>
				<td class="leftForm">Alt Text</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<input type="text" name="img_altText" value="#qPromotionImage.img_altText#" style='width:250px'>
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>

			<tr>
				<td class="leftForm">Glory Image<br /><em>This image 800px x 400px, and will overwrite the flash intro.</em></td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<cfif val(qPromotionGloryImage.img_id) gt 0>
						#application.imageObj.showImage(img_id=qPromotionGloryImage.img_id,forceWidth="400")#
						<br />
					</cfif>
					<input type="file" name="img_nameGlory" value="" style="width:250px" />
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>

			<tr>
				<td class="formFooter" colspan="5">
					<input type="submit" value="Save" name="save" class="button" onMouseOver="this.className='buttonOver';" onMouseOut="this.className='button';">
				</td>
			</tr>

		</form>

	</cfoutput>

</table>