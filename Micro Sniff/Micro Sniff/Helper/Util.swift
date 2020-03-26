//
//  Utils.swift
//  MicMonitor
//
//  Created by phucld on 2/26/20.
//  Copyright © 2020 Dwarvesf. All rights reserved.
//

import Cocoa

enum DockIconState: String {
    case hide
    case show
}

class Util {
    
    static var timer: Timer?
    
    static func toggleDockIcon(_ state: DockIconState) {
        // We need to use scheduled timer here for not create multiple dock icon when quickly toggle this option
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { _ in
            switch state {
            case .hide: NSApp.setActivationPolicy(NSApplication.ActivationPolicy.accessory)
            case .show: NSApp.setActivationPolicy(NSApplication.ActivationPolicy.regular)
            }
            
            NSApp.activate(ignoringOtherApps: true)
        }
        
    }
}
