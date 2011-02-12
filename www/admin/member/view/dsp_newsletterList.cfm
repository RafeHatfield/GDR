<br /><br />

<cfoutput>

	<table id="dataTable">

		<tr class="tableHeader">
			<td colspan="4">
				<div class="tableTitle">Newsletter List</div>
				<div class="showAll">#qNewsletters.recordCount# Records</div>
			</td>
		</tr>

		<tr>
			<th style="text-align:center;">ID</th>
			<th>Title</th>
			<th>Date Entered</th>
			<th>Send</th>
		</tr>

		<cfloop query="qNewsletters">

			<tr <cfif currentRow mod 2 eq 0>class="darkData"<cfelse>class="lightData"</cfif>>
				<td align="center">#nsl_id#</td>
				<td><a href="#myself##xfa.editNewsletter#&nsl_id=#nsl_id#">#nsl_title#</a></td>
				<td>#dateFormat(nsl_dateEntered,"ddd d mmm, yyyy")#</td>
				<td><a href="#myself##xfa.sendNewsletter#&nsl_id=#nsl_id#">Send Newsletter</a></td>
			</tr>

		</cfloop>

	</table>

</cfoutput>