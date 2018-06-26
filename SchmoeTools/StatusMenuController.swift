//
//  StatusMenuController.swift
//  WeatherBar
//
//  Created by Brad Greenlee on 10/11/15.
//  Copyright © 2015 Etsy. All rights reserved.
//

import Cocoa
import Carbon.HIToolbox
import MASShortcut

class StatusMenuController: NSObject {
    @IBOutlet weak var statusMenu: NSMenu!
    
    var monitor: MASShortcutMonitor! = MASShortcutMonitor.shared()
    var preferencesWindow: PreferencesWindowController!
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    var actionManager: ActionManager?

    var regularIcon: NSImage?
    var talkbackEnabledIcon: NSImage?
    
    func setTalkback() {
        statusItem.button?.image = self.talkbackEnabledIcon
    }
    
    func unsetTalkback() {
        statusItem.button?.image = self.regularIcon
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        preferencesWindow = PreferencesWindowController(windowNibName: NSNib.Name("PreferencesWindow"))
        regularIcon = NSImage(named: NSImage.Name("statusIcon"))
        regularIcon?.isTemplate = true
        talkbackEnabledIcon = NSImage(named: NSImage.Name("talkbackLive"))
        talkbackEnabledIcon?.isTemplate = true
        
        statusItem.button?.image = regularIcon
        statusItem.menu = statusMenu
        actionManager = ActionManager(statusController: self)
    }
    
    @IBAction func quitClicked(_ sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
    
    @IBAction func preferencesClick(_ sender: NSMenuItem) {
        preferencesWindow.showWindow(nil)
    }
}
