<cfoutput>

	<table id="formTable">

		<form action="#myself##xfa.saveVillaDetails#" method="post">

			<tr class="tableHeader">
				<td colspan='5'><div class="tableTitle">Villa Details</div></td>
			</tr>

			<tr>
				<td class="leftForm">Title</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<input type="text" name="vil_title" value="#attributes.vil_title#" style='width:250px'>
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>

			<tr>
				<td class="leftForm">Phone</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<input type="text" name="vil_phone" value="#attributes.vil_phone#" style='width:250px'>
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>

			<tr>
				<td class="leftForm">Fax</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<input type="text" name="vil_fax" value="#attributes.vil_fax#" style='width:250px'>
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>

			<tr>
				<td class="leftForm">Email</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<input type="text" name="vil_email" value="#attributes.vil_email#" style='width:250px'>
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>

			<tr>
				<td class="leftForm">Description</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>

					<cfmodule template="/assets/tiny_mce/tinyMCE.cfm"
					  instanceName="vil_description"
					  value="#attributes.vil_description#"
					  width="600"
					  height="250"
					  toolbarset="Basic" />

				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>

			<tr>
				<td class="leftForm">Address</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>

					<cfmodule template="/assets/tiny_mce/tinyMCE.cfm"
					  instanceName="vil_address"
					  value="#attributes.vil_address#"
					  width="600"
					  height="150"
					  toolbarset="Basic" />

				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>

			<tr>
				<td class="leftForm">Other Contact Details</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>

					<cfmodule template="/assets/tiny_mce/tinyMCE.cfm"
					  instanceName="vil_otherContact"
					  value="#attributes.vil_otherContact#"
					  width="600"
					  height="150"
					  toolbarset="Basic" />

				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>

			<tr>
				<td class="formFooter" colspan="5">
					<input type="submit" value="Save" name='save' onMouseOver="this.className='buttonOver'" onMouseOut="this.className='button'" class="button">
				</td>
			</tr>

		</form>

	</table>

</cfoutput>