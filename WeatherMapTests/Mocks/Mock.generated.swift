import SwiftyMocky
import XCTest
import CoreLocation
import Foundation
import MapKit
@testable import WeatherMap


// MARK: - LocationServiceProtocol

open class LocationServiceProtocolMock: LocationServiceProtocol, Mock {
    public init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
        SwiftyMockyTestObserver.setup()
        self.sequencingPolicy = sequencingPolicy
        self.stubbingPolicy = stubbingPolicy
        self.file = file
        self.line = line
    }

    var matcher: Matcher = Matcher.default
    var stubbingPolicy: StubbingPolicy = .wrap
    var sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst

    private var queue = DispatchQueue(label: "com.swiftymocky.invocations", qos: .userInteractive)
    private var invocations: [MethodType] = []
    private var methodReturnValues: [Given] = []
    private var methodPerformValues: [Perform] = []
    private var file: StaticString?
    private var line: UInt?

    public typealias PropertyStub = Given
    public typealias MethodStub = Given
    public typealias SubscriptStub = Given

    /// Convenience method - call setupMock() to extend debug information when failure occurs
    public func setupMock(file: StaticString = #file, line: UInt = #line) {
        self.file = file
        self.line = line
    }

    /// Clear mock internals. You can specify what to reset (invocations aka verify, givens or performs) or leave it empty to clear all mock internals
    public func resetMock(_ scopes: MockScope...) {
        let scopes: [MockScope] = scopes.isEmpty ? [.invocation, .given, .perform] : scopes
        if scopes.contains(.invocation) { invocations = [] }
        if scopes.contains(.given) { methodReturnValues = [] }
        if scopes.contains(.perform) { methodPerformValues = [] }
    }

    public var currentLattitude: Double {
		get {	invocations.append(.p_currentLattitude_get); return __p_currentLattitude ?? givenGetterValue(.p_currentLattitude_get, "LocationServiceProtocolMock - stub value for currentLattitude was not defined") }
	}
	private var __p_currentLattitude: (Double)?

    public var currentLongtitude: Double {
		get {	invocations.append(.p_currentLongtitude_get); return __p_currentLongtitude ?? givenGetterValue(.p_currentLongtitude_get, "LocationServiceProtocolMock - stub value for currentLongtitude was not defined") }
	}
	private var __p_currentLongtitude: (Double)?





    open func requestAlwaysAndWhenInUseAccess() {
        addInvocation(.m_requestAlwaysAndWhenInUseAccess)
		let perform = methodPerformValue(.m_requestAlwaysAndWhenInUseAccess) as? () -> Void
		perform?()
    }

    open func startUpdatinglocation() {
        addInvocation(.m_startUpdatinglocation)
		let perform = methodPerformValue(.m_startUpdatinglocation) as? () -> Void
		perform?()
    }


    fileprivate enum MethodType {
        case m_requestAlwaysAndWhenInUseAccess
        case m_startUpdatinglocation
        case p_currentLattitude_get
        case p_currentLongtitude_get

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_requestAlwaysAndWhenInUseAccess, .m_requestAlwaysAndWhenInUseAccess): return .match

            case (.m_startUpdatinglocation, .m_startUpdatinglocation): return .match
            case (.p_currentLattitude_get,.p_currentLattitude_get): return Matcher.ComparisonResult.match
            case (.p_currentLongtitude_get,.p_currentLongtitude_get): return Matcher.ComparisonResult.match
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case .m_requestAlwaysAndWhenInUseAccess: return 0
            case .m_startUpdatinglocation: return 0
            case .p_currentLattitude_get: return 0
            case .p_currentLongtitude_get: return 0
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_requestAlwaysAndWhenInUseAccess: return ".requestAlwaysAndWhenInUseAccess()"
            case .m_startUpdatinglocation: return ".startUpdatinglocation()"
            case .p_currentLattitude_get: return "[get] .currentLattitude"
            case .p_currentLongtitude_get: return "[get] .currentLongtitude"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }

        public static func currentLattitude(getter defaultValue: Double...) -> PropertyStub {
            return Given(method: .p_currentLattitude_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func currentLongtitude(getter defaultValue: Double...) -> PropertyStub {
            return Given(method: .p_currentLongtitude_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }

    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func requestAlwaysAndWhenInUseAccess() -> Verify { return Verify(method: .m_requestAlwaysAndWhenInUseAccess)}
        public static func startUpdatinglocation() -> Verify { return Verify(method: .m_startUpdatinglocation)}
        public static var currentLattitude: Verify { return Verify(method: .p_currentLattitude_get) }
        public static var currentLongtitude: Verify { return Verify(method: .p_currentLongtitude_get) }
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func requestAlwaysAndWhenInUseAccess(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_requestAlwaysAndWhenInUseAccess, performs: perform)
        }
        public static func startUpdatinglocation(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_startUpdatinglocation, performs: perform)
        }
    }

    public func given(_ method: Given) {
        methodReturnValues.append(method)
    }

    public func perform(_ method: Perform) {
        methodPerformValues.append(method)
        methodPerformValues.sort { $0.method.intValue() < $1.method.intValue() }
    }

    public func verify(_ method: Verify, count: Count = Count.moreOrEqual(to: 1), file: StaticString = #file, line: UInt = #line) {
        let fullMatches = matchingCalls(method, file: file, line: line)
        let success = count.matches(fullMatches)
        let assertionName = method.method.assertionName()
        let feedback: String = {
            guard !success else { return "" }
            return Utils.closestCallsMessage(
                for: self.invocations.map { invocation in
                    matcher.set(file: file, line: line)
                    defer { matcher.clearFileAndLine() }
                    return MethodType.compareParameters(lhs: invocation, rhs: method.method, matcher: matcher)
                },
                name: assertionName
            )
        }()
        MockyAssert(success, "Expected: \(count) invocations of `\(assertionName)`, but was: \(fullMatches).\(feedback)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        self.queue.sync { invocations.append(call) }
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        matcher.set(file: self.file, line: self.line)
        defer { matcher.clearFileAndLine() }
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher).isFullMatch })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        matcher.set(file: self.file, line: self.line)
        defer { matcher.clearFileAndLine() }
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher).isFullMatch }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType, file: StaticString?, line: UInt?) -> [MethodType] {
        matcher.set(file: file ?? self.file, line: line ?? self.line)
        defer { matcher.clearFileAndLine() }
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher).isFullMatch }
    }
    private func matchingCalls(_ method: Verify, file: StaticString?, line: UInt?) -> Int {
        return matchingCalls(method.method, file: file, line: line).count
    }
    private func givenGetterValue<T>(_ method: MethodType, _ message: String) -> T {
        do {
            return try methodReturnValue(method).casted()
        } catch {
            onFatalFailure(message)
            Failure(message)
        }
    }
    private func optionalGivenGetterValue<T>(_ method: MethodType, _ message: String) -> T? {
        do {
            return try methodReturnValue(method).casted()
        } catch {
            return nil
        }
    }
    private func onFatalFailure(_ message: String) {
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleFatalError(message: message, file: file, line: line)
    }
}

