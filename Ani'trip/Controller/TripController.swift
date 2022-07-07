//
//  TripController.swift
//  Ani'trip
//
//  Created by Kevin Bertrand on 06/07/2022.
//

import CoreLocation
import Foundation
import MapKit

final class TripController: ObservableObject {
    // MARK: Public
    // MARK: Properties
    @Published var trips: [Trip] = []
    @Published var searchFilter: String = ""
    
    // Detailed trip
    @Published var startAddress: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), latitudinalMeters: 0, longitudinalMeters: 0)
    var startPin: [Places] = []
    @Published var endAddress: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), latitudinalMeters: 0, longitudinalMeters: 0)
    var endPin: [Places] = []
    
    // Add trip
    @Published var showSuccessAddingTripAlert: Bool = false
    @Published var newTrip: AddTrip = AddTrip(startDate: .now, endDate: .now, missions: [], comment: "", totalDistance: "0", startingAddress: Address(roadName: "", roadType: "", streetNumber: "", complement: "", zipCode: "", city: "", country: ""), endingAddress: Address(roadName: "", roadType: "", streetNumber: "", complement: "", zipCode: "", city: "", country: ""))
    
    // MARK: Methods
    /// Downloading trip list
    func getTripList() {
        tripManager.getTripList()
    }
    
    /// Getting map pin from address at displaying detailed
    func showDetailledTrip(trip: Trip) {
        resetMapPin()
        
        mapController.getAddressFromString(trip.startingAddress) { startLocation in
            if let startLocation = startLocation {
                self.startAddress = MKCoordinateRegion(center: startLocation, latitudinalMeters: 750, longitudinalMeters: 750)
                self.startPin = [Places(lat: startLocation.latitude, lon: startLocation.longitude)]
                
                self.mapController.getAddressFromString(trip.endingAddress) { endLocation in
                    if let endLocation = endLocation {
                        self.endAddress = MKCoordinateRegion(center: endLocation, latitudinalMeters: 750, longitudinalMeters: 750)
                        self.endPin = [Places(lat: endLocation.latitude, lon: endLocation.longitude)]
                    }
                }
            }
        }
    }
    
    /// Adding a new trip
    func addNewTrip() {
        tripManager.addNewTrip(newTrip)
    }
    
    // MARK: Init
    init() {
        configureNotification(for: Notification.AniTrip.successGettingTripList.notificationName)
        configureNotification(for: Notification.AniTrip.errorGettingTripList.notificationName)
        configureNotification(for: Notification.AniTrip.successAddingTrip.notificationName)
        configureNotification(for: Notification.AniTrip.errorAddingTrip.notificationName)
    }
    
    // MARK: Private
    // MARK: Properties
    private let tripManager: TripManager = TripManager()
    private let mapController: MapController = MapController()
    
    // MARK: Methods
    /// Initialise all notification for this controller
    @objc private func processNotification(_ notification: Notification) {
        if let notificationName = notification.userInfo?["name"] as? Notification.Name {
            DispatchQueue.main.async {
                self.objectWillChange.send()
                
                switch notificationName {
                case Notification.AniTrip.successGettingTripList.notificationName:
                    self.trips = self.tripManager.trips
                case Notification.AniTrip.errorGettingTripList.notificationName:
                    print("error")
                case Notification.AniTrip.successAddingTrip.notificationName:
                    self.showSuccessAddingTripAlert = true
                case Notification.AniTrip.errorAddingTrip.notificationName:
                    print("error")
                default: break
                }
            }
        }
    }
    
    /// Configure notification
    private func configureNotification(for name: Notification.Name) {
        NotificationCenter.default.addObserver(self, selector: #selector(processNotification), name: name, object: nil)
    }
    
    /// Reset Map pin
    private func resetMapPin() {
        startAddress = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), latitudinalMeters: 0, longitudinalMeters: 0)
        endAddress = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), latitudinalMeters: 0, longitudinalMeters: 0)
    }
}
