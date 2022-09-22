enum VersionType{
	Major
	Minor
	Build
	Revision
}

function Update-Version{
	[cmdletbinding()]
	param(
		[Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'Manual')]
		[Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'Increase')]
		[Version]$Version,
		[Parameter(Mandatory = $true, ParameterSetName = 'Manual')]
		[Parameter(Mandatory = $true, ParameterSetName = 'Increase')]
		[ValidateNotNullOrEmpty()]
		[VersionType]$Type,
		[Parameter(Mandatory = $true, ParameterSetName = 'Manual')]
		[int]$Value,
		[Parameter(Mandatory = $true, ParameterSetName = 'Increase')]
		[switch]$Increase
	)

	begin{
		$TargetVersion = $Value
	}
	process{
		switch($Type){
			Major{
				if($Increase){
					$TargetVersion = $Version.Major + 1 
				}

				if($Version.Revision -ge 0){
					[Version]::new($TargetVersion, $Version.Minor, $Version.Build, $Version.Revision)
				}
				else{
					[Version]::new($TargetVersion, $Version.Minor, $Version.Build)
				}
			}
			Minor{
				if($Increase){
					$TargetVersion = $Version.Minor + 1
				}

				if($Version.Revision -ge 0){
					[Version]::new($Version.Major, $TargetVersion, $Version.Build, $Version.Revision)
				}
				else{
					[Version]::new($Version.Major, $TargetVersion, $Version.Build)
				}
			}
			Build{
				if($Increase){
					$TargetVersion = $Version.Build + 1
				}

				if($Version.Revision -ge 0){
					[Version]::new($Version.Major, $Version.Minor, $TargetVersion, $Version.Revision)
				}
				else{
					[Version]::new($Version.Major, $Version.Minor, $TargetVersion)
				}
				
			}
			Revision{
				if($Increase){
					$TargetVersion = $Version.Revision + 1
				}

				[Version]::new($Version.Major, $Version.Minor, $Version.Build, $TargetVersion)
			}
		}
	}
}