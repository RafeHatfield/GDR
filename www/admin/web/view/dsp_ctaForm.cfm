<table id="formTable">

	<cfoutput>

		<form action="#myself##xfa.saveCTA#" method="post" enctype="multipart/form-data">

			<input type="hidden" name="cta_id" value="#attributes.cta_id#" />

			<tr class="tableHeader">
				<td colspan='5'><div class="tableTitle">CTA</div></td>
			</tr>

			<tr>
				<td class="leftForm">Title</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<input type="text" name="cta_title" value="#attributes.cta_title#" style="width:250px" />
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>

			<tr>
				<td class="leftForm">Link</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<input type="text" name="cta_link" value="#attributes.cta_link#" style="width:250px" />
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>

			<tr>
				<td class="leftForm">Active</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<input type="checkbox" name="cta_active" value="1"<cfif yesNoFormat(attributes.cta_active)> checked</cfif>>
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>

			<tr>
				<td class="leftForm">Random</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<input type="checkbox" name="cta_random" value="1"<cfif yesNoFormat(attributes.cta_random)> checked</cfif>>
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>

			<tr>
				<td class="leftForm">Image</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<cfif len(attributes.cta_image) gt 0>
						<img src="#application.imagePath##attributes.cta_image#" />
						<br />
					</cfif>
					<input type="file" name="cta_image" value="" style="width:250px">
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