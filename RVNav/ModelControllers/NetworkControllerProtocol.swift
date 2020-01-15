//
//  NetworkControllerProtocol.swift
//  RVNav
//
//  Created by Lambda_School_Loaner_214 on 1/15/20.
//  Copyright © 2020 RVNav. All rights reserved.
//

import Foundation

protocol NetworkControllerProtocol {
    
    var result: Result? {get set}
    var vehicle: Vehicle? {get set}
    
    
    func register(with user: User, completion: @escaping (Error?) -> Void)
    
    func signIn(with signInInfo: SignInInfo, completion: @escaping (Error?) -> Void)
    
    func logout(completion: @escaping () -> Void)
    
    func createVehicle(with vehicle: Vehicle, completion: @escaping (Error?) -> Void)
    
    func editVehicle(with vehicle: Vehicle, id: Int, completion: @escaping (Error?) -> Void)
    
    func deleteVehicle(id: Int, completion: @escaping (Error?) -> Void)
    
    func getVehicles(completion: @escaping ([Vehicle], Error?) -> Void)
    
    func getAvoidances(with routeInfo: RouteInfo, completion: @escaping ([Avoid]?,Error?) -> Void)
}
