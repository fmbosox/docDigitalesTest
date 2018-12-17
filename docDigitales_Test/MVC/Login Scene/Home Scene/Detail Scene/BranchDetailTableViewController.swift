//
//  BranchDetailTableViewController.swift
//  docDigitales_Test
//
//  Created by Felipe Montoya on 12/13/18.
//  Copyright © 2018 Felipe Montoya. All rights reserved.
//

import UIKit
import MapKit

class BranchDetailTableViewController: UITableViewController, MKMapViewDelegate {

    //MARK: - Properties -
    var currentBranch: BranchMO!
    
    //MARK: - ViewController Lyfecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - MapView -
    
    func setUpMapView(mkMapView: MKMapView) {
        mkMapView.delegate = self
        let MKSearchRequest = MKLocalSearch.Request()
        MKSearchRequest.naturalLanguageQuery = currentBranch.streetName! + currentBranch.extNumber! + "," + currentBranch.postalCode! + "," + currentBranch.city! + "," + currentBranch.country!
        
        let MKSearch = MKLocalSearch(request: MKSearchRequest)
        MKSearch.start { (response, error) in
            var _placeCoordinates: CLLocationCoordinate2D?
            if error == nil && !(response?.mapItems.isEmpty ?? true) {
                _placeCoordinates = response!.mapItems[0].placemark.coordinate
            } else if response != nil  {
                _placeCoordinates = response!.boundingRegion.center
            }
            guard let placeCoordinates = _placeCoordinates else { return }
            mkMapView.region  = MKCoordinateRegion(center: placeCoordinates, span: MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3))
            mkMapView.camera.altitude = 100 * 4
            mkMapView.isHidden = false
        }
        

    }
    

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 2
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 { //Map Cell
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Map Cell", for: indexPath) as? MapTableViewCell else { print("Couldn't get the map cell"); return UITableViewCell() }
            cell.branchNameLabel.text = currentBranch.branchName!
            cell.adress1Label.text = currentBranch.streetName! + " #" + currentBranch.extNumber! + ", " + currentBranch.suburbName!
            cell.adress2Label.text = currentBranch.city! + ", " + currentBranch.country! + ", " + "C.P " + currentBranch.postalCode!
            cell.mapView.isHidden = true
            setUpMapView(mkMapView: cell.mapView)
            return cell
            
        } else if indexPath.row == 1 { //Employees Cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "Employees Cell", for: indexPath)
            cell.textLabel?.text = "\(currentBranch.employees?.count ?? 0)"
            return cell
        }else {
            return UITableViewCell()
        }
       
    }
}
