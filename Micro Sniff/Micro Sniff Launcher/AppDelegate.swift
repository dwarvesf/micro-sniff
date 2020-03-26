//
//  AppDelegate.swift
//  MicMonitorLauncher
//
//  Created by phucld on 2/29/20.
//  Copyright © 2020 Dwarvesf. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        LauncherManager.shared.setupLauncher()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

