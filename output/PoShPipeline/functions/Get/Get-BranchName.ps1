function Get-BranchName{
	process{
		git rev-parse --abbrev-ref HEAD
	}
}