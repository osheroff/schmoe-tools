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
    let group: SystemEventsSplitterGroup
    let mixerCheckbox: SystemEventsCheckbox
    
    init() {
        systemEvents = SBApplication(bundleIdentifier: "com.apple.systemevents")! as SystemEventsApplication
        
        apogeeApplication = systemEvents.applicationProcesses?().object(withName: "Apogee Maestro 2") as!  SystemEventsProcess
        apogeeWindow = apogeeApplication.windows!().object(withName: "Maestro 2") as! SystemEventsWindow
        group = apogeeWindow.splitterGroups!().object(at: 0) as! SystemEventsSplitterGroup
        mixerCheckbox = group.checkboxes!().object(withName: "Mixer") as! SystemEventsCheckbox
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
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + .milliseconds(300)) {
            if ( completed != true) {
                self.flickerFocus()
            }
        }
        closure()
        completed = true
    }
    
    private func getChannel() -> Int? {
         return UserDefaults.standard.integer(forKey: "talkback-channel")
    }
    
    func startTalkbackWatchThread(statusController: StatusMenuController) {
        _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            let muteValue = self.getMuteValue(channel: self.getChannel())
            if ( muteValue == true ) {
                statusController.unsetTalkback();
            } else if ( muteValue == false ) {
                statusController.setTalkback();
            }
            
        }
    }
    
    private func getMuteCheckbox(channel: Int) -> SystemEventsCheckbox {
        let checkboxIndex = ((channel + 1) * 2) - 1
        let scrollArea = group.scrollAreas!().object(at: 1) as! SystemEventsScrollArea
        return scrollArea.checkboxes!().object(at: checkboxIndex) as! SystemEventsCheckbox
    }
    
    private func getMuteValue(channel: Int?) -> Bool? {
        if ( channel == nil ) {
            return nil;
        }
        let valueObj = getMuteCheckbox(channel: channel!).value as! SBObject
        let value = valueObj.get() as! NSNumber?
        if ( value == nil ) {
            return nil
        } else {
            return value == 1
        }
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
            
            actionWithWatch { _ = mixerCheckbox.clickAt!([0 as NSNumber]) }
            
            NSLog("checkbox clicked")
        }
        return true;
    }
    
    func mute(channel: Int) -> Bool {
        let muteCheckbox = getMuteCheckbox(channel: channel)

        if ( clickMixer() ) {
            NSLog("clicking mute checkbox")
            actionWithWatch { _ = muteCheckbox.clickAt!([0 as NSNumber]) }
            NSLog("mute checkbox clicked")
            return true;
        } else {
            return false;
        }
    }
    
}

