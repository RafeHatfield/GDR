<br /><br />
<cfoutput>

	<table id="dataTable">

		<tr class="tableHeader">
			<td colspan="4"><div class="tableTitle">Process List</div><div class="showAll">#getProcesses.recordCount# Processes</div></td>
		</tr>

		<tr>
			<th style="text-align:center;">ID</th>
			<th>Name</th>
			<th>Fuses</th>
			<th>Path</th>
		</tr>

		<cfloop query='getProcesses'>

			<tr <cfif currentRow mod 2 eq 0>class="darkData"<cfelse>class="lightData"</cfif>>
				<td align="center">#pro_id#</td>
				<td><a href='#myself##attributes.fuseAction#&pro_id=#pro_id#'>#pro_name#</a></td>
				<td><a href='#myself##xfa.fuseList#&pro_id=#pro_id#'>Edit Fuses</td>
				<td>#pro_path#</td>
			</tr>

		</cfloop>

	</table>

</cfoutput>