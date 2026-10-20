@echo off
setlocal EnableExtensions DisableDelayedExpansion
title Universal Folder Organizer - Windows 7 / 10 / 11

rem ====================================================================
rem UNIVERSAL FOLDER ORGANIZER (v2.0)
rem Works on Windows 7, 10 and 11 with Windows PowerShell 2.0 or later.
rem ONE FILE ONLY: PowerShell code is embedded below the marker.
rem - Double-click to choose Downloads, Desktop, Documents, or a folder.
rem - Drag and drop a folder on this BAT to select that folder directly.
rem - Or run: Universal_Folder_Organizer.bat "D:\Some Folder"
rem - No file is moved until the user types Y after previewing changes.
rem ====================================================================

set "ORGANIZER_SELF=%~f0"
set "ORGANIZER_INPUT=%~1"
set "ORGANIZER_PS=%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe"

if not exist "%ORGANIZER_PS%" (
    echo ERROR: Windows PowerShell was not found.
    echo This program requires the built-in Windows PowerShell 2.0 or newer.
    echo.
    pause
    exit /b 1
)

rem Read ONLY the PowerShell section of this very same .bat file.
rem No temporary .ps1 or external script is created.
"%ORGANIZER_PS%" -NoLogo -NoProfile -ExecutionPolicy Bypass -Command "$ErrorActionPreference='Stop'; $s=[IO.File]::ReadAllText($env:ORGANIZER_SELF); $m='#==UNIVERSAL_ORGANIZER_POWERSHELL=='; $i=$s.LastIndexOf($m); if($i -lt 0){throw 'Embedded PowerShell code not found.'}; & ([ScriptBlock]::Create($s.Substring($i+$m.Length)))"

set "ORGANIZER_EXIT_CODE=%errorlevel%"
echo.
pause
exit /b %ORGANIZER_EXIT_CODE%

#==UNIVERSAL_ORGANIZER_POWERSHELL==

# This code uses Windows PowerShell 2.0-compatible language and .NET APIs.
$ErrorActionPreference = 'Stop'

# -------------------------- CUSTOM SETTINGS ---------------------------
# Add/remove extensions or rename the categories here.
# Each extension MUST start with a dot, e.g. '.png'.
# Keep an extension in only ONE group to avoid ambiguous classification.
$groups = @(
    @{ Name='Images';     Extensions=@('.jpg','.jpeg','.png','.gif','.bmp','.webp','.heic','.svg','.tif','.tiff','.ico','.avif') },
    @{ Name='Videos';     Extensions=@('.mp4','.mkv','.mov','.avi','.wmv','.webm','.flv','.mpeg','.mpg','.m4v','.3gp') },
    @{ Name='Audio';      Extensions=@('.mp3','.wav','.aac','.flac','.ogg','.m4a','.wma','.opus','.aiff') },
    @{ Name='Documents';  Extensions=@('.pdf','.doc','.docx','.xls','.xlsx','.ppt','.pptx','.txt','.csv','.rtf','.odt','.ods','.odp','.epub') },
    @{ Name='Markdown';   Extensions=@('.md','.markdown','.mdown') },
    @{ Name='Archives';   Extensions=@('.zip','.rar','.7z','.tar','.gz','.bz2','.xz','.tgz','.iso') },
    @{ Name='Code';       Extensions=@('.py','.ipynb','.c','.cpp','.h','.hpp','.java','.js','.jsx','.ts','.tsx','.html','.htm','.css','.scss','.php','.sql','.json','.xml','.yaml','.yml','.sh','.ps1','.bat','.cmd','.rb','.go','.rs') },
    @{ Name='Installers'; Extensions=@('.exe','.msi','.msix','.msixbundle','.apk','.appx','.dmg','.deb') },
    @{ Name='Fonts';      Extensions=@('.ttf','.otf','.woff','.woff2') }
)

# User-adjustable behavior. Only the chosen folder's top-level files move.
$unknownCategory = 'Others'
$previewLimit = 30
$incompleteExtensions = @('.crdownload','.part','.partial','.download','.tmp','.aria2','.opdownload','.!qb')
$skipExtensions = @('.lnk','.url')  # Preserve Windows desktop shortcuts/links.
$skipNames = @('desktop.ini','thumbs.db')
# ---------------------------------------------------------------------

# Resolve Downloads even if Windows has redirected the known folder.
function Get-DownloadsFolder {
    $fallback = Join-Path $env:USERPROFILE 'Downloads'
    try {
        $key = [Microsoft.Win32.Registry]::CurrentUser.OpenSubKey('Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders')
        if ($key -ne $null) {
            $value = $key.GetValue('{374DE290-123F-4565-9164-39C4925E467B}')
            $key.Close()
            if (-not [string]::IsNullOrEmpty($value)) {
                return [Environment]::ExpandEnvironmentVariables([string]$value)
            }
        }
    } catch { }
    return $fallback
}

