<br /><br />
<cfoutput>

	<table id="dataTable">

		<tr class="tableHeader">
			<td colspan="3">
				<div class="tableTitle">Menu Section List</div>
				<div class="showAll">#getMenuSections.recordCount# Records</div>
			</td>
		</tr>

		<tr>
			<th style="text-align:center;">ID</th>
			<th>Name</th>
			<th style="text-align:center;">Order</th></th>
		</tr>

		<cfloop query='getMenuSections'>

			<tr <cfif currentRow mod 2 eq 0>class="darkData"<cfelse>class="lightData"</cfif>>
				<td align="center">#mse_id#</td>
				<td><a href='#myself##xfa.editMenuSection#&mse_id=#mse_id#'>#mse_title#</a></td>
				<td align="center">#mse_order#</td>
			</tr>

		</cfloop>

	</table>

</cfoutput>