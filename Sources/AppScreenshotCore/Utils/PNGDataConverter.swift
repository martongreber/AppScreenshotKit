//
//  PNGDataConverter.swift
//  AppScreenshotKit
//
//  Created by Shuhei Shitamori on 2025/04/25.
//

import SwiftUI

@MainActor
struct PNGDataConverter {
    /// Convert a SwiftUI view to PNG Data
    func convert<Content: View>(
        _ content: Content,
        rect: CGRect? = nil,
        scale: CGFloat = 1
    ) throws -> Data {
        #if canImport(UIKit)
            let controller = UIHostingController(rootView: content)
            if #available(iOS 16.4, *) {
                controller.safeAreaRegions = []
            }
            let view = controller.view!
            let targetSize = controller.view.intrinsicContentSize
            view.bounds = CGRect(origin: .zero, size: targetSize)
            view.backgroundColor = .clear

            let window = UIWindow()
            window.frame = CGRect(origin: .zero, size: targetSize)
            window.rootViewController = controller
            window.makeKeyAndVisible()
            controller.view.setNeedsLayout()
            controller.view.layoutIfNeeded()

            let format = UIGraphicsImageRendererFormat()
            format.scale = scale
            format.opaque = false

            let rect = rect ?? CGRect(origin: .zero, size: targetSize)
            let renderer = UIGraphicsImageRenderer(size: rect.size, format: format)
            return renderer.pngData { ctx in
                ctx.cgContext.translateBy(x: -rect.origin.x, y: -rect.origin.y)
                view.layer.render(in: ctx.cgContext)
            }
        #elseif canImport(AppKit)
            let view = NSHostingView(rootView: content)
            let targetSize = view.intrinsicContentSize
            view.frame = NSRect(origin: .zero, size: targetSize)

            guard let bitmapRep = view.bitmapImageRepForCachingDisplay(in: view.bounds) else {
                return Data()
            }

            view.cacheDisplay(in: view.bounds, to: bitmapRep)
            let targetRect = rect ?? CGRect(origin: .zero, size: targetSize)
            let scale = CGFloat(bitmapRep.pixelsWide) / targetSize.width

            let pixelRect = CGRect(
                x: targetRect.origin.x * scale,
                y: targetRect.origin.y * scale,
                width: targetRect.size.width * scale,
                height: targetRect.size.height * scale
            )

            let outputRep: NSBitmapImageRep
            if let cgImage = bitmapRep.cgImage,
                let croppedImage = cgImage.cropping(to: pixelRect.integral)
            {
                let outputPixelWidth = max(Int(round(targetRect.size.width)), 1)
                let outputPixelHeight = max(Int(round(targetRect.size.height)), 1)
                let resizedRep = NSBitmapImageRep(
                    bitmapDataPlanes: nil,
                    pixelsWide: outputPixelWidth,
                    pixelsHigh: outputPixelHeight,
                    bitsPerSample: 8,
                    samplesPerPixel: 4,
                    hasAlpha: true,
                    isPlanar: false,
                    colorSpaceName: .deviceRGB,
                    bytesPerRow: 0,
                    bitsPerPixel: 0
                )

                if let resizedRep {
                    NSGraphicsContext.saveGraphicsState()
                    if let context = NSGraphicsContext(bitmapImageRep: resizedRep) {
                        NSGraphicsContext.current = context
                        context.cgContext.interpolationQuality = .high
                        context.cgContext.draw(
                            croppedImage,
                            in: CGRect(
                                origin: .zero,
                                size: CGSize(
                                    width: CGFloat(outputPixelWidth),
                                    height: CGFloat(outputPixelHeight)
                                )
                            )
                        )
                        context.cgContext.flush()
                    }
                    NSGraphicsContext.restoreGraphicsState()
                    outputRep = resizedRep
                } else {
                    outputRep = NSBitmapImageRep(cgImage: croppedImage)
                }
            } else {
                outputRep = bitmapRep
            }

            guard let data = outputRep.representation(using: .png, properties: [:]) else {
                return Data()
            }

            return data
        #endif
    }
}
