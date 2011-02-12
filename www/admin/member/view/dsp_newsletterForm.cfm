<cfoutput>

	<table id="formTable">

		<form action="#myself##xfa.saveNewsletter#" method="post">

			<input type="hidden" name="nsl_id" value="#attributes.nsl_id#">

			<tr class="tableHeader">
				<td colspan='5'><div class="tableTitle">Newsletter - <a href="#myself#member.newsletterView&nsl_id=#attributes.nsl_id#&displayMode=newsletter" target="_blank">Preview</a></div></td>
			</tr>

			<tr>
				<td class="leftForm">Title</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<input type="text" name="nsl_title" value="#attributes.nsl_title#" style='width:250px'>
				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>

			<tr>
				<td class="leftForm">Body</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>

					<cfmodule template="/assets/tiny_mce/tinyMCE.cfm"
					  instanceName="nsl_body"
					  value="#attributes.nsl_body#"
					  width="680"
					  height="200"
					  toolbarset="Basic" />

				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>

			<tr>
				<td class="leftForm">Addtional Content</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>

					<ul>
						<cfloop query="qNewsletterContent">
							<li>
								<cfif con_type is "Content" and not len(con_fuseAction)>
									<a href="#application.wwwURL#index.cfm?fuseAction=content.display&page=#con_sanitise#" target="_new">#con_Title#</a>
								<cfelseif con_type is "Content" and len(con_fuseAction)>
									<a href="#application.wwwURL#index.cfm?fuseAction=#con_fuseAction#&page=#con_sanitise#" target="_new">#con_Title#</a>
								<cfelse>
									#con_Title# (<a href="#con_link#" target="_blank">links to</a>)
								</cfif>
							</li>
						</cfloop>
					</ul>

				</td>
				<td class="whiteGutter">&nbsp;</td>
				<td class="rightForm">&nbsp;</td>
			</tr>

			<tr>
				<td class="leftForm">Add More Content</td>
				<td class="whiteGutter">&nbsp;</td>
				<td>
					<select name="con_id" style="width: 500">
						<option value="0"></option>
						<cfloop query="qAllContent">
							<option value="#con_id#">[#con_type#] #con_title#</option>
						</cfloop>
					</select>

					Order: <input type="text" value="" name="nlc_order" style="width: 20px" />

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