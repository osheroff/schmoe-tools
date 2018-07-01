//
//  KeyTapHandler.swift
//  SchmoeTools
//
//  Created by Ben Osheroff on 6/30/18.
//

import Foundation

class KeyTapHandler {
    let keyDown: () -> (Void)
    let keyUp: () -> (Void)
    let doubleTap:  () -> (Void)
    
    // what we consider a tap
    let tapTime = TimeInterval(0.200)
    // time between taps
    let doubleTapTime = TimeInterval(0.300)
    
    var lastTapAt: TimeInterval?
    var lastKeyDownAt: TimeInterval?
    var keyDownTimer: Timer?
    
    init(keyDown: @escaping () -> (Void) , keyUp: @escaping () -> (Void) , doubleTap: @escaping () -> (Void)) {
        self.keyDown = keyDown
        self.keyUp = keyUp
        self.doubleTap = doubleTap
    }
    
    private func now() -> TimeInterval {
        return Date().timeIntervalSinceReferenceDate
    }
    
    func onKeyDown() {
        lastKeyDownAt = now()
        let keyDownValue = lastKeyDownAt!
        keyDownTimer = Timer.scheduledTimer(withTimeInterval: tapTime, repeats: false) { timer in
            if ( self.lastKeyDownAt == keyDownValue) {
                self.keyDown()
            }
        }
    }
    
    func onKeyUp() {
        let keyInterval = now() - lastKeyDownAt!
        lastKeyDownAt = nil
        
        if ( keyInterval < tapTime ) {
            keyDownTimer?.invalidate()
            if ( lastTapAt == nil ) {
                lastTapAt = now()
            } else if ( now() - lastTapAt! < doubleTapTime ) {
                doubleTap()
                lastTapAt = nil
            } else {
                lastTapAt = now()
            }
        } else {
            keyUp()
        }
    }
}
