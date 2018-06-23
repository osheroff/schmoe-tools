//
//  ProToolsScripting.swift
//  TalkBack
//
//  Created by Ben Osheroff on 6/22/18.
//

import Foundation
import AppleScriptObjC

@objc(NSObject) protocol ProToolsScriptingProtocol {
    func changeTrim(_: NSAppleEventDescriptor)
    func changeGrabber(_: NSAppleEventDescriptor)
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
    
    func trimTool() { scriptObject.changeTrim(makeInt(1)) }
    func tceTool()  { scriptObject.changeTrim(makeInt(2)) }
    func loopTool() { scriptObject.changeTrim(makeInt(3)) }
    func grabberTool() { scriptObject.changeGrabber(makeInt(1)) }
    func separationTool() { scriptObject.changeGrabber(makeInt(2)) }
    func objectTool() { scriptObject.changeGrabber(makeInt(3)) }

}

