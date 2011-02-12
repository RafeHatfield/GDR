<table id="formTable">
	<cfoutput>
		<form action="#myself##xfa.saveMenuSection#" method="post">
			<input type="hidden" name="mse_id" value="#attributes.mse_id#">
			<tr class="tableHeader">
				<td colspan='5'><div class="tableTitle">Menu Section Add/Edit</div></td>
			</tr>
			
			<tr>
				<td class="leftForm">Name</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<input type="text" name="mse_title" value="#attributes.mse_title#">
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>
			<tr>
				<td class="leftForm">Order</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<input type="text" name="mse_order" value="#attributes.mse_order#">
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