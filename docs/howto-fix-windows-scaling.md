# How-To: Fix Windows 11 UI Scaling and Overlapping Issues

When running YPipe on Windows 11 with High-DPI (Retina) displays, the JavaFX graphical interface may occasionally overlap other applications, run off-screen, or cover the Windows taskbar. 

While YPipe includes auto-bounding logic to shrink the initial window to fit your usable workspace, you can also resolve or customize this behavior manually using operating system or JVM scaling workarounds.

---

## 1. Force Scaling via JVM System Properties

You can explicitly override JavaFX's DPI scaling behavior by passing a system property to the Java Virtual Machine (JVM). This overrides the automatic scaling and forces the UI to render at a 1:1 pixel scale.

### Using JBang
Run YPipe with the `--java-options` flag:
```bash
jbang --java-options "-Dglass.win.uiScale=1.0" ypipe@.
```

### Using Executable JAR / Java Command
Pass the property using the `-D` flag:
```bash
java -Dglass.win.uiScale=1.0 -jar ypipe-cross-platform.jar
```

> [!NOTE]
> Setting the scale factor to `1.0` (or `100%`) will prevent the window from expanding beyond your screen boundary. However, on highly dense displays, this will make text and interface elements appear smaller.

---

## 2. Windows Compatibility DPI Override

You can delegate the scaling control back to Windows rather than letting JavaFX/Java handle it natively.

1. Navigate to the folder containing your executable Java runner (e.g. `java.exe` / `javaw.exe` under your JDK installation directory) or right-click the YPipe launcher/shortcut if using a packaged installer.
2. Right-click the file and select **Properties**.
3. Navigate to the **Compatibility** tab.
4. Click the **Change high DPI settings** button.
5. In the next dialog:
   * Check the box under **High DPI scaling override** labeled: **"Override high DPI scaling behavior."**
   * Change the **Scaling performed by:** dropdown menu from **System** to **Application** (or vice-versa, depending on which renders cleaner on your display setup).
6. Click **OK**, then **Apply**.

---

## 3. Disable "Fix Apps so they're not blurry"

Windows 11 features a built-in assistant designed to auto-correct blurry scaling on legacy apps. This frequently conflicts with JavaFX's built-in scaling calculations.

1. Open Windows **Settings** (Win + I).
2. Go to **System** $\rightarrow$ **Display** $\rightarrow$ **Scale & layout**.
3. Locate **Let Windows try to fix apps so they're not blurry** (sometimes found under *Advanced scaling settings* depending on your Windows build version).
4. Toggle this setting to **Off**.
