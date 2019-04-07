//
//  RootViewController.swift
//  ClosestSubway
//
//  Created by Daniel Distant on 4/7/19.
//  Copyright © 2019 Daniel Distant. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - properties
    let viewModel = RootViewModel()
    
    // MARK: - life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        title = "Closest Subways"
    }
    
    // MARK: - private methods
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellIdentifier")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
        
        cell.textLabel?.text = viewModel.subwayStations[indexPath.row].name
        return cell
    }
}
