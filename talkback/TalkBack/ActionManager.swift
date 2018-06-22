//
//  ActionManager.swift
//  TalkBack
//
//  Created by Ben Osheroff on 6/22/18.
//

import Foundation
typealias ActionFunction = () -> (Void)
struct ActionDefinition {
    let defaultsName: String
    let hotKey: Int?
    let modifier: UInt
    let action: ActionFunction
    let keyUpAction: ActionFunction?
    
    init(defaultsName: String, hotKey: Int?, modifier: NSEvent.ModifierFlags?, action: @escaping ActionFunction, keyUpAction: ActionFunction?) {
        self.hotKey = hotKey
        if ( modifier == nil ) {
            self.modifier = 0
        } else {
            self.modifier = modifier!.rawValue
        }
        
        self.defaultsName = defaultsName
        self.action = action
        self.keyUpAction = keyUpAction
    }

    init(defaultsName: String, hotKey: Int?, modifier: NSEvent.ModifierFlags?, action: @escaping ActionFunction) {
        self.init(defaultsName: defaultsName, hotKey: hotKey, modifier: modifier, action: action, keyUpAction: nil)
    }

    init(defaultsName: String, action: @escaping ActionFunction) {
        self.init(defaultsName: defaultsName, hotKey: nil, modifier: nil, action: action, keyUpAction: nil)
    }
    
    init(defaultsName: String, action: @escaping ActionFunction, keyUpAction: @escaping ActionFunction) {
        self.init(defaultsName: defaultsName, hotKey: nil, modifier: nil, action: action, keyUpAction: keyUpAction)
    }
}

class ActionManager {
    let apogeeScripting = ApogeeScripting()
    let statusController: StatusMenuController
    let SHIFT = NSEvent.ModifierFlags.shift
    let OPTION = NSEvent.ModifierFlags.option

    init(statusController: StatusMenuController) {
        self.statusController = statusController

        let actions =  [
            ActionDefinition(defaultsName: "talkback-key", action: talkbackOn, keyUpAction: talkbackOff),
            ActionDefinition(defaultsName: "trimtool-key", hotKey: kVK_F6, modifier: SHIFT, action: trimTool),
            ActionDefinition(defaultsName: "tcetool-key", hotKey: kVK_F6, modifier: OPTION, action: tceTool),
            ActionDefinition(defaultsName: "looptool-key", hotKey: kVK_F6, modifier: [OPTION, SHIFT], action: tceTool),
        ]
        registerHotKeys(actions: actions)
    }
    
    func registerHotKeys(actions: [ActionDefinition]) {
        actions.forEach { action in
            if ( action.hotKey != nil && UserDefaults.standard.object(forKey: action.defaultsName) == nil ) {
                let shortcut = MASShortcut(keyCode: UInt(action.hotKey!), modifierFlags: action.modifier)
                let shortcutData = NSKeyedArchiver.archivedData(withRootObject: shortcut!)
                UserDefaults.standard.set(shortcutData, forKey: action.defaultsName)
            }
            MASShortcutBinder.shared().bindShortcut(withDefaultsKey: action.defaultsName, toAction: action.action, onKeyUp: action.keyUpAction)
        }
    }
    
    func getTalkbackChannel() -> Int {
        return UserDefaults.standard.integer(forKey: "talkback-channel")
    }
    
    func talkbackOn() {
        if ( apogeeScripting.mute(channel: getTalkbackChannel()) ) {
            statusController.setTalkback()
        }
    }
    
    func talkbackOff() {
        if ( apogeeScripting.mute(channel: getTalkbackChannel()) ) {
            statusController.unsetTalkback()
        }
    }

    func trimTool() {}
    func tceTool() {}
    func loopTool() {}
}
