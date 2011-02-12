<table id="formTable">
	<cfoutput>
		<form action="#myself##xfa.saveMember#" method="post">

			<input type="hidden" name="usr_id" value="#attributes.usr_id#">

			<tr class="tableHeader">
				<td colspan='5'><div class="tableTitle">User Details</div></td>
			</tr>

			<tr>
				<td class="leftForm">First Name</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<input type="text" name="usr_firstName" value="#attributes.usr_firstName#" style='width:250px'>
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>

			<tr>
				<td class="leftForm">Surname</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<input type="text" name="usr_surname" value="#attributes.usr_surname#" style='width:250px'>
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>

			<tr>
				<td class="leftForm">Email</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<input type="text" name="usr_email" value="#attributes.usr_email#" style='width:250px'>
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>

			<tr>
				<td class="leftForm">Password</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<input type="text" name="usr_password" value="#attributes.usr_password#" style='width:250px'>
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
					<input type="submit" value="Save" name='save' class="button" onMouseOver="this.className='buttonOver';" onMouseOut="this.className='button';">
				</td>
			</tr>

		</form>

	</cfoutput>

</table>