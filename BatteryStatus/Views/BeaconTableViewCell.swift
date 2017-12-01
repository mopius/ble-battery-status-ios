//
//  BeaconTableViewCell.swift
//  BatteryStatus
//
//  Created by Patrick Steiner on 21.02.17.
//  Copyright © 2017 Mopius. All rights reserved.
//

import UIKit

final class BeaconTableViewCell: UITableViewCell {

    @IBOutlet weak var identifierLabel: UILabel!
    @IBOutlet weak var rssiLabel: UILabel!
    @IBOutlet weak var batteryLabel: UILabel!

    var beacon: Beacon? { didSet { setBeacon() } }

    private func setBeacon() {
        guard let beacon = beacon else { return }

        identifierLabel.text = beacon.identifier
        rssiLabel.text = "RSSI: \(beacon.rssi)"
        batteryLabel.text = "\(beacon.power)%"
    }

}
