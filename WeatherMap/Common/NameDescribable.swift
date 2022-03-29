import Foundation

protocol NameDescribable {
    var typeName: String { get }
    static var typeName: String { get }
}

extension NameDescribable {
    var typeName: String {
        String(describing: type(of: self))
    }
    
    static var typeName: String {
        String(describing: self)
    }
    
}
