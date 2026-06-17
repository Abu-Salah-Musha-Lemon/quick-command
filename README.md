# 🖥️ PC Hardware & System Diagnostics Toolkit

A collection of Windows and Linux commands for inspecting hardware, monitoring device changes, checking activation status, and managing system configuration.

---

## 📋 Features

* CPU information
* RAM details
* Disk drive inspection
* GPU information
* Complete system summary
* Hardware change auditing
* Device installation/removal logs
* Windows activation status
* Windows Update management

---

# Windows

## 📌 System Information

Display a complete system summary.

```powershell
systeminfo
```

---

## 🧠 CPU Information

```powershell
wmic cpu get name,NumberOfCores,NumberOfLogicalProcessors
```

---

## 💾 Memory Information

Basic RAM details:

```powershell
wmic memorychip get capacity,manufacturer,speed
```

Detailed RAM information:

```powershell
wmic memorychip get BankLabel,Manufacturer,PartNumber,Speed,SerialNumber
```

---

## 💽 Disk Information

```powershell
wmic diskdrive get model,size,serialnumber
```

---

## 🎮 GPU Information

```powershell
wmic path win32_VideoController get name
```

---

# Linux

## 📌 System Summary

```bash
sudo lshw -short
```

---

## 🧠 CPU Information

```bash
lscpu
```

---

## 💾 Memory Information

```bash
free -h
```

---

## 💽 Disk Information

```bash
lsblk
```

---

## 🎮 GPU Information

```bash
lspci | grep VGA
```

---

# 🔍 Hardware Monitoring & Auditing (Windows)

## 1. Check Device Installation / Removal Logs

```powershell
Get-WinEvent -LogName System |
Where-Object {
    $_.Id -eq 20001 -or $_.Id -eq 20003
} |
Select-Object TimeCreated, Id, Message |
Format-Table -AutoSize
```

### Event IDs

| Event ID | Description      |
| -------- | ---------------- |
| 20001    | Device Installed |
| 20003    | Device Removed   |

---

## 2. Audit Plug and Play Events

```powershell
Get-WinEvent -FilterHashtable @{
    LogName='Microsoft-Windows-DriverFrameworks-UserMode/Operational'
    ID=1003
} |
Select-Object TimeCreated, Message
```

---

## 3. Query Installed Hardware

```powershell
Get-WmiObject -Class Win32_PnPEntity |
Select-Object Name, Manufacturer, DeviceID
```

---

## 4. Export Hardware Snapshot

Create a hardware inventory for future comparison.

```powershell
Get-WmiObject -Class Win32_PnPEntity |
Export-Csv "hardware_snapshot.csv" -NoTypeInformation
```

---

## 5. Compare Hardware Changes

Create baseline:

```powershell
Get-WmiObject -Class Win32_PnPEntity |
Export-Csv "C:\hardware_snapshot.csv" -NoTypeInformation
```

Create a new snapshot later and compare:

```powershell
Compare-Object `
    (Import-Csv "C:\hardware_snapshot.csv") `
    (Import-Csv "C:\new_snapshot.csv")
```

---

# 🛡️ Enable Hardware Change Auditing

Open Group Policy Editor:

```powershell
gpedit.msc
```

Navigate to:

```text
Computer Configuration
 └─ Windows Settings
     └─ Security Settings
         └─ Advanced Audit Policy Configuration
```

Enable:

* Audit System Events
* Audit Plug and Play Events

Open Event Viewer:

```powershell
eventvwr.msc
```

---

# 🔑 Windows Activation Status

Check whether Windows activation is permanent.

## Command

```cmd
slmgr /xpr
```

## Example

```cmd
C:\> slmgr /xpr
```

## Possible Results

### Permanent Activation

```text
The machine is permanently activated.
```

### Temporary Activation

```text
Windows will expire on 12/31/2026 11:59:59 PM
```

This usually indicates a KMS or volume-based activation.

---

## Related Activation Commands

| Command            | Description                          |
| ------------------ | ------------------------------------ |
| `slmgr /dli`       | Display basic license information    |
| `slmgr /dlv`       | Display detailed license information |
| `slmgr /ato`       | Attempt activation                   |
| `slmgr /ipk <key>` | Install product key                  |
| `slmgr /upk`       | Uninstall product key                |

---

# ⚙️ Windows Update Management

> **Warning:** Disabling updates may expose your system to security vulnerabilities.

## Method 1 — Disable Windows Update Service

Open:

```powershell
services.msc
```

Locate:

```text
Windows Update
```

Change:

```text
Startup Type → Disabled
```

Then click:

```text
Stop → Apply → OK
```

---

## Method 2 — Group Policy (Pro & Enterprise)

Open:

```powershell
gpedit.msc
```

Navigate to:

```text
Computer Configuration
 └─ Administrative Templates
     └─ Windows Components
         └─ Windows Update
             └─ Manage Updates offered from Windows Update
```

Open:

```text
Configure Automatic Updates
```

Set to:

```text
Disabled
```

---

## Method 3 — Registry Editor

Open:

```powershell
regedit
```

Navigate to:

```text
HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows
```

Create:

```text
WindowsUpdate
└─ AU
    └─ NoAutoUpdate (DWORD)
```

Set:

```text
NoAutoUpdate = 1
```

Restart the system.

---

## Method 4 — Metered Connection

Navigate to:

```text
Settings
 └─ Network & Internet
     └─ Wi-Fi / Ethernet
```

Enable:

```text
Set as metered connection
```

This prevents most automatic update downloads.

---

# 📦 Requirements

## Windows

* PowerShell
* Administrator privileges (recommended)

## Linux

Install `lshw` if missing:

```bash
sudo apt update
sudo apt install lshw
```

---

# 📄 License

This project is intended for educational, troubleshooting, and system administration purposes.
