import Foundation

#if DEBUG
public func dLog(error: Error, filename: String = #file, function: String = #function, line: Int = #line) {
    print("[\(filename.split(separator: "/").last ?? ""):\(line)] \(function):\n\(error)")
}

public func dLog(message: String, filename: String = #file, function: String = #function, line: Int = #line) {
    print("[\(filename.split(separator: "/").last ?? ""):\(line)] \(function):\n\(message)")
}
#else
public func dLog(error: Error, filename: String = "", function: String = "", line: Int = 0) {
}

public func dLog(message: String, filename: String = "", function: String = "", line: Int = 0) {
}
#endif