# A folder chooser is convenient, but typing/pasting a path always works.
function Choose-FolderDialog {
    try {
        $shell = New-Object -ComObject Shell.Application
        $chosen = $shell.BrowseForFolder(0, 'Select the folder to organize', 0, 0)
        if ($chosen -ne $null) { return [string]$chosen.Self.Path }
    }
    catch {
        Write-Host 'Folder dialog is unavailable. Choose the paste-path option instead.' -ForegroundColor Yellow
    }
    return ''
}

function Choose-TargetFolder {
    while ($true) {
        Write-Host ''
        Write-Host '================ SELECT A FOLDER ================' -ForegroundColor Cyan
        Write-Host '  1. Downloads'
        Write-Host '  2. Desktop'
        Write-Host '  3. Documents'
        Write-Host '  4. Browse for a folder'
        Write-Host '  5. Paste or type a folder path'
        Write-Host '  6. Exit'
        Write-Host '=================================================' -ForegroundColor Cyan
        $choice = Read-Host 'Enter option 1-6'
        switch ($choice) {
            '1' { return (Get-DownloadsFolder) }
            '2' { return [Environment]::GetFolderPath('DesktopDirectory') }
            '3' { return [Environment]::GetFolderPath('MyDocuments') }
            '4' {
                $picked = Choose-FolderDialog
                if (-not [string]::IsNullOrEmpty($picked)) { return $picked }
                Write-Host 'No folder selected.' -ForegroundColor Yellow
            }
            '5' {
                $typed = Read-Host 'Paste the full folder path'
                if ($typed -ne $null) {
                    $typed = $typed.Trim().Trim('"')
                    if ($typed.Length -gt 0) { return $typed }
                }
                Write-Host 'Please provide a folder path.' -ForegroundColor Yellow
            }
            '6' { exit 0 }
            default { Write-Host 'Invalid choice. Try again.' -ForegroundColor Yellow }
        }
    }
}

