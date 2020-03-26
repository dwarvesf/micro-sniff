//
//  Bundle+Extension.swift
//  MicMonitor
//
//  Created by phucld on 2/29/20.
//  Copyright © 2020 Dwarvesf. All rights reserved.
//

import Foundation

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}
