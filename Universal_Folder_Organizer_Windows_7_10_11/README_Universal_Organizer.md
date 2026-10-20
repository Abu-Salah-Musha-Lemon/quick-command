# Universal Folder Organizer for Windows 7, 10, and 11

**One standalone `.bat` file. No Python, installation, or second script required.**

The organizer sorts **files directly inside a folder you select** into category subfolders (Images, Videos, Documents, Archives, Code, etc.). Choose the **Desktop**, **Documents**, **Downloads**, or **any other ordinary personal folder**. It shows a preview and requires a `Y` confirmation before moving anything.

> Windows 7 compatibility is implemented using Windows PowerShell 2.0-compatible syntax and built-in Windows/.NET features. Windows 7 could not be tested in this environment; test with disposable files before organizing important data. Windows 7 is no longer supported by Microsoft.

## Download / contents

- **`Universal_Folder_Organizer.bat`** — only file needed to run the organizer.
- `README_Universal_Organizer.md` — user instructions (optional).
- `DEVELOPER_GUIDE_Universal.md` — technical walkthrough and customization (optional).

## Use it

### Method A: Double-click

1. Save `Universal_Folder_Organizer.bat` anywhere on your PC.
2. Double-click it.
3. Choose from the menu:
   - `1` = Downloads
   - `2` = Desktop
   - `3` = Documents
   - `4` = Browse for a folder
   - `5` = Paste/type a folder path
   - `6` = Exit
4. Read the **preview** (file counts and destination categories).
5. Type **`Y`** and press Enter to move the files, or anything else to cancel.

### Method B: Drag and drop

Drag **one folder** from File Explorer onto `Universal_Folder_Organizer.bat`. The chosen folder is used without showing the menu; you still get the preview and confirmation.

### Method C: Command Prompt

```bat
"C:\Tools\Universal_Folder_Organizer.bat" "D:\Work Files\Project Assets"
```

You can also target a network folder if it is accessible and you have write permission:

```bat
"C:\Tools\Universal_Folder_Organizer.bat" "\\SERVER\Share\MyFiles"
```

## Before and after

Before:

```text
Documents\
  report.pdf
  notes.md
  cover.png
  slides.pptx
  backup.zip
  important_folder\
```

After you confirm:

```text
Documents\
  Documents\
    report.pdf
    slides.pptx
  Markdown\
    notes.md
  Images\
    cover.png
  Archives\
    backup.zip
  important_folder\  <-- existing subfolder remains untouched
```

## Folder categories

| Destination | Sample extensions |
|---|---|
| `Images` | `.jpg`, `.jpeg`, `.png`, `.gif`, `.webp`, `.svg` |
| `Videos` | `.mp4`, `.mkv`, `.avi`, `.mov`, `.webm` |
| `Audio` | `.mp3`, `.wav`, `.flac`, `.aac` |
| `Documents` | `.pdf`, `.docx`, `.xlsx`, `.pptx`, `.txt`, `.csv` |
| `Markdown` | `.md`, `.markdown`, `.mdown` |
| `Archives` | `.zip`, `.rar`, `.7z`, `.tar`, `.gz` |
| `Code` | `.py`, `.cpp`, `.java`, `.html`, `.js`, `.ts`, `.bat`, `.ps1` |
| `Installers` | `.exe`, `.msi`, `.apk` |
| `Fonts` | `.ttf`, `.otf`, `.woff` |
| `Others` | Any other unrecognized extension, including extensionless files |

The exact list of extensions is in the BAT's `$groups` setting. Note: `.ts` defaults to `Code` (TypeScript). To treat `.ts` as video, move it to the Videos group instead.

## Safety features

- **Preview-first:** nothing moves until you type `Y`.
- **No recursion:** it never scans or moves the contents of existing subfolders.
- **No overwrites:** duplicates become `name (1).ext`, `name (2).ext`, etc. The script checks again immediately before each move.
- **Self-protection:** it never moves the currently running `.bat` file.
- **Conservative exclusions:** known incomplete downloads (`.crdownload`, `.part`, `.tmp`, etc.), `.lnk` and `.url` shortcuts, `desktop.ini`, hidden/system files, and reparse-point files are skipped.
- **System protections:** drive roots, Windows, Program Files, ProgramData, the Users folder, and your user-profile root are blocked as targets.
- **No extra generated files:** the PowerShell code is already embedded inside the BAT. The script does not create a temporary `.ps1`, log, or configuration file.

**Important:** This changes where files are stored and may break software or documents that depend on files staying in their original location. Use a test folder or a backup first. There is no automatic undo or restore function. Files that are open, locked, or inaccessible might fail to move; such failures are reported.

## Requirements

- Windows 7, 10, or 11.
- Windows PowerShell 2.0 or later (included in a standard Windows 7 installation and available on Windows 10/11).
- Read/write permissions in the selected folder.

No Python, `pip`, third-party programs, or separate PowerShell files are needed.

## Customize

Right-click the BAT -> **Edit** (or open it in VS Code/Notepad), and locate the embedded PowerShell section:

```powershell
# Add/remove extensions or rename the categories here.
$groups = @(
    @{ Name='Images'; Extensions=@('.jpg','.png', ...) },
    ...
)
```

Edit category names, extensions, skip rules, preview length, or the unknown category label in **CUSTOM SETTINGS**. Read [`DEVELOPER_GUIDE_Universal.md`](DEVELOPER_GUIDE_Universal.md) for step-by-step examples and technical details.

## Troubleshooting

| Problem | What to do |
|---|---|
| Folder does not exist | Check spelling, quotations, and whether the drive is connected. |
| Folder picker does not open | Choose option `5` and paste the full folder path. |
| `BLOCKED: For safety` | Choose a personal data folder rather than a Windows/system directory or drive root. |
| Access denied | Run from an account with read/write access and close apps using the files. |
| Some files stay put | They may be hidden, system files, shortcuts, incomplete downloads, links, or locked. |
| Script window immediately closes | Run it from Command Prompt to see output; the normal BAT launcher pauses at the end. |
| Categorization not as expected | Edit `$groups` in the BAT and test on a sample folder. |

## Compatibility and limitations

The source intentionally avoids Windows PowerShell 3+/5+-only features such as `Get-ChildItem -File`, `[ordered]`, `[pscustomobject]`, `-notin`, and `::new()`. It uses Windows PowerShell 2.0-compatible commands and .NET file operations. This is a **compatibility-oriented design, not a substitute for testing on each Windows release**. It does not recurse into folders, watch folders continuously, schedule recurring runs, or offer automatic undo. The standard Windows legacy path-length limits may apply on older systems.
