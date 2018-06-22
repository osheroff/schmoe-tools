//
//  ApogeeScripting.swift
//  TalkBack
//
//  Created by Ben Osheroff on 6/19/18.
//

import Foundation
import ScriptingBridge

class ApogeeScripting {
    let systemEvents: SystemEventsApplication
    let apogeeApplication: SystemEventsProcess
    let apogeeWindow: SystemEventsWindow
    let mixerCheckbox: SystemEventsCheckbox
    let muteCheckbox: SystemEventsCheckbox
    
    init() {
        systemEvents = SBApplication(bundleIdentifier: "com.apple.systemevents")! as SystemEventsApplication
            
        apogeeApplication = systemEvents.applicationProcesses?().object(withName: "Apogee Maestro 2") as!  SystemEventsProcess
        apogeeWindow = apogeeApplication.windows!().object(withName: "Maestro 2") as! SystemEventsWindow
        let group = apogeeWindow.splitterGroups!().object(at: 0) as! SystemEventsSplitterGroup
        mixerCheckbox = group.checkboxes!().object(withName: "Mixer") as! SystemEventsCheckbox
        let scrollArea = group.scrollAreas!().object(at: 1) as! SystemEventsScrollArea
        muteCheckbox = scrollArea.checkboxes!().object(at: 7) as! SystemEventsCheckbox
    }
    
    func flickerFocus() {
        let frontmost = NSWorkspace.shared.frontmostApplication
        let apogee = NSWorkspace.shared.runningApplications.first {
            $0.bundleIdentifier == "com.apogee.Apogee-Maestro-2"
        }
        if ( apogee != nil ) {
            NSLog("activating window " + apogee!.localizedName!)
            apogee?.activate(options: NSApplication.ActivationOptions.activateIgnoringOtherApps)
            usleep(10000)
            NSLog("activating window " + frontmost!.localizedName!)
            frontmost?.activate(options: NSApplication.ActivationOptions.activateIgnoringOtherApps)
        }
        
    }
    func actionWithWatch(closure: () -> Void) {
        var completed = false
        DispatchQueue.global(qos: .userInitiated).async {
            usleep(300000)
            
            if ( completed != true) {
                debugPrint("focusing window")
                self.flickerFocus()
            }
        }
        closure()
        completed = true
    }
    
    func withoutReply(closure: () -> Void) {
        let oldSendMode = systemEvents.sendMode
        systemEvents.sendMode = Int32(kAENoReply)
        closure()
        systemEvents.sendMode = oldSendMode
    }
    
    func clickMixer() -> Bool {
        NSLog("checking CB value")
        var mixerCheckboxValue: NSNumber?
        actionWithWatch {
            mixerCheckboxValue = (mixerCheckbox.value as! SBObject).get() as! NSNumber?
        }
        NSLog("done CB value")

        if ( mixerCheckboxValue == nil ) {
            return false;
        }

        if ( mixerCheckboxValue != 1 ) {
            NSLog("clicking checkbox")
            //mixerCheckbox.setValue!(1 as NSNumber)

            actionWithWatch { mixerCheckbox.clickAt!([0 as NSNumber]) }

            NSLog("checkbox clicked")
       }
        return true;
    }
    func mute() -> Bool {
        if ( clickMixer() ) {
            NSLog("clicking mute checkbox")

            actionWithWatch { muteCheckbox.clickAt!([0 as NSNumber]) }

            NSLog("mute checkbox clicked")
            return true;
        } else {
            return false;
        }
    }
   
}