# Avoid destructive mistakes involving the Windows operating system.
# Other user-selected directories, including Desktop/Documents, are allowed.
function Is-ProtectedTarget([string]$path) {
    $comparison = [StringComparison]::OrdinalIgnoreCase
    $root = [IO.Path]::GetPathRoot($path)
    if ($path.TrimEnd('\') -eq $root.TrimEnd('\')) { return $true }

    $protectedTrees = @($env:WINDIR, $env:ProgramFiles, ${env:ProgramFiles(x86)}, $env:ProgramData)
    foreach ($item in $protectedTrees) {
        if (-not [string]::IsNullOrEmpty($item)) {
            $base = [IO.Path]::GetFullPath($item).TrimEnd('\')
            if ($path.Equals($base,$comparison) -or $path.StartsWith($base+'\',$comparison)) {
                return $true
            }
        }
    }

    $blockedExact = @($env:USERPROFILE, (Join-Path $env:SystemDrive 'Users'), (Join-Path $env:SystemDrive 'Documents and Settings'))
    foreach ($item in $blockedExact) {
        if (-not [string]::IsNullOrEmpty($item)) {
            if ($path.Equals(([IO.Path]::GetFullPath($item).TrimEnd('\')),$comparison)) { return $true }
        }
    }
    return $false
}

Write-Host ''
Write-Host '=======================================================' -ForegroundColor Cyan
Write-Host '       UNIVERSAL FOLDER ORGANIZER - WINDOWS PC' -ForegroundColor Cyan
Write-Host '=======================================================' -ForegroundColor Cyan
Write-Host 'Supports Windows 7 / 10 / 11; no Python required.'
Write-Host 'Organizes top-level files only (never subfolders).'

$target = $env:ORGANIZER_INPUT
if ([string]::IsNullOrEmpty($target)) { $target = Choose-TargetFolder }

try {
    $target = [Environment]::ExpandEnvironmentVariables($target)
    $target = [IO.Path]::GetFullPath($target).TrimEnd('\')
    # Keep the separator for drive roots, so the protection test can reject it.
    if (-not [IO.Directory]::Exists($target)) {
        Write-Host ('ERROR: This folder does not exist: ' + $target) -ForegroundColor Red
        exit 1
    }
    if (Is-ProtectedTarget $target) {
        Write-Host ('BLOCKED: For safety, this location cannot be organized: ' + $target) -ForegroundColor Red
        Write-Host 'Choose a personal folder rather than a drive root or system directory.'
        exit 1
    }
}
catch {
    Write-Host ('ERROR: Invalid folder path. ' + $_.Exception.Message) -ForegroundColor Red
    exit 1
}

Write-Host ''
Write-Host ('Selected folder: ' + $target) -ForegroundColor Yellow
Write-Host ''

# Build extension mapping. The first category wins on accidental duplicates.
$extensionMap = @{}
foreach ($group in $groups) {
    foreach ($extension in $group.Extensions) {
        $key = [string]$extension
        $key = $key.ToLowerInvariant()
        if (-not $extensionMap.ContainsKey($key)) {
            $extensionMap[$key] = [string]$group.Name
        }
        else {
            Write-Host ('WARNING: Duplicate extension in settings: ' + $key) -ForegroundColor Yellow
        }
    }
}

# Construct an in-memory move plan; do not change any file during preview.
$plan = New-Object System.Collections.ArrayList
$reservedDestinations = @{}
$skipped = 0
try {
    $files = @(Get-ChildItem -LiteralPath $target -ErrorAction Stop | Where-Object { -not $_.PSIsContainer } | Sort-Object Name)
}
catch {
    Write-Host ('ERROR: Cannot read this folder: ' + $_.Exception.Message) -ForegroundColor Red
    exit 1
}

foreach ($file in $files) {
    $extension = $file.Extension.ToLowerInvariant()
    $flags = $file.Attributes
    $hidden = (($flags -band [IO.FileAttributes]::Hidden) -ne 0)
    $systemFile = (($flags -band [IO.FileAttributes]::System) -ne 0)
    $link = (($flags -band [IO.FileAttributes]::ReparsePoint) -ne 0)
    $self = $file.FullName.Equals($env:ORGANIZER_SELF,[StringComparison]::OrdinalIgnoreCase)
    if ($self -or $hidden -or $systemFile -or $link -or ($incompleteExtensions -contains $extension) -or ($skipExtensions -contains $extension) -or ($skipNames -contains $file.Name)) {
        $skipped++
        continue
    }

    $category = $unknownCategory
    if ($extensionMap.ContainsKey($extension)) { $category = $extensionMap[$extension] }

    $destinationFolder = Join-Path $target $category
    $candidate = Join-Path $destinationFolder $file.Name
    $baseName = [IO.Path]::GetFileNameWithoutExtension($file.Name)
    $index = 1
    while ([IO.File]::Exists($candidate) -or [IO.Directory]::Exists($candidate) -or $reservedDestinations.ContainsKey($candidate.ToLowerInvariant())) {
        $candidateName = ('{0} ({1}){2}' -f $baseName,$index,$file.Extension)
        $candidate = Join-Path $destinationFolder $candidateName
        $index++
    }
    $reservedDestinations[$candidate.ToLowerInvariant()] = $true
    $item = New-Object PSObject -Property @{
        Name=$file.Name
        Source=$file.FullName
        Destination=$candidate
        Category=$category
    }
    [void]$plan.Add($item)
}

if ($plan.Count -eq 0) {
    Write-Host 'Nothing to organize. No files moved.' -ForegroundColor Green
    exit 0
}

Write-Host ('Files to organize: ' + $plan.Count) -ForegroundColor Yellow
Write-Host ('Files skipped:     ' + $skipped)
Write-Host ''
Write-Host 'Summary by destination folder:' -ForegroundColor Cyan
$plan | Group-Object Category | Sort-Object Name | ForEach-Object {
    Write-Host ('  {0,-15} {1,5}' -f $_.Name,$_.Count)
}

Write-Host ''
Write-Host 'PREVIEW - nothing has been moved yet:' -ForegroundColor Cyan
$maxPreview = [Math]::Min($previewLimit,$plan.Count)
for ($i = 0; $i -lt $maxPreview; $i++) {
    $item = $plan[$i]
    Write-Host ('  {0}  -->  {1}\{2}' -f $item.Name,$item.Category,[IO.Path]::GetFileName($item.Destination))
}
if ($plan.Count -gt $maxPreview) {
    Write-Host ('  ... plus ' + ($plan.Count - $maxPreview) + ' more files.')
}

Write-Host ''
$answer = Read-Host 'Type Y to move these files (anything else cancels)'
if ($answer -eq $null -or $answer.Trim().ToUpperInvariant() -ne 'Y') {
    Write-Host 'Cancelled. No files have been moved.' -ForegroundColor Yellow
    exit 0
}

$moved = 0
$failed = 0
foreach ($item in $plan) {
    try {
        # Recheck immediately before moving: never overwrite files that
        # appeared after the preview. A collision causes a safe failure.
        if (-not [IO.File]::Exists($item.Source)) {
            throw 'Source file no longer exists.'
        }
        if ([IO.File]::Exists($item.Destination) -or [IO.Directory]::Exists($item.Destination)) {
            throw 'Destination already exists; no overwrite was attempted.'
        }
        $destinationDir = [IO.Path]::GetDirectoryName($item.Destination)
        [void][IO.Directory]::CreateDirectory($destinationDir)
        [IO.File]::Move($item.Source,$item.Destination)
        $moved++
        Write-Host ('[MOVED] ' + $item.Name + ' --> ' + $item.Category)
    }
    catch {
        $failed++
        Write-Host ('[FAILED] ' + $item.Name + ' : ' + $_.Exception.Message) -ForegroundColor Red
    }
}

Write-Host ''
Write-Host '==================== RESULTS ====================' -ForegroundColor Cyan
Write-Host ('Moved:      ' + $moved) -ForegroundColor Green
Write-Host ('Failed:     ' + $failed)
Write-Host ('Skipped:    ' + $skipped)
Write-Host ('Folder:     ' + $target)
Write-Host '=================================================' -ForegroundColor Cyan
if ($failed -gt 0) { exit 1 }
exit 0
