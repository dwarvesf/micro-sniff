//
//  GeneralPreferenceViewController.swift
//  MicMonitor
//
//  Created by phucld on 2/28/20.
//  Copyright © 2020 Dwarvesf. All rights reserved.
//

import Cocoa
import Preferences

final class GeneralPreferenceViewController: NSViewController, PreferencePane {
    let preferencePaneIdentifier = PreferencePane.Identifier.general
    let preferencePaneTitle = "General"
    let toolbarItemIcon = NSImage(named: NSImage.preferencesGeneralName)!
    
    override var nibName: NSNib.Name? { "GeneralPreferenceViewController" }
    
    @IBOutlet weak var checkboxStartAtLogin: NSButton!
    @IBOutlet weak var checkboxKeepIconInDock: NSButton!
    @IBOutlet weak var checkboxShowPreferencesOnLaunch: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchPreferenes()
    }
    
    private func fetchPreferenes() {
        checkboxStartAtLogin.state = Preference.startAtLogin ? .on : .off
        checkboxKeepIconInDock.state = Preference.dockIconState ==  .show ? .on : .off
        checkboxShowPreferencesOnLaunch.state = Preference.showPreferencesOnlaunch ? .on : .off
    }
    
    @IBAction func toggleStartAtLogin(_ sender: NSButton) {
        switch sender.state {
        case .on:
            Preference.startAtLogin = true
        case .off:
            Preference.startAtLogin = false
        default:
            break
        }
    }
    
    @IBAction func toggleKeepIconInDock(_ sender: NSButton) {
        switch sender.state {
        case .on:
            Preference.dockIconState = .show
        case .off:
            Preference.dockIconState = .hide
        default:
            break
        }
    }
    
    @IBAction func toggleShowPreferencesOnLaunch(_ sender: NSButton) {
        switch sender.state {
        case .on:
            Preference.showPreferencesOnlaunch = true
        case .off:
            Preference.showPreferencesOnlaunch = false
        default:
            break
        }
    }
}
