//
//  BatteryStatusTableViewController.swift
//  BatteryStatus
//
//  Created by Patrick Steiner on 21.02.17.
//  Copyright © 2017 Mopius. All rights reserved.
//

import CoreBluetooth.CBCentralManager
import UIKit

final class BatteryStatusTableViewController: UITableViewController {

    private var centralManager: CBCentralManager!

    var beacons = [Beacon]() {
        didSet {
            refreshTableView()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()

        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        startScanning()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        stopScanning()
    }

    // MARK: CoreBluetooth

    func startScanning() {
        if centralManager.state == .poweredOn {
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        }
    }

    fileprivate func stopScanning() {
        centralManager.stopScan()
    }

    // MARK: UI

    private func setupUI() {
        title = "Beacon Battery Scanner"
    }

    // MARK: TableView

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beacons.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BeaconCell", for: indexPath) as! BeaconTableViewCell

        cell.beacon = beacons[indexPath.row]

        return cell
     }

    private func refreshTableView() {
        tableView.reloadData()
    }

}
