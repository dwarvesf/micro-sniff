//
//  MicroManager.swift
//  MicMonitor
//
//  Created by phucld on 2/17/20.
//  Copyright © 2020 Dwarvesf. All rights reserved.
//

import Foundation

class MicroManager {
    
    static let sharedInstance = MicroManager()
    private init(){}
    
    var microDidRunningSomeWhere: ((_ isRunning: Bool,_ title: String) -> ())?
    var microDidAdd:((_ title: String) ->())?
    var microDidRemove:((_ title: String) ->())?
    

    func regisAudioNotification() {
        NotificationCenter.defaultCenter.subscribe(self, eventType: AudioHardwareEvent.self, dispatchQueue: DispatchQueue.main)
        NotificationCenter.defaultCenter.subscribe(self, eventType: AudioDeviceEvent.self, dispatchQueue: DispatchQueue.main)
    }
    
    func removeAllAudioNotification() {
        NotificationCenter.defaultCenter.unsubscribe(self, eventType: AudioHardwareEvent.self)
        NotificationCenter.defaultCenter.unsubscribe(self, eventType: AudioDeviceEvent.self)
    }
    
}
extension MicroManager: EventSubscriber {
    func eventReceiver(_ event: Event) {
        if let event = event as?  AudioDeviceEvent {
            switch event {
                case .isRunningSomewhereDidChange(audioDevice: let audioDevice):
                    guard
                        audioDevice.isInputOnlyDevice(),
                        let microDidRunningSomeWhere = self.microDidRunningSomeWhere
                    else {return}
                    microDidRunningSomeWhere(audioDevice.isRunningSomewhere(), audioDevice.name)
                default: break

            }
        }
        
        if let event = event as? AudioHardwareEvent {
            switch event {
                case .deviceListChanged(addedDevices: let addedDevices, removedDevices: let removedDevices):
                    
                    if let microDidAdd = self.microDidAdd, let addedMic = addedDevices.first(where: {$0.isMicroDevice()}) {
                        microDidAdd(addedMic.name)
                    }
                    
                    if let microDidRemove = microDidRemove, let removedMic = removedDevices.first(where: {$0.isMicroDevice()}) {
                        microDidRemove(removedMic.name)
                    }
                    
                default: break
            }
        }
    }
    
    var hashValue: Int {
        return 0
    }
    
}


