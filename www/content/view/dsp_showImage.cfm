<cfoutput query="qImage">

	<cfif len(img_title)>

		<h1 align="center">#img_title#</h1>

		<br /><br />

	</cfif>

	<img src="#application.imagePath##img_origName#" alt="#img_altText#">

</cfoutput>
