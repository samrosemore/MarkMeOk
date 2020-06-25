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
                    
                    HStack {
                        Text(invitation)
                        Spacer()
                    }.contentShape(Rectangle()).onTapGesture
                    {
                        self.showAlert = true
                    }.alert(isPresented: self.$showAlert)
                    {
                        Alert(title: Text("\(self.userStorage.invitationsToHosts[invitation]!) group"), message: Text("Are you sure you want to join this group?"),
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
                                            let data = snapshot!.data()
                                            
                                            
                                            var pendingUsers:[String] = Utilities.unstringify(value: data!["pendingUsers"] as! String)
                                            
                                            let pendingIndex = pendingUsers.firstIndex(of: Auth.auth().currentUser!.uid)
                                            
                                            pendingUsers.remove(at: pendingIndex!)
                                            
                                            var currentUsers = Utilities.unstringify(value: data!["users"] as! String)
                                            currentUsers.append(Auth.auth().currentUser!.uid)
                                            
                                            let dataToAdd = ["pendingUsers":Utilities.restringify(array: pendingUsers), "users": Utilities.restringify(array: currentUsers)]
                                            
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
                                         
                                    })
                                    
                                }),
                              
                                secondaryButton: Alert.Button.cancel(Text("No"), action:
                                {
                                    //ignore
                                })
                            )
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
                            let vc = storyboard.instantiateViewController(withIdentifier: "GroupsScreen")
                            
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
}

struct Invitations_Previews: PreviewProvider {
    static var previews: some View {
        Invitations()
    }
}
