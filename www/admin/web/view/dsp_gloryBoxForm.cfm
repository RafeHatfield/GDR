<table id="formTable">

	<cfoutput>

		<form action="#myself##xfa.saveGloryBox#" method="post" enctype="multipart/form-data">

			<input type="hidden" name="gbx_id" value="#attributes.gbx_id#" />

			<tr class="tableHeader">
				<td colspan='5'><div class="tableTitle">Glory Box - the default images at the top of every page unless overwritten in content</div></td>
			</tr>

			<tr>
				<td class="leftForm">Title</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<input type="text" name="gbx_title" value="#attributes.gbx_title#" style='width:250px' />
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>

			<tr>
				<td class="leftForm">Type</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<select name="gbx_type" style='width:250px'>
						<option value="Image"<cfif attributes.gbx_type is "Image"> selected</cfif>>Image</option>
						<option value="Flash"<cfif attributes.gbx_type is "Flash"> selected</cfif>>Flash</option>
					</select>
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>

			<tr>
				<td class="leftForm">File</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<cfif attributes.gbx_id gt 0>
						#attributes.gbx_name#
						<input type="hidden" name="gbx_name" value="#attributes.gbx_name#" />
					<cfelse>
						<input type="file" name="gbx_name" value="" /><br />
					<em>All images will be resized to 837 x 418 px</em>
					</cfif>
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>

			<tr>
				<td class="leftForm">Active</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<input type="checkbox" name="gbx_active" value="1"<cfif attributes.gbx_active is 1> checked</cfif>>
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>


			<tr>
				<td class="formFooter" colspan="5">
					<input type="submit" value="Save" name='save' onMouseOver="this.className='buttonOver'" onMouseOut="this.className='button'" class="button" />
				</td>
			</tr>

		</form>

	</cfoutput>

</table>