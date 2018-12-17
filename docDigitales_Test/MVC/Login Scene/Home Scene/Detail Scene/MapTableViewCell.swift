//
//  MapTableViewCell.swift
//  docDigitales_Test
//
//  Created by Felipe Montoya on 12/13/18.
//  Copyright © 2018 Felipe Montoya. All rights reserved.
//

import UIKit
import MapKit

class MapTableViewCell: UITableViewCell {
    @IBOutlet weak var branchNameLabel: UILabel!
    @IBOutlet weak var adress1Label: UILabel!
    @IBOutlet weak var adress2Label: UILabel!
    @IBOutlet weak var mapView: MKMapView!
}
