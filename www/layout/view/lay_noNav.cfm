<cfcontent reset="true"><cfoutput><html>
	<head>
		<cfparam name="request.pageTitle" default="Bali Resorts: Bali Sentosa Private Villas &amp; Spa in Seminyak Bali Resort" />
		<title>#request.pageTitle#</title>

		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<meta name="description" content="#request.metaDescription#" />
		<meta name="keywords" content="#request.metaKeywords#" />


		<link rel="stylesheet" href="assets/css/style.css" type="text/css" media="screen">

	</head>

	<body>

		<div id="container600">

			#trim(content.header)#

			<div class="clear"></div>

			<div>

				#trim(content.mainContent)#

			</div>

			<div class="clear"></div>

			#trim(content.footer)#

		</div>

	</body>

</html>
</cfoutput>