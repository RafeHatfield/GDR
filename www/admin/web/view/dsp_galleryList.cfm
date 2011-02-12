<cfoutput>

	<table id="dataTable">

		<tr class="tableHeader">
			<td colspan="5">
				<div class="tableTitle">Galleries</div>
				<div class="showAll">#qGalleries.recordCount# Records</div>
			</td>
		</tr>

		<tr>
			<th style="text-align:center;">ID</th>
			<th>Title</th>
			<th>Gallery</th>
			<th>Num Images</th>
			<th>Active</th>
		</tr>

		<cfloop query="qGalleries">

			<tr <cfif currentRow mod 2 eq 0>class="darkData"<cfelse>class="lightData"</cfif>>
				<td align="center">#qGalleries.gal_id#</td>
				<td><a href="#myself##xfa.editGallery#&gal_id=#qGalleries.gal_id#">#qGalleries.gal_title#</a></td>
				<td><a href="#myself##xfa.editGalleryImages#&gal_id=#qGalleries.gal_id#">Edit Images</a></td>
				<td>#qGalleries.imageCount#</td>
				<td><cfif qGalleries.gal_active>Yes<cfelse>No</cfif></td>
			</tr>

		</cfloop>

	</table>

</cfoutput>