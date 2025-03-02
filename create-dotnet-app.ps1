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

$fixtureProjectDir = Join-Path -Path $testDir -ChildPath "$solutionName.Fixture"
$unitTestProjectDir = Join-Path -Path $testDir -ChildPath "$solutionName.UnitTest"

dotnet new classlib -o $fixtureProjectDir --name "$solutionName.Fixture"
dotnet new xunit -o $unitTestProjectDir --name "$solutionName.UnitTest"

dotnet sln add "$fixtureProjectDir/$solutionName.Fixture.csproj"
dotnet sln add "$unitTestProjectDir/$solutionName.UnitTest.csproj"

Write-Host "Solution and projects created successfully!"