//
//  UserController.swift
//  RVNav
//
//  Created by Lambda_School_Loaner_214 on 1/16/20.
//  Copyright © 2020 RVNav. All rights reserved.
//

import Foundation

class UserController: UserControllerProtocol {
    static let shared = UserController()
    let networkController: NetworkControllerProtocol
    var result: Result?
    let userDefaults = UserDefaults.standard
    var userID: Int?
    
    init (networkController: NetworkControllerProtocol = WebRESTAPINetworkController()) {
        self.networkController = networkController
        userID = userDefaults.integer(forKey: "userID")
    }
    
    func register(with user: User, completion: @escaping (Error?) -> Void) {
        networkController.register(with: user, completion: completion)
    }
    
    func signIn(with signInInfo: SignInInfo, group: DispatchGroup? = nil, completion: @escaping (Error?) -> Void) -> Int? {
        let mygroup = DispatchGroup()
    
        group?.enter()
        self.userID = networkController.signIn(with: signInInfo, group: mygroup, completion: completion)
        mygroup.wait()
        guard let result = networkController.result else { return nil}
        self.result = result
        group?.leave()
        return userID
    }
    
    func logout(completion: @escaping () -> Void = { }) {
        networkController.logout(completion: completion)
        userDefaults.removeObject(forKey: "userID")
    }
}
