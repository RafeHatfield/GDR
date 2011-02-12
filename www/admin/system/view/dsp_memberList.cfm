<br /><br />

<cfoutput>

	<table id="dataTable">

		<tr class="tableHeader">
			<td colspan="4">
				<div class="tableTitle">Member List</div>
				<div class="showAll">#getMembers.recordCount# Records</div>
			</td>
		</tr>

		<tr>
			<th style="text-align:center;">ID</th>
			<th>Name</th>
			<th>Profile</th>
			<th>Email</th>
		</tr>

		<cfloop query='getMembers'>

			<tr <cfif currentRow mod 2 eq 0>class="darkData"<cfelse>class="lightData"</cfif>>
				<td align="center">#usr_id#</td>
				<td><a href='#myself##xfa.editMember#&usr_id=#usr_id#'>#usr_firstName# #usr_surname#</a></td>
				<td>#prf_name#</td>
				<td>#usr_email#</td>
			</tr>

		</cfloop>

	</table>

</cfoutput>