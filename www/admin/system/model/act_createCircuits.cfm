
<!--- <cfsilent> --->

<cfparam name="url.doThisFuse" default="" />

<cfquery name="getFuses" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
	select pro_id, pro_name, pfu_CircuitXML, pfu_name, pfu_path<!--- , prf_id --->
	FROM Process
	INNER JOIN ProcessFuses ON pfu_process = pro_id
		LEFT OUTER JOIN ProfileFuses pff ON pff_processFuse = pfu_id
		LEFT OUTER JOIN Profiles prf ON prf_id = pff_processFuse
	WHERE 1 = 1
		<cfif Len(url.doThisFuse) AND ListLen(url.dothisFuse,".") eq 2>
			AND pro_name = '#ListFirst(url.doThisFuse,".")#'
			AND pfu_name = '#ListLast(url.doThisFuse,".")#'
		</cfif>
	ORDER BY pro_name, pfu_name
</cfquery>

<cfprocessingdirective suppresswhitespace="yes">
<cfoutput query="getFuses" group="pro_name">

<!--- If directory for circuit dont exist - create it --->
<cfset path = GetDirectoryFromPath(GetTemplatePath()) & pro_name />
<cfset viewpath = path & "/view/" />
<cfset modelpath = path & "/model/" />

<cfif NOT DirectoryExists(path)>
	<cfdirectory action="create" directory="#path#/" />
</cfif>
<cfif NOT DirectoryExists(viewpath)>
	<cfdirectory action="create" directory="#viewpath#" />
</cfif>
<cfif NOT DirectoryExists(modelpath)>
	<cfdirectory action="create" directory="#modelpath#" />
</cfif>
<!--- <cfoutput>#application.rootDir# #path# #viewpath# #modelpath# <cfdump var="#getFuses#"></cfoutput><cfabort> --->
<!--- if the model or view has not circuit.xml create it --->

<cfif NOT fileExists(viewpath & "circuit.xml")>
	<cffile action="copy" source="#application.rootDir#/circuit.xml.template" destination="#viewpath#/circuit.xml" />
</cfif>
<cfif NOT fileExists(modelpath & "circuit.xml")>
	<cffile action="copy" source="#application.rootDir#/circuit.xml.template" destination="#modelpath#/circuit.xml" />
</cfif>

<!--- If we specified a fuse --->
<cfif Len(url.doThisFuse) AND ListLen(url.dothisFuse,".") eq 2>
	<!--- open circuit.xml and read into var --->
	<cfset circuit = xmlParse("#path#/circuit.xml.cfm")/>
	<!--- XML search on the fuseaction name="ListLast(url.doThisFuse,".")" --->

	<!--- remove fuseaction --->

	<!--- Insert new fuseaction with XMLElemNew --->

<!--- doing the complete application --->
<cfelse>
	<!--- use cfxml to make it well formed --->
	<cfxml casesensitive="no" variable="circuit">
	<?xml version='1.0' encoding='utf-8' ?>
	<circuit access="public">
	<cfoutput group="pfu_name"><!--- output the fuse --->
		<cfset accessList = "" />
		<cfset viewList = "" />
		<cfset editList = "" />
		<cfset fuseXML = "" />
		<cfset filename = listLast(pfu_path,"/") />
		<!--- build view/edit lists --->
<!--- 		<cfoutput>
			<cfset editList = listappend(editList, prf_id, ",")>
		</cfoutput> --->
		<cfset editList = '1,2,3,4,5'>
		<!--- FB4.1 has permissions= in fuseaction element of circuits so pipe them so we can pass both view and edit --->
		<cfset accessList = editList & "|" & viewList />
		<!--- if xml has been written for fuse grab it --->
		<!--- <cfif listLast(fileName,".") EQ "xml">
			<cffile action="read" variable="fuseXML" file="#application.rootDir#/#pfu_path#" />
		</cfif> --->
		<!--- if circuitXML has name of circuit XML in --->
		<cfif Len(pfu_circuitXML) and FileExists("#application.rootDir#/#pro_name#/#pfu_circuitXML#")>
			<cffile action="read" variable="fuseXML" file="#application.rootDir#/#pro_name#/#pfu_circuitXML#" />
		</cfif>
		<!--- write out the fuse --->
		<fuseaction name='#pfu_name#' permissions='#accessList#'>
			<cfif Len(fuseXML) gt 0>#Replace(fuseXML, "#chr(13)##chr(10)#", "#chr(13)##chr(10)##chr(9)##chr(9)##chr(9)#", "ALL")#<cfelse>
			<!--- for legacy purposes - you should be working away from this--->
			<cfif listfirst(fileName,"_") EQ "dsp">
			<include template="view/#fileName#" contentvariable="content.maincontent" />
			<cfelse>
			<include template="model/#fileName#" />
			</cfif>
			</cfif>
		</fuseaction>
	</cfoutput>
	</circuit>
	</cfxml>
</cfif>
	<!--- save output to file --->
	<cffile action="write" file="#path#/circuit.xml.cfm" output="#circuit#" />
</cfoutput>

<!--- delete parsed file for a fuse if specified --->
<cfif Len(url.doThisFuse) AND ListLen(url.dothisFuse,".") eq 2>
	<cffile action="delete" file="#application.rootDir#parsed/#url.doThisFuse#.cfm" />
</cfif>

</cfprocessingdirective>
<!--- </cfsilent> --->