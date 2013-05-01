<cfif not len(trim(content.gloryBox))>
	<cfoutput>
		<div class="featured_photos">
		
			<div id="slider2" class="sliderwrapper">
				<cfloop query="request.qContentImages">
					<div class="contentdiv">
						<img src="#application.imagePath#gloryBox/#imageName#" alt="#imageTitle#" width="837" height="418" />
					</div>    
				</cfloop>             
			</div>        
<!--- 			
			<div id="slider2" class="sliderwrapper">
				<div class="contentdiv">
					<img src="#application.imagePath#featured_photos_img1.jpg" alt="" />
				</div>                    
				<div class="contentdiv">
					<img src="#application.imagePath#featured_photos_img2.jpg" alt="" />
				</div>                    
				<div class="contentdiv">
					<img src="#application.imagePath#featured_photos_img3.jpg" alt="" />
				</div>                
			</div>        
			<div id="paginate-slider2" class="pagination">                
				<span><a href="##" class="toc">01</a></span><span><a href="##" class="toc anotherclass">02</a></span><span><a href="##" class="toc">03</a></span>                
			</div>
			 --->        
			<div id="paginate-slider2" class="pagination">                
				<cfloop query="request.qContentImages"><span><a href="##" class="toc">0#request.qContentImages.currentRow#</a></span></cfloop>               
			</div>
			
			<script type="text/javascript">
			
			featuredcontentslider.init({
			    id: "slider2",  //id of main slider DIV
			    contentsource: ["inline", ""],  //Valid values: ["inline", ""] or ["ajax", "path_to_file"]
			    toc: "markup",  //Valid values: "##increment", "markup", ["label1", "label2", etc]
			    nextprev: ["Previous", "Next"],  //labels for "prev" and "next" links. Set to "" to hide.
			    revealtype: "click", //Behavior of pagination links to reveal the slides: "click" or "mouseover"
			    enablefade: [true, 0.2],  //[true/false, fadedegree]
			    autorotate: [false, 3000],  //[true/false, pausetime]
			    onChange: function(previndex, curindex){  //event handler fired whenever script changes slide
			        //previndex holds index of last slide viewed b4 current (1=1st slide, 2nd=2nd etc)
			        //curindex holds index of currently shown slide (1=1st slide, 2nd=2nd etc)
			    }
			})
			
			</script>
		
		</div>
	</cfoutput>
	
	<!--- 

	<cfoutput>

		<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab##version=6,0,29,0" height="400" width="800">

			<param name="movie" value="#application.flashPath##request.qContent.gbx_name#">
			<param name="quality" value="high">
			<param name="wmode" value="transparent">

			<embed src="#application.flashPath##request.qContent.gbx_name#" wmode="transparent" quality="high" pluginspage="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash" height="400" width="800">

		</object>

	</cfoutput>
 --->
</cfif>