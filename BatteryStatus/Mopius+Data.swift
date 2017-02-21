//
//  Mopius+Data.swift
//  BatteryStatus
//
//  Created by Patrick Steiner on 21.02.17.
//  Copyright © 2017 Mopius. All rights reserved.
//

import Foundation

extension Data {
    func hexEncodedString() -> String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
}
