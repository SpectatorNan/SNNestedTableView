//
//  SNLog.swift
//  SNNestedTableView
//
//  Created by x j z l on 2019/9/20.
//  Copyright © 2019 spectator. All rights reserved.
//

import Foundation

// MARK: Public
func logInfo<T>(
    _ message : T,
    file : StaticString = #file,
    function : StaticString = #function,
    line : UInt = #line
    ) {
    SNLog(message, type: .info, file : file, function: function, line: line)
}

func logWarn<T>(
    _ message : T,
    file : StaticString = #file,
    function : StaticString = #function,
    line : UInt = #line
    ) {
    SNLog(message, type: .warning, file : file, function: function, line: line)
}

func logDebug<T>(
    _ message : T,
    file : StaticString = #file,
    function : StaticString = #function,
    line : UInt = #line
    ) {
    SNLog(message, type: .debug, file : file, function: function, line: line)
}

func logError<T>(
    _ message : T,
    file : StaticString = #file,
    function : StaticString = #function,
    line : UInt = #line
    ) {
    SNLog(message, type: .error, file : file, function: function, line: line)
}


enum LogType: String {
    case error = "❤️ ERROR"
    case warning = "💛 WARNING"
    case info = "💙 INFO"
    case debug = "💚 DEBUG"
}

private func SNLog<T>(
    _ message : T,
    type: LogType,
    file : StaticString = #file,
    function : StaticString = #function,
    line : UInt = #line
    ) {
    #if DEBUG
    let time = shared.logDateFormatter.string(from: Date())
    let fileName = (file.description as NSString).lastPathComponent
    print("\(time) \(type.rawValue) \(fileName):\(line)\n>>>>> \(message)")
    #endif
}


// MARK: Log
private let shared = Logger.shared

private class Logger {
    static let shared = Logger()
    private init() { }

    let logDateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        return f
    }()
}

