//  Bezel.swift
//  AppScreenshotKit
//
//  Created by Shuhei Shitamori on 2025/04/25.
//

import SwiftUI

/// A view that renders app content within a device bezel frame.
struct Bezel<Content: View>: View {
    @Environment(\.deviceModel) var model: DeviceViewModel
    let bezelImageData: Data
    let content: Content

    init(bezelImageData: Data, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.bezelImageData = bezelImageData
    }

    var body: some View {
        Image(data: bezelImageData)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .background {
                GeometryReader { proxy in
                    let bezelDefinition = model.appldeBezelDefinition
                    let scale = min(
                        proxy.size.width / bezelDefinition.imageSize.width,
                        proxy.size.height / bezelDefinition.imageSize.height
                    )
                    let scaledScreenOrigin = CGPoint(
                        x: bezelDefinition.screenRect.origin.x * scale,
                        y: bezelDefinition.screenRect.origin.y * scale
                    )
                    let scaledScreenSize = CGSize(
                        width: bezelDefinition.screenRect.size.width * scale,
                        height: bezelDefinition.screenRect.size.height * scale
                    )
                    let contentScaleX = scaledScreenSize.width / model.screenSize.width
                    let contentScaleY = scaledScreenSize.height / model.screenSize.height

                    ScreenContentView {
                        content
                    }
                    .scaleEffect(
                        CGSize(width: contentScaleX, height: contentScaleY),
                        anchor: .topLeading
                    )
                    .offset(x: scaledScreenOrigin.x, y: scaledScreenOrigin.y)
                }
            }
    }
}

extension Image {
    init(data: Data) {
        #if canImport(UIKit)
            let uiImage = UIImage(data: data) ?? UIImage()
            self.init(uiImage: uiImage)
        #elseif canImport(AppKit)
            let nsImage = NSImage(data: data) ?? NSImage()
            self.init(nsImage: nsImage)
        #endif
    }
}
