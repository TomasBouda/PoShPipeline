function Set-AssemblyInfoVersion {
	param(
		[Parameter(Mandatory = $true)]
		[string]$FilePath,
		[Parameter(Mandatory = $true)]
		[string]$AttributeName,
		[Parameter(Mandatory = $true)]
		[Version]$FullVersion
	)

	Write-Output "Setting $AttributeName $FullVersion for $FilePath"

	if(Test-Path $FilePath){
		(Get-Content $FilePath) `
				-replace ('(?<!// )\[assembly: ' + $AttributeName + '\(\"(.*)\"\)\]'), ('[assembly: ' + $AttributeName + '("' + (Convert-VersionToString $FullVersion) + '")]') |
			Out-File $FilePath -Encoding utf8
	}
	else{
		Write-Warning "$FilePath not found!"
	}	
}