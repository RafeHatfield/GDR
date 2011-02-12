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
		
		<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.3.2/jquery.min.js"></script>
		<script type="text/javascript" src="assets/js/jquery.cycle.lite.1.0.min.js"></script>
		
		<script type="text/javascript">
			$(function() {
			    $('##slideshow').cycle({
			        delay: 2000,
			        speed: 500,
			        prev:   '##prev',
			        next:   '##next'
			    });
			    
			   <!---  $('##slideshow').cycle({
			        delay: 2000,
			        speed: 500,
			        prev:   '##prev',
			        next:   '##next',
			        timeout: 0
			    }); --->
			    
			   <!---  $('##slideshow3').cycle({
			        delay: 2000,
			        speed: 500,
			        before: onBefore
			    }); --->
			    
			    <!--- function onBefore() {
			        $('##title').html(this.alt);
			    } --->
			});
		</script>

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
				
		         <div class="product_box">

		             <div class="product_box_left_gallery">
		                #content.mainContent#
		             </div>
		             
		        <div style="float: right; margin-top: 545px"><a href="##" id="prev" class="np">< PREV</a> | <a href="##" id="next" class="np">NEXT ></a></div>
	             
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