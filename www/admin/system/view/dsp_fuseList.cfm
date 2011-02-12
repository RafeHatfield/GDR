<br /><br />

<cfoutput>

	<table id="dataTable">

		<tr class="tableHeader">
			<td colspan="8">
				<div class="tableTitle">Fuse List in Process "#getProcess.pro_name#"</div>
				<div class="showAll">#getFuses.recordCount# Records</div>
			</td>
		</tr>

		<tr>
			<th style="text-align:center;">ID</th>
			<th>Name</th>
			<th>Path</th>
			<th>XML</th>
			<th style="text-align:center;">On Menu</th>
			<th>Menu Title</th>
			<th>Menu Order</th>
			<th>Menu Section</th>
		</tr>

		<cfloop query='getFuses'>

			<tr <cfif currentRow mod 2 eq 0>class="darkData"<cfelse>class="lightData"</cfif>>
				<td align="center">#pfu_id#</td>
				<td><a href='#myself##attributes.fuseAction#&pfu_id=#pfu_id#&pro_id=#attributes.pro_id#'>#pfu_name#</a></td>
				<td>#pfu_path#</td>
				<td>#pfu_circuitXML#</td>
				<td align="center"><cfif pfu_isMenu>Yes<cfelse>No</cfif></td>
				<td>#pfu_title#</td>
				<td>#pfu_menuOrder#</td>
				<td>#mse_title#</td>
			</tr>

		</cfloop>

	</table>

</cfoutput>
