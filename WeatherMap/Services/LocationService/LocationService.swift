import Foundation
import CoreLocation
import MapKit

final class LocationService {
    
    static let shared = LocationService()
    private init() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        if Self.locationServicesEnabled {
//            locationManager.startUpdatingLocation()
        }
    }
    
    static var locationServicesEnabled: Bool {
        CLLocationManager.locationServicesEnabled()
    }
    
    private let locationManager: CLLocationManager
    
    var currentLattitude: Double {
        let location = locationManager.location
        return location?.coordinate.latitude ?? 0
    }
    
    var currentLongtitude: Double {
        let location = locationManager.location
        return location?.coordinate.longitude ?? 0
    }
    
    func requestAlwaysAndWhenInUseAccess() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startUpdatinglocation() {
        locationManager.startUpdatingLocation()
    }
}
