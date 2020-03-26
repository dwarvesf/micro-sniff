//
//  AboutPreferenceViewController.swift
//  MicMonitor
//
//  Created by phucld on 2/28/20.
//  Copyright © 2020 Dwarvesf. All rights reserved.
//

import Cocoa
import Preferences

final class AboutPreferenceViewController: NSViewController, PreferencePane {
    let preferencePaneIdentifier = PreferencePane.Identifier.about
    let preferencePaneTitle = "About"
    let toolbarItemIcon = NSImage(named: NSImage.infoName)!
    
    override var nibName: NSNib.Name? { "AboutPreferenceViewController" }
    
    @IBOutlet weak var lblVersion: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        preferredContentSize = CGSize(width: 500, height: 360)
    }
    
    private func setupUI() {
        if let version = Bundle.main.releaseVersionNumber,
            let buildNumber = Bundle.main.buildVersionNumber {
            lblVersion.stringValue += " \(version) (\(buildNumber))"
        }
    }
}
