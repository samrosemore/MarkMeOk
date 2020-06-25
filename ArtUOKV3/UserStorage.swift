//
//  UserStorage.swift
//  ArtUOKV2
//
//  Created by Sam Rosemore on 5/16/20.
//  Copyright © 2020 Sam Rosemore. All rights reserved.
//

import Foundation
import SwiftUI
import FirebaseFirestore


class UserStorage: ObservableObject
{
    //for initial sign up
    @Published var email: String = ""
    @Published var username:String = ""
    @Published var fullName:String = ""
    @Published var password: String = ""
    
    @Published var timePeriod: String = ""
    @Published var timeBetweenWarnings:String = ""
    @Published var numWarnings:String = ""
    
    
    @Published var contactOne:String = ""
    @Published var onePhoneNumber:String = ""
    @Published var oneEmail:String = ""
    @Published var contactTwo:String = ""
    @Published var twoPhoneNumber:String = ""
    @Published var twoEmail:String = ""
    
    @Published var startingTime:Double = 0.0
    @Published var hoursLeft:Int = 0
    @Published var minLeft:Int = 0
    @Published var preset = false;
    
    @Published var groupIDs:[String] = []
    @Published var listDispaly:[String] = []
    @Published var altListDisplay:[String] = []
    @Published var hostName:String = ""
    
    @Published var invitationsToHosts:[String:String] = Dictionary<String,String>()
    
    
    //for home screen
    @Published var selectedGroup:String=""
    
    //for new group screen
    @Published var newGroupName:String = ""
    
    @Published var groupUserIDs:[String] = []
    
    @Published var groupUsers:[String] = []
    @Published var checkedInOn:[String] = []
    @Published var pendingUsers:[String] = []
    
    @Published var adminPriv:Bool = false
    
    
    
    
    
    
    init()
    {
        
    }
    
    func update(email:String, password:String)
    {
        self.email = email
        self.password = password
    }
    
    
    func convertGroupIDsToName()
    {
        let db = Firestore.firestore()
        
        for id in groupIDs
        {
            if((id != ""))
            {
                let docRef = db.collection("Groups").document(id)
                
                docRef.getDocument
                    {
                        (snapshot, error) in
                        
                        if let err = error
                        {
                            debugPrint("error fetching data\(err)")
                        }
                        else
                        {
                            let data = snapshot!.data()
                            self.listDispaly.append(data?["groupName"] as! String)
                            
                        }
                        
                    }
            }
            
        }
    }
    
    
    
    
    
}
