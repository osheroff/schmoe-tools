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
    @IBOutlet weak var talkbackChannel: NSPopUpButton!

    @IBOutlet weak var standardTrimToolShortcutView: MASShortcutView!
    @IBOutlet weak var tceTrimToolShortcutView: MASShortcutView!
    @IBOutlet weak var loopTrimToolShortcutView: MASShortcutView!
    @IBOutlet weak var grabberToolShortcutView: MASShortcutView!
    @IBOutlet weak var separationToolShortcutView: MASShortcutView!
    @IBOutlet weak var objectToolShortcutView: MASShortcutView!
    
    override var windowNibName : NSNib.Name? {
        return NSNib.Name(rawValue: "PreferencesWindow")
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        self.window?.center()
        self.window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
        
        talkbackShortcutView.associatedUserDefaultsKey = "talkback-key"
        
        standardTrimToolShortcutView.associatedUserDefaultsKey = "trimtool-key"
        tceTrimToolShortcutView.associatedUserDefaultsKey = "tcetool-key"
        loopTrimToolShortcutView.associatedUserDefaultsKey = "looptool-key"
        grabberToolShortcutView.associatedUserDefaultsKey = "grabbertool-key"
        separationToolShortcutView.associatedUserDefaultsKey = "separationtool-key"
        objectToolShortcutView.associatedUserDefaultsKey = "objecttool-key"
        
        let channel = UserDefaults.standard.integer(forKey: "talkback-channel")
        talkbackChannel.selectItem(at: channel)
    }
    
    @IBAction func okClicked(_ sender: Any) {
        UserDefaults.standard.set(talkbackChannel.indexOfSelectedItem, forKey: "talkback-channel")
        self.window?.close()
    }
}
