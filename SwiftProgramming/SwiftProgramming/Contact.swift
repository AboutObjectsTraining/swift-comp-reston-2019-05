import Foundation

enum PhoneType: String, CustomDebugStringConvertible {
    case Home = "Home"
    case Work = "Work"
    case Cell = "Cell"
    
    var debugDescription: String {
        return rawValue
    }
}

class Contact: CustomDebugStringConvertible
{
    var firstName: String?
    var lastName: String?
    var companyName: String?
    var phoneNumbers: [PhoneType: String]?
        
    var fullName: String {
        
        var name = ""
        
        if let last = lastName {
            name += last
            if firstName != nil {
                name += ", "
            }
        }
        
        if let first = firstName {
            name += first
        }
        
        return name
    }
    
    var debugDescription: String {
        
        var desc = "name: \(fullName) | phone numbers: "
        
        if let phones = phoneNumbers {
            desc += "\(phones)"
        } else {
            desc += "none"
        }
        
        return desc
    }
}