<table id="formTable">

	<cfoutput>

		<form action="#myself##xfa.saveMenuArea#" method="post">

			<input type="hidden" name="mna_id" value="#attributes.mna_id#">

			<tr class="tableHeader">
				<td colspan='5'><div class="tableTitle">Menu Area</div></td>
			</tr>

			<tr>
				<td class="leftForm">Name</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<input type="text" name="mna_title" value="#attributes.mna_title#">
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>

			<tr>
				<td class="leftForm">Active</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<input type="checkbox" name="mna_active" value="1" <cfif attributes.mna_active> checked</cfif>>
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

	</cfoutput>

</table>