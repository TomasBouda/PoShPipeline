function Set-PipelineVar{
	param(
		[Parameter(Mandatory = $true)]
		[string]$Name,
		[Parameter(Mandatory = $true)]
		[AllowEmptyString()]
		[string]$Value,
		[Parameter(Mandatory = $false)]
		[switch]$IsOutput,
		[Parameter(Mandatory = $false)]
		[switch]$IsSecret,
		[Parameter(Mandatory = $false)]
		[switch]$IsReadOnly
	)

	if($IsOutput){
		$isOutputProp = 'isoutput=true;'
	}
	if($IsSecret){
		$isSecretProp = 'issecret=true;'
	}
	if($IsReadOnly){
		$isReadOnlyProp = 'isreadonly=true;'
	}
	
	Write-Output "##vso[task.setvariable variable=$Name;$isOutputProp$isSecretProp$isReadOnlyProp]$Value"
}