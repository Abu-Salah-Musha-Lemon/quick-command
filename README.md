# 🖥️ PC Hardware Check Tool

This is a simple guide and script collection to help you check your PC hardware configuration using built-in command-line tools.

---

## 📌 Features

- View CPU information
- Check RAM details
- Inspect disk drives
- Get GPU information
- Display overall system info

---

## 🧰 Requirements

### Windows:
- PowerShell (pre-installed)
- Administrator privileges (for full access)

### Linux:
- Bash terminal
- May require installing `lshw`

```bash
sudo apt install lshw
```
# System Info
systeminfo

# CPU Info
```bash
wmic cpu get name,NumberOfCores,NumberOfLogicalProcessors
```
# RAM Info
```bash
wmic memorychip get capacity,manufacturer,speed
```
# Disk Info
```bash
wmic diskdrive get model,size,serialnumber
```
# GPU Info
```bash
wmic path win32_VideoController get name
```
###Linux (Terminal)
# System Summary
```bash
sudo lshw -short
```
# CPU Info
```bash
lscpu
```
# Memory Info
```bash
free -h
```
# Disk Info
```bash
lsblk
```
# GPU Info
```bash
lspci | grep VGA
```
🔍 1. Check for Device Installation/Removal Logs(windows  powercell)
```bash
Get-WinEvent -LogName System | Where-Object {    $_.Id -eq 20001 -or $_.Id -eq 20003 } | Select-Object TimeCreated, Id, Message | Format-Table -AutoSize
```
Event IDs:

<br>20001 – New device installed
<br>20003 – Device removed
###🔧 2. Audit Plug and Play Events
```bash
Get-WinEvent -FilterHashtable @{LogName='Microsoft-Windows-DriverFrameworks-UserMode/Operational'; ID=1003} |   Select-Object TimeCreated, Message
```
###🧠 3. Query Installed Hardware with WMI
```bash
Get-WmiObject -Class Win32_PnPEntity | Select-Object Name, Manufacturer, DeviceID
```
### 🧾 4. Export Full Hardware Snapshot (Before/After Comparison)
```bash
Get-WmiObject -Class Win32_PnPEntity | Export-Csv "hardware_snapshot.csv" -NoTypeInformation
```
🛡️ Bonus: Setup Hardware Change Auditing (Windows Only)
Enable hardware change auditing through Group Policy:<br>

Run
```bash gpedit.msc```

Go to Computer Configuration > Windows Settings > Security Settings > Advanced Audit Policy Configuration<br>

Enable:<br>
<br>
Audit System Events
<br>
Audit Plug and Play Events
<br>
You can then view these in Event Viewer (eventvwr.msc).<br>
###Create a Baseline and Compare
Save current hardware info:
```bach
Get-WmiObject -Class Win32_PnPEntity | Export-Csv "C:\hardware_snapshot.csv" -NoTypeInformation
```
Later, run it again and compare files using:
```bach
Compare-Object (Import-Csv "hardware_snapshot.csv") (Import-Csv "C:\new_snapshot.csv")
```
