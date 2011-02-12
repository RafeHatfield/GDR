<cfoutput>
	<h1 class="ACP">#request.t("online_profile")#</h1>

	<div style="padding-bottom:5px"><a href="http://#request.fullMainDomain#/profile.cfm/#attributes.name#" target='_new' rel="nofollow">#request.t("view_current_profile")#</a></div>
	
	<cfif IsDefined("attributes.updated")>
		<div class="ACP_green">#request.t("updated_successfully")#</div><br />
	<cfelseif isdefined("attributes.errorMsg")>
		<div class="ACP_red"><ul class="ACP">#error_message#</ul></div><br />
	<cfelseif isdefined("uc_obj_error_struct.body_a_tag")>
		<div class="ACP_red">#uc_obj_error_struct.body_a_tag#</div><br />
	<cfelseif isdefined("uc_obj_error_struct.body")>
		<div class="ACP_red">#uc_obj_error_struct.body#</div><br />
	<cfelse>
		<hr class="ACP" />
	</cfif>

	<h2 class="ACP">#request.t("profile_options")#</h2>

	<form action="#myself##xfa.saveMemberProfile#" method="post" enctype="multipart/form-data" class="mysuite_form">
	
	<div class="ele">
		<div class="e1">#request.t("your_personal_homepage")#</div>
		<div class="e2"><input type="text" name="url" value="#attributes.url#" maxlength="128" class="ACP_medium" /></div>
		<div class="clear_both"></div>
	</div>

	<div class="ele">
		<div class="e1">&nbsp;</div>
		<div class="e2">
			<cfif (is_feature_writer OR is_editor OR is_contributing_writer OR is_inactive_writer)>
				<input type="checkbox" checked="checked" disabled="disabled" />
				<input type="hidden" name="show_full_name" value="1" />

			<cfelse>
				<input type="checkbox" name="show_full_name" value="1" <cfif attributes.show_full_name EQ 1>checked="checked"</cfif> />

			</cfif>
			#request.t("display_my_full_name_rather_than_my_username")#
		</div>

		<div class="clear_both"></div>
	</div>

	<div class="ele">
		<div class="e1">&nbsp;</div>
		<div class="e2">
			<cfif (is_feature_writer OR is_editor OR is_contributing_writer OR is_inactive_writer)>
				<input type="checkbox" checked="checked" disabled="disabled" />
				<input type="hidden" name="is_contactable" value="1" />
			<cfelse>
				<input type="checkbox" name="is_contactable" value="1" <cfif attributes.is_contactable EQ 1>checked="checked"</cfif> />
			</cfif>
			#request.t("allow_suite101_readers_to_contact_me")#
			<br /><span class="note point_pad">#request.t("your_email_address_will_not_be_accessible")#</span>
		</div>
		<div class="clear_both"></div>
	</div>

	<h2 class="ACP">#request.t("profile_text")#</h2>


	<cfset showTextArea = 0 />
	<cfif attributes.text EQ 0>
		<cftry>
			<cfscript>
				body_fckEditor_obj.create(); // create the editor.
			</cfscript> 
			<cfcatch type="any">
				<cfset showTextArea = 1 />
			</cfcatch>
		</cftry>					
	<cfelse>
		<cfset showTextArea = 1 />
	</cfif>
	<cfif showTextArea>
		<textarea name="profile" style="width:595px; height:300px;" wrap="virtual" class="element_width_01">#attributes.profile#</textarea>
	</cfif>
	
	<br />
	<h2><div class="limeTitle">#request.t("profile_image")#</div></h2>

	<cfif getImage.recordcount>
		<table class="ACP">
			<tr>
				<th class="ACP_blue" colspan="6">#request.t("current_image")#</th>
			</tr>
			<tr>
				<th class="ACP_silver" style="text-align:center;">#request.t("image")#</th>
				<th class="ACP_silver">#request.t("caption")#</th>
				<th class="ACP_silver">#request.t("credit")#</th>
				<th class="ACP_silver" style="text-align:center; width:1%; white-space:nowrap;">#request.t("file_date")#</th>
				<th class="ACP_silver" style="text-align:center; width:1%; white-space:nowrap;">#request.t("file_size")#</th>
				<th class="ACP_silver" style="text-align:center; width:1%; white-space:nowrap;">#request.t("delete")#</th>
			</tr>
			<tr>
				<td class="ACP_white" style="width:1%"><cf_display_image instance_id="#attributes.member_id#" object_id="14" image_type_id="3"></td>
				<td class="ACP_white">#getImage.caption#</td>
				<td class="ACP_white">#getImage.credit#</td>
				<td class="ACP_white" style="text-align:center; width:1%; white-space:nowrap;">#dateFormat(getImage.insert_date,"mmmm d yyyy")#</td>
				<td class="ACP_white" style="text-align:center; width:1%; white-space:nowrap;">#numberFormat(evaluate(getImage.filesize/1000),"_.__")# KB</td>
				<td class="ACP_white" style="text-align:center; width:1%; white-space:nowrap;"><input type="Submit" name="Delete" value="#request.t("delete_lc")#" class="button" onClick="return confirm('#request.t("are_you_sure_delete_image")#');"></td>
			</tr>
		</table>
	</cfif>

	<div style="margin-top:10px">
		<cfif getImage.recordcount>
			<h2>#request.t("attach_new_photo")#</h2>
		<cfelse>
			<h2>#request.t("attach_photo")#</h2>
		</cfif>
		<cfif isdefined("error.portraitImage")><span class="error">#error.image#</span><br /></cfif>
		<span class="note note_colour">#request.t("portrait_form_image")#</span><br />
		<input type="file" name="image" size="56" accept="image/*"<cfif isdefined("portraitFilename")> value="#portraitFilename#"</cfif> class="mysuite_form_ele" /><br />
	</div>
	<div style="margin-top:10px">
		<h2>#request.t("photo_caption")#</h2>
		<cfif isdefined("error.PortraitCaption")><span class="error">#error.caption#</span><br /></cfif>
		<span class="note note_colour">#request.t("portrait_form_image_caption")#</span><br />
		<input type="text" name="caption" value="#attributes.caption#" maxlength="50" class="ACP_medium" />
	</div>
	<div style="margin-top:10px">
		<h2>#request.t("photo_credit")#</h2>
		<cfif isdefined("error.PortraitCredit")><span class="error">#error.credit#</span><br /></cfif>
		<span class="note note_colour">#request.t("portrait_form_image_credit")#</span><br />
		<input type="text" name="credit" value="#attributes.credit#" maxlength="50" class="ACP_medium" />
	</div>
	
	<div class="ACP_buttons">
		<input type="submit" name="save" value="#request.t("save_lc")#" class="button" />
		<input type="submit" name="cancel" value="#request.t("cancel_lc")#" class="button" />
	</div>


	</form>
	<br class="clear_both" />
</cfoutput>
