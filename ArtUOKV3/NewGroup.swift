//
//  NewGroup.swift
//  ArtUOKV3
//
//  Created by Sam Rosemore on 6/10/20.
//  Copyright © 2020 Sam Rosemore. All rights reserved.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct NewGroup: View
{
    @ObservedObject var userStorage = UserStorage()
    @ObservedObject var error = Error()
    
    @State var newParticipantEmail:String=""
    @State var userIsCheckedOn:Bool = false
    
    
    
    
    
    var vc:UIViewController?
    
    
    var body: some View
    {
        VStack(alignment: .leading, spacing: 30)
        {
            Spacer()
            
            HStack{
                Spacer()
                Text("New Group")
                Spacer()
            }
            
            
            TextField("New Group", text: $userStorage.newGroupName).padding()
            .background(Color.init("Whiteish"))
            .cornerRadius(4.0)
            .padding(EdgeInsets(top: 0, leading: 10, bottom: 15, trailing: 10))
            
            HStack
            {
                TextField("Email", text: $newParticipantEmail).frame(width: 150).padding(10)
                .background(Color.init("Whiteish"))
                .cornerRadius(4.0)
                .padding(EdgeInsets(top: 10, leading: 10, bottom: 15, trailing: 10))
                
                
                
                Button(action:
                {
                    print(self.newParticipantEmail)
                    let db = Firestore.firestore()
                    db.collection("users").whereField("email", isEqualTo: self.newParticipantEmail).getDocuments()
                        { (querySnapshot, err) in
                            if let err = err {
                                print("Error getting documents: \(err)")
                            } else {
                                print(self.newParticipantEmail)
                                for document in querySnapshot!.documents {
                                    let data = document.data()
                                    
                                    //store fullName to display to user
                                    self.userStorage.listDispaly.append(data["fullName"] as! String)
                                    
                                    //store UID for internal use
                                    self.userStorage.groupUserIDs.append(document.documentID)
                                }
                            }
                        }
                    
                })
                {
                    Text("Add").foregroundColor(Color.white).padding()
                }.background(Color.init("Grayish"))
                
                
                
            }
            
            List(userStorage.listDispaly, id: \.self)
            {
                users in
                
                HStack
                    {
                        Text(users)
                        Toggle(isOn: self.$userIsCheckedOn)
                        {
                            Text("\(self.updateCheckIn(user: users, isCheckedOn:  self.userIsCheckedOn))")
                        }
                        
                        
                        
                        
                    }
                
            }
            
            HStack
            {
                Spacer()
                Button(action: submitData) {
                    Text("Submit").padding().foregroundColor(Color.white)
                }.background(Color.init("Grayish"))
                Spacer()
            }
            
            HStack
            {
                Spacer()
                Text(error.message)
                    .foregroundColor(Color.red)
                
                Spacer()
            }
            
            

            Spacer()
            
        }.background(Color.init("Logo Color"))
        
    }
    func updateCheckIn(user:String, isCheckedOn:Bool) -> String
    {
        if isCheckedOn
        {
            //get index specified user ID
            let index = self.userStorage.listDispaly.firstIndex(of: user)
            let userID = self.userStorage.groupUserIDs[index!]
            
            if !(self.userStorage.checkedInOn.contains(userID))
            {
                userStorage.checkedInOn.append(userID)
            }
        }
        else
        {
            //get index specified user ID
            let index = self.userStorage.listDispaly.firstIndex(of: user)
            let userID = self.userStorage.groupUserIDs[index!]
            
            if(self.userStorage.checkedInOn.contains(userID))
            {
                userStorage.checkedInOn.remove(at: index!)
            }
            
            
            
        }
        
        return ""
    }
    
    func showErrorMessage(message:String)
    {
        self.error.message = message
    }
    func submitData()
    {
        let db = Firestore.firestore()
        
        if(userStorage.newGroupName == "" || userStorage.groupUserIDs.count == 0)
        {
            self.showErrorMessage(message: "Please Fill out all of the fields")
        }
        else
        {
            let dataToAdd = [
                "groupName": userStorage.newGroupName,
                "host": Auth.auth().currentUser!.uid,
                "pendingUsers": Utilities.restringify(array: userStorage.groupUserIDs),
                "checkedInOn": Utilities.restringify(array: userStorage.checkedInOn),
                "users": ""
                ]
            print(userStorage.newGroupName)
            var ref: DocumentReference? = nil
            ref = db.collection("Groups").addDocument(data: dataToAdd)
                { err in
                    if err != nil
                    {
                        self.showErrorMessage(message: "Database Connection Error... Please Check Internet Connection")
                    }
                    else
                    {
                        self.userStorage.selectedGroup = ref!.documentID
                        //make a seperate call to update this users information
                        self.updateUserInformation(id: ref!.documentID)
                    }
                }
        }
        
    }
    func updateUserInformation(id:String)
    {
        let db = Firestore.firestore()
        db.collection("users").document(Auth.auth().currentUser!.uid).getDocument()
        { (snapshot, error) in
            if error != nil
            {
                self.showErrorMessage(message: "error connecting to database")
            }
            else
            {
                let data = snapshot!.data()
                
                //for invitations (in MSettings)
                let fullName:String = data!["fullName"] as! String
                
                var pastGroups:[String] = Utilities.unstringify(value: data!["Groups"] as! String)
                pastGroups.append(id)
                let dataToAdd = ["Groups" : Utilities.restringify(array: pastGroups)]
                
                db.collection("users").document(Auth.auth().currentUser!.uid).updateData(dataToAdd)
                    { err in
                        if let err = err
                        {
                            print("Error writing document: \(err)")
                        }
                        else
                        {
                            let storyboard = UIStoryboard(name: "GroupsListings", bundle: nil)
                            let newVC:RevViewController = storyboard.instantiateViewController(withIdentifier: "MSettings") as! RevViewController
                            newVC.transferData = DataChannel()
                            //newVC.transferData!.groupName = id
                            newVC.transferData!.groupID = id
                            newVC.transferData!.groupName = self.userStorage.newGroupName
                            newVC.transferData!.groupUserIDs = self.userStorage.groupUserIDs
                            newVC.transferData!.hostName = fullName
                            self.vc!.present(newVC, animated: true, completion: nil)
                        }
                    }
            }
        }
    }
    mutating func setVC(vc: UIViewController) 
    {
        self.vc = vc
    }
    
    func getData() -> (UserStorage)
    {
        return userStorage
    }
}

struct NewGroup_Previews: PreviewProvider {
    static var previews: some View {
        NewGroup()
    }
}

