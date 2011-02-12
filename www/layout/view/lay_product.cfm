<cfcontent reset="true"><cfoutput><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<cfparam name="request.pageTitle" default="Great Dividing Range, Bali" />
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
	<cfparam name="request.googleMap" default="0" />
	<body<cfif request.googleMap> onload="load()" onunload="GUnload()"</cfif>>
	
		<div id="container">
		
			<!-- header begin-->
			<div id="header">
				#trim(content.header)#
				#trim(content.mainMenu)#
			</div>
			<!--header end-->
			
			<!-- content begin-->
			<div id="content">
				
		         <div class="product_box">
		         
		             <div class="product_box_left">
		             
		                 <div class="menu">
		                     <h2>product</h2>
		                     #content.categoryMenu#
		                 </div>
		                 
		                 <div class="submenu">
			                 #content.subCategoryMenu#        
		                 </div>
		                 
		             </div>
		             
		             <div class="product_box_right">
		             
<!--- 		                <div class="flexcroll_wrapper"> --->
		                
		                	#content.mainContent#
		                	
		                <!--- </div> --->
		                
		                 <!---  <div class="pages">
		                  <div class="pages_left"><a href="##">&lt;</a> <a href="##">1</a>|<a href="##">2</a>|<a href="##">3</a>|<a href="##">4</a>|<a href="##">5</a>| ... <a href="##">&gt;</a></div>
		                    <a href="##">view all thumbnails</a>
		                </div> --->
		                
		             </div>
		             
		         </div>
		
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
</cfoutput>