<?php
	$returnURL = $_REQUEST['return_url'];

	// Setup config
	$path = "";
	$rootpath = "ext=files";
	$user = "";

	// Change this to match the one in config.php
	$secretKey = "someSecretKey";

	// Generate hash
	$key = MD5($returnURL . $path . $rootpath . $user . $secretKey);
?>
<html>
<body onload="document.forms[0].submit();">
<form method="post" action="Authenticate.php">
	<input type="hidden" name="return_url" value="<?php echo htmlentities($returnURL); ?>" />
	<input type="hidden" name="path" value="<?php echo htmlentities($path); ?>" />
	<input type="hidden" name="rootpath" value="<?php echo htmlentities($rootpath); ?>" />
	<input type="hidden" name="user" value="<?php echo htmlentities($user); ?>" />
	<input type="hidden" name="key" value="<?php echo htmlentities($key); ?>" />
</form>
</body>
</html>