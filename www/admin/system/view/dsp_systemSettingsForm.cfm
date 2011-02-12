<cfoutput>

	<table id="formTable">

		<form action="#myself##xfa.saveSystemSettings#" method="post">

			<input type="hidden" name="sys_approval" value="#attributes.sys_approval#" />
			<input type="hidden" name="sys_buildNumber" value="#attributes.sys_buildNumber#" />

			<tr class="tableHeader">
				<td colspan='5'><div class="tableTitle">System Settings</div></td>
			</tr>
			
<!--- 
			<tr>
				<td class="leftForm">Content Needs Approval?</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<input type="checkbox" value="1" name="sys_approval"<cfif attributes.sys_approval is 1> checked</cfif>>
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>

			<tr>
				<td class="leftForm">Build Number</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<input type="text" name="sys_buildNumber" value="#attributes.sys_buildNumber#" style='width:50px'>
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>
 --->

			<tr>
				<td class="leftForm">Default Page Title</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					Great Dividing Range - <input type="text" name="sys_pageTitle" value="#attributes.sys_pageTitle#" style='width:200px'>
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>

			<tr>
				<td class="leftForm">Default Meta Description</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<textarea name="sys_metaDescription" style="width: 400px">#attributes.sys_metaDescription#</textarea>
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>

			<tr>
				<td class="leftForm">Default Meta Keywords</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<textarea name="sys_metaKeywords" style="width: 400px">#attributes.sys_metaKeywords#</textarea>
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

	</table>

</cfoutput>