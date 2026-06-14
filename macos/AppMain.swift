import AppKit
import WebKit

final class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    private var window: NSWindow!
    private var webView: WKWebView!
    private var serverProcess: Process?
    private let serverURL = URL(string: "http://127.0.0.1:43110")!

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.regular)
        startServerIfNeeded()
        createWindow()
        waitForServerAndLoad()
        NSApp.activate(ignoringOtherApps: true)
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool { true }

    func applicationWillTerminate(_ notification: Notification) {
        if let serverProcess, serverProcess.isRunning { serverProcess.terminate() }
    }

    func windowWillClose(_ notification: Notification) { NSApp.terminate(nil) }

    private func createWindow() {
        let configuration = WKWebViewConfiguration()
        configuration.websiteDataStore = .default()
        webView = WKWebView(frame: .zero, configuration: configuration)
        window = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 1180, height: 780), styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView], backing: .buffered, defer: false)
        window.title = "OpenClaw 会话管理器"
        window.titlebarAppearsTransparent = true
        window.titleVisibility = .hidden
        window.minSize = NSSize(width: 760, height: 560)
        window.center()
        window.contentView = webView
        window.delegate = self
        window.makeKeyAndOrderFront(nil)
    }

    private func serverIsReady() -> Bool {
        guard let data = try? Data(contentsOf: serverURL.appendingPathComponent("api/status")), !data.isEmpty else { return false }
        return true
    }

    private func startServerIfNeeded() {
        guard !serverIsReady(), let resourceURL = Bundle.main.resourceURL, let nodeURL = findExecutable(named: "node") else { return }
        let process = Process()
        process.executableURL = nodeURL
        process.arguments = ["server.mjs"]
        process.currentDirectoryURL = resourceURL.appendingPathComponent("app")
        var environment = ProcessInfo.processInfo.environment
        let home = FileManager.default.homeDirectoryForCurrentUser.path
        environment["PATH"] = "\(home)/.npm-global/bin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin"
        process.environment = environment
        let logURL = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Library/Logs/OpenClaw Session Manager.log")
        FileManager.default.createFile(atPath: logURL.path, contents: nil)
        if let handle = try? FileHandle(forWritingTo: logURL) {
            handle.truncateFile(atOffset: 0)
            process.standardOutput = handle
            process.standardError = handle
        }
        try? process.run()
        serverProcess = process
    }

    private func findExecutable(named name: String) -> URL? {
        let home = FileManager.default.homeDirectoryForCurrentUser.path
        let candidates = ["\(home)/.local/bin/\(name)", "/opt/homebrew/bin/\(name)", "/usr/local/bin/\(name)", "/usr/bin/\(name)"]
        return candidates.first(where: { FileManager.default.isExecutableFile(atPath: $0) }).map(URL.init(fileURLWithPath:))
    }

    private func waitForServerAndLoad(attempt: Int = 0) {
        if serverIsReady() { webView.load(URLRequest(url: serverURL)); return }
        guard attempt < 50 else {
            webView.loadHTMLString("<body style='font:16px -apple-system;padding:40px'><h2>无法启动 OpenClaw 会话管理器</h2><p>请查看 ~/Library/Logs/OpenClaw Session Manager.log</p></body>", baseURL: nil)
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { self.waitForServerAndLoad(attempt: attempt + 1) }
    }
}

let application = NSApplication.shared
let delegate = AppDelegate()
application.delegate = delegate
application.run()
