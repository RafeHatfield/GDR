<br /><br />

<table id="dataTable">

	<tr class="tableHeader">
		<td colspan="6">
			<div class="tableTitle">Content List</div>
			<div class="showAll"><cfoutput>#qAllContent.recordCount#</cfoutput> Records</div>
		</td>
	</tr>

	<tr>
		<th style="text-align:center;">ID</th>
		<th>Menu</th>
		<th>Title</th>
		<th style="text-align:center;">Approved</th></th>
		<th>Order</th>
		<th style="text-align:center;">Active</th></th>
	</tr>

	<cfoutput query='qAllContent' group="mna_id">

		<tr class="darkData">
			<td colspan="6">#mna_title#</td>
		</tr>

		<cfoutput>

			<tr class="lightData">
				<td align="center">#con_id#</td>
				<td>
					<a href='#myself##xfa.editContent#&con_id=#con_id#'>
						<cfif len(con_menuTitle)>
							#con_menuTitle#
						<cfelse>
							#con_title#
						</cfif>
					</a>
				</td>
				<td>#con_title#</td>
				<td align="center"><cfif con_approved>Yes<cfelse><strong><span style="color: red">No</span></strong></cfif></td>
				<td><cfif con_isMenu>#con_menuOrder#<cfelse>-</cfif></td>
				<td align="center"><cfif con_active>Yes<cfelse>No</cfif></td>
			</tr>

		</cfoutput>

	</cfoutput>

</table>