//
//  ProToolsScripting.swift
//  TalkBack
//
//  Created by Ben Osheroff on 6/22/18.
//

import Foundation
import AppleScriptObjC

@objc(NSObject) protocol ProToolsScriptingProtocol {
    func trimTool()
    func loopTool()
    func tceTool()
    func grabberTool()
    func separationTool()
    func objectTool()
}

class ProToolsScripting {
    static var loaded = false
    static func load() {
        if ( !loaded ) {
            Bundle.main.load()
            Bundle.main.loadAppleScriptObjectiveCScripts()
        }
    }
    
    let script: ProToolsScriptingProtocol
    
    init() {
        ProToolsScripting.load()
        script = NSClassFromString("ProToolsApplescript")!.alloc() as! ProToolsScriptingProtocol
    }
}

