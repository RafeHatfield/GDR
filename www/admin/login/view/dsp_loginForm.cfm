<cfoutput>
	<br><br>
	<table align="center" border='0'>
		<form name="loginForm" method="post" action="#myself##xfa.dologin#">
			<tr>
				<td colspan="2">
				<cfif isDefined("attributes.message")>
					<p>#attributes.message#</p>
				</cfif>
				</td>
			</tr>
			
			<tr>
				<td>Username</td>
				<td><input type="text" name="username"></td>
			</tr>
			
			<tr>
				<td>Password</td>
				<td><input type="password" name="password"></td>
			</tr>

			<tr>
				<td colspan=2 align=right><input type="submit" value="Login" class="button" onMouseOver="this.className='buttonOver';" onMouseOut="this.className='button';"></td>
			</tr>
		</form>
	</table>
	<div align="center">
		#RepeatString('<br>', 20)#
	</div>
	<script language="JavaScript1.2">
		loginForm.username.focus();
	</script>
</cfoutput>
