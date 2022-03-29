import Foundation

public protocol BaseViewModeling: AnyObject {
    var isLoading: Bool { get }
    
    var didChange: (() -> Void)? { get set }
    var didGetError: ((_ message: String) -> Void)? { get set }
}

public class BaseViewModel: NSObject, BaseViewModeling {
    
    public var isLoading = false {
        didSet {
            didChange?()
        }
    }
    
    public var didChange: (() -> Void)? {
        didSet {
            didChange?()
        }
    }
    
    public var didGetError: ((_ message: String) -> Void)?
}



