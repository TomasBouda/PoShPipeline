function Set-AllProjVersions {
	param(
		[Parameter(Mandatory = $true, ParameterSetName = 'FullVersion')]
		[Parameter(Mandatory = $true, ParameterSetName = 'Revision')]
		[string]$Path,
		[Parameter(Mandatory = $true, ParameterSetName = 'FullVersion')]
		[Version]$FullVersion,
		[Parameter(Mandatory = $true, ParameterSetName = 'Revision')]
		[int]$Revision,
		[Parameter(Mandatory = $false)]
		[bool]$SetFileVersion = $true,
		[Parameter(Mandatory = $false)]
		[bool]$SetAssemblyVersion = $true
	)

	Get-ChildItem -Path $Path | Where-Object { $_.PSIsContainer } | ForEach-Object { 
		$directory = $_.FullName
		switch ($PsCmdlet.ParameterSetName) { 
			'FullVersion' { 
				Set-ProjVersion -ProjectDirectory $directory -FullVersion $FullVersion -SetFileVersion $SetFileVersion -SetAssemblyVersion $SetAssemblyVersion
			} 
			'Revision' { 
				Set-ProjVersion -ProjectDirectory $directory -Revision $Revision -SetFileVersion $SetFileVersion -SetAssemblyVersion $SetAssemblyVersion
			} 
		}
	}
}