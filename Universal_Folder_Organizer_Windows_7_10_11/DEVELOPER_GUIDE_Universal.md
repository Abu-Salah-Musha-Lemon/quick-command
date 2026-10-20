# Developer Guide — Universal Folder Organizer (One-File Windows BAT)

**Project:** Universal Folder Organizer v2.0  
**Main executable:** `Universal_Folder_Organizer.bat`  
**Operating systems targeted:** Windows 7, Windows 10, Windows 11  
**Runtime requirement:** Windows PowerShell 2.0+ and .NET APIs built into Windows  
**External scripts:** None

This document explains **how the actual code works**, **which lines a developer can edit**, **how to extend it without adding dependencies**, and **how to test modifications safely**.

## 1. Architecture

The project is a **hybrid batch/PowerShell script stored in one `.bat` file**:

```text
Universal_Folder_Organizer.bat
  |-- Batch launcher (first section)
  |     |-- Captures the path to itself in ORGANIZER_SELF
  |     |-- Captures an optional folder argument in ORGANIZER_INPUT
  |     |-- Locates the Windows PowerShell executable
  |     |-- Reads the embedded PowerShell after a special marker
  |     `-- Preserves PowerShell's exit code and pauses
  |
  `-- #==UNIVERSAL_ORGANIZER_POWERSHELL==
        |-- Configurable file groups and skip rules
        |-- Folder menu / picker / command-line argument
        |-- Safety validation
        |-- Enumerate top-level files
        |-- Build an in-memory move plan
        |-- Show preview and request user confirmation
        |-- Move each file without overwriting
        `-- Report moved / failed / skipped totals
