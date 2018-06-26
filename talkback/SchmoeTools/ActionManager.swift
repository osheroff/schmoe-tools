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
    let modifier: NSEvent.ModifierFlags
    let action: ActionFunction?
    let keyUpAction: ActionFunction?
    
    init(
        defaultsName: String,
        hotKey: Int? = nil,
        modifier: NSEvent.ModifierFlags = [],
        action: ActionFunction? = nil,
        keyUpAction: ActionFunction? = nil) {
        self.hotKey = hotKey
        self.modifier = modifier
        self.defaultsName = defaultsName
        self.action = action
        self.keyUpAction = keyUpAction
    }
}

class ActionManager {
    let apogeeScripting = ApogeeScripting()
    let protoolsScripting = ProToolsScripting().script
    let statusController: StatusMenuController
    let SHIFT = NSEvent.ModifierFlags.shift
    let OPTION = NSEvent.ModifierFlags.option

    init(statusController: StatusMenuController) {
        self.statusController = statusController

        let actions =  [
            ActionDefinition(defaultsName: "talkback-key", action: talkbackOn, keyUpAction: talkbackOff),
            ActionDefinition(defaultsName: "trimtool-key", hotKey: kVK_F6, modifier: SHIFT, keyUpAction: trimTool),
            ActionDefinition(defaultsName: "tcetool-key", hotKey: kVK_F6, modifier: OPTION, keyUpAction: tceTool),
            ActionDefinition(defaultsName: "looptool-key", hotKey: kVK_F6, modifier: [OPTION, SHIFT], keyUpAction: loopTool),
            ActionDefinition(defaultsName: "grabbertool-key", hotKey: kVK_F8, modifier: SHIFT, keyUpAction: grabberTool),
            ActionDefinition(defaultsName: "separationtool-key", hotKey: kVK_F8, modifier: SHIFT, keyUpAction: separationTool),
            ActionDefinition(defaultsName: "objecttool-key", hotKey: kVK_F8, modifier: SHIFT, keyUpAction: objectTool)
        ]
        registerHotKeys(actions: actions)
    }
    
    func registerHotKeys(actions: [ActionDefinition]) {
        actions.forEach { action in
            if ( action.hotKey != nil && UserDefaults.standard.object(forKey: action.defaultsName) == nil ) {
                let shortcut = MASShortcut(keyCode: UInt(action.hotKey!), modifierFlags: action.modifier.rawValue)
                let shortcutData = NSKeyedArchiver.archivedData(withRootObject: shortcut!)
                UserDefaults.standard.set(shortcutData, forKey: action.defaultsName)
            }
            MASShortcutBinder.shared().bindShortcut(
                withDefaultsKey: action.defaultsName,
                toAction: action.action ?? { },
                onKeyUp: action.keyUpAction
            )
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

    func trimTool() { protoolsScripting.trimTool() }
    func tceTool() { protoolsScripting.tceTool() }
    func loopTool() { protoolsScripting.loopTool() }
    func grabberTool() { protoolsScripting.grabberTool() }
    func separationTool() { protoolsScripting.separationTool() }
    func objectTool() { protoolsScripting.objectTool() }
}
