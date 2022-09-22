function Write-Issue {
	param(
		[Parameter(Mandatory = $true, Position = 0)]
		[string]$Message,
		[Parameter(Mandatory = $true, Position = 1)]
		[ValidateSet('Error', 'Warning')]
		[string]$Type
	)

	Write-Host "##vso[task.logissue type=$($Type.ToLower());]$Message"
}