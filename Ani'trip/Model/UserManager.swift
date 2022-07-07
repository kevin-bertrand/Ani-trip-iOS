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
                    self.sendErrorNotification(with: "Wrong credentials!")
                case 460:
                    self.sendErrorNotification(with: "Your account is not active yet!")
                default:
                    self.sendErrorNotification(with: "Unknown error! Try later!")
                }
            } else {
                self?.sendErrorNotification(with: "Unknown error! Try later!")
            }
        }
    }
    
    /// Perform the creation of the new account
    func createAccount(for user: UserToConnect) {
        // TODO: Process creation
        sendNotification(.successfullCreation)
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
        if let connecteUser = connecteUser {
            networkManager.request(urlParams: ["user"], method: .patch, authorization: .authorization(bearerToken: connecteUser.token), body: user) { [weak self] data, response, error in
                if let self = self,
                   let response = response,
                   let statusCode = response.statusCode {
                    switch statusCode {
                    case 200:
                        self.sendNotification(.successUserUpdate)
                    case 401:
                        self.sendErrorNotification(with: "Your are not authorised to perform this operation!")
                    case 406:
                        self.sendErrorNotification(with: "Your user account was not found!")
                    case 460:
                        self.sendErrorNotification(with: "Your account is not active yet!")
                    default:
                        self.sendErrorNotification(with: "Unknown error! Try later!")
                    }
                } else {
                    self?.sendErrorNotification(with: "Unknown error! Try later!")
                }
            }
        }
    }
    
    // MARK: Private
    // MARK: Properties
    private var connecteUser: User?
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
                                address: self.mapController.emptyAddress,
                                token: user.token)
            sendNotification(.loginSuccess)
        } else {
            sendErrorNotification(with: "Unknown error! Try later!")
        }
    }
    
    /// Configure and send error notification
    private func sendErrorNotification(with error: String) {
        errorMessage = error
        sendNotification(.loginFailled)
    }
}
