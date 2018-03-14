<!DOCTYPE html>
<html>
	<head>
		<title>PHP Initial Test Page</title>
		<style>
		body {
		    width: 35em;
		    margin: 0 auto;
		    font-family: Tahoma, Verdana, Arial, sans-serif;
		}
		</style>
	</head>
	<body>
		<?php echo '<h1>Hello world !!!</h1>'; ?>
		<p>
			<?php echo $_SERVER['HTTP_USER_AGENT']; ?>
		</p>
	</body>
</html>
