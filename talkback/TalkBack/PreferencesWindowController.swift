//
//  PreferencesWindowController.swift
//  TalkBack
//
//  Created by Ben Osheroff on 6/21/18.
//

import Foundation
import Cocoa
class PreferencesWindowController: NSWindowController, NSWindowDelegate {
    @IBOutlet weak var talkbackShortcutView: MASShortcutView!
    @IBOutlet weak var standardTrimToolShortcutView: MASShortcutView!
    @IBOutlet weak var tceTrimToolShortcutView: MASShortcutView!
    @IBOutlet weak var loopTrimToolShortcutView: MASShortcutView!
    
    override var windowNibName : NSNib.Name? {
        return NSNib.Name(rawValue: "PreferencesWindow")
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        self.window?.center()
        self.window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
        
        talkbackShortcutView.associatedUserDefaultsKey = "talkback-key"
    }
    
    @IBAction func okClicked(_ sender: Any) {
        self.window?.close()
    }
}
