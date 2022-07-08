//
//  TripManager.swift
//  Ani'trip
//
//  Created by Kevin Bertrand on 06/07/2022.
//

import Foundation

final class TripManager {
    // MARK: Public
    // MARK: Properties
    var trips: [Trip] { tripList.sorted {$0.date > $1.date}}
    var numberOfTripThisWeek: Int = 0
    var distanceThisWeek: Double = 0.0
    var threeLatestTrips: [Trip] = []
    var chartTrips: [TripChartPoint] { chartTripsPoints.sorted { $0.date < $1.date } }
    
    // MARK: Methods
    /// Getting trip list
    func getTripList(for user: User) {
        if let userId = user.id {
            networkManager.request(urlParams: ["trip", "\(userId)"], method: .get, authorization: .authorization(bearerToken: user.token), body: nil) { [weak self] data, response, error in
                if let self = self,
                   let response = response,
                   let statusCode = response.statusCode {
                    switch statusCode {
                    case 200:
                        self.successGettingTripList(with: data)
                    case 404:
                        self.sendErrorNotification(with: "No list found!", for: .errorGettingTripList)
                    default:
                        self.sendErrorNotification(with: "Unknown error! Try later!", for: .errorGettingTripList)
                    }
                } else {
                    self?.sendErrorNotification(with: "Unknown error! Try later!", for: .errorGettingTripList)
                }
            }
        } else {
            sendErrorNotification(with: "Unknown error! Try later!", for: .errorGettingTripList)
        }
    }
    
    /// Adding a new trip
    func addNewTrip(_ trip: AddTrip, for user: User) {
        let newTrip = NewTrip(date: trip.date.ISO8601Format(), missions: trip.missions, comment: trip.comment, totalDistance: Double(trip.totalDistance) ?? 0.0, startingAddress: trip.startingAddress, endingAddress: trip.endingAddress)
        
        networkManager.request(urlParams: ["trip"], method: .post, authorization: .authorization(bearerToken: user.token), body: newTrip) { [weak self] data, response, error in
            if let self = self,
               let response = response,
               let statusCode = response.statusCode {
                switch statusCode {
                case 200:
                    self.getTripList(for: user)
                    self.sendNotification(.successAddingTrip)
                case 401:
                    self.sendErrorNotification(with: "Your are not authorised to perform this operation!", for: .errorAddingTrip)
                default:
                    self.sendErrorNotification(with: "Unknown error! Try later!", for: .errorAddingTrip)
                }
            } else {
                self?.sendErrorNotification(with: "Unknown error! Try later!", for: .errorAddingTrip)
            }
        }
    }
    
    /// Downloading home informations
    func downloadHomeInformations(for user: User) {
        if let userId = user.id {
            networkManager.request(urlParams: ["trip", "latest", "\(userId)"], method: .get, authorization: .authorization(bearerToken: user.token), body: nil) { [weak self] data, response, error in
                if let self = self,
                   let response = response,
                   let statusCode = response.statusCode {
                    switch statusCode {
                    case 200:
                        self.successGettingThreeLatestTrips(with: data, for: userId, withToken: user.token)
                    case 404:
                        self.sendErrorNotification(with: "No list found!", for: .errorGettingTripList)
                    default:
                        self.sendErrorNotification(with: "Unknown error! Try later!", for: .errorGettingTripList)
                    }
                } else {
                    self?.sendErrorNotification(with: "Unknown error! Try later!", for: .errorGettingTripList)
                }
            }
        } else {
            sendErrorNotification(with: "Unknown error! Try later!", for: .errorGettingTripList)
        }
    }
    
    // MARK: Private
    // MARK: Properties
    private var tripList: [Trip] = []
    private var chartTripsPoints: [TripChartPoint] = []
    private let networkManager = NetworkManager()
    
    // MARK: Methods
    /// Send Notification
    private func sendNotification(_ notification: Notification.AniTrip) {
        let notificationName = notification.notificationName
        let notificationBuilder = Notification(name: notificationName, object: self, userInfo: ["name": notificationName])
        NotificationCenter.default.post(notificationBuilder)
    }
    
