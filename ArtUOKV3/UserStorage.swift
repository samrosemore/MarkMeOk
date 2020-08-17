//
//  UserStorage.swift
//  ArtUOKV3
//
//  Created by Sam Rosemore on 5/16/20.
//  Copyright © 2020 Sam Rosemore. All rights reserved.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseAuth


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
    @Published var endDate:String = ""
    @Published var warningFlag:Bool = false
    @Published var expiredFlag:Bool = false
    @Published var hoursLeft:String = ""
    @Published var minLeft:String = ""
    @Published var preset:Bool = false
    
    @Published var groupIDs:[String] = []
    @Published var listDispaly:[String] = []
    @Published var altListDisplay:[String] = []
    @Published var altListDisplay2:[String] = []
    @Published var hostName:String = ""
    
    @Published var invitationsToHosts:[String:String] = Dictionary<String,String>()
    
    
    //for home screen
    @Published var selectedGroup:String=""
    @Published var groupName:String=""
    
    //for new group screen
    @Published var newGroupName:String = ""
    
    @Published var groupUserIDs:[String] = []
    
    @Published var groupUsers:[String] = []
    @Published var checkedInOn:[String] = []
    @Published var pendingUsers:[String] = []
    
    @Published var adminPriv:Bool = false
    
    @Published var counter:Int = 0
    
    
    @Published var textFieldTagNum = 0

    
    @Published var initialBootup: Bool = false
    
    
    //part of my re envisioned way to keep track of in app data
    
    @Published var usersInGroup:[User] = [User]()
    
    @Published var groupIDToName:[String: String] = [String:String]()
    
    
    //for FAQ's
    @Published var faqQuestions:[FCell] = [FCell]()
    
    @Published var startTimer:Bool = true
    
    @Published var groups:[Group] = [Group]()
    @Published var tempGroups:[Group] = [Group]()
    
    @Published var creatingDefaultGroup:Bool = false;
    
    @Published var defaultGroup:Group?
    
    
    
    
    
    init()
    {
        
    }
    
    func listUsersInGroup()
    {
        for user in usersInGroup
        {
            print(user.displayName)
        }
    }
    
    
    
    func sortUsers()
    {
        //results sent into pendingUsers and checked in on
        
        for user in usersInGroup
        {
            self.pendingUsers.append(user.ID)
            
            if(user.checkInStatus.isCheckedIn)
            {
                self.checkedInOn.append(user.ID)
            }
        }
    }
    //migrate data from usersInGroup (which is an array of User Objects)
    //to group user ids (just an array of strings)
    func decodeUserList()
    {
        for user in usersInGroup
        {
            self.groupUserIDs.append(user.ID)
        }
    }
    
    
    func update(email:String, password:String)
    {
        self.email = email
        self.password = password
    }
    
    
    func convertGroupIDsToName()
    {
        let db = Firestore.firestore()
        
       
        
        for curr in tempGroups
        {
            let id = curr.groupID
            
            if((id != ""))
            {
                let docRef = db.collection("Groups").document(id)
                
                
                docRef.getDocument
                    {
                        (snapshot, error) in
                        
                        if let err = error
                        {
                            debugPrint("error fetching data\(err)")
                            //self.updateUserProfile(id: id)
                        }
                        else
                        {
                            
                            let data = snapshot!.data()
                            if(data?.index(forKey: "groupName") != nil)
                            {
                                curr.groupName = (data?["groupName"] as! String)
                                self.groups.append(curr)
  
                            }
                            else
                            {
                                //data was deleted (intentionally I hope) so delete fix...
                                //...this users info
                                self.updateUserProfile(id: id)
                                
                            }
                            
                        }
                        
                        
                    }
            }
            
            
        }
    }
    //for deleting
    func updateUserProfile(id:String)
    {
        let db = Firestore.firestore()
        db.collection("users").document(Auth.auth().currentUser!.uid).getDocument()
        { (snapshot, error) in
            if error != nil
            {
                //self.showErrorMessage(message: "error connecting to database")
            }
            else
            {
                let data = snapshot!.data()
                
                var pastGroups:[String] = (data!["Groups"] as! [String])
                if(pastGroups.contains(id))
                {
                    let index = pastGroups.firstIndex(of: id)
                    pastGroups.remove(at: index!)
                }
                
                let dataToAdd = ["Groups" : pastGroups]
                
                db.collection("users").document(Auth.auth().currentUser!.uid).updateData(dataToAdd)
                    { err in
                        if let err = err
                        {
                            print("Error writing document: \(err)")
                        }
                        else
                        {
                            
                        }
                    }
            }
        }
        
    }
    
    
    
    
    
}
