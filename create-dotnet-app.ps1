param (
    [string]$solutionName,
    [string]$dotnetVersion = "net8.0",  # Default to .NET 8.0 if no version is specified
    [string]$language = "C#"            # Default to C# if no language is specified
)

# Check if the solution name was provided
if (-not $solutionName) {
    Write-Host "Please provide the solution name as an argument."
    exit 1
}

# Define the paths for the physical directories
$srcDir = Join-Path -Path $PWD.Path -ChildPath "src"
$testDir = Join-Path -Path $PWD.Path -ChildPath "test"

# Create the physical directories
New-Item -ItemType Directory -Path $srcDir
New-Item -ItemType Directory -Path $testDir

# Create the empty solution
dotnet new sln -n $solutionName

# Define the paths for the projects within the test directory
$fixtureProjectDir = Join-Path -Path $testDir -ChildPath "$solutionName.Fixture"
$unitTestProjectDir = Join-Path -Path $testDir -ChildPath "$solutionName.UnitTest"

# Use the same template for both C# and F# class libraries
$classlibTemplate = "classlib"
$testTemplate = "xunit"

# Create the projects in their respective directories with the specified .NET version and language
dotnet new $classlibTemplate -o $fixtureProjectDir --name "$solutionName.Fixture" --framework $dotnetVersion --language $language
dotnet new $testTemplate -o $unitTestProjectDir --name "$solutionName.UnitTest" --framework $dotnetVersion --language $language

# Determine the project file extension based on the language
$projectFileExtension = if ($language -eq "F#") { "fsproj" } else { "csproj" }

# Add the projects to the solution
dotnet sln add "$fixtureProjectDir/$solutionName.Fixture.$projectFileExtension"
dotnet sln add "$unitTestProjectDir/$solutionName.UnitTest.$projectFileExtension"

Write-Host "Solution and projects created successfully with .NET version $dotnetVersion and language $language!"