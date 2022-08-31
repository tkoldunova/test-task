//
//  Constant .swift
//  TestTaskNatife
//
//  Created by Tanya Koldunova on 26.08.2022.
//

import UIKit

enum Color {
    case baseColor
    
    var color: UIColor {
        switch self {
        case .baseColor:
           return  UIColor(named: "baseColor")!
        }
    }
}

enum NotificationText {
    case success
    case error
    case permissionDenied
    
    var title: String {
        switch self {
        case .success:
            return "Success"
        case .error:
            return "Error"
        case .permissionDenied:
            return "Permission denied"
        }
    }
    
    var description: String {
        switch self {
        case .success:
            return ""
        case .error:
            return "Something went wrong, please check your internet connection"
        case .permissionDenied:
            return "Permission to use your location is denied. Please change it in your settings"
        }
    }
}
