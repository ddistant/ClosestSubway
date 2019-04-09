//
//  RootViewController.swift
//  ClosestSubway
//
//  Created by Daniel Distant on 4/7/19.
//  Copyright © 2019 Daniel Distant. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
    // MARK: - enums
    enum Constants {
        static let title = "Closest Subways"
        static let cellIdentifier = "cellIdentifier"
        
        enum LocationAlert {
            static let title = "Location Services Not Allowed"
            static let message = "Location access is restricted. To change this, go to Settings > Privacy > Location Services and allow location access."
            static let cancel = "Cancel"
            static let settings = "Go to Settings"
        }
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - properties
    let viewModel = RootViewModel()
    
    // MARK: - life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = Constants.title
        setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        checkLocationAccessEnabled()
    }
    
    // MARK: - private methods
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.cellIdentifier)
    }
    
    private func checkLocationAccessEnabled() {
        if viewModel.locationServicesEnabled == false {
            showUserDeniedLocationAlert()
        }
    }
    
    private func showUserDeniedLocationAlert() {
        let alertController = UIAlertController(title: Constants.LocationAlert.title,
                                                message: Constants.LocationAlert.message,
                                                preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: Constants.LocationAlert.cancel, style: .cancel)
        let goToSettings = UIAlertAction(title: Constants.LocationAlert.settings, style: .default) { [weak self] _ in
            self?.deeplinkToSettings()
        }
        
        alertController.addAction(cancel)
        alertController.addAction(goToSettings)
        
        present(alertController, animated: true)
    }
    
    private func deeplinkToSettings() {
        guard let bundleId = Bundle.main.bundleIdentifier,
            let appSettingsUrl = URL(string: UIApplication.openSettingsURLString + bundleId) else {
            print("📌 could not deeplink to settings")
            return
        }
        
        if UIApplication.shared.canOpenURL(appSettingsUrl) {
            UIApplication.shared.open(appSettingsUrl, completionHandler: { (success) in
                print("📉 Settings opened: \(success)")
            })
        }
    }
}

// MARK: - UITableViewDelegate
extension RootViewController: UITableViewDelegate {
    
}

// MARK: - UITableViewDataSource
extension RootViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.subwayStations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath)
        
        cell.textLabel?.text = viewModel.subwayStations[indexPath.row].name
        return cell
    }
}
