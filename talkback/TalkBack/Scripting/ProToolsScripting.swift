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
}

class ProToolsScripting {
    static var loaded = false
    static func load() {
        if ( !loaded ) {
            Bundle.main.load()
            Bundle.main.loadAppleScriptObjectiveCScripts()
        }
    }
    
    let scriptObject: ProToolsScriptingProtocol
    
    init() {
        ProToolsScripting.load()
        scriptObject = NSClassFromString("ProToolsApplescript")!.alloc() as! ProToolsScriptingProtocol
    }
    
    func makeInt(_ i: Int32) -> NSAppleEventDescriptor {
        return NSAppleEventDescriptor(int32: i)
    }
    
    func trimTool() { scriptObject.trimTool() }
    func tceTool()  { scriptObject.tceTool() }
    func loopTool() { scriptObject.loopTool() }
    func grabberTool() {  }
    func separationTool() {  }
    func objectTool() {  }

}

