<br /><br />

<cfoutput>

	<table id="dataTable">

		<tr class="tableHeader">
			<td colspan="4">
				<div class="tableTitle">Glory Box List</div>
				<div class="showAll">#qGloryBoxes.recordCount# Records</div>
			</td>
		</tr>

		<tr>
			<th style="text-align:center;">ID</th>
			<th>Title</th>
			<th>Name</th>
			<th>Type</th>
			<th>Active</th>
		</tr>

		<cfloop query='qGloryBoxes'>

			<tr <cfif currentRow mod 2 eq 0>class="darkData"<cfelse>class="lightData"</cfif>>
				<td align="center">#gbx_id#</td>
				<td><a href="#myself##xfa.editGloryBox#&gbx_id=#gbx_id#">#gbx_title#</a></td>
				<td>#gbx_name#</td>
				<td>#gbx_type#</td>
				<td><cfif gbx_active is 1>Yes<cfelse>No</cfif></td>
			</tr>

		</cfloop>

	</table>

</cfoutput>