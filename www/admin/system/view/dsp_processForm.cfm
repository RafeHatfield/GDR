<table id="formTable">
	<cfoutput>
		<form action="#myself##xfa.saveProcess#" method="post">
			<input type="hidden" name="pro_id" value="#attributes.pro_id#">
			<tr class="tableHeader">
				<td colspan='5'><div class="tableTitle">Process Add/Edit</div></td>
			</tr>
			
			<tr>
				<td class="leftForm">Name</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<input type="text" name="pro_name" value="#attributes.pro_name#">
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>
			<tr>
				<td class="leftForm">Path</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<input type="text" name="pro_path" value="#attributes.pro_path#">
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