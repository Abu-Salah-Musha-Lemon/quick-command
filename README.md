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
```bash
wmic memorychip get BankLabel, Manufacturer, PartNumber, Speed, SerialNumber
```
# Disk Info
```bash
wmic diskdrive get model,size,serialnumber
```
# GPU Info
```bash
wmic path win32_VideoController get name
```
### Linux (Terminal)
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
### 🔧 2. Audit Plug and Play Events
```bash
Get-WinEvent -FilterHashtable @{LogName='Microsoft-Windows-DriverFrameworks-UserMode/Operational'; ID=1003} |   Select-Object TimeCreated, Message
```
### 🧠 3. Query Installed Hardware with WMI
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

1. Disable Windows Update Service (Permanent until re-enabled)

This method disables the Windows Update service, effectively preventing updates from downloading or installing.

Steps:

Press Win + R to open the Run dialog box.

Type services.msc and press Enter.

In the Services window, scroll down to find Windows Update.

Right-click Windows Update and select Properties.

In the Startup type dropdown menu, select Disabled.

Click Stop to stop the service immediately.

Click Apply, then OK.

This method works well for disabling updates until you manually enable the service again.

2. Using Group Policy Editor (Pro & Enterprise versions only)

The Group Policy Editor is a powerful tool in Windows 11 Pro and Enterprise versions. You can use it to configure update settings and prevent updates from being installed automatically.

Steps:

Press Win + R to open the Run dialog box.

Type gpedit.msc and press Enter.

In the Local Group Policy Editor, navigate to:

Computer Configuration > Administrative Templates > Windows Components > Windows Update > Manage Updates offered from Windows Update


On the right side, double-click Configure Automatic Updates.

Set it to Disabled and click Apply and OK.

3. Using Registry Editor (Advanced Users)

You can modify the Windows Registry to prevent updates from being installed.

Steps:

Press Win + R to open the Run dialog box.

Type regedit and press Enter.

Navigate to the following path:

HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows


Right-click the Windows folder, select New > Key, and name it WindowsUpdate.

Right-click the WindowsUpdate folder, select New > Key, and name it AU.

Right-click the AU folder, select New > DWORD (32-bit) Value, and name it NoAutoUpdate.

Double-click NoAutoUpdate, set its value to 1, and click OK.

Close the Registry Editor and restart your computer.

4. Using Metered Connection (Temporary Solution)

If you don't want to permanently disable updates but want to prevent them from downloading over your network, you can set your Wi-Fi or Ethernet connection as "metered."

Steps:

Go to Settings > Network & Internet.

Select either Wi-Fi or Ethernet depending on your connection.

Click on the network you're connected to.

Toggle Set as metered connection to On.

This prevents Windows 11 from automatically downloading updates when using a metered connection, but it won’t prevent manual updates or major version upgrades.

5. Using Third-Party Tools (Not recommended for long-term use)

There are third-party tools like O&O ShutUp10++ and Windows Update Blocker that can help manage updates on Windows, but be cautious using them. They can sometimes cause issues, and these tools may not be compatible with every Windows update.

# `slmgr /xpr`

Checks whether your Windows activation is permanent or has an expiration date.

## Syntax

```cmd
slmgr /xpr
```

## Example

```cmd
C:\> slmgr /xpr
```

## Possible Outputs

### Permanent Activation

```text
The machine is permanently activated.
```

**Meaning:** Windows is permanently activated.

### Temporary Activation

```text
Windows will expire on 12/31/2026 11:59:59 PM
```

**Meaning:** Windows is activated through a temporary license (such as KMS) and will expire on the shown date.

## Related Commands

| Command | Description |
|----------|-------------|
| `slmgr /dli` | Display basic license information |
| `slmgr /dlv` | Display detailed license information |
| `slmgr /ato` | Attempt online activation |
| `slmgr /ipk <key>` | Install a product key |
| `slmgr /upk` | Uninstall the current product key |

## Notes

- Works on Windows 10 and Windows 11.
- Administrator privileges are recommended.
- Useful for checking whether activation is Retail, OEM, or KMS-based.


