<br /><br />

<cfoutput>

	<table id="dataTable">

		<tr class="tableHeader">
			<td colspan="4">
				<div class="tableTitle">Member Messages for #qMemberMessages.mem_firstName# #qMemberMessages.mem_surname#</div>
				<div class="showAll">#qMemberMessages.recordCount# Records</div>
			</td>
		</tr>

		<tr>
			<th style="text-align:center;">Date</th>
			<th>Message</th>
		</tr>

		<cfloop query='qMemberMessages'>

			<tr <cfif currentRow mod 2 eq 0>class="darkData"<cfelse>class="lightData"</cfif>>
				<td align="center">#dateFormat(mes_dateEntered,"ddd d mmm, yyyy")# #timeFormat(mes_dateEntered,"h:mm tt")#</td>
				<td>
					<strong>#mes_title#</strong>
					<br /><br />
					#mes_body#
					<br /><br />
				</td>
			</tr>

		</cfloop>

	</table>

</cfoutput>