    /// Configure and send error notification
    private func sendErrorNotification(with error: String, for notification: Notification.AniTrip) {
        sendNotification(notification)
    }
    
    /// Decode data when success downloading trip list
    private func successGettingTripList(with data: Data?) {
        if let data = data,
           let trips = try? JSONDecoder().decode([TripInformation].self, from: data) {
            tripList = []
            
            for trip in trips {
                tripList.append(Trip(id: trip.id, date: formatDateFromString(trip.date), missions: trip.missions, comment: trip.comment, totalDistance: trip.totalDistance, startingAddress: trip.startingAddress, endingAddress: trip.endingAddress))
            }
            sendNotification(.successGettingTripList)
        } else {
            sendErrorNotification(with: "Unknown error! Try later!", for: .errorGettingTripList)
        }
    }
    
    /// Decode data when success downloading three latest trips
    private func successGettingThreeLatestTrips(with data: Data?, for userId: UUID, withToken token: String) {
        if let data = data,
           let trips = try? JSONDecoder().decode([TripInformation].self, from: data) {
            threeLatestTrips = []
            
            for trip in trips {
                threeLatestTrips.append(Trip(id: trip.id, date: formatDateFromString(trip.date), missions: trip.missions, comment: trip.comment, totalDistance: trip.totalDistance, startingAddress: trip.startingAddress, endingAddress: trip.endingAddress))
            }
            
            networkManager.request(urlParams: ["trip", "chart", "\(userId)"], method: .get, authorization: .authorization(bearerToken: token), body: nil) { [weak self] data, response, error in
                if let self = self,
                   let response = response,
                   let statusCode = response.statusCode {
                    switch statusCode {
                    case 200:
                        if let data = data,
                           let chartPoints = try? JSONDecoder().decode([DownloadedTripChatPoint].self, from: data) {
                            for chartPoint in chartPoints {
                                self.chartTripsPoints.append(TripChartPoint(date: chartPoint.date, distance: chartPoint.distance))
                            }
                            
                            self.networkManager.request(urlParams: ["trip", "thisWeek", "\(userId)"], method: .get, authorization: .authorization(bearerToken: token), body: nil) { [weak self] data, response, error in
                                if let self = self,
                                   let response = response,
                                   let statusCode = response.statusCode {
                                    switch statusCode {
                                    case 200:
                                        if let data = data,
                                           let thisWeek = try? JSONDecoder().decode(ThisWeekInformations.self, from: data) {
                                            self.distanceThisWeek = thisWeek.distance
                                            self.numberOfTripThisWeek = thisWeek.numberOfTrip
                                            self.sendNotification(.successDownloadedHomeInformations)
                                        } else {
                                            self.sendErrorNotification(with: "No list found!", for: .errorDownloadedHomeInformations)
                                        }
                                    case 404:
                                        self.sendErrorNotification(with: "No list found!", for: .errorDownloadedHomeInformations)
                                    default:
                                        self.sendErrorNotification(with: "Unknown error! Try later!", for: .errorDownloadedHomeInformations)
                                    }
                                } else {
                                    self?.sendErrorNotification(with: "Unknown error! Try later!", for: .errorDownloadedHomeInformations)
                                }
                            }
                        } else {
                            self.sendErrorNotification(with: "Unknown error! Try later!", for: .errorDownloadedHomeInformations)
                        }
                    case 404:
                        self.sendErrorNotification(with: "No list found!", for: .errorDownloadedHomeInformations)
                    default:
                        self.sendErrorNotification(with: "Unknown error! Try later!", for: .errorDownloadedHomeInformations)
                    }
                } else {
                    self?.sendErrorNotification(with: "Unknown error! Try later!", for: .errorDownloadedHomeInformations)
                }
            }
        } else {
            sendErrorNotification(with: "Unknown error! Try later!", for: .errorDownloadedHomeInformations)
        }
    }
    
    /// Format date
    private func formatDateFromString(_ input: String) -> Date {
        var date = Date.now
        let dateFormatter = ISO8601DateFormatter()
        if let formattedDate = dateFormatter.date(from: input) {
            date = formattedDate
        }
        
        return date
    }
}
