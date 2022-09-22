function Convert-VersionToString {
	[Cmdletbinding()]
	param(
		[Parameter(Mandatory = $true, ValueFromPipeline = $true)]
		[Version]$Version
	)

	process{
		if ($Version.Revision -eq -1) {
			"$($Version.Major).$($Version.Minor).$($Version.Build)"
		}
		else {
			"$($Version.Major).$($Version.Minor).$($Version.Build).$($Version.Revision)"
		}
	}
}