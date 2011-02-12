<cfoutput>

	<table id="dataTable">

		<tr class="tableHeader">
			<td colspan="4">
				<div class="tableTitle">Promotions</div>
				<div class="showAll">#qPromotions.recordCount# Records</div>
			</td>
		</tr>

		<tr>
			<th style="text-align:center;">ID</th>
			<th>Title</th>
			<th>Active</th>
		</tr>

		<cfloop query="qPromotions">

			<tr <cfif currentRow mod 2 eq 0>class="darkData"<cfelse>class="lightData"</cfif>>
				<td align="center">#qPromotions.prm_id#</td>
				<td><a href="#myself#villa.promotionsList&prm_id=#qPromotions.prm_id#">#qPromotions.prm_title#</a></td>
				<td><cfif qPromotions.prm_active>Yes<cfelse>No</cfif></td>
			</tr>

		</cfloop>

	</table>

</cfoutput>