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
    
    func signIn(with signInInfo: SignInInfo, group: DispatchGroup? = nil, completion: @escaping (Error?) -> Void) {
        let mygroup = DispatchGroup()
    
        group?.enter()
        print ("Entering Group 1 within UserController: \(#line)")
        networkController.signIn(with: signInInfo, group: mygroup, completion: completion)
        print ("Awaiting Group 2 within UserController: \(#line)")
        mygroup.wait()
        print ("Done Awaiting Group 2 within UserController: \(#line)")
        guard let result = networkController.result else { return }
        self.result = result
        group?.leave()
        print ("Left Group 1 within UserController: \(#line)")
    }
    
    func logout(completion: @escaping () -> Void = { }) {
        networkController.logout(completion: completion)
    }
}
