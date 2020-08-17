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
    @ObservedObject var error = CustomError()
    
    var customPopUp:CustomPopUpError = CustomPopUpError(title: "", msg: "", justMsg: true)
    
    
    @State var userIsCheckedOn:Bool = false
    
    @State var showAlert:Bool = false
    
    
    
    var title:String?
    var message:String?
    var justAMessage:Bool?
    
    
    
    
    var vc:RevViewController?
    
    
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
            

            CustomTextField(text: $userStorage.newGroupName, hintText: "New Group",    option: CustomTextField.GENERIC).padding()
            .frame(height: 40)
            .textFieldStyle(RoundedBorderTextFieldStyle())
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.init("Grayish"), lineWidth: 1)).padding(.leading, 15).padding(.trailing, 60)
            
            HStack
            {
                CustomTextField(text: $userStorage.email, hintText: "Email",  option: CustomTextField.USERNAME).padding().frame(width: 150).frame(height: 40)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.init("Grayish"), lineWidth: 1))
                
                
                
                
                Button(action:
                {
                    
                    
                    
                    if(Utilities.validateEmail(testStr: self.userStorage.email.lowercased()))
                    {
                        let db = Firestore.firestore()
                        db.collection("users").whereField("email", isEqualTo: self.userStorage.email.lowercased()).getDocuments()
                            { (querySnapshot, err) in
                                if let err = err {
                                    print("Error getting documents: \(err)")
                                    
                                    
                                } else {
                                    
                                    
                                    
                                    if(querySnapshot!.documents.count == 0)
                                    {
                                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
                                        
                                        
                                        self.customPopUp.title = "Desired User is not registered"
                                        self.customPopUp.msg = "Would you like to invite the  user?"
                                        self.customPopUp.justMsg = false
                                        self.showAlert = true
                                        
                                    }
                                    
                                    for document in querySnapshot!.documents
                                    {
                                        let data = document.data()
                                        
                                        
                                        
                                        let user : User = User(ID: document.documentID, displayName: data["fullName"] as! String, pending: true)
                                       
                                        if(!Utilities.emailIsAlreadyPresent(list: self.userStorage.usersInGroup, u: user))
                                        {
                                            self.userStorage.usersInGroup.append(user)
                                            self.userStorage.listUsersInGroup()
                                        }
                                        else
                                        {
                                            self.customPopUp.title = "User Already Added"
                                            self.customPopUp.msg = "Please Add a diffrent user or click submit to continue creating your group"
                                            self.customPopUp.justMsg = true
                                            self.showAlert = true
                                        }
                                        
                                        
                                        //reset email storage
                                        self.userStorage.email = ""
                                        
                                        
                                        /*
                                        //store fullName to display to user
                                        self.userStorage.listDispaly.append(data["fullName"] as! String)
                                        
                                        //store UID for internal use
                                        
                                        self.userStorage.groupUserIDs.append(document.documentID)
                                        self.userStorage.activateCheckIn[document.documentID] = CheckInStatus(status: false)
                                        */
                                    }
                                }
                        }

                    }
                    else
                    {
                        self.customPopUp.title = "Invalid Email"
                        self.customPopUp.msg = "User attempted to add user through an invalid email. Please make sure the email conforms to  username@example.com"
                        self.customPopUp.justMsg = true
                        self.showAlert = true
                    }
                    
                    
                }) 
                {
                    Text("Add").foregroundColor(Color.white).padding()
                }.background(Color.init("Grayish"))
                
                
                
            }.padding(.leading, 15)
            Text("*select user to require the user to check in").padding(.leading, 15)
            
            
            List(userStorage.usersInGroup, id: \.ID)
            {
                user in
                
                HStack
                    {
                        Text(user.displayName)
                        
                        
                        
                        
                        Toggle(isOn: user.$checkInStatus.isCheckedIn)
                        {
                            Text("")
                        }
                        Button(action:
                        {
                            let index = self.userStorage.usersInGroup.firstIndex(of: user)
                            self.userStorage.usersInGroup.remove(at: index!)
                            
                        })
                        {
                            Image("Delete")
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
            
        }.background(Color.init("Logo Color")).alert(isPresented: self.$showAlert)
            {
                if(customPopUp.justMsg)
                {
                    return Alert(title: Text(customPopUp.title), message: Text(customPopUp.msg), dismissButton: Alert.Button.cancel(Text("Ok")))
                }
                return Alert(title: Text(customPopUp.title), message: Text(customPopUp.msg), primaryButton: Alert.Button.default(Text("Yes"), action:
                    {
                        print("email is being sent to " + self.userStorage.email)
                        //send email invitation to non registered user
                        self.vc!.sendEmail(email: self.userStorage.email)
                        
                        
                        
                    }), secondaryButton: .cancel())
                
                
            }
            
        
    }
    
    
    
    
    func showErrorMessage(message:String)
    {
        self.error.message = message
    }
    func submitData()
    {
        let db = Firestore.firestore()
        
        
        self.userStorage.sortUsers()
        
        //sort data from users in group
        
        if(userStorage.newGroupName == "" || userStorage.usersInGroup.count == 0)
        {
            self.showErrorMessage(message: "Please Fill out all of the fields")
        }
        else
        {
            //remove the current user from pending users
            let index = userStorage.pendingUsers.firstIndex(of: Auth.auth().currentUser!.uid)!
            userStorage.pendingUsers.remove(at: index)
            
            //need a way to tell if group should be default or not
            //if initial bootup
            //or if there is no other group
            let dataToAdd = [
                "groupName": userStorage.newGroupName,
                "startTimer": false,
                "host": Auth.auth().currentUser!.uid,
                "pendingUsers": userStorage.pendingUsers,
                "checkedInOn": userStorage.checkedInOn,
                "users": [String]()
                ] as [String : Any]
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
                
                var pastGroups:[String]?
                if(data!["Groups"] == nil)
                {
                    pastGroups = [String]()
                }
                else
                {
                    pastGroups = (data!["Groups"] as! [String])
                }
                
               
                var dataToAdd:[String:Any]?
                
                //automatically the default group
                if(pastGroups!.count == 0)
                {
                    pastGroups!.append(id)
                    
                    dataToAdd = ["Groups" : pastGroups!,
                                                   "initialBootup": false, "defaultGroup": id]
                }
                else
                {
                    pastGroups!.append(id)
                    
                    dataToAdd = ["Groups" : pastGroups!,
                                     "initialBootup": false]
                }
                
                
                db.collection("users").document(Auth.auth().currentUser!.uid  ).setData(dataToAdd!, merge: true)
                    { err in
                        if let err = err
                        {
                            print("Error writing document: \(err)")
                        }
                        else
                        {
                            let storyboard = UIStoryboard(name: "GroupsListings", bundle: nil)
                            let newVC:RevViewController = storyboard.instantiateViewController(withIdentifier: "MSettings") as! RevViewController
                            newVC.modalPresentationStyle = .fullScreen
                            newVC.isModalInPresentation = true
                            newVC.transferData = DataChannel()
                            //newVC.transferData!.groupName = id
                            newVC.transferData!.groupID = id
                            newVC.transferData!.groupName = self.userStorage.newGroupName
                            
                            self.userStorage.decodeUserList()
                            newVC.transferData!.groupUserIDs = self.userStorage.groupUserIDs
                            
                            
                            newVC.transferData!.hostName = fullName
                            self.vc!.present(newVC, animated: true, completion: nil)
                        }
                    }
            }
        }
    }
    mutating func setVC(vc: RevViewController)
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

