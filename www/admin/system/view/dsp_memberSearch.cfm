<table id="formTable">

	<cfoutput>

		<form action="#myself##xfa.searchMember#" method="post">

			<tr class="tableHeader">
				<td colspan='5'><div class="tableTitle">Member Search</div></td>
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
				<td class="leftForm">Profile</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<select name='prf_id' style='width:250px'>
						<option value='0'>All Profiles</option>
						<cfloop query='getProfiles'>
							<option value='#getProfiles.prf_id#'<cfif attributes.prf_id is getProfiles.prf_id> selected</cfif>>#getProfiles.prf_name#</option>
						</cfloop>
					</select>
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>

			<tr>
				<td class="formFooter" colspan="5">
					<input type="submit" value="Search" name='save' class="button">
				</td>
			</tr>

		</form>

	</cfoutput>

</table>
