//
//  Logger.swift
//  Places
//
//  Created by Sergey Bendak on 3.12.2024.
//

import Foundation
import OSLog

public final class LoggerProvider {
    public enum LogCategory: String {
        case locationsViewModel = "LocationsViewModel"
        case locationService = "LocationService"
        case `default` = "Default"
        
        var logger: Logger {
            Logger(subsystem: Bundle.main.bundleIdentifier ?? "Unknown", category: self.rawValue)
        }
    }
    
    public static let shared = LoggerProvider()
    
    private init() {}
    
    public func info(_ message: String, category: LogCategory = .default) {
        log(message, level: .info, category: category)
    }

    public func error(_ message: String, category: LogCategory = .default) {
        log(message, level: .error, category: category)
    }

    public func debug(_ message: String, category: LogCategory = .default) {
        #if DEBUG
        log(message, level: .debug, category: category)
        #endif
    }
    
    private func log(_ message: String, level: OSLogType, category: LogCategory = .default) {
        let logger = category.logger

        switch level {
        case .info:
            logger.info("\(message, privacy: .public)")
        case .error:
            logger.error("\(message, privacy: .public)")
        case .debug:
            logger.debug("\(message, privacy: .public)")
        default:
            logger.log("\(message, privacy: .public)")
        }
    }
}
