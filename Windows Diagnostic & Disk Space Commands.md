# Windows Diagnostic & Disk Space Troubleshooting

 A collection of PowerShell and Windows commands for checking Windows services, system information, disk usage, recovery files, and component-store cleanup.

 > **Note:** Some commands may require **Administrator privileges**. The commands are intended for diagnostics unless explicitly marked as a cleanup operation.

---

 ## 1\. Check Windows Defender and Security Services

 Check whether Microsoft Defender Antivirus is running:

```
sc.exe query WinDefend
```

 Check the Windows Security Health Service:

```
sc.exe query SecurityHealthService
```

 Look for:

```
STATE              : 4  RUNNING
```

 `RUNNING` indicates that the service is currently running.

---

 ## 2\. Check Windows Version and Build

```
Get-ComputerInfo |
    Select-Object WindowsProductName, WindowsDisplayVersion, OsBuildNumber
```

 This displays:

 - Windows edition
- Windows display version
- OS build number

---

 ## 3\. Open System Properties

```
sysdm.cpl
```

 This opens the Windows **System Properties** dialog.

---

 ## 4\. Check Large Items on the C: Drive

```
Get-ChildItem C:\ -Force |
    Sort-Object Length -Descending |
    Select-Object -First 20 Name,Length
```

 This attempts to show the largest items directly under `C:\`.

 > **Note:** This does not calculate the total size of directories recursively.

---

 ## 5\. Check Volume Shadow Copy Storage

```
vssadmin list shadowstorage
```

 This shows how much disk space is allocated to and currently used by Volume Shadow Copy.

 This can help identify storage being consumed by:

 - System Restore
- Previous versions
- Volume Shadow Copy data

---

 ## 6\. Check Windows Recovery and Installation Folders

 The following folders can sometimes contain files left over from Windows upgrades or recovery operations:

 - `C:\$Windows.~WS`
- `C:\$WinREAgent`
- `C:\ESD`

 Use:

```
$folders = 'C:\$Windows.~WS','C:\$WinREAgent','C:\ESD'

foreach ($folder in $folders) {
    if (Test-Path $folder) {
        $size = (
            Get-ChildItem $folder -Force -Recurse -ErrorAction SilentlyContinue |
            Measure-Object -Property Length -Sum
        ).Sum

        "{0} = {1:N2} GB" -f $folder, ($size / 1GB)
    }
    else {
        "$folder = Not found"
    }
}
```

 This reports the approximate size of each folder.

 > **Important:** Do not manually delete Windows recovery or installation folders unless you know that they are no longer required.

---

 ## 7\. Check Free Space on C:

```
Get-Volume C |
    Select-Object DriveLetter,Size,SizeRemaining
```

 This displays:

 - Total volume size
- Remaining free space

---

 ## 8\. Windows Component Store Cleanup

```
DISM /Online /Cleanup-Image /StartComponentCleanup
```

 This performs Windows component-store cleanup and can remove superseded component versions.

 ### Administrator privileges

 Run PowerShell or Command Prompt **as Administrator** before executing this command.

 > **Warning:** Unlike the commands above, this command performs a system cleanup operation.

---

 ## 9\. Find the Largest Files in `$WinREAgent`

```
Get-ChildItem 'C:\$WinREAgent' -Force -Recurse -ErrorAction SilentlyContinue |
    Sort-Object Length -Descending |
    Select-Object -First 30 FullName,
        @{Name='SizeGB';Expression={[math]::Round($_.Length/1GB,3)}}
```

 This displays the 30 largest files found inside:

```
C:\$WinREAgent
```

 If the folder does not exist, the command will simply return no results.

---

 ## 10\. Find the Largest Top-Level Folders on C:

```
Get-ChildItem C:\ -Directory -Force -ErrorAction SilentlyContinue |
ForEach-Object {
    $size = (
        Get-ChildItem $_.FullName -File -Force -Recurse -ErrorAction SilentlyContinue |
        Measure-Object Length -Sum
    ).Sum

    [PSCustomObject]@{
        Folder = $_.FullName
        SizeGB = [math]::Round($size / 1GB, 2)
    }
} |
Sort-Object SizeGB -Descending
```

 This recursively calculates the approximate size of each top-level directory on `C:\`.

 ### Performance note

 This can take a significant amount of time because PowerShell has to enumerate files recursively.

---

 ## 11\. Check the Windows Directory

```
$env:windir
```

 This displays the location of the Windows installation directory.

 For example:

```
C:\Windows
```

---

 ## 12\. List Windows User Profiles

```
Get-ChildItem C:\Users -Directory |
    Select-Object Name
```

 This shows the user-profile directories under `C:\Users`.

---

 ## 13\. List ProgramData Folders

```
Get-ChildItem 'C:\ProgramData' -Directory -Force |
    Select-Object Name
