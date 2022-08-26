//
//  MessageManager.swift
//  TestTaskNatife
//
//  Created by Tanya Koldunova on 26.08.2022.
//

import Foundation
import SwiftMessages



protocol MessageManager: AnyObject {
    func showErrorMessage(type: NotificationText, actionText : String?, isForever: Bool, action : (() -> Void)?)
    func showSuccessMessage(type: NotificationText, actionText : String?, isForever: Bool, action : (() -> Void)?)
    func showWarningMessage(type: NotificationText, actionText : String?, isForever: Bool, action : (() -> Void)?)
    func showInfoMessage(type: NotificationText, actionText : String?, isForever: Bool, action : (() -> Void)?)
}

extension MessageManager {
    
    func showErrorMessage(type: NotificationText, actionText : String?, isForever: Bool, action : (() -> Void)?) {
        let messageView = MessageView.viewFromNib(layout: .cardView)
        messageView.configureTheme(.error)
        messageView.configureDropShadow()
        messageView.configureContent(title: type.title, body: type.description)
        messageView.button?.isHidden = (action == nil)
        messageView.button?.setTitle(actionText, for: .normal)
        messageView.buttonTapHandler = { _ in
            SwiftMessages.hide(id: type.description)
            action?()
        }
        var config = SwiftMessages.defaultConfig
        config.duration = isForever ? .forever : .automatic
        config.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
        messageView.id = type.description
        SwiftMessages.show(config: config, view: messageView)
    }
    func showSuccessMessage(type: NotificationText, actionText : String?, isForever: Bool, action : (() -> Void)?) {
        let messageView = MessageView.viewFromNib(layout: .cardView)
        messageView.configureTheme(.success)
        messageView.configureDropShadow()
        messageView.configureContent(title: type.title, body: type.description)
        messageView.button?.isHidden = (action == nil)
        messageView.button?.setTitle(actionText, for: .normal)
        messageView.buttonTapHandler = { _ in
            SwiftMessages.hide(id: type.description)
            action?()
        }
        var config = SwiftMessages.defaultConfig
        config.duration = isForever ? .forever : .automatic
        config.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
        messageView.id = type.description
        SwiftMessages.show(config: config, view: messageView)
    }
    
    func showWarningMessage(type: NotificationText, actionText : String?, isForever: Bool, action : (() -> Void)?) {
        let messageView = MessageView.viewFromNib(layout: .cardView)
        messageView.configureTheme(.warning)
        messageView.configureDropShadow()
        messageView.configureContent(title: type.title, body: type.description)
        messageView.button?.isHidden = (action == nil)
        messageView.button?.setTitle(actionText, for: .normal)
        messageView.buttonTapHandler = { _ in
            SwiftMessages.hide(id: type.description)
            action?()
        }
        var config = SwiftMessages.defaultConfig
        config.duration = isForever ? .forever : .automatic
        config.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
        messageView.id = type.description
        SwiftMessages.show(config: config, view: messageView)
    }
    
    func showInfoMessage(type: NotificationText, actionText : String?, isForever: Bool, action : (() -> Void)?) {
        let messageView = MessageView.viewFromNib(layout: .cardView)
        messageView.configureTheme(.info)
        messageView.configureDropShadow()
        messageView.configureContent(title: type.title, body: type.description)
        messageView.button?.isHidden = (action == nil)
        messageView.button?.setTitle(actionText, for: .normal)
        messageView.buttonTapHandler = { _ in
            SwiftMessages.hide(id: type.description)
            action?()
        }
        var config = SwiftMessages.defaultConfig
        config.duration = isForever ? .forever : .automatic
        config.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
        messageView.id = type.description
        SwiftMessages.show(config: config, view: messageView)
    }
}
