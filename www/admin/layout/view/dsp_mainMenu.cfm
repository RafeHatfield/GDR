<div>

	<div>
		<h1>GDR Admin</h1>
	</div>

	<div>

		<div>

			<cfoutput query='getMenu' group='mse_title'>

				<div>
					<span>#mse_title#</span>
				</div>

				<ul>
					<cfoutput>
						<li><a href="#myself##pro_name#.#pfu_name#">#pfu_title#</a></li>
					</cfoutput>
				</ul>

			</cfoutput>

		</div>

	</div>

</div>