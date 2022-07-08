//
//  UserManager.swift
//  Ani'trip
//
//  Created by Kevin Bertrand on 04/07/2022.
//

import Foundation

final class UserManager {
    // MARK: Public
    // MARK: Properties
    var user: User? { connecteUser }
    var volunteers: [User] { volunteersList.sorted {$0.firstname.lowercased() < $1.firstname.lowercased()} }
    var errorMessage: String = ""
    
    // MARK: Methods
    /// Perform the login of the user
    func login(user: UserToConnect) {
        networkManager.request(urlParams: ["user", "login"], method: .post, authorization: .authorization(username: user.email, password: user.password), body: nil) { [weak self] data, response, error in
            if let self = self,
               let response = response,
               let statusCode = response.statusCode {
                switch statusCode {
                case 200:
                    self.successLogin(with: data)
                case 401:
                    self.sendErrorNotification(with: "Wrong credentials!", for: .loginFailled)
                case 460:
                    self.sendErrorNotification(with: "Your account is not active yet!", for: .loginFailled)
                default:
                    self.sendErrorNotification(with: "Unknown error! Try later!", for: .loginFailled)
                }
            } else {
                self?.sendErrorNotification(with: "Unknown error! Try later!", for: .loginFailled)
            }
        }
    }
    
    /// Perform the creation of the new account
    func createAccount(for user: UserToCreate) {
        networkManager.request(urlParams: ["user", "create"], method: .post, authorization: nil, body: user) { [weak self] data, response, error in
            if let self = self,
               let response = response,
               let statusCode = response.statusCode {
                switch statusCode {
                case 201:
                    self.sendNotification(.successfullCreation)
                case 406:
                    self.sendErrorNotification(with: "Your passwords don't match!", for: .errorDuringCreation)
                case 500:
                    self.sendErrorNotification(with: "Your account cannot be created! Verify your informations!", for: .errorDuringCreation)
                default:
                    self.sendErrorNotification(with: "Unknown error! Try later!", for: .errorDuringCreation)
                }
            } else {
                self?.sendErrorNotification(with: "Unknown error! Try later!", for: .errorDuringCreation)
            }
        }
    }
    
    /// Perform the asking of a new password
    func forgetPassword(for user: UserToConnect) {
        // TODO: Process api call
        sendNotification(.successRequestForNewPassword)
    }
    
    /// Disconnect the user
    func disconnect() {
        connecteUser = nil
    }
    
    /// Update the user informations
    func update(user: UpdateUser) {
        guard let connecteUser = connecteUser else {
            sendErrorNotification(with: "Unknown error! Try later!", for: .errorDuringUpdatingUser)
            return
        }
        
        networkManager.request(urlParams: ["user"], method: .patch, authorization: .authorization(bearerToken: connecteUser.token), body: user) { [weak self] data, response, error in
            if let self = self,
               let response = response,
               let statusCode = response.statusCode {
                switch statusCode {
                case 202:
                    self.successUpdate(with: data)
                case 401:
                    self.sendErrorNotification(with: "Your are not authorised to perform this operation!", for: .errorDuringUpdatingUser)
                case 406:
                    self.sendErrorNotification(with: "Your user account was not found!", for: .errorDuringUpdatingUser)
                case 460:
                    self.sendErrorNotification(with: "Your account is not active yet!", for: .errorDuringUpdatingUser)
                default:
                    self.sendErrorNotification(with: "Unknown error! Try later!", for: .errorDuringUpdatingUser)
                }
            } else {
                self?.sendErrorNotification(with: "Unknown error! Try later!", for: .errorDuringUpdatingUser)
            }
        }
    }
    
    /// Getting the list of all volunteers
    func getVolunteerList() {
        guard let connecteUser = connecteUser else {
            sendErrorNotification(with: "Unknown error! Try later!", for: .errorGettingVolunteerList)
            return
        }
        
        networkManager.request(urlParams: ["user"], method: .get, authorization: .authorization(bearerToken: connecteUser.token), body: nil) { [weak self] data, response, error in
            if let self = self,
               let response = response,
               let statusCode = response.statusCode {
                switch statusCode {
                case 200:
                    self.successGettingVolunteersList(with: data)
                default:
                    self.sendErrorNotification(with: "Unknown error! Try later!", for: .errorGettingVolunteerList)
                }
            } else {
                self?.sendErrorNotification(with: "Unknown error! Try later!", for: .errorGettingVolunteerList)
            }
        }
    }
    
    // MARK: Private
    // MARK: Properties
    private var connecteUser: User?
    private var volunteersList: [User] = []
    private let networkManager = NetworkManager()
    private let mapController = MapController()
    
    // MARK: Methods
    /// Send Notification
    private func sendNotification(_ notification: Notification.AniTrip) {
        let notificationName = notification.notificationName
        let notificationBuilder = Notification(name: notificationName, object: self, userInfo: ["name": notificationName])
        NotificationCenter.default.post(notificationBuilder)
    }
    
    private func getBasicAuthentication(for user: UserToConnect) -> String {
        var authentication: String = ""
        
        let credentials = "\(user.email):\(user.password)"
        let dataCredentials = credentials.data(using: .utf8)
        
        if let dataCredentials = dataCredentials {
            let encodedCredentials = dataCredentials.base64EncodedString()
            authentication = "Basic \(encodedCredentials)"
        }
        return authentication
    }
    
    /// Decode data when success login
    private func successLogin(with data: Data?) {
        if let data = data,
           let user = try? JSONDecoder().decode(ConnectedUser.self, from: data),
           let userId = UUID(uuidString: user.id),
           let gender = Gender(rawValue: user.gender),
           let position = Position(rawValue: user.position) {
            errorMessage = ""
            connecteUser = User(id: userId,
                                firstname: user.firstname,
                                lastname: user.lastname,
                                email: user.email,
                                phoneNumber: user.phoneNumber,
                                gender: gender,
                                position: position,
                                missions: user.missions,
                                isActive: true,
                                address: user.address ?? self.mapController.emptyAddress,
                                token: user.token)
            sendNotification(.loginSuccess)
        } else {
            sendErrorNotification(with: "Unknown error! Try later!", for: .loginFailled)
        }
    }
    
    /// Decode data when success downloading volunteer list
    private func successGettingVolunteersList(with data: Data?) {
        if let data = data,
           let users = try? JSONDecoder().decode([User].self, from: data) {
            volunteersList = users
            sendNotification(.successGettingVolunteerList)
        } else {
            sendErrorNotification(with: "Unknown error! Try later!", for: .errorGettingVolunteerList)
        }
    }
    
    /// Decode data when success update
    private func successUpdate(with data: Data?) {
        if let data = data,
           let user = try? JSONDecoder().decode(ConnectedUser.self, from: data),
           let userId = UUID(uuidString: user.id),
           let gender = Gender(rawValue: user.gender),
           let position = Position(rawValue: user.position) {
            errorMessage = ""
            connecteUser = User(id: userId,
                                firstname: user.firstname,
                                lastname: user.lastname,
                                email: user.email,
                                phoneNumber: user.phoneNumber,
                                gender: gender,
                                position: position,
                                missions: user.missions,
                                isActive: true,
                                address: user.address ?? self.mapController.emptyAddress,
                                token: user.token)
            sendNotification(.successUserUpdate)
        } else {
            sendErrorNotification(with: "Unknown error! Try later!", for: .errorDuringUpdatingUser)
        }
    }
    
    /// Configure and send error notification
    private func sendErrorNotification(with error: String, for notification: Notification.AniTrip) {
        errorMessage = error
        sendNotification(notification)
    }
}
