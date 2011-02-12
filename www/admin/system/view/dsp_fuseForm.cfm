<table id="formTable">
	<cfoutput>
		<form action="#myself##xfa.saveFuse#" method="post">
			<input type="hidden" name="pro_id" value="#attributes.pro_id#">
			<input type="hidden" name="pfu_id" value="#attributes.pfu_id#">
			<tr class="tableHeader">
				<td colspan='5'><div class="tableTitle">Fuse Add/Edit in Process "#getProcess.pro_name#"</div></td>
			</tr>
			
			<tr>
				<td class="leftForm">Name</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<input type="text" name="pfu_name" value="#attributes.pfu_name#">
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>
			
			<tr>
				<td class="leftForm">Path</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<input type="text" name="pfu_path" value="#attributes.pfu_path#">
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>
			
			<tr>
				<td class="leftForm">XML</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<input type="text" name="pfu_circuitXML" value="#attributes.pfu_circuitXML#">
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>
			
			<tr>
				<td class="leftForm">Menu Item?</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<input type="checkbox" name="pfu_isMenu" value="1"<cfif attributes.pfu_isMenu is 1> checked</cfif>>
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>
			
			<tr>
				<td class="leftForm">Menu Title</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<input type="text" name="pfu_title" value="#attributes.pfu_title#">
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>
			
			<tr>
				<td class="leftForm">Menu Section</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<select name='mse_id'>
						<option value='0'>Select Menu Section</option>
						<option value='0'>-------------------</option>
						<cfloop query='getMenuSections'>
							<option value='#mse_id#'<cfif mse_id is attributes.mse_id> selected</cfif>>#mse_title#</option>
						</cfloop>
					</select>
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>
			
			<tr>
				<td class="leftForm">Menu Order</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<input type="text" name="pfu_menuOrder" value="#attributes.pfu_menuOrder#">
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>
			<!--- 
			<tr>
				<td class="leftForm">Permissions</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<select name='permissionsList' size='5' style='width:150px' multiple>
						<cfloop query='getProfiles'>
							<option value='#getProfiles.prf_id#'<cfif isBinary(getProfiles.prf_permissions) and application.permissionsObject.checkPermission(pfu_id,application.permissionsObject.binaryToStringPermissions(getProfiles.prf_permissions))> selected</cfif>>#getProfiles.prf_name#</option>
						</cfloop>
					</select>
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>
			 --->
			<tr>
				<td class="formFooter" colspan="5">
					<input type="submit" value="Save" name='save' onMouseOver="this.className='buttonOver'" onMouseOut="this.className='button'" class="button">
				</td>
			</tr>
		</form>
	</cfoutput>
</table>
