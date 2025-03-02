param (
    [string]$solutionName
)

if (-not $solutionName) {
    Write-Host "Please provide the solution name as an argument."
    exit 1
}

$srcDir = Join-Path -Path $PWD.Path -ChildPath "src"
$testDir = Join-Path -Path $PWD.Path -ChildPath "test"

New-Item -ItemType Directory -Path $srcDir
New-Item -ItemType Directory -Path $testDir

dotnet new sln -n $solutionName

dotnet sln add "$srcDir"
dotnet sln add "$testDir"

Write-Host "Solution and directories created successfully!"
