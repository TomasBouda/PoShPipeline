function Get-NewVersion {
	param(
		[Parameter(Mandatory = $true)]
		[Version]$Version,
		[Parameter(Mandatory = $true)]
		[int]$Revision
	)

	[Version]::new($Version.Major, $Version.Minor, $Version.Build, $Revision) | Convert-VersionToString
}