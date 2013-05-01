<cfoutput>

	<form action="#myself##xfa.searchProducts#" method="post">

		<table id="formTable">

			<tr class="tableHeader">
				<td colspan='5'><div class="tableTitle">Search</div></td>
			</tr>

			<tr>
				<td class="leftForm">Category</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<select name="cat_id" style='width:250px'>
						<option value="0"></option>
						<cfloop query="qCategories">
							<option value="#cat_id#"<cfif attributes.cat_id is cat_id> selected</cfif>>#cat_title#</option>
						</cfloop>
					</select>
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>

			<tr>
				<td class="leftForm">Subcategory</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<select name="subcat_id" style='width:250px'>
						<option value="0"></option>
						<cfloop query="qSubCategories">
							<option value="#cat_id#"<cfif attributes.subcat_id is cat_id> selected</cfif>>#cat_title#</option>
						</cfloop>
					</select>
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>

			<tr>
				<td class="leftForm">Category 3</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<select name="cat3_id" style='width:250px'>
						<option value="0"></option>
						<cfloop query="qCategories3">
							<option value="#cat_id#"<cfif attributes.cat3_id is cat_id> selected</cfif>>#cat_title#</option>
						</cfloop>
					</select>
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>

			<tr>
				<td class="leftForm">Fast Find</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<input type="text" name="keyword" value="#attributes.keyword#" style='width:250px'>
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>

			<tr>
				<td class="formFooter" colspan="5">
					<input type="submit" value="Search" name='search' onMouseOver="this.className='buttonOver'" onMouseOut="this.className='button'" class="button">
				</td>
			</tr>

		</table>

	</form>

</cfoutput>