//
//  UserController.swift
//  Ani'trip
//
//  Created by Kevin Bertrand on 04/07/2022.
//

import CoreLocation
import Foundation
import MapKit

final class UserController: ObservableObject {
    // MARK: Public
    // MARK: Properties
    // General
    @Published var showLoadingInProgressView: Bool = false
    @Published var isLoggedIn: Bool = false
    @Published var errorMessage: String = ""
    var connectedUser: User? { userManager.user }
    
    // Login view
    @Published var loginEmail: String = ""
    @Published var loginPassword: String = ""
    @Published var rememberEmail: Bool = false
    
    // New user view
    @Published var showNewAccountAlert: Bool = false
    @Published var showNewAccountView: Bool = false
    @Published var newEmail: String = ""
    @Published var newPassword: String = ""
    @Published var newPasswordVerification: String = ""
    
    // Forget password view
    @Published var showForgetPasswordView: Bool = false
    @Published var showForgetPasswordAlert: Bool = false
    @Published var forgetPasswordEmail: String = ""
    
    // Update user informations
    @Published var showUpdateUserAlert: Bool = false
    @Published var userToUpdate: User
    @Published var updatePassword: String = ""
    @Published var updatePasswordVerification: String = ""
    var updatePasswordError: String = ""
    
    // User profil
    @Published var userCoordinate: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), latitudinalMeters: 0, longitudinalMeters: 0)
    var userPin: [Places] = []
    
    // MARK: Methods
    /// Login user
    func login() {
        showLoadingInProgressView = true
        
        guard !loginPassword.isEmpty,
              !loginEmail.isEmpty else {
            errorMessage = "An email and a password are needed!"
            showLoadingInProgressView = false
            return
        }
        
        guard isValidEmailAddress(loginEmail) else {
            errorMessage = "A valid email address is required!"
            showLoadingInProgressView = false
            return
        }
        
        userManager.login(user: UserToConnect(email: loginEmail.trimmingCharacters(in: .whitespacesAndNewlines), password: loginPassword))
    }
    
    /// Perform the creation of the new account
    func createNewAccount() {
        showLoadingInProgressView = true
        
        guard !newPassword.isEmpty, !newPasswordVerification.isEmpty, !newEmail.isEmpty else {
            showLoadingInProgressView = false
            errorMessage = "An email and a password are needed!"
            return
        }
        
        guard isValidEmailAddress(newEmail) else {
            showLoadingInProgressView = false
            errorMessage = "A valid email address is required!"
            return
        }
        
        guard newPassword == newPasswordVerification else {
            showLoadingInProgressView = false
            errorMessage = "Both password are not equals!"
            return
        }
        
        userManager.createAccount(for: UserToCreate(email: newEmail, password: newPassword, passwordVerification: newPasswordVerification))
    }
    
    /// End the request of the creation of a new account
    func finishUserCreation() {
        showNewAccountView = false
        errorMessage = ""
        newEmail = ""
        newPassword = ""
        newPasswordVerification = ""
    }
    
    /// Perform the request to send a new password
    func forgetPassword() {
        showLoadingInProgressView = true
        
        guard !forgetPasswordEmail.isEmpty,
              isValidEmailAddress(forgetPasswordEmail) else {
            showLoadingInProgressView = false
            errorMessage = "A valid email address is needed!"
            return
        }
        
        userManager.forgetPassword(for: UserToConnect(email: forgetPasswordEmail, password: ""))
    }
    
    /// End the request of a new password
    func finishForgetPasswordRequest() {
        showForgetPasswordView = false
        errorMessage = ""
        forgetPasswordEmail = ""
    }
    
    /// Disconnect the user
    func disconnect() {
        objectWillChange.send()
        isLoggedIn = false
    }
    
    /// Update user
    func update() {
        showLoadingInProgressView = true
        
        if (!updatePassword.isEmpty == true) == !updatePasswordVerification.isEmpty {
            guard updatePassword == updatePasswordVerification else {
                updatePasswordError = "Both password must match!"
                showLoadingInProgressView = false
                return
            }
        }
        
        userManager.update(user: UpdateUser(id: userToUpdate.id,
                                            firstname: userToUpdate.firstname,
                                            lastname: userToUpdate.lastname,
                                            email: userToUpdate.email,
                                            phoneNumber: userToUpdate.phoneNumber,
                                            gender: userToUpdate.gender,
                                            position: userToUpdate.position,
                                            missions: userToUpdate.missions,
                                            isActive: userToUpdate.isActive,
                                            address: userToUpdate.address,
                                            password: updatePassword,
                                            passwordVerification: updatePasswordVerification))
    }
    
    // MARK: Init
    init() {
        userToUpdate = User(id: UUID(), firstname: "", lastname: "", email: "", phoneNumber: "", gender: .notDeterminded, position: .user, missions: [], isActive: false, address: mapController.emptyAddress, token: "")
        
        configureNotification(for: Notification.AniTrip.loginSuccess.notificationName)
        configureNotification(for: Notification.AniTrip.loginFailled.notificationName)
        configureNotification(for: Notification.AniTrip.successfullCreation.notificationName)
        configureNotification(for: Notification.AniTrip.errorDuringCreation.notificationName)
        configureNotification(for: Notification.AniTrip.successRequestForNewPassword.notificationName)
        configureNotification(for: Notification.AniTrip.errorDuringRequestForNewPassword.notificationName)
        configureNotification(for: Notification.AniTrip.successUserUpdate.notificationName)
        configureNotification(for: Notification.AniTrip.errorDuringUpdatingUser.notificationName)
    }
    
    // MARK: Private
    // MARK: Properties
    private let userManager: UserManager = UserManager()
    private let mapController: MapController = MapController()
    
    // MARK: Methods
    /// Check if the entered email is correct
    private func isValidEmailAddress(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: email)
    }
    
    /// Initialise all notification for this controller
    @objc private func processNotification(_ notification: Notification) {
        if let notificationName = notification.userInfo?["name"] as? Notification.Name {
            showLoadingInProgressView = false
            objectWillChange.send()
            
            switch notificationName {
            case Notification.AniTrip.loginFailled.notificationName:
                errorMessage = self.userManager.errorMessage
            case Notification.AniTrip.loginSuccess.notificationName:
                loginSuccess()
            case Notification.AniTrip.successfullCreation.notificationName:
                showNewAccountAlert = true
            case Notification.AniTrip.errorDuringCreation.notificationName:
                errorMessage = Notification.AniTrip.errorDuringCreation.notificationMessage
            case Notification.AniTrip.successRequestForNewPassword.notificationName:
                showForgetPasswordAlert = true
            case Notification.AniTrip.errorDuringRequestForNewPassword.notificationName:
                errorMessage = Notification.AniTrip.errorDuringRequestForNewPassword.notificationMessage
            case Notification.AniTrip.successUserUpdate.notificationName:
                showUpdateUserAlert = true
            case Notification.AniTrip.errorDuringUpdatingUser.notificationName:
                errorMessage = self.userManager.errorMessage
                showUpdateUserAlert = true
            default: break
            }
        }
    }
    
    /// Configure notification
    private func configureNotification(for name: Notification.Name) {
        NotificationCenter.default.addObserver(self, selector: #selector(processNotification), name: name, object: nil)
    }
    
    /// Perform action when the login is a success
    private func loginSuccess() {
        loginPassword = ""
        isLoggedIn = true
        if let user = connectedUser {
            userToUpdate = user
            mapController.getAddressFromString(user.address) { location in
                if let location = location {
                    self.userCoordinate = MKCoordinateRegion(center: location, latitudinalMeters: 750, longitudinalMeters: 750)
                    self.userPin = [Places(lat: location.latitude, lon: location.longitude)]
                }
            }
        }
    }
}
