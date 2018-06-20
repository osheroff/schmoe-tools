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
            
        systemEvents.sendMode = Int32(kAENoReply)
        apogeeApplication = systemEvents.applicationProcesses?().object(withName: "Apogee Maestro 2") as!  SystemEventsProcess
        apogeeWindow = apogeeApplication.windows!().object(withName: "Maestro 2") as! SystemEventsWindow
        let group = apogeeWindow.splitterGroups!().object(at: 0) as! SystemEventsSplitterGroup
        mixerCheckbox = group.checkboxes!().object(withName: "Mixer") as! SystemEventsCheckbox
        let scrollArea = group.scrollAreas!().object(at: 1) as! SystemEventsScrollArea
        muteCheckbox = scrollArea.checkboxes!().object(at: 7) as! SystemEventsCheckbox
    }
    
    func startWatchThread() {
        DispatchQueue.global(qos: .userInitiated).async {
            while ( true ) {
                //self.actionWithWatch {
                    self.mixerCheckbox.clickAt!([0 as NSNumber])
                //}
                sleep(2)
            }
        }
    }
    
    
    func actionWithWatch(closure: () -> Void) {
        var completed = false
        DispatchQueue.global(qos: .userInitiated).async {
            usleep(300000)
            
            if ( completed != true) {
                debugPrint("focusing window")
                self.apogeeApplication.setFrontmost!(true)
                self.apogeeApplication.setFrontmost!(false)
            }
        }
        closure()
        completed = true
    }
    
    func clickMixer() -> Bool {
        let mixerCheckboxValue = (mixerCheckbox.value as! SBObject).get() as! NSNumber?

        if ( mixerCheckboxValue == nil ) {
            return false;
        }
        if ( mixerCheckboxValue != 1 ) {
            debugPrint("clicking checkbox")
            //mixerCheckbox.setValue!(1 as NSNumber)

            mixerCheckbox.clickAt!([0 as NSNumber])

            debugPrint("checkbox clicked")
        }
        return true;
    }
    func mute() -> Bool {
        if ( clickMixer() ) {
            debugPrint("clicking mute checkbox")

            muteCheckbox.clickAt!([0 as NSNumber])

            debugPrint("mute checkbox clicked")
            return true;
        } else {
            return false;
        }
    }
   
}

