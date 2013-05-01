<cfoutput>

	<cfif attributes.newslettersSent gt 0>
		<div><strong>#attributes.newslettersSent# emails sent.</strong></div>
	</cfif>
	<br /><br />
	<table id="formTable">

		<form action="#myself##xfa.sendNewsletter#" method="post">

			<input type="hidden" name="nsl_id" value="#attributes.nsl_id#">

			<tr class="tableHeader">
				<td colspan='5'><div class="tableTitle">Newsletter - <a href="#myself#member.newsletterView&nsl_id=#attributes.nsl_id#&displayMode=newsletter" target="_blank">Preview</a></div></td>
			</tr>

			<tr>
				<td class="leftForm">Title</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					#qNewsletter.nsl_title#
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>

			<tr>
				<td class="leftForm">Select Groups</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<select name="grp_id" multiple="true" size="8" style="width:250px">
						<cfloop query="qGroups">
							<option value="#qGroups.grp_id#">#qGroups.grp_title#</option>
						</cfloop>
					</select>
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>

			<tr>
				<td class="leftForm">Select Interests</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<select name="int_id" multiple="true" size="8" style="width: 250px">
						<cfloop query="qInterests">
							<option value="#int_id#">#int_title#</option>
						</cfloop>
					</select>
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>

			<tr>
				<td class="leftForm">Select Countries</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<select name="cou_id" multiple="true" size="8" style="width:250px">
						<cfloop query="qCountries">
							<option value="#qCountries.cou_id#">#qCountries.cou_title#</option>
						</cfloop>
					</select>
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>

			<tr>
				<td class="leftForm"></td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<input type="checkbox" value="1" name="resend" />

					Resend to people that have already received this newsletter?
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>

			<tr>
				<td class="formFooter" colspan="5">
					<input type="submit" value="Send" name="send" onMouseOver="this.className='buttonOver'" onMouseOut="this.className='button'" class="button">
				</td>
			</tr>

		</form>

	</table>

</cfoutput>