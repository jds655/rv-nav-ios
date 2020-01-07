//
//  NetworkController.swift
//  RVNav
//
//  Created by Jonathan Ferrer on 8/21/19.
//  Copyright © 2019 RVNav. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper
import ArcGIS

class NetworkController {
    
    // MARK: - Properties
    var vehicle: Vehicle?
    let baseURL = URL(string: "https://labs-rv-life-staging-1.herokuapp.com/")!
    let avoidURL = URL(string: "https://dr7ajalnlvq7c.cloudfront.net/fetch_low_clearance")!
    var result: Result?
    
    // MARK: - Public Methods
    // Register
    func register(with user: User, completion: @escaping (Error?) -> Void) {
        let url = baseURL.appendingPathComponent("users").appendingPathComponent("register")
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        guard let username = user.email,
            let password = user.password else { return }
        let userSignInInfo = SignInInfo(email: username, password: password)
        do {
            let jsonEncoder = JSONEncoder()
            jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
            request.httpBody = try jsonEncoder.encode(userSignInInfo)
        } catch {
            completion(error)
            return
        }
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 && response.statusCode != 201 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            if let error = error {
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
    // Log In
    func signIn(with signInInfo: SignInInfo, completion: @escaping (Error?) -> Void) {
        let url = baseURL.appendingPathComponent("users").appendingPathComponent("login")
        var request = URLRequest(url: url)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        do {
            let jsonEncoder = JSONEncoder()
            request.httpBody = try jsonEncoder.encode(signInInfo)
        } catch {
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            if let error = error {
                completion(error)
                return
            }
            guard let data = data else {
                completion(NSError())
                return
            }
            do {
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                self.result = try jsonDecoder.decode(Result.self, from: data)
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary
                if let parseJSON = json {
                    let accessToken = parseJSON["token"] as? String
                    let saveAccessToken: Bool = KeychainWrapper.standard.set(accessToken!, forKey: "accessToken")
                    print("The access token save result: \(saveAccessToken)")
                    if (accessToken?.isEmpty)! {
                        NSLog("Access Token is Empty")
                        return
                    }
                }
            } catch {
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
    // Creates vehicle in api for the current user.
    
    func createVehicle(with vehicle: Vehicle, completion: @escaping (Error?) -> Void) {
        let url = baseURL.appendingPathComponent("vehicle")
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(KeychainWrapper.standard.string(forKey: "accessToken"), forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        do {
            let jsonEncoder = JSONEncoder()
            jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
            request.httpBody = try jsonEncoder.encode(vehicle)
        } catch {
            completion(error)
            return
        }
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            if let error = error {
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
    // Edit a stored vehicle with a vehivle id.
    func editVehicle(with vehicle: Vehicle, id: Int, completion: @escaping (Error?) -> Void) {
        let url = baseURL.appendingPathComponent("vehicle").appendingPathComponent("\(id)")
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(KeychainWrapper.standard.string(forKey: "accessToken"), forHTTPHeaderField: "Authorization")
        request.httpMethod = "PUT"
        do {
            let jsonEncoder = JSONEncoder()
            jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
            request.httpBody = try jsonEncoder.encode(vehicle)
        } catch {
            completion(error)
            return
        }
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            if let error = error {
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
    // Delete a stored vehicle with vehivle id.
    func deleteVehicle(id: Int, completion: @escaping (Error?) -> Void) {
        let url = baseURL.appendingPathComponent("vehicle").appendingPathComponent("\(id)")
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(KeychainWrapper.standard.string(forKey: "accessToken"), forHTTPHeaderField: "Authorization")
        request.httpMethod = "DELETE"
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                NSLog("Error Deleting entry to server: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
    // Gets all currently stored vehicles for a user
    func getVehicles(completion: @escaping ([Vehicle], Error?) -> Void) {
        let url = baseURL.appendingPathComponent("vehicle")
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(KeychainWrapper.standard.string(forKey: "accessToken"), forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching vehicle: \(error)")
                completion([], error)
                return
            }
            guard let data = data else {
                NSLog("No data returned from dataTask")
                completion([], error)
                return
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let vehicles = try decoder.decode([Vehicle].self, from: data)
                completion(vehicles, nil)
            } catch {
                NSLog("Error decoding vehicle: \(error)")
                completion([], error)
            }
        }.resume()
    }
    
    // Gets an array of avoidance coordinates from DS backend.
    func getAvoidances(with routeInfo: RouteInfo, completion: @escaping ([Avoid]?,Error?) -> Void) {
        var request = URLRequest(url: avoidURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let jsonEncoder = JSONEncoder()
            jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
            request.httpBody = try jsonEncoder.encode(routeInfo)
        } catch {
            NSLog("error encoding\(error)")
            completion(nil, error)
            return
        }
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(nil, NSError())
                return
            }
            if let error = error {
                completion(nil, error)
                return
            }
            guard let data = data else {
                completion(nil, NSError())
                return
            }
            let jsonDecoder = JSONDecoder()
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let avoidArray: [Avoid] = try jsonDecoder.decode([Avoid].self, from: data)
                completion(avoidArray, nil)
                
            } catch {
                completion(nil, error)
                return
            }
        }.resume()
    }
}
