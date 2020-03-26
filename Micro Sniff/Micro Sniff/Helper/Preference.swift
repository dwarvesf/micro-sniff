//
//  Preference.swift
//  MicMonitor
//
//  Created by phucld on 2/29/20.
//  Copyright © 2020 Dwarvesf. All rights reserved.
//

import Cocoa

extension UserDefaults {
    enum Key {
        static let startAtLogin = "startAtLogin"
        static let dockIconState = "dockIconState"
        static let showPreferencesOnLaunch = "showPreferencesOnLaunch"
    }
}

enum Preference {
    static var dockIconState: DockIconState {
        get {
            guard let state = UserDefaults.standard.string(forKey: UserDefaults.Key.dockIconState) else {
                return .show
            }
            
            return DockIconState(rawValue: state) ?? .hide
        }
        
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: UserDefaults.Key.dockIconState)
            
            Util.toggleDockIcon(newValue)
        }
    }
    
    static var startAtLogin: Bool {
        get {
            UserDefaults.standard.register(defaults: [UserDefaults.Key.startAtLogin: true])
            return UserDefaults.standard.bool(forKey: UserDefaults.Key.startAtLogin)
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaults.Key.startAtLogin)
            LauncherManager.shared.setupMainApp(isAutoStart: newValue)
        }
    }
    
    static var showPreferencesOnlaunch: Bool {
        get {
            UserDefaults.standard.register(defaults: [UserDefaults.Key.showPreferencesOnLaunch: true])
            return UserDefaults.standard.bool(forKey: UserDefaults.Key.showPreferencesOnLaunch)
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaults.Key.showPreferencesOnLaunch)
        }
    }
}
