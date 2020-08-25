//
//  Groups.swift
//  ArtUOKV3
//
//  Created by Sam Rosemore on 6/9/20.
//  Copyright © 2020 Sam Rosemore. All rights reserved.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct Groups: View
{
    @ObservedObject var userStorage = UserStorage()
    //@ObservedObject var converter = Converter(userStorage: userStorage)
    var vc:RevViewController?
    
    @State var showAlert:Bool = false
    
    init()
    {
              
           UITableView.appearance().backgroundColor = UIColor.init(named: "Logo Color")
           UITableViewCell.appearance().backgroundColor = UIColor.init(named: "Logo Color")
           UITableView.appearance().tableFooterView = UIView()
           UITableView.appearance().separatorColor = .black
    }
   
    
    
    var body: some View
    {
        VStack {
            NavigationView
            {
                List()
                {
                    ForEach(userStorage.groups, id: \.groupID)
                    {
                        curr in
                        
                        HStack
                            {
                                HStack
                                {
                                    Text(curr.groupName)
                                    Spacer()
                                }.contentShape(Rectangle()).onTapGesture
                                    {

                                    let storyboard = UIStoryboard(name: "Home", bundle: nil)
                                        
                                    
                                    let vc : RootTabController = (storyboard.instantiateViewController(withIdentifier: "HomeLanding") as? RootTabController)!
                                   
                                        
                                    
                                    
                                    vc.groupName = curr.groupID
                                        
                                    self.vc!.present(vc, animated: true, completion: nil)
                                    
                                }
                                
                                
                                if(curr.defaultStatus.isDefualtGroup)
                                {
                                    Text("Default Group").foregroundColor(Color.white).font(.system(size: 12))
                                }
                                else
                                {
                                    Button(action :
                                    {
                                        print("hello")
                                        let db = Firestore.firestore()
                                        let docRef = db.collection("users").document(Auth.auth().currentUser!.uid)
                                        docRef.updateData(["defaultGroup": curr.groupID])
                                        { err in
                                            if let err = err {
                                                print("Error updating document: \(err)")
                                            } else {
                                                let storyboard = UIStoryboard(name: "GroupsListings", bundle: nil)
                                                let vc = storyboard.instantiateViewController(withIdentifier: "GroupBase1")
                                                vc.isModalInPresentation = true
                                                vc.modalPresentationStyle = .fullScreen
                                                self.vc!.present(vc, animated: true, completion: nil)
                                            }
                                        }
                                        
                                    })
                                    {
                                        Text("Make Default Group").foregroundColor(Color.white).font(.system(size: 10)).padding(10)
                                    }.background(Color.init("Grayish")).cornerRadius(.infinity)
                                }
                                Spacer().frame(width:20)
                                
                                Button(action:
                                {
                                    self.showAlert = true
                                })
                                {
                                    Image("Delete")
                                }.buttonStyle(BorderlessButtonStyle()).alert(isPresented:self.$showAlert)
                                {
                                    Alert(title: Text("Are you sure you want to delete this group?"), message: Text("There is no undo"), primaryButton: .destructive(Text("Delete"))
                                    {
                                            let db = Firestore.firestore()
                                            
                                        db.collection("Groups").document(curr.groupID).delete { (error) in
                                                
                                                if(error != nil)
                                                {
                                                    //show error message
                                                }
                                                else
                                                {
                                                    self.updateUserProfile(id: curr.groupID)
                                                }
                                                
                                            }
                                    }, secondaryButton: .cancel())
                                }
                                
                                
                        }
                        
                        
                    }
                }.navigationBarTitle(Text("Groups"))
                    /*
                    .navigationBarItems(leading:
                        
                        HStack(spacing: 20)
                        {
                            Button(action:
                            {
                                let storyboard = UIStoryboard(name: "GroupsListings", bundle: nil)
                                let vc = storyboard.instantiateViewController(withIdentifier: "NewGroup")
                                self.vc!.present(vc, animated: true, completion:nil)
                                
                            }, label: {
                                Text("Add New Group")
                            })
                            Spacer()
                            
                            Button("Sign Out")
                            {
                  
                                let firebaseAuth = Auth.auth()
                                do {
                                  try firebaseAuth.signOut()
                                    
                                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                    
                                    let newVC =  storyboard.instantiateViewController(withIdentifier: "Login")
                                    newVC.modalPresentationStyle = .fullScreen
                                    newVC.isModalInPresentation = true
                                    self.vc!.present(newVC, animated: true, completion: nil)
                                    print("created new user")
                                    
                                } catch let signOutError as NSError {
                                  print ("Error signing out: %@", signOutError)
                                }
                            }
                            Spacer()
                            
                            Button(action: {
                                let storyboard = UIStoryboard(name: "GroupsListings", bundle: nil)
                                let newVc = storyboard.instantiateViewController(withIdentifier:"Help")
                                
                                self.vc!.present(newVc, animated: true, completion: nil)
                                
                            }) {
                                Image("helpIcon")
                            }
                              
                            
                                
                        })
                        */
                        
                
                
            }
            
           
        }
        
    }
    func addNewGroup()
    {
        print("wow this worked")
    }
    func getData() ->(UserStorage)
    {
         return userStorage
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

struct Groups_Previews: PreviewProvider {
    static var previews: some View {
        Groups()
    }
}