```

The `.bat` file is self-contained. PowerShell **reads the embedded section from the same file in memory**. It does **not** write an intermediate `.ps1` file.

### Why use PowerShell instead of pure batch?

Windows Batch can perform simple file moves, but reliable categorization, duplicate filename handling, unusual characters in filenames, and error handling are difficult. PowerShell + .NET are available on the supported Windows versions and offer filesystem APIs such as `[IO.File]::Move()`.

## 2. Entry points / user experience

| Entry point | Folder source | Shows folder selection menu? |
|---|---|---|
| Double-click BAT | User selects Downloads/Desktop/Documents/custom | Yes |
| Drag folder onto BAT | First dragged folder is passed as `%~1` | No |
| `BAT "D:\My Data"` | Explicit argument, including spaces | No |

The application **always** shows a preview and asks for `Y` before moving any files. If users select `N`, press Enter, or close the window, no file moves are initiated.

## 3. Batch launcher explained

```bat
@echo off
setlocal EnableExtensions DisableDelayedExpansion
set "ORGANIZER_SELF=%~f0"
set "ORGANIZER_INPUT=%~1"
set "ORGANIZER_PS=%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe"
```

- `%~f0` is the full path of the running BAT.
- `%~1` removes surrounding quotes from the first argument, which is usually a folder path.
- `DisableDelayedExpansion` avoids corrupting folder names containing `!`.
- The PowerShell executable path points to Windows' built-in version and does **not** require PowerShell 7.

The launcher searches the file for this literal marker:

```text
#==UNIVERSAL_ORGANIZER_POWERSHELL==
```

It takes everything after the **last** occurrence of the marker and executes that text as a PowerShell scriptblock. Do not remove, rename, or duplicate this marker without updating the batch launcher. Because the launcher uses `LastIndexOf`, an occurrence **later in the BAT than the real delimiter** can change which code is executed; avoid adding this marker elsewhere in the source. The quoted example above is documentation only, not executable source.

The launcher then saves the PowerShell exit status, runs `pause`, and exits with the same status (`0` success/cancel, `1` errors). The pause makes results visible to people who double-click the file.

## 4. PowerShell 2.0 compatibility choices

Windows 7 normally includes Windows PowerShell 2.0, so the application avoids commands/syntax that require later releases.

| Avoided feature | Compatible alternative in this project |
|---|---|
| `Get-ChildItem -File` | `Get-ChildItem | Where-Object { -not $_.PSIsContainer }` |
| `[ordered]@{}` | A normal array of simple hashtables |
| `[pscustomobject]@{}` | `New-Object PSObject -Property @{...}` |
| `[System.Collections.Generic.HashSet[string]]::new()` | Standard hashtable for reserved destinations |
| `-notin` | `-contains` with boolean logic, or direct string comparison |
| Third-party dialog libraries | Windows Shell COM `Shell.Application.BrowseForFolder()` |

**Windows 7 testing note:** This version is written against older APIs, but it has not been run inside a Windows 7 machine in the creation environment. Verify on each target version before production use.

## 5. Configuration: where developers should start

Open `Universal_Folder_Organizer.bat` in VS Code, Notepad++, or Notepad. Locate:

```powershell
# -------------------------- CUSTOM SETTINGS ---------------------------
$groups = @(
    @{ Name='Images'; Extensions=@('.jpg','.jpeg','.png',...) },
    @{ Name='Videos'; Extensions=@('.mp4','.mkv','.mov',...) },
    # ...
)
$unknownCategory = 'Others'
$previewLimit = 30
$incompleteExtensions = @('.crdownload','.part',...)
$skipExtensions = @('.lnk','.url')
$skipNames = @('desktop.ini','thumbs.db')
```

### 5.1 Add a file extension

To classify `.jfif` images, insert `'.jfif'` within the `Images` array:

```powershell
@{ Name='Images'; Extensions=@('.jpg','.jpeg','.png','.jfif','.webp') },
```

**Rules:** Include the dot (`.`); use quotes; separate items using commas; each extension should be present in only one group. The map converts extensions to lowercase when it starts.

### 5.2 Create a new category

For 3D model files, add a new item inside `$groups`:

```powershell
@{ Name='Models_3D'; Extensions=@('.stl','.obj','.fbx','.blend') },
```

For a file named `robot.stl`, the destination becomes `YourFolder\Models_3D\robot.stl`. **Use a simple directory name:** do not add a path separator, `..`, absolute path, or other path-navigation syntax as a category name.

### 5.3 Rename a folder

Change the `Name` property:

```powershell
@{ Name='Photos'; Extensions=@('.jpg','.jpeg','.png') },
```

Newly organized images will go into `Photos`. Existing `Images` folder contents **will not be renamed or moved**; the script never recurses into folders.

### 5.4 Change `.ts` classification

The default is `.ts` in `Code` (TypeScript). If your `.ts` files are MPEG transport-stream videos, remove `'.ts'` from the Code extensions and add it to Videos.

### 5.5 Change unknown file destination

```powershell
$unknownCategory = 'Unsorted'
```

Files with extensions that are not listed (and files with no extension) will go to the `Unsorted` subfolder.

### 5.6 Show more files during preview

```powershell
$previewLimit = 100
```

This only changes how many moves are **displayed**. All planned files remain subject to confirmation and, if approved, will be processed.

### 5.7 Preserve additional extensions

To ensure `.reg` files are not moved:

```powershell
$skipExtensions = @('.lnk','.url','.reg')
```

Or skip a specific filename anywhere:

```powershell
$skipNames = @('desktop.ini','thumbs.db','DO_NOT_MOVE.txt')
```

Both arrays are compared case-insensitively by PowerShell's default `-contains` behavior.

### 5.8 Change available folders in the start menu

Edit the `Choose-TargetFolder` function. The default menu exposes Downloads, Desktop, Documents, Browse, Paste/Type, and Exit. For example, another known folder can be added by using:

```powershell
[Environment]::GetFolderPath('MyPictures')
```

Be sure to use a new numeric menu choice and update the prompt to match. The browse and typed-path entries already let users select other personal folders without changing code.

## 6. Folder discovery logic

- **Downloads:** `Get-DownloadsFolder` first reads the well-known Windows Downloads folder registry value from `Explorer\User Shell Folders`. If unavailable, it uses `%USERPROFILE%\Downloads`.
- **Desktop:** `[Environment]::GetFolderPath('DesktopDirectory')`.
- **Documents:** `[Environment]::GetFolderPath('MyDocuments')`.
- **Browse:** `Shell.Application.BrowseForFolder(...)` (Windows built-in COM object).
- **Typed/dragged path:** the code expands `%ENVIRONMENT_VARIABLES%` and calls `[IO.Path]::GetFullPath()`.

Built-in known folder resolution supports common redirected locations (including some OneDrive redirections). It cannot make inaccessible locations writable; the user still needs permissions.

## 7. Folder-level protections

Before enumerating files, `Is-ProtectedTarget` blocks:

1. **Drive/share roots**, such as `C:\` or a network share root.
2. Windows system directories and their descendants (`%WINDIR%`, `%ProgramFiles%`, `%ProgramData%`, and Program Files (x86) when present).
3. High-risk exact directories: `%USERPROFILE%`, `%SystemDrive%\Users`, and `%SystemDrive%\Documents and Settings`.

This deliberately blocks moving files from operating-system installation locations. Personal folders such as Desktop, Documents, Downloads, and project directories elsewhere remain valid targets.

**Do not remove these guards casually.** If expanding them, consider junctions/symlinks and redirected folders. The guard uses lexical path comparisons and is not intended to be a complete filesystem security boundary.

## 8. Inventory and file exclusions

The script enumerates only the immediate children of the selected directory:

```powershell
$files = @(Get-ChildItem -LiteralPath $target |
    Where-Object { -not $_.PSIsContainer } |
    Sort-Object Name)
