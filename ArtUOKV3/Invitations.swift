//
//  Invitations.swift
//  ArtUOKV3
//
//  Created by Sam Rosemore on 6/9/20.
//  Copyright © 2020 Sam Rosemore. All rights reserved.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct Invitations: View
{
    @ObservedObject var userStorage = UserStorage()
    
    @State var showAlert:Bool = false
    @State var success:Bool = false
    
    var customPopUp:CustomPopUpError = CustomPopUpError(title: "", msg:  "", justMsg: true)
    
    var vc:RevViewController?
    
    init()
       {
            UITableView.appearance().backgroundColor = UIColor.init(named: "Logo Color")
            UITableViewCell.appearance().backgroundColor = UIColor.init(named: "Logo Color")
            UITableView.appearance().tableFooterView = UIView()
            UITableView.appearance().separatorColor = .black
        }
    
    
    var body: some View
    {
        NavigationView
        {
            List()
            {
                ForEach(userStorage.listDispaly, id: \.self)
                {invitation in
                    
                    
                HStack
                    {
                        HStack {
                            Text(invitation)
                            Spacer()
                              
                        }.contentShape(Rectangle()).onTapGesture
                        {
                            self.customPopUp.title = self.userStorage.invitationsToHosts[invitation] ?? ""
                            self.customPopUp.msg = "Are you sure you want to join this group?"
                            self.customPopUp.justMsg = false
                            self.showAlert = true
                            
                        }.alert(isPresented: self.$showAlert)
                        {
                            if(!self.customPopUp.justMsg)
                            {
                                return Alert(title: Text(self.customPopUp.title), message: Text(self.customPopUp.msg),
                                  primaryButton: Alert.Button.default(Text("Yes"), action:
                                    {
                                        let index = self.userStorage.listDispaly.firstIndex(of: invitation)
                                        let groupId = self.userStorage.groupIDs[index!]
                                        //update group profile
                                        let db = Firestore.firestore()
                                        
                                        db.collection("Groups").document(groupId).getDocument(completion: {
                                            (snapshot, error) in
                                            
                                            if let err = error
                                            {
                                                debugPrint("error fetching data\(err)")
                                            }
                                            else
                                            {
                                                if((snapshot?.exists) != nil)
                                                {
                                                    let data = snapshot!.data()
                                                    
                                                    if(data?["pendingUsers"] != nil)
                                                    {
                                                        var pendingUsers:[String] =  (data!["pendingUsers"] as! [String])
                                                        
                                                        let pendingIndex = pendingUsers.firstIndex(of: Auth.auth().currentUser!.uid)
                                                        
                                                        pendingUsers.remove(at: pendingIndex!)
                                                        
                                                        var currentUsers = (data!["users"] as! [String])
                                                        currentUsers.append(Auth.auth().currentUser!.uid)
                                                        
                                                        let dataToAdd:[String : Any] = ["pendingUsers": pendingUsers, "users":  currentUsers, "startTimer": true]
                                                        
                                                        db.collection("Groups").document(groupId).updateData(dataToAdd) { err in
                                                            if let err = err {
                                                                print("Error writing document: \(err)")
                                                            } else {
                                                                //update user profile
                                                                self.updateUserProfile(id:
                                                                    groupId)
                                                            }
                                                        }
                                                    }
                                                    else
                                                    {
                                                        //delete it from local storage
                                                        let index = self.userStorage.listDispaly.firstIndex(of: invitation)
                                                        self.userStorage.listDispaly.remove(at: index!)
                                                         self.userStorage.groupIDs.remove(at: index!)
                                                        
                                                        //delete it from firebase
                                                        self.deleteInvitation(groupId: groupId, dontUpdateGroup: true)
                                                        self.customPopUp.title = "Group Data Deleted By Host"
                                                        self.customPopUp.msg = "You will not see this paticular group invitation again"
                                                        self.customPopUp.justMsg = true
                                                        self.showAlert = true
                                                    }
                                                }
                                                else
                                                {
                                                    //delete it from local storage
                                                    let index = self.userStorage.listDispaly.firstIndex(of: invitation)
                                                    self.userStorage.listDispaly.remove(at: index!)
                                                     self.userStorage.groupIDs.remove(at: index!)
                                                    
                                                    //delete it from firebase
                                                    self.deleteInvitation(groupId: groupId, dontUpdateGroup: true)
                                                    self.customPopUp.title = "Group Data Deleted By Host"
                                                    self.customPopUp.msg = "You will not see this paticular group invitation again"
                                                    self.customPopUp.justMsg = true
                                                    self.showAlert = true
                                                }
                                            }
                                             
                                        })
                                        
                                    }),
                                  
                                    secondaryButton: Alert.Button.cancel(Text("No"), action:
                                    {
                                        //ignore
                                    })
                                )
                            }
                            else
                            {
                                return Alert(title: Text(self.customPopUp.title), message: Text(self.customPopUp.msg), dismissButton: Alert.Button.cancel(Text("Ok")))
                            }
                            
                        }
                        Button(action:
                        {
                            let index = self.userStorage.listDispaly.firstIndex(of: invitation)
                            let groupId = self.userStorage.groupIDs[index!]
                            self.userStorage.listDispaly.remove(at: index!)
                            self.userStorage.groupIDs.remove(at: index!)
                            self.deleteInvitation(groupId: groupId, dontUpdateGroup: false)
                            
                        })
                        {
                            Image("Delete")
                        }
                    }
                    
                }
            }.navigationBarTitle(Text("Invitations"))
            
        }
        
    } 
    mutating func setVC(vc:RevViewController)
    {
        self.vc = vc
    }
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
                
                var pastGroups:[String]?
                if(data!["Groups"] == nil)
                {
                    pastGroups = [String]()
                }
                else
                {
                    pastGroups = (data!["Groups"] as! [String])
                }
            
                pastGroups!.append(id)
                let dataToAdd = ["Groups" : pastGroups!]
                
                db.collection("users").document(Auth.auth().currentUser!.uid).updateData(dataToAdd)
                    { err in
                        if let err = err
                        {
                            print("Error writing document: \(err)")
                        }
                        else
                        {
                            let storyboard = UIStoryboard(name: "GroupsListings", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "GroupBase1")
                            
                            vc.isModalInPresentation = true
                            vc.modalPresentationStyle = .fullScreen
                            
                            self.vc!.present(vc, animated: true, completion: nil)
                        }
                    }
            }
        }
        db.collection("users").document(Auth.auth().currentUser!.uid).collection("invitation").document(id).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    func getData() -> (UserStorage)
    {
        return userStorage
    }
    func deleteInvitation(groupId: String, dontUpdateGroup: Bool)
    {
        
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(Auth.auth().currentUser!.uid).collection("invitation").document(groupId)
        docRef.delete()
        
        if(!dontUpdateGroup)
        {
            db.collection("Groups").document(groupId).getDocument(completion:
            {
                (snapshot, error) in
                
                if let err = error
                {
                    debugPrint("error fetching data\(err)")
                }
                else
                {
                    let data = snapshot!.data()
                    
                    if(data != nil && data!["pendingUsers"] != nil)
                    {
                        var pendingUsers:[String] =  (data!["pendingUsers"] as! [String])
                        
                        let pendingIndex = pendingUsers.firstIndex(of: Auth.auth().currentUser!.uid)
                        
                        pendingUsers.remove(at: pendingIndex!)
                        
                        
                        
                        let dataToAdd:[String : Any] = ["pendingUsers": pendingUsers]
                        
                        db.collection("Groups").document(groupId).updateData(dataToAdd)
                    }
                    
                     
                }
                 
            })
        }
    }
}

struct Invitations_Previews: PreviewProvider {
    static var previews: some View {
        Invitations()
    }
}
