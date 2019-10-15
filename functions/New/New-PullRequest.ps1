function New-PullRequest {
	Param(
		[parameter(Mandatory = $true)]
		[string]$Owner,
		[parameter(Mandatory = $true)]
		[string]$Repo,
		[parameter(Mandatory = $true, ParameterSetName='AuthToken')]
		[string]$AuthToken,
		[parameter(Mandatory = $true, ParameterSetName='PAT')]
		[string]$Username,
		[parameter(Mandatory = $true, ParameterSetName='PAT')]
		[string]$PAT,
		[parameter(Mandatory = $true)]
		[string]$Title,
		[parameter(Mandatory = $true)]
		[string]$Head,
		[parameter(Mandatory = $true)]
		[string]$Base,		
		[parameter(Mandatory = $false)]
		[string]$Body,
		[parameter(Mandatory = $false)]
		[bool]$MaintainerCanModify = $true,
		[parameter(Mandatory = $false)]
		[bool]$Draft = $false
	)

	switch ($PsCmdlet.ParameterSetName)
    {
		'PAT'{
			$bytes = [System.Text.Encoding]::UTF8.GetBytes("$($Username):$($PAT)")
			$AuthToken = [System.Convert]::ToBase64String($bytes)
		}
    }

	$headers = @{
		Authorization = "Basic $AuthToken";
	}
	$headers.Add('Content-Type', 'application/json')

	$objBody = 
	@{
		title = $Title
		head = $Head
		base = $Base
		body = $Body
		maintainer_can_modify = $MaintainerCanModify
		draft = $Draft
	};
	$jsonBody = ConvertTo-Json -InputObject $objBody
	$result = Invoke-WebRequest -Uri "https://api.github.com/repos/$Owner/$Repo/pulls" -Headers $headers -Method POST -Body $jsonBody | ConvertFrom-Json

	return $result.id
}