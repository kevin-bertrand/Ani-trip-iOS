//
//  VolunteerController.swift
//  Ani'trip
//
//  Created by Kevin Bertrand on 06/07/2022.
//

import Foundation

final class VolunteerController: ObservableObject {
    // MARK: Public
    // MARK: Properties
    @Published var volunteersList: [User] = []
    @Published var searchFilter: String = "" {
        didSet {
            filterVolunteersList()
        }
    }
    
    // MARK: Methods
    /// Getting the list of all volunteers
    func getVolunteerList() {
        volunteerManager.getVolunteerList()
    }

    // MARK: Init
    init(userController: UserController) {
        self.userController = userController
        
        configureNotification(for: Notification.AniTrip.successGettingVolunteerList.notificationName)
        configureNotification(for: Notification.AniTrip.errorGettingVolunteerList.notificationName)
    }
        
    // MARK: Private
    // MARK: Properties
    private let volunteerManager: VolunteerManager = VolunteerManager()
    private let userController: UserController
    
    // MARK: Methods
    /// Filter list
    private func filterVolunteersList() {
        if searchFilter.isEmpty {
            volunteersList = volunteerManager.volunteers
        } else {
            volunteersList = volunteerManager.volunteers.filter { $0.firstname.localizedCaseInsensitiveContains(searchFilter) || $0.lastname.localizedCaseInsensitiveContains(searchFilter) || !($0.missions.filter {$0.localizedCaseInsensitiveContains(searchFilter)}).isEmpty }
        }
    }
    
    /// Initialise all notification for this controller
    @objc private func processNotification(_ notification: Notification) {
        if let notificationName = notification.userInfo?["name"] as? Notification.Name {
            DispatchQueue.main.async {
                self.objectWillChange.send()
                
                switch notificationName {
                case Notification.AniTrip.successGettingVolunteerList.notificationName:
                    self.volunteersList = self.volunteerManager.volunteers
                case Notification.AniTrip.errorGettingVolunteerList.notificationName:
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
}
