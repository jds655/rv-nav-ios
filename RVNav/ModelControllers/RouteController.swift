//
//  RouteController.swift
//  RVNav
//
//  Created by Lambda_School_Loaner_214 on 1/28/20.
//  Copyright © 2020 RVNav. All rights reserved.
//

import Foundation

//This and vehicles needs to be persisted localy at some point
class RouteController {
    
    private(set) var routes: [Route] = []
    private var networkController: NetworkControllerProtocol
    
    init(networkController: NetworkControllerProtocol) {
        self.networkController = networkController
        routes = self.get() ?? []
    }
    
    public func add(route: Route) {
        networkController.addRoute(route)
    }
    
    public func delete(_ route: Route) {
        networkController.deleteRoute(route)
    }
    
    public func update(_ route: Route, newRoute: Route) {
        networkController.updateRoute(route, newRoute)
    }
    
    public func get() -> [Route]? {
        //getRoutes from local store
        //get routes from online storage - Firebase, WebAPI?
        return nil
    }
}