```

Notably:

- There is **no `-Recurse`**.
- Existing subfolders are **not moved or scanned**.
- There is **no `-Force`**, so hidden/system items are normally absent even before additional attribute checks.
- It skips the running BAT itself; hidden/system/reparse files; known incomplete downloads; `.lnk`/`.url` shortcut files; and configured filenames such as `desktop.ini`.
- Other existing `.bat` files may be moved into Code (only the actively running BAT is specially protected).

File attributes are inspected via `[IO.FileAttributes]`. Incomplete download extensions are matched by the **last** filename extension, so a file ending in `.crdownload` will be skipped.

## 9. Classifying files

During setup, the script builds a lookup hashtable:

```powershell
$extensionMap = @{}
foreach ($group in $groups) {
    foreach ($extension in $group.Extensions) {
        $key = [string]$extension
        $key = $key.ToLowerInvariant()
        if (-not $extensionMap.ContainsKey($key)) {
            $extensionMap[$key] = [string]$group.Name
        }
    }
}
```

The program warns if you accidentally list an extension in more than one group. The **first group wins** (deterministic array order). If a file's extension is not present in the map, it uses `$unknownCategory`.

**Note on multi-part extensions:** `.tar.gz` is classified by its final extension `.gz`. This already maps to Archives; if you need more complex filename rules, add explicit logic before the default extension lookup.

## 10. Preview (dry-run) and duplicate avoidance

The script adds each planned action to an in-memory `System.Collections.ArrayList`. During preview it does not create folders or move files.

For each file it:

1. Determines the category from its extension.
2. Constructs `targetFolder\category\filename.ext`.
3. Tests whether that destination exists or is already reserved by an earlier plan item.
4. If occupied, tries `filename (1).ext`, then `(2)`, etc.
5. Saves `Name`, `Source`, `Destination`, and `Category` as a `PSObject`.

It then prints totals, category counts, and up to `$previewLimit` example moves. `Read-Host` requires a case-insensitive `Y` before applying changes. All other responses cancel.

**Not a transactional operation:** Another process can create files between preview and execution. The execution phase rechecks the destination immediately before `File.Move`. In a genuine race, an unexpected collision fails safely rather than overwriting. A few earlier files may already have moved by the time a later file fails.

## 11. Execution and failure handling

Execution uses built-in .NET methods:

```powershell
[void][IO.Directory]::CreateDirectory($destinationDir)
[IO.File]::Move($item.Source, $item.Destination)
```

- `CreateDirectory` is safe when the category folder already exists.
- `File.Move` moves rather than copying and does not overwrite an existing destination.
- Each file is handled with its own `try/catch` so one failure does not prevent later files from being processed.
- Typical failures: insufficient permissions, a locked source file, path-length limits on older Windows, missing source, or a destination that appeared after planning.
- The script reports **Moved**, **Failed**, and **Skipped**. An execution with failures exits with status `1`.

**There is no undo** and no audit log created on disk. If you need rollback support, develop and test a separate move manifest/restore mechanism before using the tool on important data.

## 12. Suggested test matrix

Create a safe test folder (never use irreplaceable source files for initial testing):

```text
C:\OrganizerTest\
  photo.png
  photo.jpg
  video.mp4
  README.md
  notes.txt
  backup.zip
  main.cpp
  data.unknown
  in_progress.crdownload
  shortcut.lnk
  ExistingSubfolder\
    nested.png
  Images\
    photo.png     <-- forces duplicate rename
