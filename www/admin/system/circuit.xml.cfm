<?xml version="1.0" encoding="UTF-8"?>
<circuit access="public">
	
		
		<fuseaction name="fuseList" permissions="1,2,3,4,5|">
			<xfa name="saveFuse" value="system.fuseList"/>
			
			<set name="attributes.pfu_id" overwrite="false" value="0"/>
			<set name="attributes.pro_id" overwrite="false" value="0"/>
			<set name="attributes.pfu_isMenu" overwrite="false" value="0"/>
			<set name="attributes.permissionsList" overwrite="false" value=""/>
			
			<if condition="isDefined('attributes.save')">
				<true>
					<do action="m_system.fuseListAction"/>
				</true>
			</if>
			
			<do action="m_system.getFuse"/>
			
			<if condition="getFuse.recordCount gte 1">
				<true>
					<set name="attributes.pfu_name" value="#getFuse.pfu_name#"/>
					<set name="attributes.pfu_path" value="#getFuse.pfu_path#"/>
					<set name="attributes.pfu_circuitXML" value="#getFuse.pfu_circuitXML#"/>
					<set name="attributes.pfu_isMenu" value="#getFuse.pfu_isMenu#"/>
					<set name="attributes.pfu_title" value="#getFuse.pfu_title#"/>
					<set name="attributes.pfu_menuOrder" value="#getFuse.pfu_menuOrder#"/>
					<set name="attributes.mse_id" value="#getFuse.pfu_menuSection#"/>
					
					<!--
					<do action="m_system.getFuseProfilePermissions" />
					<set name="attributes.fuseProfilePermissionsList" value="#valueList(getFuseProfilePermissions.pff_profile)#" />
					-->
				</true>
				<false>
					<set name="attributes.pfu_name" value=""/>
					<set name="attributes.pfu_path" value=""/>
					<set name="attributes.pfu_circuitXML" value=""/>
					<set name="attributes.pfu_isMenu" value="0"/>
					<set name="attributes.pfu_title" value=""/>
					<set name="attributes.pfu_menuOrder" value="0"/>
					<set name="attributes.mse_id" value="0"/>
					
					<!--
					<set name="attributes.fuseProfilePermissionsList" value="" />
					-->
				</false>
			</if>
			
			<do action="m_system.getProcess"/>
			<do action="m_system.getProcesses"/>
			<do action="m_system.getMenuSections"/>
			<!-- <do action='m_system.getProfiles' /> -->
			
			<do action="v_system.fuseForm" append="yes" contentVariable="content.mainContent"/>
			
			<do action="m_system.getFuses"/>
			
			<do action="v_system.fuseList" append="yes" contentVariable="content.mainContent"/>
		</fuseaction>
	
		
		<fuseaction name="memberForm" permissions="1,2,3,4,5|">
			<xfa name="saveMember" value="system.memberForm"/>
			<xfa name="changePassword" value="system.passwordForm"/>
			
			<set name="attributes.usr_id" overwrite="false" value="0"/>
			<set name="attributes.prf_id" overwrite="false" value="0"/>
			
			<if condition="isDefined('attributes.save')">
				<true>
					<do action="m_system.memberAction"/>
					<relocate addtoken="false" type="client" url="#myself#system.memberList"/>
				</true>
			</if>
			
			<do action="m_system.getMember"/>
			<do action="m_system.getProfiles"/>
			
			<!-- this section will be expanded to include all the details about a member - limiting to name and profile for now -->
			<if condition="getMember.recordCount gte 1">
				<true>
					<set name="attributes.usr_firstName" value="#getMember.usr_firstName#"/>
					<set name="attributes.usr_surname" value="#getMember.usr_surname#"/>
					<set name="attributes.usr_email" value="#getMember.usr_email#"/>
					<set name="attributes.usr_password" value="#getMember.usr_password#"/>
					<set name="attributes.prf_id" value="#getMember.usr_profile#"/>
				</true>
				<false>
					<set name="attributes.usr_firstName" overwrite="false" value=""/>
					<set name="attributes.usr_surname" overwrite="false" value=""/>
					<set name="attributes.usr_email" overwrite="false" value=""/>
					<set name="attributes.usr_password" overwrite="false" value=""/>
					<set name="attributes.prf_id" value="0"/>
				</false>
			</if>
			
			<do action="v_system.memberForm" append="yes" contentVariable="content.mainContent"/>
		</fuseaction>
	
		
		<fuseaction name="memberList" permissions="1,2,3,4,5|">
			<xfa name="searchMember" value="system.memberList"/>
			<xfa name="editMember" value="system.memberForm"/>
			<xfa name="memberPermissions" value="system.memberPermissions"/>
			<xfa name="memberProfile" value="system.memberProfile"/>
			
			<set name="attributes.prf_id" overwrite="false" value="0"/>
			<set name="attributes.fastFind" overwrite="false" value=""/>
			<set name="attributes.city" overwrite="false" value=""/>
			<set name="attributes.state" overwrite="false" value=""/>
			<set name="attributes.country" overwrite="false" value=""/>
			
			<do action="m_system.getProfiles"/>
			
			<do action="v_system.memberSearch" append="yes" contentVariable="content.mainContent"/>
			
			<do action="m_system.getMembers"/>
			
			<do action="v_system.memberList" append="yes" contentVariable="content.mainContent"/>
		</fuseaction>
	
		
		<fuseaction name="menuSectionList" permissions="1,2,3,4,5|">
			<xfa name="saveMenuSection" value="system.menuSectionList"/>
			<xfa name="editMenuSection" value="system.menuSectionList"/>
			
			<set name="attributes.mse_id" overwrite="false" value="0"/>
			
			<if condition="isDefined('attributes.save')">
				<true>
					<do action="m_system.menuSectionAction"/>
				</true>
			</if>
			
			<do action="m_system.getMenuSection"/>
			<if condition="getMenuSection.recordCount gte 1">
				<true>
					<set name="attributes.mse_title" value="#getMenuSection.mse_title#"/>
					<set name="attributes.mse_order" value="#getMenuSection.mse_order#"/>
				</true>
				<false>
					<set name="attributes.mse_title" value=""/>
					<set name="attributes.mse_order" value="0"/>
				</false>
			</if>
			
			<do action="v_system.menuSectionForm" append="yes" contentVariable="content.mainContent"/>
			
			<do action="m_system.getMenuSections"/>
			
			<do action="v_system.menuSectionList" append="yes" contentVariable="content.mainContent"/>
		</fuseaction>
	
		
		<fuseaction name="processList" permissions="1,2,3,4,5|">
			<xfa name="saveProcess" value="system.processList"/>
			<xfa name="fuseList" value="system.fuseList"/>
			
			<set name="attributes.pro_id" overwrite="false" value="0"/>
			
			<if condition="isDefined('attributes.save')">
				<true>
					<do action="m_system.processAction"/>
				</true>
			</if>
			
			<do action="m_system.getProcess"/>
			
			<if condition="getProcess.recordCount gte 1">
				<true>
					<set name="attributes.pro_name" value="#getProcess.pro_name#"/>
					<set name="attributes.pro_path" value="#getProcess.pro_path#"/>
				</true>
				<false>
					<set name="attributes.pro_name" value=""/>
					<set name="attributes.pro_path" value=""/>
				</false>
			</if>
			
			<do action="v_system.processForm" append="yes" contentVariable="content.mainContent"/>
			
			<do action="m_system.getProcesses"/>
			
			<do action="v_system.processList" append="yes" contentVariable="content.mainContent"/>
		</fuseaction>
	
		
		<fuseaction name="profileList" permissions="1,2,3,4,5|">
			<xfa name="saveProfile" value="system.profileList"/>
			<xfa name="editProfile" value="system.profileList"/>
			<xfa name="permissionsList" value="system.profilePermissions"/>
			
			<set name="attributes.prf_id" overwrite="false" value="0"/>
			
			<if condition="isDefined('attributes.save')">
				<true>
					<do action="m_system.profileAction"/>
				</true>
			</if>
			
			<do action="m_system.getProfile"/>
			
			<if condition="getProfile.recordCount gte 1">
				<true>
					<set name="attributes.prf_name" value="#getProfile.prf_name#"/>
					<set name="attributes.prf_description" value="#getProfile.prf_description#"/>
				</true>
				<false>
					<set name="attributes.prf_name" value=""/>
					<set name="attributes.prf_description" value=""/>
				</false>
			</if>
			
			<do action="v_system.profileForm" append="yes" contentVariable="content.mainContent"/>
			
			<do action="m_system.getProfiles"/>
			
			<do action="v_system.profileList" append="yes" contentVariable="content.mainContent"/>
		</fuseaction>
	
		
		<fuseaction name="profilePermissions" permissions="1,2,3,4,5|">
			<xfa name="saveProfilePermissions" value="system.profilePermissions"/>
			
			<set name="attributes.prf_id" overwrite="false" value="0"/>
			<set name="attributes.profilePermissionsList" overwrite="false" value=""/>
			
			<if condition="isDefined('attributes.save')">
				<true>
					<do action="m_system.profilePermissionsUpdate"/>
				</true>
			</if>
			
			<do action="m_system.getProfile"/>
			<do action="m_system.getFuses"/>
			<do action="m_system.getProfilePermissions"/>
			
			<set name="attributes.thisProfilePermissionsList" value="#valueList(getProfilePermissions.pff_processFuse)#"/>
			
			<do action="v_system.profilePermissionsList" append="yes" contentVariable="content.mainContent"/>
		</fuseaction>
	
		
		<fuseaction name="systemSettings" permissions="1,2,3,4,5|">
			<xfa name="saveSystemSettings" value="system.systemSettings"/>
			
			<if condition="isDefined('attributes.save')">
				<true>
					<invoke methodcall="systemSettingsSave(argumentCollection=attributes)" object="application.systemObj"/>
				</true>
			</if>
			 
			<invoke methodcall="getSystemSettings()" object="application.systemObj" returnVariable="qSystemSettings"/>
			
			<if condition="qSystemSettings.recordCount gte 1">
			
				<true>
					<set name="attributes.sys_approval" value="#qSystemSettings.sys_approval#"/>
					<set name="attributes.sys_buildNumber" value="#qSystemSettings.sys_buildNumber#"/>
					<set name="attributes.sys_metaDescription" value="#qSystemSettings.sys_metaDescription#"/>
					<set name="attributes.sys_metaKeywords" value="#qSystemSettings.sys_metaKeywords#"/>
					<set name="attributes.sys_pageTitle" value="#qSystemSettings.sys_pageTitle#"/>
				</true>
				
				<false>
					<set name="attributes.sys_approval" value="0"/>
					<set name="attributes.sys_buildNumber" value="0"/>
					<set name="attributes.sys_metaDescription" value=""/>
					<set name="attributes.sys_metaKeywords" value=""/>
					<set name="attributes.sys_pageTitle" value=""/>
				</false>
				
			</if>
			
			<do action="v_system.systemSettingsForm" append="yes" contentVariable="content.mainContent"/>
		</fuseaction>
	
	</circuit>
