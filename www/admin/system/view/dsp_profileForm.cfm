<table id="formTable">
	<cfoutput>
		<form action="#myself##xfa.saveProfile#" method="post">
			<input type="hidden" name="prf_id" value="#attributes.prf_id#">
			<tr class="tableHeader">
				<td colspan='5'><div class="tableTitle">Process Add/Edit</div></td>
			</tr>
			
			<tr>
				<td class="leftForm">Name</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<input type="text" name="prf_name" value="#attributes.prf_name#">
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>
			<tr>
				<td class="leftForm">Description</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<textarea name='prf_description' cos='60' rows='3'>#attributes.prf_description#</textarea>
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>
			<tr>
				<td class="formFooter" colspan="5">
					<input type="submit" value="Save" name='save' onMouseOver="this.className='buttonOver'" onMouseOut="this.className='button'" class="button">
				</td>
			</tr>
		</form>
	</cfoutput>
</table>

<!--- <cfdump var='#attributes#'> --->