<cfoutput>

	<form action="#myself##xfa.saveGalleryImages#" method="post" enctype="multipart/form-data">

		<input type="hidden" name="gal_id" value="#attributes.gal_id#" />
		<input type="hidden" name="galleryImageCount" value="#qGalleryImages.recordCount#" />

		<table id="formTable">

			<tr class="tableHeader">
				<td colspan='5'><div class="tableTitle">New Gallery Images</div></td>
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
					<div class="tableTitle">Existing Images</div>
					<div class="showAll">#qGalleryImages.recordCount# Records</div>
				</td>
			</tr>

			<cfloop query="qGalleryImages">
				<cfif qGalleryImages.currentRow mod 3 is 1>
					<tr>
				</cfif>

				<td align="center">
					<input type="hidden" name="imgID#qGalleryImages.currentRow#" value="#qGalleryImages.img_id#" />
					<img src="#application.imagePath#slideshow/#img_name#" alt="#img_altText#" width="240" /><br />
					Title:<br />
					<input type="text" name="imgTitle#qGalleryImages.currentRow#" value="#qGalleryImages.img_title#" style="width: 200px"/><br />
					Alt Text:<br />
					<input type="text" name="imgAltText#qGalleryImages.currentRow#" value="#qGalleryImages.img_altText#" style="width: 200px" /><br />
					Order:
					<select name="imgOrder#qGalleryImages.currentRow#">
						<cfloop from="1" to="#qGalleryImages.recordCount#" index="thisOrder">
							<option value="#thisOrder#"<cfif thisOrder is qGalleryImages.currentRow> selected</cfif>>#thisOrder#</option>
						</cfloop>
					</select><br />

					<input type="checkbox" name="imgDelete#qGalleryImages.currentRow#" value="1" /> Delete?
					<br /><br />
				</td>

				<cfif qGalleryImages.currentRow mod 3 is 0>
					</tr>
				</cfif>

			</cfloop>

		</table>

	</form>

</cfoutput>
