param (
    [string]$solutionName,
    [string]$dotnetVersion = "net8.0",  # Default to .NET 8.0 if no version is specified
    [string]$language = "C#",            # Default to C# if no language is specified
    [string]$presentationType = "api"    # Default to API if no presentation type is specified
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

# Determine the project file extension based on the language
$projectFileExtension = if ($language -eq "F#") { "fsproj" } else { "csproj" }

# Create the projects in their respective directories with the specified .NET version and language
dotnet new $classlibTemplate -o $fixtureProjectDir --name "$solutionName.Fixture" --framework $dotnetVersion --language $language
dotnet new $testTemplate -o $unitTestProjectDir --name "$solutionName.UnitTest" --framework $dotnetVersion --language $language

# Define the paths for the projects within the src directory
$applicationProjectDir = Join-Path -Path $srcDir -ChildPath "$solutionName.Application"
$configurationProjectDir = Join-Path -Path $srcDir -ChildPath "$solutionName.Configuration"
$domainProjectDir = Join-Path -Path $srcDir -ChildPath "$solutionName.Domain"
$dataProjectDir = Join-Path -Path $srcDir -ChildPath "$solutionName.Data"

dotnet new $classlibTemplate -o $applicationProjectDir --name "$solutionName.Application" --framework $dotnetVersion --language $language
dotnet new $classlibTemplate -o $configurationProjectDir --name "$solutionName.Configuration" --framework $dotnetVersion --language $language
dotnet new $classlibTemplate -o $domainProjectDir --name "$solutionName.Domain" --framework $dotnetVersion --language $language
dotnet new $classlibTemplate -o $dataProjectDir --name "$solutionName.Data" --framework $dotnetVersion --language $language

# Determine the presentation project name and template based on the selected type
switch ($presentationType.ToLower()) {
    "api" {
        $presentationTemplate = "webapi"
        $presentationProjectName = "$solutionName.API"
    }
    "mvc" {
        $presentationTemplate = "mvc"
        $presentationProjectName = "$solutionName.Web"
    }
    "serviceworker" {
        $presentationTemplate = "worker"
        $presentationProjectName = "$solutionName.Scheduler"
    }
    "console" {
        $presentationTemplate = "console"
        $presentationProjectName = "$solutionName.CLI"
    }
    default {
        Write-Host "Invalid presentation type. Defaulting to API."
        $presentationTemplate = "webapi"
        $presentationProjectName = "$solutionName.API"
    }
}

# Define the path for the presentation project
$presentationProjectDir = Join-Path -Path $srcDir -ChildPath $presentationProjectName

# Create the presentation project
dotnet new $presentationTemplate -o $presentationProjectDir --name $presentationProjectName --framework $dotnetVersion --language $language

# Add the projects to the solution
dotnet sln add "$fixtureProjectDir/$solutionName.Fixture.$projectFileExtension"
dotnet sln add "$unitTestProjectDir/$solutionName.UnitTest.$projectFileExtension"
dotnet sln add "$applicationProjectDir/$solutionName.Application.$projectFileExtension"
dotnet sln add "$configurationProjectDir/$solutionName.Configuration.$projectFileExtension"
dotnet sln add "$domainProjectDir/$solutionName.Domain.$projectFileExtension"
dotnet sln add "$dataProjectDir/$solutionName.Data.$projectFileExtension"
dotnet sln add "$presentationProjectDir/$presentationProjectName.$projectFileExtension"

# Add project references
dotnet add "$dataProjectDir/$solutionName.Data.$projectFileExtension" reference "$domainProjectDir/$solutionName.Domain.$projectFileExtension"
dotnet add "$applicationProjectDir/$solutionName.Application.$projectFileExtension" reference "$dataProjectDir/$solutionName.Data.$projectFileExtension"
dotnet add "$presentationProjectDir/$presentationProjectName.$projectFileExtension" reference "$applicationProjectDir/$solutionName.Application.$projectFileExtension"

Write-Host "Solution and projects created successfully with .NET version $dotnetVersion, language $language, and presentation type $presentationType!"