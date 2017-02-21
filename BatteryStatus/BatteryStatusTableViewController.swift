//
//  BatteryStatusTableViewController.swift
//  BatteryStatus
//
//  Created by Patrick Steiner on 21.02.17.
//  Copyright © 2017 Mopius. All rights reserved.
//

import UIKit
import CoreBluetooth

class BatteryStatusTableViewController: UITableViewController {
    
    private var centralManager: CBCentralManager!
    
    fileprivate var beacons = [Beacon]() {
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
    
    fileprivate func startScanning() {
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

// MARK: - CBCentralManagerDelegate

extension BatteryStatusTableViewController: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        var message = "CoreBluetooth state did update:"
        
        switch central.state {
        case .poweredOff:
            message += " poweredOff"
        case .poweredOn:
            message += " poweredOn"
            
            // start ble scan
            startScanning()
        case .resetting:
            message += " resetting"
        case .unauthorized:
            message += " unauthorized"
        case .unknown:
            message += " unknown"
        case .unsupported:
            message += " unsupported"
        }
        
        print(message)
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        guard let serviceData = advertisementData[CBAdvertisementDataServiceDataKey] as? Dictionary<CBUUID, Data> else {
            return
        }
       
        // Kontakt.io Beacon data from old advertismentData
        if let ktkOldData = serviceData[CBUUID(string:"D00D")] {
            //print("DBG: kontakt old data: \(ktkOldData.hexEncodedString())")
            
            // parse identifier get byte 0 - 6
            guard let identifier = String(data: ktkOldData.subdata(in: Range(0...4)), encoding: String.Encoding.ascii) else {
                print("ERROR: Can't parse name")
                return
            }
            
            // parse battery level get byte 6
            var power: UInt8 = 0
            ktkOldData.copyBytes(to: &power, from: Range(6..<7))
            
            print("\(identifier) \(power)%")
            beacons.append(Beacon(identifier: identifier, rssi: RSSI, power: power))
        }
        
        // Kontakt.io Beacon data from new (pro beacons) advertismentData
        if let ktkNewData = serviceData[CBUUID(string:"FE6A")] {
            //print("DBG: kontakt new data: \(ktkNewData.hexEncodedString())")
            
            // parse battery level get byte 4
            var power: UInt8 = 0
            ktkNewData.copyBytes(to: &power, from: Range(4..<5))
            
            // parse identifier get byte 6 - 9
            guard let identifier = String(data: ktkNewData.subdata(in: Range(6...9)), encoding: String.Encoding.ascii) else {
                print("ERROR: Can't parse name")
                return
            }

            print("\(identifier) \(power)%")
            beacons.append(Beacon(identifier: identifier, rssi: RSSI, power: power))
        }
    }
}
