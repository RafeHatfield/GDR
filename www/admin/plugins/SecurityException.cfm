<cfcatch type="SecurityException">
<cfoutput>
<!DOCTYPE html PUBLIC
"-//W3C//DTD XHTML 1.0 Strict//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
	<head>
		<title>Permissions Error</title>

		<link rel="stylesheet" href="css/default.css" type="text/css" media="screen">

	</head>

	<body>
		<table width='100%' border='0' bgcolor="##ffffff">
<!--- 			<tr>
				<td>
					<div id="header">
						<a id="logo" href="/"><img src="http://graphics.suite101.com/logo_print_5.gif" alt="Suite101" title="Suite101" width="300" height="100" style="position:relative: left:5px;" /><span></span></a>
						<div id="bannerAd"><br /><br /><br /><h1>ADMIN</h1></div>
					</div>
				</td>
			</tr> --->

			<tr>
				<td>
					<h1>Sorry - you dont have permission to access this page.</h1>
				</td>
			</tr>
		</table>
	</body>
</html>
</cfoutput>
</cfcatch>