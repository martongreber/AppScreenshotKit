import AppScreenshotKitTestTools
import Testing
import Foundation

@testable import Demo

@MainActor
@Test func example() async throws {
    let outputDirectoryURL = try AppScreenshotKitUtils.packageURL().appending(path: "Screenshots")

    let exporter = AppScreenshotExporter(option: .file(outputURL: outputDirectoryURL))
    exporter.setAppleDesignResourceURL(URL(filePath: "/Users/martongreber/Documents/AppleDesignResources"))

    try exporter.export(READMEDemo.self)
}
