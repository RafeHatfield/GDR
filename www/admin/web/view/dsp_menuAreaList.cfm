<br /><br />
<cfoutput>

	<table id="dataTable">

		<tr class="tableHeader">
			<td colspan="3">
				<div class="tableTitle">Menu Area List</div>
				<div class="showAll">#qMenuAreas.recordCount# Records</div>
			</td>
		</tr>

		<tr>
			<th style="text-align:center;">ID</th>
			<th>Name</th>
			<th style="text-align:center;">Active</th></th>
		</tr>

		<cfloop query='qMenuAreas'>

			<tr <cfif currentRow mod 2 eq 0>class="darkData"<cfelse>class="lightData"</cfif>>
				<td align="center">#mna_id#</td>
				<td><a href='#myself##xfa.editMenuArea#&mna_id=#mna_id#'>#mna_title#</a></td>
				<td align="center"><cfif mna_active>Yes<cfelse>No</cfif></td>
			</tr>

		</cfloop>

	</table>

</cfoutput>