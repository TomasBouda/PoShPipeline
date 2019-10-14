function Set-PipelineVar{
	param(
		[Parameter(Mandatory = $true)]
		[string]$Name,
		[Parameter(Mandatory = $true)]
		[AllowEmptyString()]
		[string]$Value
	)

	Write-Output "##vso[task.setvariable variable=$Name]$Value"
}