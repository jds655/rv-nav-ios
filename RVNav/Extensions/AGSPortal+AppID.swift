//
//  AGSPortal+AppID.swift
//  RVNav
//
//  Created by Jake Connerly on 1/30/20.
//  Copyright © 2020 RVNav. All rights reserved.
//

import Foundation
import ArcGIS

import Foundation
import ArcGIS

private struct AppIdToken : Decodable {
    let token:String
    let expiresIn:Int

    private enum CodingKeys: String, CodingKey {
        case token = "access_token"
        case expiresIn = "expires_in"
    }
}

extension AGSPortal {
    public enum AppIDError : LocalizedError {
        case badUrl
        case badJsonResponse

        public var errorDescription: String? {
            switch self {
            case .badUrl:
                return "URL to token service could not be constructed from the portal URL."
            case .badJsonResponse:
                return "The response from the token service could not be interpreted!"
            }
        }
    }

    public func getAppIDToken(clientId:String, clientSecret:String, duration:Int? = nil, callback:@escaping (AGSCredential?, Error?)->Void) {
        load { [unowned portal = self] error in
            guard error == nil else {
                print("Error loading portal!")
                callback(nil, error)
                return
            }

            guard let tokenUrl = URL(string: "sharing/rest/oauth2/token", relativeTo: portal.url) else {
                print("Couldn't construct token URL!")
                callback(nil, AppIDError.badUrl)
                return
            }

            var appIdParameters:[String:Any] = [
                "f": "json",
                "client_id": clientId,
                "client_secret": clientSecret,
                "grant_type": "client_credentials"
            ]

            if let duration = duration, duration > 0 {
                appIdParameters["expiration"] = duration
            }

            let request = AGSRequestOperation(remoteResource: nil, url: tokenUrl,
                                              queryParameters: appIdParameters,
                                              method: .postFormEncodeParameters)
            request.registerListener(AGSOperationQueue.shared(), forCompletion: { (result, error) in
                guard error == nil else {
                    print("Error getting token! \(error!.localizedDescription)")
                    callback(nil, error)
                    return
                }

                guard let tokenData = result as? Data else {
                    print("Expected Data, but didn't get Data")
                    callback(nil, AppIDError.badJsonResponse)
                    return
                }

                var tokenInfo:AppIdToken!

                do {
                    tokenInfo = try JSONDecoder().decode(AppIdToken.self, from: tokenData)
                } catch {
                    print("Couldn't decode token info! \(error)")
                    callback(nil, error)
                    return
                }

                let credential = AGSCredential(token: tokenInfo.token, referer: nil)
                credential.tokenUrl = tokenUrl
                callback(credential, nil)
            })

            AGSOperationQueue.shared().addOperation(request)
        }
    }
}
