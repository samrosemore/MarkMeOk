//
//  SceneDelegate.swift
//  ArtUOKV3
//
//  Created by Sam Rosemore on 5/20/20.
//  Copyright © 2020 Sam Rosemore. All rights reserved.
//

import UIKit
import GoogleSignIn
import FirebaseAuth
import FirebaseFirestore
import Firebase
import FirebaseInstanceID



class SceneDelegate: UIResponder, UIWindowSceneDelegate
{
    
    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions)
    {
        //for google sign in option
        
        if let windowScene = scene as? UIWindowScene
        {
            self.window = UIWindow(windowScene: windowScene)
            
            Auth.auth().addStateDidChangeListener
            { (auth, user) in
                
                if auth.currentUser != nil
                {
                    // redirect to the home controller
                    //GroupsListings
                    let storyboard = UIStoryboard(name: "GroupsListings", bundle: nil)
                    self.window!.rootViewController = storyboard.instantiateViewController(withIdentifier: "GroupBase1")
                    self.window!.makeKeyAndVisible()
                    
                    //update rt
                    InstanceID.instanceID().instanceID(handler:
                        {
                            (result, error) in
                            
                            if let err = error
                            {
                                print("shit there was an err \(err)")
                            }
                            else if let res = result
                            {
                                //database call to register token
                                let db = Firestore.firestore()
                                db.collection("users").document(Auth.auth().currentUser!.uid).setData(["rt" : res.token], merge: true)
                            }
                        })
                    
                } else {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    // redirect to the login controller
                    self.window!.rootViewController = storyboard.instantiateViewController(withIdentifier: "Login")
                    self.window!.makeKeyAndVisible()
                }
              
            }
            
        }
       
        
        
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    
     
 
      
    
}




