function New-Release{
	param(
		[Parameter(Mandatory = $true)]
		[string]$Path,
		[Parameter(Mandatory = $true)]
		[string]$BranchName,
		[Parameter(Mandatory = $true)]
		[int]$BuildNumber,
		[Parameter(Mandatory = $false)]
		[string[]]$Exclude
	)

	$BranchName -match 'releases/v?(?<targetVersion>\d+\.\d+\.\d+)(?<label>-\w+)?'
	[Version]$targetVersion = $Matches.targetVersion | Update-Version -Type Revision -Value $BuildNumber

	Set-AllProjVersions -Path $Path -FullVersion $targetVersion -Exclude $Exclude

	Set-PipelineVar -Name 'major_version' -Value $targetVersion.Major
	Set-PipelineVar -Name 'minor_version' -Value $targetVersion.Minor
	Set-PipelineVar -Name 'bugfix_version' -Value $targetVersion.Build
	Set-PipelineVar -Name 'version_label' -Value $Matches.label
}