['']//
//  MapBoxAPIController.swift
//  RVNav
//
//  Created by Jonathan Ferrer on 8/30/19.
//  Copyright © 2019 RVNav. All rights reserved.
//

import Foundation
import MapboxGeocoder


class MapBoxAPIController  {
    var avoidanceController: AvoidanceControllerProtocol
    var mapAPIController: MapAPIControllerProtocol
    
    required init(mapAPIController: MapAPIControllerProtocol, avoidanceController: AvoidanceControllerProtocol) {
        self.mapAPIController = mapAPIController
        self.avoidanceController = avoidanceController
    }
    
    // MARK: - Properties
    // instance of the geocoder (address look up and converter)
    let geocoder = Geocoder.shared
    
    // MARK: - Public Methods
    
    func search(with address: String, completion: @escaping ([AddressProtocol]?) -> Void) {
        let options = ForwardGeocodeOptions(query: address)
        options.allowedScopes = [.address, .pointOfInterest]

        _ = geocoder.geocode(options) { (placemarks, attribution, error) in
            guard let placemarks = placemarks else { return }

            completion(placemarks)
        }
    }
}
