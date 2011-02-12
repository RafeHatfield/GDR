<?xml version="1.0" encoding="UTF-8"?>
<circuit access="public">
	
		
		<fuseaction name="memberForm" permissions="1,2,3,4,5|">
			<set name="attributes.mem_id" overwrite="no" value="0"/>
			<set name="attributes.grp_id" overwrite="no" value=""/>
			<set name="attributes.groupOther" overwrite="no" value=""/>
			 
			<if condition="isDefined('attributes.save')">
				<true>
					<invoke methodcall="memberSave(argumentCollection=attributes)" object="application.memberObj" returnVariable="attributes.mem_id"/>
					<invoke methodcall="memberGroupSave(mem_id=attributes.mem_id, grp_id=attributes.grp_id, groupOther=attributes.groupOther)" object="application.memberObj"/>
				</true>
			</if>
			
			<invoke methodcall="displayMemberForm(mem_id=attributes.mem_id)" object="application.memberObj" returnVariable="displayMemberFormOutput"/>
			
			<set name="content.mainContent" overwrite="yes" value="#displayMemberFormOutput#"/>
		</fuseaction>
	
		
		<fuseaction name="memberList" permissions="1,2,3,4,5|">
			<xfa name="editMember" value="member.memberForm"/>
			<xfa name="memberMessages" value="member.memberMessages"/>
			
			<set name="attributes.fastFind" overwrite="no" value=""/>
			<set name="attributes.groupList" overwrite="no" value="13"/>
			<set name="attributes.country" overwrite="no" value="0"/>
			
			<invoke methodcall="displayMemberSearch(argumentCollection=attributes)" object="application.memberObj" returnVariable="content.mainContent"/>
			 
			<if condition="isDefined('attributes.save')">
				<true>
					<invoke methodcall="approveMembers(attributes.approvedMembers)" object="application.memberObj"/>
				</true>
			</if>
			
			<invoke methodcall="getMembers(argumentCollection=attributes)" object="application.memberObj" returnVariable="qMembers"/>
			
			<do action="v_member.memberList" append="yes" contentVariable="content.mainContent"/>
		</fuseaction>
	
		
		<fuseaction name="memberMessages" permissions="1,2,3,4,5|">
			<set name="attributes.mem_id" overwrite="no" value="0"/>
			
			<invoke methodcall="getMemberMessages(mem_id=attributes.mem_id)" object="application.memberObj" returnVariable="qMemberMessages"/>
			 
			<do action="v_member.memberMessages" append="yes" contentVariable="content.mainContent"/>
		</fuseaction>
	
		
		<fuseaction name="newsletterForm" permissions="1,2,3,4,5|">
			<xfa name="saveNewsletter" value="member.newsletterForm"/>
			
			<set name="attributes.nsl_id" overwrite="no" value="0"/>
			
			<if condition="isDefined('attributes.save')">
				<true>
					<invoke methodCall="newsletterSave(argumentCollection=attributes)" object="application.contentObj" returnVariable="attributes.nsl_id"/>
				</true>
			</if>
			
			<invoke methodcall="getNewsletter(nsl_id=attributes.nsl_id)" object="application.contentObj" returnVariable="qNewsletter"/>
			<invoke methodcall="getNewsletterContent(nsl_id=attributes.nsl_id)" object="application.contentObj" returnVariable="qNewsletterContent"/>
			<invoke methodcall="getAllContent(approved=1,con_type='Content,Newsletter',excludeContent=valueList(qNewsletterContent.con_id))" object="application.contentObj" returnVariable="qAllContent"/>
			
			<if condition="qNewsletter.recordCount">
				<true>
					<set name="attributes.nsl_title" value="#qNewsletter.nsl_title#"/>
					<set name="attributes.nsl_body" value="#qNewsletter.nsl_body#"/>
				</true>
				<false>
					<set name="attributes.nsl_title" value=""/>
					<set name="attributes.nsl_body" value=""/>
				</false>
			</if>
			
			<do action="v_member.newsletterForm" append="yes" contentVariable="content.mainContent"/>
		</fuseaction>
	
		
		<fuseaction name="newsletterList" permissions="1,2,3,4,5|">
			<xfa name="editNewsletter" value="member.newsletterForm"/>
			<xfa name="sendNewsletter" value="member.newsletterSendForm"/>
			
			<invoke methodcall="getNewsletters()" object="application.contentObj" returnVariable="qNewsletters"/>
			
			<do action="v_member.newsletterList" append="yes" contentVariable="content.mainContent"/>
		</fuseaction>
	
		
		<fuseaction name="newsletterSendForm" permissions="1,2,3,4,5|">
			<xfa name="sendNewsletter" value="member.newsletterSendForm"/>
			
			<set name="attributes.nsl_id" overwrite="no" value="0"/>
			<set name="attributes.grp_id" overwrite="no" value=""/>
			<set name="attributes.cou_id" overwrite="no" value=""/>
			<set name="attributes.int_id" overwrite="no" value=""/>
			
			<set name="attributes.newslettersSent" overwrite="no" value="0"/>
			
			<if condition="isDefined('attributes.send')">
				<true>
					<invoke methodCall="newsletterSend(argumentCollection = attributes)" object="application.contentObj" returnVariable="attributes.newslettersSent"/>
				</true>
			</if>
			
			<invoke methodcall="getNewsletter(nsl_id=attributes.nsl_id)" object="application.contentObj" returnVariable="qNewsletter"/>
			<invoke methodcall="getGroups()" object="application.memberObj" returnVariable="qGroups"/>
			<invoke methodcall="getCountries()" object="application.memberObj" returnVariable="qCountries"/>
			<invoke methodcall="getInterests()" object="application.memberObj" returnVariable="qInterests"/>
			<invoke methodcall="getMemberNewsletter(nsl_id=attributes.nsl_id)" object="application.memberObj" returnVariable="qMemberNewsletter"/>
			
			<do action="v_member.newsletterSendForm" append="yes" contentVariable="content.mainContent"/>
			
			<do action="v_member.memberNewsletterList" append="yes" contentVariable="content.mainContent"/>
		</fuseaction>
	
		
		<fuseaction name="newsletterView" permissions="1,2,3,4,5|">
			<set name="attributes.nsl_id" overwrite="no" value="0"/>
			
			<invoke methodcall="getNewsletter(nsl_id=attributes.nsl_id)" object="application.contentObj" returnVariable="qNewsletter"/>
			<invoke methodcall="getNewsletterContent(nsl_id=attributes.nsl_id)" object="application.contentObj" returnVariable="qNewsletterContent"/>
			
			<do action="v_member.newsletterView" append="yes" contentVariable="content.mainContent"/>
		</fuseaction>
	
	</circuit>
