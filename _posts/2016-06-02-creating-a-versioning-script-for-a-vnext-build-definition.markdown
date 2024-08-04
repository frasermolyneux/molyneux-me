---
layout: post
title:  "Creating a versioning script for a vNext build definition"
date: 2016-06-02 18:47:37 +0000
categories: application-lifecycle powershell software-engineering tfs
---

<!-- paragraph -->
<p>OK so this is actually a little more than a version&nbsp;script. I was asked to create a PowerShell step in a vNext build definition that would set the version, company, copyright and product information in all of the AssemblyInfo.cs files in a solution.</p>
<!-- /paragraph -->

<!-- paragraph -->
<p>I started with looking for existing solutions which led me to an excellent article from InCycle&nbsp;<a href="https://web.archive.org/web/20170929203905/http://incyclesoftware.com/2015/06/vnext-build-awesomeness-managing-version-numbers/">here</a>. This in turn led me to Microsoft’s example&nbsp;<a href="https://web.archive.org/web/20170929203905/https://www.visualstudio.com/docs/build/scripts/index">here</a>. So this was doing essentially what I wanted and could be expanded upon, here is what I did and the code I used.</p>
<!-- /paragraph -->

<!-- paragraph -->
<p>The main challenge that I had to handle with this solution is that it is fairly old and well over a hundred projects of varying versions. This means that there has been multiple management methods and as such I had to account for missing or modified from default assembly information.</p>
<!-- /paragraph -->

<!-- paragraph -->
<p><strong>Example: </strong></p>
<!-- /paragraph -->

<!-- code -->
<pre><code>&#091;assembly: AssemblyVersion("1.0.0.0")]
&#091;assembly: AssemblyFileVersion("1.0.0.0")]
//&#091;assembly: AssemblyVersion("1.0.0.0")]
//&#091;assembly: AssemblyFileVersion("1.0.0.0")]
&#091;assembly: AssemblyVersion("1.0.*")]

//or simply missing completely..</code></pre>
<!-- /code -->

<!-- paragraph -->
<p>So my solution was to use the following:</p>
<!-- /paragraph -->

<!-- code -->
<pre><code>##-----------------------------------------------------------------------
## Based on: https://msdn.microsoft.com/Library/vs/alm/Build/scripts/index
##-----------------------------------------------------------------------
# Replace values in AssemblyInfo.cs with Company default ones and apply version number based on build.
$copy = &#091;char]0x00A9
# Start Configuration
$DefaultAssemblyDescription = "My Product Description"
$DefaultAssemblyCompany = "My Company"
$DefaultAssemblyProduct = "Product Name"
$DefaultAssemblyCopyright = "Copyright " + $copy + " My Company 2016"
# End Configuration

function FindOrReplaceAttribute($filecontent, $assemblyValue, $newValue)
{
	$regex = "\&#091;assembly: Assembly" + $assemblyValue + "\((.+)\)\]"
	$replacement = '&#091;assembly: Assembly' + $assemblyValue + '("' + $newValue + '")]'
	
    $propertyExists = &#091;regex]::matches($filecontent, $regex)
    
    if ($propertyExists.Count -eq 1)
    {
        return $filecontent -replace $regex, $replacement
    }
    
    return $filecontent + $replacement
}

# Enable -Verbose option
&#091;CmdletBinding()]

# Set a flag to force verbose as a default
$VerbosePreference ='Continue' # equiv to -verbose

# If this script is not running on a build server, remind user to 
# set environment variables so that this script can be debugged
if(-not ($Env:BUILD_SOURCESDIRECTORY -and $Env:BUILD_BUILDNUMBER))
{
    Write-Error "You must set the following environment variables"
    Write-Error "to test this script interactively."
    Write-Host '$Env:BUILD_SOURCESDIRECTORY - For example, enter something like:'
    Write-Host '$Env:BUILD_SOURCESDIRECTORY = "C:\code\FabrikamTFVC\HelloWorld"'
    Write-Host '$Env:BUILD_BUILDNUMBER - For example, enter something like:'
    Write-Host '$Env:BUILD_BUILDNUMBER = "Build HelloWorld_0000.00.00.0"'
    exit 1
}

