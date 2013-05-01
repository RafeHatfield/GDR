<br /><br />

<cfparam name="attributes.emailsOnly" default="0" />

<cfoutput>

	<table id="dataTable">
		<cfif not attributes.emailsOnly>
		<form name="productOrder" action="#request.myself#member.memberList" method="post">
					
			<tr class="tableHeader">
				<td colspan="4">
					<div class="tableTitle">Member List</div>
					<div class="showAll">#qMembers.recordCount# Records</div>
				</td>
			</tr>
	
			<tr>
				<th style="text-align:center;">ID</th>
				<th>Name</th>
				<th>Email</th>
				<th>Communication</th>
				<th>Approved</th>
			</tr>
	
			<cfloop query='qMembers'>
	
				<tr <cfif currentRow mod 2 eq 0>class="darkData"<cfelse>class="lightData"</cfif>>
					<td align="center">#mem_id#</td>
					<td><a href="#myself##xfa.editMember#&mem_id=#mem_id#">#mem_title# #mem_firstName# #mem_surname#</a></td>
					<td>#mem_email#</td>
					<td>
						<cfif val(messageCount) gt 0>
							<a href="#myself##xfa.memberMessages#&mem_id=#mem_id#">View Communication</a>
						<cfelse>
							-
						</cfif>
					</td>
					<td><input type="checkbox" value="#mem_id#" name="approvedMembers" <cfif mem_approved> checked</cfif> /></td>
				</tr>
	
			</cfloop>
							
			<tr>
				<td class="formFooter" colspan="6">
					<input type="submit" value="save" name='save' onMouseOver="this.className='buttonOver'" onMouseOut="this.className='button'" class="button" />
				</td>
			</tr>
							
		</form>
			
		<cfelse>
			
			<tr class="tableHeader">
				<td>
					<div class="tableTitle">Email List</div>
					<div class="showAll">#qMembers.recordCount# Records</div>
				</td>
			</tr>
			
			<tr>
				<th>If you use this for a mail out, <strong>make sure</strong> you put this list into the "bcc" field</th>
			</tr>
			
			<tr>
				<td><cfloop query='qMembers'><cfif len(trim(mem_email)) and findNoCase("@",mem_email)>#mem_email#<cfif qMembers.currentRow neq qMembers.recordCount>, </cfif></cfif></cfloop></td>
			</tr>
			
		</cfif>

	</table>

</cfoutput>