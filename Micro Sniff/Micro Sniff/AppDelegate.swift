//
//  AppDelegate.swift
//  MicMonitor
//
//  Created by Trung Phan on 2/17/20.
//  Copyright © 2020 Dwarvesf. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    let statusBarController = StatusBarController()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        LauncherManager.shared.setupMainApp(isAutoStart: Preference.startAtLogin)
        
        registerDefaultValues()
        
        Util.toggleDockIcon(Preference.dockIconState)

        if Preference.showPreferencesOnlaunch {
            statusBarController.preferencesWindowController.show()
        }
    }


    func applicationWillTerminate(_ aNotification: Notification) {
        
    }
    
    func registerDefaultValues() {
        UserDefaults.standard.register(defaults: [
            UserDefaults.Key.dockIconState: DockIconState.hide.rawValue,
            UserDefaults.Key.startAtLogin: false,
            UserDefaults.Key.showPreferencesOnLaunch: true
        ])
    }


}

