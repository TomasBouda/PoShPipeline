function Set-ProjVersion {
	param(
		[Parameter(Mandatory = $true)]
		[string]$ProjectDirectory,
		[Parameter(Mandatory = $true, ParameterSetName = 'FullVersion')]
		[Version]$FullVersion,
		[Parameter(Mandatory = $true, ParameterSetName = 'Revision')]
		[int]$Revision,
		[Parameter(Mandatory = $false)]
		[bool]$SetFileVersion = $true,
		[Parameter(Mandatory = $false)]
		[bool]$SetAssemblyVersion = $true,
		[Parameter(Mandatory = $false)]
		[bool]$SetPackageVersion = $true,
		[Parameter(Mandatory = $false)]
		[string[]]$Exclude
	)

	$projectFiles = Get-ChildItem $ProjectDirectory -Filter '*.csproj' | Where-Object { $_.Name -notin $Exclude }
	foreach ($projectFile in $projectFiles) {
		$xml = New-Object System.Xml.XmlDocument
		$xml.Load($projectFile.FullName)

		# Check if project is .Net Core
		if ($null -ne $xml.Project.Attributes['Sdk']) {	# .NET Core
			switch ($PsCmdlet.ParameterSetName) { 
				'FullVersion' { 
					$newVersion = Convert-VersionToString $FullVersion
					if ($SetAssemblyVersion) {
						Write-Output "Setting AssemblyVersion $newVersion for $($projectFile.FullName)"
						if ($null -eq $xml.Project.PropertyGroup.AssemblyVersion) {
							$child = $xml.CreateElement("AssemblyVersion")
							$xml.Project.PropertyGroup.AppendChild($child) | Out-Null
						}

						$xml.Project.PropertyGroup.AssemblyVersion = $newVersion
					}
					if ($SetFileVersion) {
						Write-Output "Setting FileVersion $newVersion for $($projectFile.FullName)"
						if ($null -eq $xml.Project.PropertyGroup.FileVersion) {
							$child = $xml.CreateElement("FileVersion")
							$xml.Project.PropertyGroup.AppendChild($child) | Out-Null
						}

						$xml.Project.PropertyGroup.FileVersion = $newVersion
					}
					if ($SetPackageVersion) {
						Write-Output "Setting Version $newVersion for $($projectFile.FullName)"
						if ($null -eq $xml.Project.PropertyGroup.Version) {
							$child = $xml.CreateElement("Version")
							$xml.Project.PropertyGroup.AppendChild($child) | Out-Null
						}

						$xml.Project.PropertyGroup.Version = $newVersion
					}
				} 
				'Revision' { 
					if ($SetAssemblyVersion) {
						$asmVersion = [Version]$xml.Project.PropertyGroup.AssemblyVersion
						$newVersion = Get-NewVersion $asmVersion $Revision

						Write-Output "Setting AssemblyVersion $newVersion for $($projectFile.FullName)"
						$xml.Project.PropertyGroup.AssemblyVersion = $newVersion
					}
					if ($SetFileVersion) {
						$fileVersion = [Version]$xml.Project.PropertyGroup.FileVersion
						$newVersion = Get-NewVersion $fileVersion $Revision

						Write-Output "Setting FileVersion $newVersion for $($projectFile.FullName)"
						$xml.Project.PropertyGroup.FileVersion = $newVersion
					}
					if ($SetPackageVersion) {
						$version = [Version]$xml.Project.PropertyGroup.Version
						$newVersion = Get-NewVersion $version $Revision

						Write-Output "Setting Version $newVersion for $($projectFile.FullName)"
						$xml.Project.PropertyGroup.Version = $newVersion
					}
				} 
			} 
		}
		else {	# .NET Framework
			switch ($PsCmdlet.ParameterSetName) { 
				'FullVersion' { 
					if ($SetAssemblyVersion) {
						if ($xml.Project.PropertyGroup[0].ApplicationVersion) {
							Write-Output "Setting AssemblyVersion $FullVersion for $($projectFile.FullName)"

							$xml.Project.PropertyGroup[0].ApplicationVersion = (Convert-VersionToString $FullVersion)
						}

						Set-AssemblyInfoVersion -FilePath "$ProjectDirectory\Properties\AssemblyInfo.cs" -AttributeName 'AssemblyVersion' -FullVersion $FullVersion
					}
					if ($SetFileVersion) {
						Set-AssemblyInfoVersion -FilePath "$ProjectDirectory\Properties\AssemblyInfo.cs" -AttributeName 'AssemblyFileVersion' -FullVersion $FullVersion
					}
				} 
				'Revision' { 
					if ($SetAssemblyVersion) {
						$appVersion = [Version]$xml.Project.PropertyGroup[0].ApplicationVersion
						if ($appVersion) {
							$newVersion = Get-NewVersion $appVersion $Revision

							Write-Output "Setting AssemblyVersion $newVersion for $($projectFile.FullName)"
							$xml.Project.PropertyGroup[0].ApplicationVersion = $newVersion
						}

						$asmVersion = Get-AssemblyInfoVersion -FilePath "$ProjectDirectory\Properties\AssemblyInfo.cs" -AttributeName 'AssemblyVersion'
						if ($asmVersion) {
							Set-AssemblyInfoVersion -FilePath "$ProjectDirectory\Properties\AssemblyInfo.cs" -AttributeName 'AssemblyVersion' -FullVersion (Get-NewVersion $asmVersion $Revision) 
						}
					}

					if ($SetFileVersion) {
						$fileVersion = Get-AssemblyInfoVersion -FilePath "$ProjectDirectory\Properties\AssemblyInfo.cs" -AttributeName 'AssemblyFileVersion'
						if ($fileVersion) {
							Set-AssemblyInfoVersion -FilePath "$ProjectDirectory\Properties\AssemblyInfo.cs" -AttributeName 'AssemblyFileVersion' -FullVersion (Get-NewVersion $fileVersion $Revision)
						}
					}
				} 
			}
		}

		$xml.Save($projectFile.FullName)

		Write-Output "$($projectFile.FullName) successfully saved"
	}
}