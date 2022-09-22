<#
.Synopsis
	Invoke git, handling its quirky stderr that isn't error
	https://stackoverflow.com/questions/34820975/git-clone-redirect-stderr-to-stdout-but-keep-errors-being-written-to-stderr

.Outputs
    Git messages, and lastly the exit code

.Example
    Invoke-Git push

.Example
    Invoke-Git "add ."
#>
function Invoke-Git {
	param(
		[Parameter(Mandatory)]
		[string] $Command )

	try {

		$exit = 0
		$path = [System.IO.Path]::GetTempFileName()

		Invoke-Expression "git $Command 2> $path"
		$exit = $LASTEXITCODE
		if ( $exit -gt 0 ) {
			Write-Error (Get-Content $path).ToString()
		}
		else {
			Get-Content $path | Select-Object -First 1
		}
		$exit
	}
	catch {
		Write-Host "Error: $_`n$($_.ScriptStackTrace)"
	}
	finally {
		if (Test-Path $path) {
			Remove-Item $path
		}
	}
}