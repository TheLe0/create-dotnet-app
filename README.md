# Clean Architecture .NET Solution Scaffolder

This PowerShell script streamlines the creation of a complete .NET solution structured according to Clean Architecture principles.

Features:

- [X] Multi-language support (C# and F#)
- [X] Compatibility with multiple .NET versions
- [X] Support for various presentation projects (API, MVC, Console, and Service Worker)

## Setup

To set up in your CLI, first clone this repository to a location on your operating system. Then, run the commands above to configure the alias.

>Note: the /path/to/your/script/ is where the repository was cloned on your OS.

### MacOs

1. You can open this file in a text editor. If the file doesn't exist, you can create it.

```bash
nano ~/.zshrc
````

2. Add the following line to the file:

```bash
alias create-dotnet-app='pwsh /path/to/your/script/create-dotnet-app.ps1'
````

3. After saving the file, apply the changes by running:

```bash
source ~/.zshrc
```

### Linux

```bash
nano ~/.bashrc
```

2. Add the following line to the file:

```bash
alias create-dotnet-app='pwsh /path/to/your/script/create-dotnet-app.ps1'
````

3. After saving the file, apply the changes by running:

```bash
source ~/.bashrc
```

### Windows

```bash
notepad $PROFILE
```

2. Add the following function to the profile script:

```bash
function create-dotnet-app {
    param (
        [string]$solutionName,
        [string]$dotnetVersion = "net8.0",
        [string]$language = "C#",
        [string]$presentationType = "api"
    )
    & 'C:\Path\To\Your\Script\create-dotnet-app.ps1' -solutionName $solutionName -dotnetVersion $dotnetVersion -language $language -presentationType $presentationType
}
````

3. After saving the file, apply the changes by running:

```bash
. $PROFILE
```

