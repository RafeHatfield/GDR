<cfcontent reset="true"><cfoutput><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<cfparam name="request.pageTitle" default="Great Dividing Range" />
		<title>#request.pageTitle#</title>

		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<meta name="description" content="#request.metaDescription#" />
		<meta name="keywords" content="#request.metaKeywords#" />

		<link href="assets/css/main.css" rel="stylesheet" type="text/css" media="screen" />
		<link rel="stylesheet" type="text/css"  href="assets/css/listmenu_h.css" />
		<link rel="stylesheet" type="text/css" id="fsmenu-fallback"   href="assets/css/listmenu_fallback.css" />
		
		<script type="text/javascript" src="assets/js/fsmenu.js"></script>
		<script type="text/javascript" src="assets/js/scripts.js"></script>

	</head>

	<body>
	
		<div id="container">
		
			<!-- header begin-->
			<div id="header">
				#trim(content.header)#
				#trim(content.mainMenu)#
			</div>
			<!--header end-->
			
			<!-- content begin-->
			<div id="content">
				
				<cfif attributes.page is "home">
					
					<ul class="imgbox">
						<li><img src="#application.imagePath#homepage/pic_featured1.jpg" alt="" /></li>
						<li><img src="#application.imagePath#homepage/pic_featured2.jpg" alt="" /></li>
						<li><img src="#application.imagePath#homepage/pic_featured3.jpg" alt="" /></li>
						<li><img src="#application.imagePath#homepage/pic_featured4.jpg" alt="" /></li>
						<li class="marginright"><img src="#application.imagePath#homepage/pic_featured5.jpg" alt="" /></li>
						<li><img src="#application.imagePath#homepage/pic_featured6.jpg" alt="" /></li>
						<li><img src="#application.imagePath#homepage/pic_featured7.jpg" alt="" /></li>
						<li><img src="#application.imagePath#homepage/pic_featured8.jpg" alt="" /></li>
						<li><img src="#application.imagePath#homepage/pic_featured9.jpg" alt="" /></li>
						<li class="marginright"><img src="#application.imagePath#homepage/pic_featured10.jpg" alt="" /></li>         
					</ul>
					
				<cfelseif attributes.fuseAction is "content.display">
				
					<div class="about_box">
						
						#trim(content.mainContent)#
						
					</div>
					
				<cfelse>
				
					<div class="register_box">
						
						#trim(content.mainContent)#
					
					</div>
					
				</cfif>
			</div>
			<!-- content end-->
		</div>
<script type="text/javascript">
var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
</script>
<script type="text/javascript">
try {
var pageTracker = _gat._getTracker("UA-15130623-1");
pageTracker._trackPageview();
} catch(err) {}</script>		
	</body>

</html>
<!-- #cookie.gdrProductList#<br />#cookie.gdrUserID# -->
</cfoutput>

<cfif isDefined("url.imageResize")>

	<cfdirectory action="list" name="imageSet" directory="#application.imageUploadPath#products/original/" />
	
	<cfset imageInterpolation = "highPerformance" />

	<cfoutput>
		<cfloop query="imageSet">
			<cfif listLen(name,".") eq 2>
		<!--- 		<cfset newFileName = replaceNoCase(name,"-","","all") />
				<cfset newFileName = replaceNoCase(newFileName," ","","all") />
				#name# - #newFileName#
				<cfif name neq newFileName>
					<cffile action="rename" destination="#application.imageUploadPath#products/#newFileName#" source="#application.imageUploadPath#products/#name#" />
					: renamed!
				</cfif>
				<br /> --->
				
				
				<!--- 
				<cfset newFileName = listGetAt(name,1,".") & "_120." & listGetAt(name,2,".") />
				
				#newFileName#<br />
		
				<cfimage action="read" name="imageInMem" source="#application.imageUploadPath#products/original/#name#" />
		
				<cfimage action="info" source="#imageInMem#" structName="ImageCR" />
		
				<cfset origWidth = imageCR.width />
				<cfset origHeight = imageCR.height />
		
				<cfset ImageSetAntialiasing(imageInMem) />
				
				<cfif origWidth gt origHeight>
					
					<cfset ImageResize(imageInMem, "120", "", imageInterpolation) />
					<cfset ImageCrop(imageInMem, "0", "0", "120", "120") />
				
				<cfelse>
				
					<cfset ImageResize(imageInMem, "", "120", imageInterpolation) />
					<cfset ImageCrop(imageInMem, "0", "0", "120", "120") />
				
				</cfif>
		
				<cfimage source="#imageInMem#" action="write" destination="#application.imageUploadPath#products/#newFileName#" overwrite="yes" />
				 --->
				 
				<cfset newFileName = listGetAt(name,1,".") & "_main." & listGetAt(name,2,".") />
				
				#newFileName#<br />
		
				<cfimage action="read" name="imageInMem" source="#application.imageUploadPath#products/original/#name#" />
		
				<cfimage action="info" source="#imageInMem#" structName="ImageCR" />
		
				<cfset origWidth = imageCR.width />
				<cfset origHeight = imageCR.height />
		
				<cfset ImageSetAntialiasing(imageInMem) />
				
				<cfif origWidth gt origHeight>
					
					<cfset ImageResize(imageInMem, "350", "", imageInterpolation) />
				
				<cfelse>
				
					<cfset ImageResize(imageInMem, "", "350", imageInterpolation) />
				
				</cfif>
		
				<cfimage source="#imageInMem#" action="write" destination="#application.imageUploadPath#products/#newFileName#" overwrite="yes" />

			</cfif>
		</cfloop>
	</cfoutput>
	
	<cfdump var="#imageSet#" />
</cfif>


