# Make sure path to source code directory is available
if (-not $Env:BUILD_SOURCESDIRECTORY)
{
    Write-Error ("BUILD_SOURCESDIRECTORY environment variable is missing.")
    exit 1
}
elseif (-not (Test-Path $Env:BUILD_SOURCESDIRECTORY))
{
    Write-Error "BUILD_SOURCESDIRECTORY does not exist: $Env:BUILD_SOURCESDIRECTORY"
    exit 1
}
Write-Verbose "BUILD_SOURCESDIRECTORY: $Env:BUILD_SOURCESDIRECTORY"

# Make sure there is a build number
if (-not $Env:BUILD_BUILDNUMBER)
{
    Write-Error ("BUILD_BUILDNUMBER environment variable is missing.")
    exit 1
}
Write-Verbose "BUILD_BUILDNUMBER: $Env:BUILD_BUILDNUMBER"

# Get and validate the version data
$VersionData = &#091;regex]::matches($Env:BUILD_BUILDNUMBER, "\d+\.\d+\.\d+\.\d+")
switch($VersionData.Count)
{
   0        
      { 
         Write-Error "Could not find version number data in BUILD_BUILDNUMBER."
         exit 1
      }
   1 {}
   default 
      { 
         Write-Warning "Found more than instance of version data in BUILD_BUILDNUMBER." 
         Write-Warning "Will assume first instance is version."
      }
}
$NewVersion = $VersionData&#091;0]
Write-Verbose "Version: $NewVersion"

# Apply the version to the assembly property files
$files = gci $Env:BUILD_SOURCESDIRECTORY -recurse -include "*Properties*","My Project" | 
    ?{ $_.PSIsContainer } | 
    foreach { gci -Path $_.FullName -Recurse -include AssemblyInfo.* }
if($files)
{
    Write-Verbose "Will apply $NewVersion to $($files.count) files."

    foreach ($file in $files) {
        $filecontent = Get-Content($file)
        attrib $file -r
        $filecontent = FindOrReplaceAttribute $filecontent "Company" $DefaultAssemblyCompany
		$filecontent = FindOrReplaceAttribute $filecontent "Copyright" $DefaultAssemblyCopyright
		$filecontent = FindOrReplaceAttribute $filecontent "Description" $DefaultAssemblyDescription
		$filecontent = FindOrReplaceAttribute $filecontent "Product" $DefaultAssemblyProduct
		$filecontent = FindOrReplaceAttribute $filecontent "Version" $NewVersion
		$filecontent = FindOrReplaceAttribute $filecontent "FileVersion" $NewVersion

        $filecontent | Out-File $file
        Write-Verbose "$file - Assembly Changes Applied"
    }
}
else
{
    Write-Warning "Found no files."
}</code></pre>
<!-- /code -->

<!-- paragraph -->
<p>Simple enough and only modified from the Microsoft version a little to account for the additional fields. This was the first time I have written PowerShell so was certainly a new experience for me.</p>
<!-- /paragraph -->

<!-- paragraph -->
<p>I then included this file in the source control of the solution in a folder called BuildScripts. And although covered in the InCycle article these are the complete steps I used to incorporate the script in my build process.</p>
<!-- /paragraph -->

<!-- list {"ordered":true} -->
<ol><li>Include the file in source control (/BuildScripts/ApplyVersionAndDefaultsToAssemblies.ps1)</li><li>Create a PowerShell step in the vNext definition and point it at the script.</li><li>On the ‘Variables’ settings create a ProjectVersion variable and set the version in the format x.x</li><li>On the ‘General’ settings set the build number format to:<br>$(BuildDefinitionName)_$(ProjectVersion).$(date:yy)$(DayOfYear)$(rev:.r)</li><li>Then save everything and queue a new build. It will apply your company information and all assemblies will have the same version. I am now using this same script in multiple solutions and all builds.</li></ol>
<!-- /list -->
