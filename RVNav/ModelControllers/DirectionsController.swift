//
//  DirectionsController.swift
//  RVNav
//
//  Created by Jonathan Ferrer on 8/30/19.
//  Copyright © 2019 RVNav. All rights reserved.
//

import Foundation
import MapboxGeocoder


class DirectionsController {

    let geocoder = Geocoder.shared
    var destinationAddress: Placemark?


    
    func search(with address: String, completion: @escaping ([Placemark]?) -> Void) {
        let options = ForwardGeocodeOptions(query: address)
        options.allowedScopes = [.address, .pointOfInterest]

        _ = geocoder.geocode(options) { (placemarks, attribution, error) in
            guard let placemarks = placemarks else { return }

            completion(placemarks)
        }
    }

   



    
}
