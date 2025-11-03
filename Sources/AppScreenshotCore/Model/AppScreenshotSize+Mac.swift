//
//  AppScreenshotSize+Mac.swift
//  AppScreenshotKit
//
//  Created by Codex on 2025/05/20.
//

import Foundation

// Mac models (landscape only)
extension AppScreenshotSize {
    public static func macBookPro16(
        model: MacModel = .macBookPro16M4(),
        size: MacModel.AppScreenshotSizeOption = .w2880h1800
    ) -> AppScreenshotSize {
        AppScreenshotSize(
            device: AppScreenshotDevice(
                orientation: model.orientation,
                color: model.color,
                model: model.model
            ),
            size: size
        )
    }

    public static func macBookPro14(
        model: MacModel = .macBookPro14M4(),
        size: MacModel.AppScreenshotSizeOption = .w2880h1800
    ) -> AppScreenshotSize {
        AppScreenshotSize(
            device: AppScreenshotDevice(
                orientation: model.orientation,
                color: model.color,
                model: model.model
            ),
            size: size
        )
    }

    public static func macBookAir13(
        model: MacModel = .macBookAir13(),
        size: MacModel.AppScreenshotSizeOption = .w2880h1800
    ) -> AppScreenshotSize {
        AppScreenshotSize(
            device: AppScreenshotDevice(
                orientation: model.orientation,
                color: model.color,
                model: model.model
            ),
            size: size
        )
    }

    public struct MacModel {
        let orientation: DeviceOrientation
        let color: DeviceColor
        let model: DeviceModel

        public enum MacBookProColor {
            case silver
        }

        public enum MacBookAirColor {
            case midnight
        }

        public enum AppScreenshotSizeOption: SizeOption, CaseIterable {
            case w2880h1800

            public var size: CGSize {
                switch self {
                case .w2880h1800:
                    CGSize(width: 2880, height: 1800)
                }
            }
        }

        public static func macBookPro16M4(
            color: MacBookProColor = .silver,
            orientation: DeviceOrientation = .landscape
        ) -> MacModel {
            MacModel(
                orientation: orientation,
                color: color.deviceColor,
                model: .macBookPro16M4
            )
        }

        public static func macBookPro14M4(
            color: MacBookProColor = .silver,
            orientation: DeviceOrientation = .landscape
        ) -> MacModel {
            MacModel(
                orientation: orientation,
                color: color.deviceColor,
                model: .macBookPro14M4
            )
        }

        public static func macBookAir13(
            color: MacBookAirColor = .midnight,
            orientation: DeviceOrientation = .landscape
        ) -> MacModel {
            MacModel(
                orientation: orientation,
                color: color.deviceColor,
                model: .macBookAir13
            )
        }
    }
}

extension AppScreenshotSize.MacModel.MacBookProColor: DeviceColorConvertable {
    var deviceColor: DeviceColor {
        switch self {
        case .silver:
            .silver
        }
    }
}

extension AppScreenshotSize.MacModel.MacBookAirColor: DeviceColorConvertable {
    var deviceColor: DeviceColor {
        switch self {
        case .midnight:
            .midnight
        }
    }
}

extension AppScreenshotSize.MacModel.MacBookProColor: CaseIterable {}
extension AppScreenshotSize.MacModel.MacBookAirColor: CaseIterable {}

extension AppScreenshotSize {
    static var macBookPro16All: [AppScreenshotSize] {
        allCases(
            of: .macBookPro16M4,
            color: MacModel.MacBookProColor.self,
            size: MacModel.AppScreenshotSizeOption.self,
            orientations: [.landscape]
        )
    }

    static var macBookPro14All: [AppScreenshotSize] {
        allCases(
            of: .macBookPro14M4,
            color: MacModel.MacBookProColor.self,
            size: MacModel.AppScreenshotSizeOption.self,
            orientations: [.landscape]
        )
    }

    static var macBookAir13All: [AppScreenshotSize] {
        allCases(
            of: .macBookAir13,
            color: MacModel.MacBookAirColor.self,
            size: MacModel.AppScreenshotSizeOption.self,
            orientations: [.landscape]
        )
    }

    static var macAll: [AppScreenshotSize] {
        macBookPro16All + macBookPro14All + macBookAir13All
    }
}
