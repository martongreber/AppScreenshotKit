//
//  RegisterBezelsCommand.swift
//  AppScreenshotKit
//
//  Created by Shuhei Shitamori on 2025/05/11.
//

import Foundation
import PackagePlugin

@main
struct RegisterBezelsCommand: BuildToolPlugin {
    func createBuildCommands(
        context: PackagePlugin.PluginContext,
        target: any PackagePlugin.Target
    ) async throws -> [PackagePlugin.Command] {
        let cacheDirectoryURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let bezelsRootURL = cacheDirectoryURL.appending(
            path: "com.shitamori1272.AppScreenshotKit/AppleDesignResource"
        )
        let sourceBezelsURL = bezelsRootURL.appending(path: "Bezels")
        let outputRootURL = context.pluginWorkDirectoryURL.appending(path: "AppleDesignResource")
        let outputBezelsURL = outputRootURL.appending(path: "Bezels")

        guard FileManager.default.fileExists(atPath: sourceBezelsURL.path) else {
            Diagnostics.warning(
                "No bezels found in \(sourceBezelsURL.path). Please download Apple's bezel resources manually and place them under this directory."
            )

            try FileManager.default.createDirectory(at: outputBezelsURL, withIntermediateDirectories: true)

            return [
                .buildCommand(
                    displayName: "Register Dummy Bezel image file",
                    executable: URL(fileURLWithPath: "/usr/bin/touch"),
                    arguments: [
                        outputBezelsURL.appending(path: "dummy.txt").path()
                    ],
                    environment: [:],
                    inputFiles: [
                        cacheDirectoryURL
                    ],
                    outputFiles: [
                        outputBezelsURL
                    ]
                )
            ]
        }

        try FileManager.default.createDirectory(at: outputRootURL, withIntermediateDirectories: true)

        return [
            .buildCommand(
                displayName: "Register Bezel images",
                executable: URL(fileURLWithPath: "/bin/cp"),
                arguments: [
                    "-R",
                    sourceBezelsURL.path(),
                    outputRootURL.path(),
                ],
                environment: [:],
                inputFiles: [
                    cacheDirectoryURL
                ],
                outputFiles: [
                    outputBezelsURL
                ]
            )
        ]
    }
}