```

### Functional tests

| Test | Expected result |
|---|---|
| Run BAT without arguments | Shows folder-selection menu |
| Select `5`, enter `C:\OrganizerTest` | Shows preview for test folder |
| Type `N` | Nothing moves; no new folders created |
| Type `Y` | Category folders created; supported top-level files move |
| Preexisting `Images\photo.png` | New photo becomes `photo (1).png` |
| `ExistingSubfolder\nested.png` | Remains where it was |
| `in_progress.crdownload` | Not moved |
| `.lnk` and `desktop.ini` | Not moved |
| Put organizer BAT inside target | It is never moved |
| Drag a folder onto BAT | Bypasses folder menu and shows preview |
| Run against `C:\` or `%WINDIR%` | Refused |
| Run against nonexistent folder | Clear error, no move |
| Put locked/read-only files in sample | Appropriate failures reported |
| Set `.ts` mapping to Videos | Sample `.ts` routes to Videos |

### Windows-specific tests

Repeat a small test on Windows 7, Windows 10, and Windows 11 (physical PCs or isolated VMs). In particular verify: double-click behavior, folder dialog, Unicode filenames, paths with spaces/`&`/`!`, Desktop/Documents known folders, preview cancellation, duplicate names, permission errors, and SMB/network paths (if needed). Standard Windows long path limitations may apply.

This guide is a source walkthrough and static design review. **Execution on all three Windows versions has not been verified in this environment.**

## 13. Maintenance guidance

- Keep the opening batch portion and the embedded-section marker intact.
- Do not introduce PS3+ syntax if Windows 7/PowerShell 2.0 support is required.
- Use simple category names (no directory separators or traversal).
- Never add `-Recurse` unless you redesign the safety and duplicate handling to manage nested paths.
- Test **preview mode** and **duplicate collisions** after any changes to file selection or destination naming.
- Consider version control (Git) so changes to extensions, skip logic, and safety behavior can be reviewed and reverted.
- If enabling automatic/scheduled execution, review the risk: this version intentionally requires an interactive confirmation.

## 14. FAQ

**Q: Does it require Python?**  
A: No. The BAT launches built-in Windows PowerShell and reads its own embedded PowerShell section.

**Q: Can it organize any drive?**  
A: It can organize normal writable folders on internal/external drives or network shares. For safety it intentionally refuses drive roots and protected system areas.

**Q: Can developers add more categories?**  
A: Yes, add an entry to `$groups`; no change to the planning/move loop is needed.

**Q: What happens if two categories list the same extension?**  
A: A warning is printed; the first matching group in `$groups` takes precedence.

**Q: Is Windows 7 supported?**  
A: The implementation targets Windows 7's built-in Windows PowerShell 2.0 and older .NET features; actual Windows 7 execution should be tested in a local VM/PC.

**Q: What happens to files inside already-existing folders?**  
A: Nothing. Only top-level files from the selected directory are considered.
