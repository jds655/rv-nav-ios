//
//  UserController.swift
//  RVNav
//
//  Created by Lambda_School_Loaner_214 on 1/16/20.
//  Copyright © 2020 RVNav. All rights reserved.
//

import Foundation

class UserController: UserControllerProtocol {
    let networkController: NetworkControllerProtocol
    var result: Result?
    
    init (networkController: NetworkControllerProtocol = WebRESTAPINetworkController()) {
        self.networkController = networkController
    }
    
    func register(with user: User, completion: @escaping (Error?) -> Void) {
        networkController.register(with: user, completion: completion)
    }
    
    func signIn(with signInInfo: SignInInfo, completion: @escaping (Error?) -> Void) {
        networkController.signIn(with: signInInfo, completion: completion)
        guard let result = networkController.result else { return }
        self.result = result
    }
    
    func logout(completion: @escaping () -> Void = { }) {
        networkController.logout(completion: completion)
    }
}
