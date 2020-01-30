//
//  AppDelegate.swift
//  RVNav
//
//  Created by Jonathan Ferrer on 8/19/19.
//  Copyright © 2019 RVNav. All rights reserved.
//

import UIKit
import FirebaseCore
import ArcGIS
import GoogleSignIn
import FacebookCore
import FBSDKCoreKit
import DropDown



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, AGSAuthenticationManagerDelegate  {
    let globalConfiguration = AGSRequestConfiguration.global()
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        AGSAuthenticationManager.shared().delegate = self
        //setupOAuthManager()
        DropDown.startListeningToKeyboard()
        globalConfiguration.timeoutInterval = 300.0
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = "199974151301-jblt1pc708u1domcc6vpvpa8av0gi8t4.apps.googleusercontent.com"
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)


        return true
    }
    
//    @available(iOS 9.0, *)
//    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
//
//        let appID = Settings.appID
//        if url == URL(string: "com.googleusercontent.apps.199974151301-jblt1pc708u1domcc6vpvpa8av0gi8t4") {
//            return GIDSignIn.sharedInstance().handle(url)
//        } else if url.scheme != nil && url.scheme!.hasPrefix("fb\(appID!)") {
//            return ApplicationDelegate.shared.application(app, open: url, options: options)
//        }
//        return false
//    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let appID = Settings.appID
        if url == URL(string: "com.googleusercontent.apps.199974151301-jblt1pc708u1domcc6vpvpa8av0gi8t4") {
            return GIDSignIn.sharedInstance().handle(url)
        } else if url.scheme != nil && url.scheme!.hasPrefix("fb\(appID!)") {
            return ApplicationDelegate.shared.application(application, open: url, sourceApplication: sourceApplication, annotation: nil)
        } 
        return false
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false),
            AppConfiguration.urlScheme == urlComponents.scheme,
            AppConfiguration.urlAuthPath == urlComponents.host {
            AGSApplicationDelegate.shared().application(app, open: url, options: options)
        }
        return true
    }

//    private func setupOAuthManager() {
//        let config = AGSOAuthConfiguration(portalURL: nil, clientID: AppConfiguration.clientID, redirectURL: "\(AppConfiguration.urlScheme)://\(AppConfiguration.urlAuthPath)")
//        AGSAuthenticationManager.shared().oAuthConfigurations.add(config)
//        AGSAuthenticationManager.shared().credentialCache.enableAutoSyncToKeychain(withIdentifier: AppConfiguration.keychainIdentifier, accessGroup: nil, acrossDevices: false)
//    }
    
    var arcgisPortal = AGSPortal.arcGISOnline(withLoginRequired: false)
    
    func authenticationManager(_ authenticationManager: AGSAuthenticationManager, didReceive challenge: AGSAuthenticationChallenge) {
        // We enter here because a call to some AGSRemoteResource (e.g. an AGSRouteTask)
        // failed with an authentication error. This is our chance to generate and provide
        // a token that we want the runtime to use. If we return nil, the authentication
        // error will be propagated through to the network caller.
        //
        // If this method is not implemented, the default Runtime username/password
        // prompt will be displayed (unless some OAuth configuration has been set up,
        // in which case Runtime will enter the OAuth workflow).
        
        // Here we will try to get a valid credential using the ClientID/ClientSecret.
        // Note, I have kept this on AGSPortal because the token REST endpoint is associated
        // with the portal so it makes logical sense. Otherwise we would need to pass in the
        // URL to the portal anyway. Portal is a very lighweight object so this isn't too
        // onerous. If needed, we can revisit this.
        arcgisPortal.getAppIDToken(clientId: "taIMz5a6FZ8j6ZCs", clientSecret: "42694cda208b4c95b7c07673ca877f92") { (credential, error) in
            if let error = error {
                print("Error getting credential using AppID! \(error)")
                // By calling continue, we will propagate the authentication error
                // to the caller. One would need to check the logs to see that the
                // attempt to get this credential also failed.
                challenge.continue(with: nil)
                return
            }
            
            guard let credential = credential else {
                // We should always have a credential if there was no error, but
                // it doesn't hurt to defend. Note that this will terminate the app.
                preconditionFailure("Didn't get a credential… That's strange")
            }
            
            // Now we have a credential. Runtime will retry the call that failed,
            // adding that credential to the credential cache (and the keychain, if you've
            // opted into synchronizing the cache with the keychain),
            // and will dequeue the requests that were waiting based off their need
            // for the credential that Runtime didn't have.
            challenge.continue(with: credential)
            
            print("Provided a valid AppID based credential!")
        }
    }


    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

