<cfoutput>

	<form action="#myself##xfa.searchContent#" method="post">

		<table id="formTable">

			<tr class="tableHeader">
				<td colspan='5'><div class="tableTitle">Search</div></td>
			</tr>

			<tr>
				<td class="leftForm">Content Type</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<select name="searchContentType" style='width:250px'>
						<option value="Content"<cfif attributes.searchContentType is "Content"> selected</cfif>>Content</option>
						<option value="Link"<cfif attributes.searchContentType is "Link"> selected</cfif>>Link</option>
						<option value="Newsletter"<cfif attributes.searchContentType is "Newsletter"> selected</cfif>>Newsletter</option>
					</select>
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>

			<tr>
				<td class="leftForm">Menu Area</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<select name="searchMenuArea" style='width:250px'>
						<option value="0"></option>
						<cfloop query="qMenuAreas">
							<option value="#mna_id#"<cfif attributes.searchMenuArea is mna_id> selected</cfif>>#mna_title#</option>
						</cfloop>
					</select>
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>

			<tr>
				<td class="leftForm">Fast Find</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<input type="text" name="fastFind" value="#attributes.fastFind#" style='width:250px'>
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>

			<tr>
				<td class="formFooter" colspan="5">
					<input type="submit" value="Search" name='search' onMouseOver="this.className='buttonOver'" onMouseOut="this.className='button'" class="button">
				</td>
			</tr>

		</table>

	</form>

</cfoutput>