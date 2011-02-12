<cfcontent reset="true"><cfoutput><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>

	<head>
		<cfparam name='request.pageTitle' default='' />
		<title>#request.pageTitle#</title>
		<meta name="system-status" content="online" />

		<link rel="stylesheet" href="css/default.css" type="text/css" media="screen">

	</head>

	<body #request.bodyParams#>

		<table width='100%' border='0'>

			<tr>
				<td>#content.headerBar#</td>
			</tr>

			<tr>
				<td align='center'>
					#content.mainContent#
				</td>
			</tr>

			<tr>
				<td>#content.footerBar#</td>
			</tr>

		</table>

	</body>

</html>

</cfoutput>