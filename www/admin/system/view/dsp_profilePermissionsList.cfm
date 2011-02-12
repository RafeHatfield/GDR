<table id="dataTable" width="100%">

	<form name='profilePermissions' action='<cfoutput>#myself##xfa.saveProfilePermissions#</cfoutput>' method='post'>

		<cfoutput>

			<input type='hidden' name='prf_id' value='#attributes.prf_id#'>

			<tr class="tableHeader">
				<td colspan='8'><div class="tableTitle">Fuse List for Profile "#getProfile.prf_name#"</div></td>
			</tr>

		</cfoutput>

		<cfoutput query='getFuses' group='pro_id'>

			<tr>
				<td><strong>#pro_name#</strong></th>
			</tr>

			<cfoutput>
				<tr>
					<td><input type='checkbox' name='profilePermissionsList' value='#pfu_id#'<cfif listFindNoCase(attributes.thisProfilePermissionsList,pfu_id)> checked</cfif>> #pfu_name#</td>
				</tr>
			</cfoutput>

		</cfoutput>

		<tr>
			<td><input type='submit' value='save' name='save' onMouseOver="this.className='buttonOver'" onMouseOut="this.className='button'" class="button"></td>
		</tr>

	</form>

</table>