<br /><br />

<cfoutput>

	<table id="dataTable">

		<tr class="tableHeader">
			<td colspan="4">
				<div class="tableTitle">Recipient List</div>
				<div class="showAll">#qMemberNewsletter.recordCount# Records</div>
			</td>
		</tr>

		<tr>
			<th>ID</th>
			<th>Name</th>
			<th>Email</th>
			<th>Date Sent</th>
		</tr>

		<cfloop query="qMemberNewsletter">

			<tr <cfif currentRow mod 2 eq 0>class="darkData"<cfelse>class="lightData"</cfif>>
				<td align="center">#mem_id#</td>
				<td>#mem_firstName# #mem_surname#</td>
				<td>#mem_email#</td>
				<td>#dateFormat(mnl_dateEntered,"ddd d mmm, yyyy")#</td>
			</tr>

		</cfloop>

	</table>

</cfoutput>