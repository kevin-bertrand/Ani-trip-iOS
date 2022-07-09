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
    @Published var searchFilter: String = "" {
        didSet {
            filterTripList()
        }
    }
    @Published var trips: [Trip] = []
    
    // Detailed trip
    @Published var endAddress: MKCoordinateRegion
    @Published var startAddress: MKCoordinateRegion
    var endPin: [Places] = []
    var startPin: [Places] = []
    
    // Add trip
    @Published var showSuccessAddingTripAlert: Bool = false
    @Published var newTrip: AddTrip
    
    // Home View
    @Published var threeLatestTrips: [Trip] = []
    var chartPoints: [TripChartPoint] = []
    var distanceThisWeek: Double = 0.0
    var numberOfTripThisWeek: Int = 0
    
    // MARK: Methods
    /// Downloading trip list
    func getTripList(for user: User) {
        tripManager.getTripList(for: user)
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
    func addNewTrip(for user: User) {
        tripManager.addNewTrip(newTrip, for: user)
    }
    
    /// Getting informations at home on appear
    func homeAppears(for user: User) {
        tripManager.downloadHomeInformations(for: user)
    }
    
    // MARK: Init
    init() {
        // Properties initialization
        mapController = MapController()
        newTrip = AddTrip(date: .now, missions: [], comment: "", totalDistance: "", startingAddress: mapController.emptyAddress, endingAddress: mapController.emptyAddress)        
        startAddress = mapController.defaultMapPoint
        endAddress = mapController.defaultMapPoint
        
        // Configure notifications
        configureNotification(for: Notification.AniTrip.successGettingTripList.notificationName)
        configureNotification(for: Notification.AniTrip.errorGettingTripList.notificationName)
        configureNotification(for: Notification.AniTrip.successAddingTrip.notificationName)
        configureNotification(for: Notification.AniTrip.errorAddingTrip.notificationName)
        configureNotification(for: Notification.AniTrip.successDownloadedHomeInformations.notificationName)
        configureNotification(for: Notification.AniTrip.errorDownloadedHomeInformations.notificationName)
    }
    
    // MARK: Private
    // MARK: Properties
    private let tripManager: TripManager = TripManager()
    private let mapController: MapController
    
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
                case Notification.AniTrip.successDownloadedHomeInformations.notificationName:
                    self.homeInformationDownloaded()
                case Notification.AniTrip.errorDownloadedHomeInformations.notificationName:
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
        startAddress = mapController.defaultMapPoint
        endAddress = mapController.defaultMapPoint
    }
    
    /// End download home information
    private func homeInformationDownloaded() {
        objectWillChange.send()
        numberOfTripThisWeek = tripManager.numberOfTripThisWeek
        distanceThisWeek = tripManager.distanceThisWeek
        threeLatestTrips = tripManager.threeLatestTrips
        chartPoints = tripManager.chartTrips
    }
    
    /// Filter trip list
    private func filterTripList() {
        if searchFilter.isEmpty {
            trips = tripManager.trips
        } else {
            trips = tripManager.trips.filter { !($0.missions.filter {$0.localizedCaseInsensitiveContains(searchFilter)}).isEmpty || $0.comment?.localizedCaseInsensitiveContains(searchFilter) ?? false || $0.startingAddress.city.localizedCaseInsensitiveContains(searchFilter) || $0.startingAddress.roadName.localizedCaseInsensitiveContains(searchFilter) || $0.endingAddress.city.localizedCaseInsensitiveContains(searchFilter) || $0.endingAddress.roadName.localizedCaseInsensitiveContains(searchFilter) }
        }
    }
}
