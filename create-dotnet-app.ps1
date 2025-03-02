param (
    [string]$solutionName,
    [string]$dotnetVersion = "net8.0"  # Use the current LTS version as default
)

# User input validations
if (-not $solutionName) {
    Write-Host "Please provide the solution name as an argument."
    exit 1
}

# Create the physical directories
$srcDir = Join-Path -Path $PWD.Path -ChildPath "src"
$testDir = Join-Path -Path $PWD.Path -ChildPath "test"

New-Item -ItemType Directory -Path $srcDir
New-Item -ItemType Directory -Path $testDir

# Create the empty solution
dotnet new sln -n $solutionName

# Create Test projects
$fixtureProjectDir = Join-Path -Path $testDir -ChildPath "$solutionName.Fixture"
$unitTestProjectDir = Join-Path -Path $testDir -ChildPath "$solutionName.UnitTest"

dotnet new classlib -o $fixtureProjectDir --name "$solutionName.Fixture" --framework $dotnetVersion
dotnet new xunit -o $unitTestProjectDir --name "$solutionName.UnitTest" --framework $dotnetVersion

dotnet sln add "$fixtureProjectDir/$solutionName.Fixture.csproj"
dotnet sln add "$unitTestProjectDir/$solutionName.UnitTest.csproj"

Write-Host "Solution and projects created successfully with .NET version $dotnetVersion!"