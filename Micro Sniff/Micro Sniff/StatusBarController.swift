//
//  StatusBarController.swift
//  MicMonitor
//
//  Created by phucld on 2/17/20.
//  Copyright © 2020 Dwarvesf. All rights reserved.
//

import Foundation
import Preferences
import Cocoa

class StatusBarController {
    private let menuStatusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    var window: MicroWindow? = nil
    
    lazy var preferencesWindowController = PreferencesWindowController(
        preferencePanes: [
            GeneralPreferenceViewController(),
            AboutPreferenceViewController()
        ],
        style: .segmentedControl
    )

    
    init() {
        MicroManager.sharedInstance.regisAudioNotification()
        setupView()
    }
    
    private func setupView() {
        if let button = menuStatusItem.button {
            button.image = #imageLiteral(resourceName: "ico_statusbar")
        }
        menuStatusItem.menu = self.getContextMenu()
        
        if let mic = AudioDevice.allInputDevices().first(where: {$0.isRunningSomewhere()}) {
            createAndShowWindow(micTitle: mic.name)
        }

        MicroManager.sharedInstance.microDidRunningSomeWhere = {[weak self] (isRunning, title) in
            NotificationManager.showNotificationIfEnable(title: title, desc: "\(title) \(isRunning ? "running" : "stopped")")
            if isRunning {
                self?.createAndShowWindow(micTitle: title)
            } else {
                self?.removeWindow()
            }
        }
        
        MicroManager.sharedInstance.microDidAdd = {deviceName in
            NotificationManager.showNotificationIfEnable(title: deviceName, desc: "\(deviceName) connected")
        }
        MicroManager.sharedInstance.microDidRemove = {deviceName in
            NotificationManager.showNotificationIfEnable(title: deviceName, desc: "\(deviceName) disconnected")
        }
    }
    
    private func createAndShowWindow(micTitle: String) {
        if window == nil {
            window = MicroWindow.initForMainScreen()
        }
        
        window?.micTitle?(micTitle)
        window?.openWithAnimation()
    }
    
    private func getContextMenu() -> NSMenu {
        let menu = NSMenu()
        
        menu.addItem(NSMenuItem(title: "Preferences...", action: #selector(openPreferences), keyEquivalent: "P"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        menu.item(withTitle: "Preferences...")?.target = self
        
        return menu
    }
    
    @objc private func openPreferences() {
        self.preferencesWindowController.show()
    }
    
    private func removeWindow() {
        window?.close()
    }
}
