//
//  AvoidanceProviderProtocol.swift
//  RVNav
//
//  Created by Lambda_School_Loaner_214 on 1/30/20.
//  Copyright © 2020 RVNav. All rights reserved.
//

import Foundation

protocol AvoidanceProviderProtocol {
    func getAvoidances(with routeInfo: RouteInfo, completion: @escaping ([Avoid]?,Error?) -> Void)
}
