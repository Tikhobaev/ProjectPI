//
//  NetworkMonitoringService.swift
//  WeatherApp
//
//  Created by Илья Соловьёв on 14.10.2020.
//  Copyright © 2020 Globus Ltd. All rights reserved.
//

import Foundation
import Network

class NetworkMonitoringService {
    static let shared = NetworkMonitoringService()
    private init() {
        
    }

    let monitor = NWPathMonitor()
    private var status: NWPath.Status = .requiresConnection
    var isReachable: Bool { status == .satisfied }
    var isReachableOnCellular: Bool = true

    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.status = path.status
            self?.isReachableOnCellular = path.isExpensive

            if path.status == .satisfied {
                print("We're connected!")
                // post connected notification
            } else {
                print("No connection.")
                // post disconnected notification
            }
            print(path.isExpensive)
        }

        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }

    func stopMonitoring() {
        monitor.cancel()
    }
}
