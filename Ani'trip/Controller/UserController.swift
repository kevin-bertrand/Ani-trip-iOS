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
    @Published var userIsLoggedIn: Bool = false
    @Published var userErrorMessage: String = ""
    var connectedUser: User? { userManager.user }
    
    // Login view
    @Published var loginEmailField: String = ""
    @Published var loginPasswordField: String = ""
    @Published var rememberEmailToggle: Bool = false
    
    // New user view
    @Published var newUserEmailField: String = ""
    @Published var newUserPasswordField: String = ""
    @Published var newUserPasswordVerificationField: String = ""
    @Published var showNewAccountAlert: Bool = false
    @Published var showNewAccountView: Bool = false
    
    // Forget password view
    @Published var forgetPasswordEmailField: String = ""
    @Published var showForgetPasswordView: Bool = false
    @Published var showForgetPasswordAlert: Bool = false
    
    // Update user informations
    @Published var showUpdateUserAlert: Bool = false
    @Published var userToUpdate: UpdateUser
    @Published var updatePasswordField: String = ""
    @Published var updatePasswordVerificationField: String = ""
    var updatePasswordError: String = ""
    
    // User profil
    @Published var userCoordinate: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), latitudinalMeters: 0, longitudinalMeters: 0)
    var userPin: [Places] = []
    
    // Volunteers view
    @Published var volunteersList: [User] = []
    @Published var searchFilter: String = "" {
        didSet {
            filterVolunteersList()
        }
    }
    
    // MARK: Methods
    /// Login user
    func login() {
        showLoadingInProgressView = true
        
        guard loginEmailField.isNotEmpty,
              loginPasswordField.isNotEmpty else {
            userErrorMessage = "An email and a password are needed!"
            showLoadingInProgressView = false
            return
        }
        
        guard loginEmailField.isEmail else {
            userErrorMessage = "A valid email address is required!"
            showLoadingInProgressView = false
            return
        }
        
        userManager.login(user: UserToConnect(email: loginEmailField.trimmingCharacters(in: .whitespacesAndNewlines), password: loginPasswordField))
    }
    
    /// Perform the creation of the new account
    func createNewAccount() {
        showLoadingInProgressView = true
        
        guard newUserPasswordField.isNotEmpty, newUserPasswordVerificationField.isNotEmpty, newUserEmailField.isNotEmpty else {
            showLoadingInProgressView = false
            userErrorMessage = "An email and a password are needed!"
            return
        }
        
        guard newUserEmailField.isEmail else {
            showLoadingInProgressView = false
            userErrorMessage = "A valid email address is required!"
            return
        }
        
        guard newUserPasswordField == newUserPasswordVerificationField else {
            showLoadingInProgressView = false
            userErrorMessage = "Both password are not equals!"
            return
        }
        
        userManager.createAccount(for: UserToCreate(email: newUserEmailField, password: newUserPasswordField, passwordVerification: newUserPasswordVerificationField))
    }
    
    /// End the request of the creation of a new account
    func finishUserCreation() {
        showNewAccountView = false
        userErrorMessage = ""
        newUserEmailField = ""
        newUserPasswordField = ""
        newUserPasswordVerificationField = ""
    }
    
    /// Perform the request to send a new password
    func forgetPassword() {
        showLoadingInProgressView = true
        
        guard forgetPasswordEmailField.isNotEmpty,
              forgetPasswordEmailField.isEmail else {
            showLoadingInProgressView = false
            userErrorMessage = "A valid email address is needed!"
            return
        }
        
        userManager.forgetPassword(for: UserToConnect(email: forgetPasswordEmailField, password: ""))
    }
    
    /// End the request of a new password
    func finishForgetPasswordRequest() {
        showForgetPasswordView = false
        userErrorMessage = ""
        forgetPasswordEmailField = ""
    }
    
    /// Disconnect the user
    func disconnect() {
        objectWillChange.send()
        userIsLoggedIn = false
    }
    
    /// Update user
    func update() {
        showLoadingInProgressView = true
        
        if (updatePasswordField.isNotEmpty == true) == updatePasswordVerificationField.isNotEmpty {
            guard updatePasswordField == updatePasswordVerificationField else {
                updatePasswordError = "Both password must match!"
                showLoadingInProgressView = false
                return
            }
        }
        
        userManager.update(user: userToUpdate)
    }
    
    /// Getting the list of all volunteers
    func getVolunteerList() {
        userManager.getVolunteerList()
    }
    
    // MARK: Init
    init() {
        userToUpdate = .init(id: UUID(), firstname: "", lastname: "", email: "", phoneNumber: "", gender: .notDeterminded, position: .user, missions: [], isActive: false, address: mapController.emptyAddress, password: "", passwordVerification: "")
        
        configureNotification(for: Notification.AniTrip.loginSuccess.notificationName)
        configureNotification(for: Notification.AniTrip.loginFailled.notificationName)
        configureNotification(for: Notification.AniTrip.successfullCreation.notificationName)
        configureNotification(for: Notification.AniTrip.errorDuringCreation.notificationName)
        configureNotification(for: Notification.AniTrip.successRequestForNewPassword.notificationName)
        configureNotification(for: Notification.AniTrip.errorDuringRequestForNewPassword.notificationName)
        configureNotification(for: Notification.AniTrip.successUserUpdate.notificationName)
        configureNotification(for: Notification.AniTrip.errorDuringUpdatingUser.notificationName)
        configureNotification(for: Notification.AniTrip.successGettingVolunteerList.notificationName)
        configureNotification(for: Notification.AniTrip.errorGettingVolunteerList.notificationName)
    }
    
    // MARK: Private
    // MARK: Properties
    private let userManager: UserManager = UserManager()
    private let mapController: MapController = MapController()
    
    // MARK: Methods
    /// Initialise all notification for this controller
    @objc private func processNotification(_ notification: Notification) {
        if let notificationName = notification.userInfo?["name"] as? Notification.Name {
            showLoadingInProgressView = false
            objectWillChange.send()
            
            switch notificationName {
            case Notification.AniTrip.loginFailled.notificationName:
                userErrorMessage = self.userManager.errorMessage
            case Notification.AniTrip.loginSuccess.notificationName:
                loginSuccess()
            case Notification.AniTrip.successfullCreation.notificationName:
                showNewAccountAlert = true
            case Notification.AniTrip.errorDuringCreation.notificationName:
                userErrorMessage = Notification.AniTrip.errorDuringCreation.notificationMessage
            case Notification.AniTrip.successRequestForNewPassword.notificationName:
                showForgetPasswordAlert = true
            case Notification.AniTrip.errorDuringRequestForNewPassword.notificationName:
                userErrorMessage = Notification.AniTrip.errorDuringRequestForNewPassword.notificationMessage
            case Notification.AniTrip.successUserUpdate.notificationName:
                showUpdateUserAlert = true
            case Notification.AniTrip.errorDuringUpdatingUser.notificationName:
                userErrorMessage = self.userManager.errorMessage
                showUpdateUserAlert = true
            case Notification.AniTrip.successGettingVolunteerList.notificationName:
                self.volunteersList = self.userManager.volunteers
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
        loginPasswordField = ""
        userIsLoggedIn = true
        if let user = connectedUser {
            userToUpdate = UpdateUser(id: user.id ?? UUID(), firstname: user.firstname, lastname: user.lastname, email: user.email, phoneNumber: user.phoneNumber, gender: user.gender, position: user.position, missions: user.missions, isActive: user.isActive, address: user.address ?? mapController.emptyAddress, password: "", passwordVerification: "")
            if let address = user.address {
                mapController.getAddressFromString(address) { location in
                    if let location = location {
                        self.userCoordinate = MKCoordinateRegion(center: location, latitudinalMeters: 750, longitudinalMeters: 750)
                        self.userPin = [Places(lat: location.latitude, lon: location.longitude)]
                    }
                }
            }
            
            DispatchQueue.main.async {
                self.getVolunteerList()
            }
        }
    }
    
    /// Filter volunteers list
    private func filterVolunteersList() {
        if searchFilter.isEmpty {
            volunteersList = userManager.volunteers
        } else {
            volunteersList = userManager.volunteers.filter { $0.firstname.localizedCaseInsensitiveContains(searchFilter) || $0.lastname.localizedCaseInsensitiveContains(searchFilter) || !($0.missions.filter {$0.localizedCaseInsensitiveContains(searchFilter)}).isEmpty }
        }
    }
}
