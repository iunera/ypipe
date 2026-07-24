# How-To: Configure Proxy Settings in YPipe

YPipe is designed to work seamlessly in restricted or enterprise environments that require network traffic (such as downloading GGUF models or llama.cpp runtimes) to go through an HTTP or HTTPS proxy.

---

## 1. Automatic Proxy Detection (Default)

By default, YPipe automatically detects and inherits your operating system's native proxy settings on startup (macOS, Windows, and Linux). 

This is enabled by the following JVM instruction executed during the bootstrap phase:
```java
System.setProperty("java.net.useSystemProxies", "true");
```

If your machine is already configured to use a system proxy (e.g., via macOS System Settings -> Network -> Proxies, or Windows Internet Options), **no additional configuration is required**. YPipe will automatically route all model and runtime downloads through it.

---

## 2. Explicit JVM Proxy Configuration

If you want to override your system proxy settings or specify a proxy explicitly, you can pass JVM system properties when starting the launcher.

### Using JBang
```bash
jbang --java-options "-Dhttps.proxyHost=your.proxy.server -Dhttps.proxyPort=8080 -Dhttp.nonProxyHosts=localhost|127.0.0.1" ypipe@.
```

### Using Executable JAR / Java Command
```bash
java -Dhttps.proxyHost=your.proxy.server \
     -Dhttps.proxyPort=8080 \
     -Dhttp.nonProxyHosts="localhost|127.0.0.1" \
     -jar ypipe.jar
```

---

## 3. Proxy Authentication

If your corporate proxy requires username and password authentication, you can configure the credentials globally for the Java Virtual Machine by setting the following properties:

```bash
java -Dhttps.proxyHost=your.proxy.server \
     -Dhttps.proxyPort=8080 \
     -Djdk.http.auth.tunneling.disabledSchemes="" \
     -Dhttp.proxyUser=your_username \
     -Dhttp.proxyPassword=your_password \
     -jar ypipe.jar
```

> [!NOTE]
> Setting `-Djdk.http.auth.tunneling.disabledSchemes=""` is required on modern JDKs (including Java 25) to allow Basic authentication over HTTP/HTTPS proxy tunnels.
