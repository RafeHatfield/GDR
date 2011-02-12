<table id="formTable">

	<cfoutput>

		<form action="#myself##xfa.saveGallery#" method="post" enctype="multipart/form-data">

			<input type="hidden" name="gal_id" value="#attributes.gal_id#" />

			<tr class="tableHeader">
				<td colspan='5'><div class="tableTitle">Gallery</div></td>
			</tr>

			<tr>
				<td class="leftForm">Title</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<input type="text" name="gal_title" value="#attributes.gal_title#" style="width:250px" />
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>

			<tr>
				<td class="leftForm">Active</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<input type="checkbox" name="gal_active" value="1"<cfif yesNoFormat(attributes.gal_active)> checked</cfif>>
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>

			<tr>
				<td class="leftForm">Image</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<cfif len(attributes.gal_image) gt 0>
						<img src="#application.imagePath##attributes.gal_image#" />
						<br />
					</cfif>
					<input type="file" name="gal_image" value="" style="width:250px">
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