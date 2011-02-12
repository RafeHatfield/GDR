<cfoutput>

	<table id="dataTable">

		<tr class="tableHeader">
			<td colspan="4">
				<div class="tableTitle">CTAs</div>
				<div class="showAll">#qCTAs.recordCount# Records</div>
			</td>
		</tr>

		<tr>
			<th style="text-align:center;">ID</th>
			<th>Title</th>
			<th>Link</th>
			<th>Active</th>
			<th>Random</th>
		</tr>

		<cfloop query="qCTAs">

			<tr <cfif currentRow mod 2 eq 0>class="darkData"<cfelse>class="lightData"</cfif>>
				<td align="center">#qCTAs.cta_id#</td>
				<td><a href="#myself##xfa.editCTA#&cta_id=#qCTAs.cta_id#">#qCTAs.cta_title#</a></td>
				<td>#qCTAs.cta_link#</td>
				<td><cfif qCTAs.cta_active>Yes<cfelse>No</cfif></td>
				<td><cfif qCTAs.cta_random>Yes<cfelse>No</cfif></td>
			</tr>

		</cfloop>

	</table>

</cfoutput>