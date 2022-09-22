function Get-AssemblyInfoVersion {
	param(
		[Parameter(Mandatory = $true)]
		[string]$FilePath,
		[Parameter(Mandatory = $true)]
		[string]$AttributeName
	)

	process {
		if(Test-Path $FilePath){
			$rawFile = Get-Content $FilePath | Out-String
			if ($rawFile -match ('(?<!// )\[assembly: ' + $AttributeName + '\(\"(?<version>.*)\"\)\]')) {
				[Version]($Matches.version)
			}
		}
	}
}