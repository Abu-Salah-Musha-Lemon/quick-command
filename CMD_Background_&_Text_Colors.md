# Change Command Prompt (CMD) Background and Text Colors

This guide explains how to customize the appearance of the Windows Command Prompt by changing the background and text colors.

---

## Method 1: Using the `color` Command

The `color` command changes the colors of the current Command Prompt window.

### Syntax

```cmd
color XY
```

* **X** = Background color
* **Y** = Text (foreground) color

> **Note:** The background and text colors cannot be the same.

---

## Common Color Combinations

### White Background with Black Text

```cmd
color F0
```

* **F** = Bright White (Background)
* **0** = Black (Text)

---

### Black Background with White Text

```cmd
color 0F
```

* **0** = Black (Background)
* **F** = Bright White (Text)

---

### Default Windows CMD Colors

```cmd
color 07
```

* **0** = Black (Background)
* **7** = Light Gray (Text)

---

## Color Code Reference

| Code | Color        |
| ---- | ------------ |
| 0    | Black        |
| 1    | Blue         |
| 2    | Green        |
| 3    | Aqua (Cyan)  |
| 4    | Red          |
| 5    | Purple       |
| 6    | Yellow       |
| 7    | Light Gray   |
| 8    | Gray         |
| 9    | Light Blue   |
| A    | Light Green  |
| B    | Light Aqua   |
| C    | Light Red    |
| D    | Light Purple |
| E    | Light Yellow |
| F    | Bright White |

---

## Make the Change Permanent

To save your preferred colors for future Command Prompt windows:

1. Open **Command Prompt**.
2. Right-click the **title bar**.
3. Select **Properties** (or **Defaults** to apply to future windows).
4. Open the **Colors** tab.
5. Choose your preferred **Screen Background** and **Screen Text** colors.
6. Click **OK**.

---

## Examples

### Hacker Style

```cmd
color 0A
```

Black background with light green text.

### White Theme

```cmd
color F0
```

White background with black text.

### Blue Theme

```cmd
color 1F
```

Blue background with bright white text.

### Yellow on Blue

```cmd
color 1E
```

Blue background with light yellow text.

---

## Reset to Default

To restore the default Command Prompt colors:

```cmd
color 07
```

---

## Summary

| Command    | Result                              |
| ---------- | ----------------------------------- |
| `color F0` | White background, black text        |
| `color 0F` | Black background, bright white text |
| `color 07` | Default CMD colors                  |
| `color 0A` | Black background, green text        |
| `color 1E` | Blue background, yellow text        |

---

Happy customizing your Windows Command Prompt!
