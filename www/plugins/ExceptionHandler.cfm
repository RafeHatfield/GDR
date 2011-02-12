<!--- FB40 plugin: ExceptionHandler --->
<!--- copyright: (c) 2003, by John Quarto-vonTivadar. You are free to use this FB40 plugin and to modify it as long as you leave my copyright notice intact. --->
<!--- use: during Phase "fuseactionException" --->
<!--- overview: if an exception occurs during execution of a fuseaction, this plugin will execute
 an exception handler template for it, in the following order:--->
<!---           1) fuseaction-specific exception handler, a template in the fuseaction's circuit named "exception.{fuseaction-name}.cfm" --->
<!---           2) circuit-wide exception handler, a template in the fuseaction's circuit named "exception.circuit.cfm" --->
<!---           3) application-wide exception handler, a template in the app root named "exception.fusebox.cfm --->
<!---           4) if none of the above is found, just rethrow the exception --->

<cfset plugin = myFusebox.plugins[myFusebox.thisPlugin]>	
<cfcatch type="any">
	<cfset plugin.fuseactionExceptionFile = "#application.fusebox.parseRootPath##application.fusebox.circuits[myFusebox.thisCircuit].path#exception.#myFusebox.thisFuseaction#.cfm">
	<cfset plugin.circuitExceptionFile = "#application.fusebox.parseRootPath##application.fusebox.circuits[myFusebox.thisCircuit].path#exception.circuit.cfm">
	<cfset plugin.fuseboxExceptionFile = "#application.fusebox.parseRootPath#exception.fusebox.cfm">
	
	<cfset plugin.myException = duplicate(cfcatch)>
	<cftry>
		<!--- first try looking for a fuseaction-specific exception handler --->
		<cfinclude template="#plugin.fuseactionExceptionFile#">
	
		<cfcatch type="missingInclude">
			<cftry>
				<!--- next try looking for a circuit-wide exception handler --->
				<cfinclude template="#plugin.circuitExceptionFile#">
				<cfcatch type="missingInclude">
					<cftry>
						<!--- finally try looking for a fusebox application-wide exception handler --->
						<cfinclude template="#plugin.fuseboxExceptionFile#">
						<cfset cfcatch = plugin.myException>
						<cfcatch type="any">
							<!--- hmm, well if it still isn't caught then just rethrow it --->
							<!--- this includes the case where any exception other than including the application-wide exception handler occurs --->
							<cfset cfcatch = plugin.myException>
							<cfrethrow>
						</cfcatch>
					</cftry>
				</cfcatch>
				<!--- if some error other than that the circuit-wide exception handler doesn't exist occurs then just rethrow it --->
				<cfcatch type="any">
					<cfset cfcatch = plugin.myException>
					<cfrethrow>
				</cfcatch>
			</cftry>
		</cfcatch>
	
		<!--- if some error other than that the fuseaction exception handler doesn't exist occurs then just rethrow it --->
		<cfcatch type="any">
			<cfset cfcatch = plugin.myException>
			<cfrethrow>
		</cfcatch>
		
	</cftry>

</cfcatch>


