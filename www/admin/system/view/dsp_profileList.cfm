<br /><br />
<cfoutput>

	<table id="dataTable">

		<tr class="tableHeader">
			<td colspan="4">
				<div class="tableTitle">Profile List</div>
				<div class="showAll">#getProfiles.recordCount# Records</div>
			</td>
		</tr>

		<tr>
			<th style="text-align:center;">ID</th>
			<th>Profile Name</th>
			<th>Permission Template</th>
			<th>Description</th>
		</tr>

		<cfloop query='getProfiles'>

			<tr <cfif currentRow mod 2 eq 0>class="darkData"<cfelse>class="lightData"</cfif>>
				<td align="center">#prf_id#</td>
				<td><a href='#myself##xfa.editProfile#&prf_id=#prf_id#'>#prf_name#</a></td>
				<td><a href='#myself##xfa.permissionsList#&prf_id=#prf_id#'>Edit Template</a></td>
				<td>#prf_description#</td>
			</tr>

		</cfloop>

	</table>

</cfoutput>