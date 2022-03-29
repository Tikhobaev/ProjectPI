import Foundation

class TimeDateFormatter: DateFormatter {
    
    override init() {
        super.init()
  
        self.dateFormat = "hh:mm"
        self.locale = Locale(identifier: "en_FR")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func time(_ date: Date?) -> String? {
        guard let date = date else {
            return nil
        }
        
        return string(from: date)
    }
    
}
