import Foundation

final class URLLogger: URLProtocol {
    
    override public class func canInit(with request: URLRequest) -> Bool {
        
        print("? Running request: \(request.httpMethod ?? "") - \(request.url?.absoluteString ?? "")")
        
        // By returning `false`, this URLProtocol will do nothing less than logging.
        return false
    }
}
