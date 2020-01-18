//
//  UserControllerProtocol.swift
//  RVNav
//
//  Created by Lambda_School_Loaner_214 on 1/16/20.
//  Copyright © 2020 RVNav. All rights reserved.
//

import Foundation

protocol UserControllerProtocol {
    var result: Result? {get set}
    var userID: Int? {get set}
    
    func register(with user: User, completion: @escaping (Error?) -> Void)
    func signIn(with signInInfo: SignInInfo, group: DispatchGroup?, completion: @escaping (Error?) -> Void)  -> Int?
    func logout(completion: @escaping () -> Void)
}