```

 This lists directories under `C:\ProgramData`.

---

 ## 14\. Find Large Folders in a User Profile

 If your Windows username is `srleo`:

```
Get-ChildItem 'C:\Users\srleo' -Directory -Force |
ForEach-Object {
    $size = (
        Get-ChildItem $_.FullName -File -Force -Recurse -ErrorAction SilentlyContinue |
        Measure-Object Length -Sum
    ).Sum

    [PSCustomObject]@{
        Folder = $_.Name
        SizeGB = [math]::Round($size / 1GB, 2)
    }
} |
Sort-Object SizeGB -Descending
```

 ### More portable version

 Instead of hard-coding the username, you can use:

```
Get-ChildItem $env:USERPROFILE -Directory -Force |
ForEach-Object {
    $size = (
        Get-ChildItem $_.FullName -File -Force -Recurse -ErrorAction SilentlyContinue |
        Measure-Object Length -Sum
    ).Sum

    [PSCustomObject]@{
        Folder = $_.Name
        SizeGB = [math]::Round($size / 1GB, 2)
    }
} |
Sort-Object SizeGB -Descending
```

 This automatically uses the currently logged-in user's profile.

---

 ## 15\. Find Large Folders in ProgramData

```
Get-ChildItem 'C:\ProgramData' -Directory -Force |
ForEach-Object {
    $size = (
        Get-ChildItem $_.FullName -File -Force -Recurse -ErrorAction SilentlyContinue |
        Measure-Object Length -Sum
    ).Sum

    [PSCustomObject]@{
        Folder = $_.Name
        SizeGB = [math]::Round($size / 1GB, 2)
    }
} |
Sort-Object SizeGB -Descending
```

 This can help identify applications or services using significant amounts of storage.

---

 ## 16\. Find Large Folders in Windows

```
Get-ChildItem 'C:\Windows' -Directory -Force |
ForEach-Object {
    $size = (
        Get-ChildItem $_.FullName -File -Force -Recurse -ErrorAction SilentlyContinue |
        Measure-Object Length -Sum
    ).Sum

    [PSCustomObject]@{
        Folder = $_.Name
        SizeGB = [math]::Round($size / 1GB, 2)
    }
} |
Sort-Object SizeGB -Descending
```

 This calculates approximate sizes for directories inside `C:\Windows`.

 > **Warning:** Many directories under `C:\Windows` are protected system directories. Use the results for investigation rather than manually deleting files.

---

 # Recommended Diagnostic Order

 If the main purpose is to investigate a **low C: drive space** problem, run these first:

```
Get-Volume C |
    Select-Object DriveLetter,Size,SizeRemaining
```

```
vssadmin list shadowstorage
```

```
$folders = 'C:\$Windows.~WS','C:\$WinREAgent','C:\ESD'

foreach ($folder in $folders) {
    if (Test-Path $folder) {
        $size = (
            Get-ChildItem $folder -Force -Recurse -ErrorAction SilentlyContinue |
            Measure-Object -Property Length -Sum
        ).Sum

        "{0} = {1:N2} GB" -f $folder, ($size / 1GB)
    }
    else {
        "$folder = Not found"
    }
}
```

 Then investigate the largest directories:

```
Get-ChildItem C:\ -Directory -Force -ErrorAction SilentlyContinue |
ForEach-Object {
    $size = (
        Get-ChildItem $_.FullName -File -Force -Recurse -ErrorAction SilentlyContinue |
        Measure-Object Length -Sum
    ).Sum

    [PSCustomObject]@{
        Folder = $_.FullName
        SizeGB = [math]::Round($size / 1GB, 2)
    }
} |
Sort-Object SizeGB -Descending
```

 Only after identifying the cause should you consider cleanup operations such as:

```
DISM /Online /Cleanup-Image /StartComponentCleanup
```

---

 # Safety Notes

 - Run diagnostic commands first and review the results before deleting anything.
- Do not manually delete files from `C:\Windows`.
- Do not manually delete files from `C:\ProgramData` unless you know which application owns them.
- Be careful with Windows recovery and upgrade folders.
- `DISM /StartComponentCleanup` is a cleanup operation, not merely a diagnostic command.
- Recursive PowerShell scans can take several minutes on systems with many files.
- `-ErrorAction SilentlyContinue` can hide access-denied errors, so reported sizes may not always include every protected file.

---

 # Purpose

 These commands are intended to help diagnose:

 - Low disk space
- Large Windows folders
- Windows upgrade leftovers
- Recovery files
- Shadow-copy usage
- User-profile storage
- ProgramData storage
- Windows component-store usage
- Basic Windows Defender service status
- Windows version/build information
