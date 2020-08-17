import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth



struct Settings: View {
    
    
    
    @ObservedObject var userStorage = UserStorage()
    
    @ObservedObject var error = CustomError()
    var vc: RevViewController?
    

    
    var body: some View
    {
        ZStack
            {
                
                Color.init("Logo Color")
                    
                    VStack(alignment: .center, spacing: 5)
                    {
                        
                        Spacer().frame(height:8)
                        HStack
                            {
                                Spacer()
                                Text("Settings").font(.system(size: 30))
                                Spacer()
                        }.frame(height: 100)
                        
                        
                        Spacer().frame(height:5)
                        
            
                        
                            
                if(userStorage.preset)
                    
                {
                   
                        
                        Text("Time Period to Check In")
                        
                         Picker(selection: $userStorage.timePeriod, label: Text("").padding(0))
                        {
                            Text("Current = " + userStorage.timePeriod + " Hours ").tag(userStorage.timePeriod)
                            Text("6 Hours").tag("6")
                            Text("12 Hours").tag("12")
                            Text("18 Hours").tag("18")
                            Text("24 Hours").tag("24")
                            Text("48 Hours").tag("48")
                            Text("72 Hours").tag("72")
                            Text("1 Week").tag("168")
                            Text("2 Weeks").tag("336")
                            
                         }.frame(height: 100).padding(EdgeInsets(top: 10, leading: 20, bottom: 50, trailing: 20))
                        
                        
                    
                        
                    
                    
                        Text("Number of Warnings")
                        
                       Picker(selection: $userStorage.numWarnings, label: Text("").padding(0))
                       {
                           Text("Current = " + userStorage.numWarnings + " Hours ").tag(userStorage.numWarnings)
                           Text("1").tag("1")
                           Text("2").tag("2")
                           Text("3").tag("3")
                           Text("4").tag("4")
                          
                           
                           
                       }.frame(height: 100).padding(EdgeInsets(top: 10, leading: 20, bottom: 50, trailing: 20))
                       
                    
                    
                    HStack
                    {
                            Spacer()
                            Button(action:
                               {
                                   self.submitInfo()
                               })
                           {
                               Text("Submit").foregroundColor(Color.white).padding().frame(width: 150)
                           }.background(Color.init("Grayish"))
                            
                            Spacer()
                    }
                    Spacer().frame(height: 20)
                    
                }
                //for group creation
                //////////////////////////////////////////////////////////////////////////////////////
                //////////////////////////////////////////////////////////////////////////////////////
                else
                {
                    
                        Text("Time Period to Check In")
                        Picker(selection: $userStorage.timePeriod, label: Text("").padding(0))
                        {
                            Text("6 Hours").tag("6")
                            Text("12 Hours").tag("12")
                            Text("18 Hours").tag("18")
                            Text("24 Hours").tag("24")
                            Text("48 Hours").tag("48")
                            Text("72 Hours").tag("72")
                            Text("1 Week").tag("168")
                            Text("2 Weeks").tag("336")
                            
                        }.frame(height: 100).padding(EdgeInsets(top: 10, leading: 20, bottom: 50, trailing: 20))
                        
                        
                   
                        Text("Number of Warnings")
                        
                        Picker(selection: $userStorage.numWarnings, label: Text("").padding(0))
                        {
                            Text("1").tag("1")
                            Text("2").tag("2")
                            Text("3").tag("3")
                            Text("4").tag("4")
                            
                            
                        }.frame(height: 100).padding(EdgeInsets(top: 10, leading: 20, bottom: 50, trailing: 20))
                        
                        
                     
                        
                        HStack
                            {
                                Spacer()
                                Button(action:
                                   {
                                       self.submitInfo()
                                   })
                               {
                                   Text("Submit").foregroundColor(Color.white).padding().frame(width: 150)
                               }.background(Color.init("Grayish"))
                                
                                Spacer()
                        }
                        Spacer().frame(height: 20)
                    
                    
                    
                    
                    
                    
                }
                            
                            
                            
                            
                            
                            
                            
                            
                                
                        }
                        
                        
                       
                    
                
                
         }
        
        
    }
    
    func getData() ->(UserStorage)
    {
        return userStorage
    }
    mutating func setVC(vc: RevViewController)
    {
        self.vc = vc
    }
    func submitInfo()
    {
          
           let db = Firestore.firestore()
           
           let uid:String = Auth.auth().currentUser!.uid
           
        
        if(!userStorage.preset)
        {
            if(Utilities.validateNumber(value: userStorage.numWarnings))
            {
                //make sure the two picker options arent empty..if the user did not interact
                //with them then they will be
                
                if(userStorage.timePeriod.isEmpty)
                {
                    userStorage.timePeriod = "6"
                }
                if(userStorage.numWarnings.isEmpty)
                {
                    userStorage.numWarnings = "1"
                }
                
                //addtional screening
                //lets say the user wants 50 notifications for a 6 hour time period with 3 hours between
                
                 
                 db.collection("Groups").document(userStorage.selectedGroup).setData([
                        "numWarnings" : Int(userStorage.numWarnings),
                        "startingTime" : NSDate().timeIntervalSince1970,
                        "timePeriod": Int(userStorage.timePeriod),
                    ], merge: true)
                     { err in
                             if err != nil
                             {
                                 Utilities.showError(error: "Error Connecting to Database", observedObject: self.error)
                             }
                             else
                             {
                                
                                 if !(self.userStorage.preset)
                                 {
                                     self.sendInvitations()
                                     let storyboard = UIStoryboard(name: "GroupsListings", bundle: nil)
                                     let vc = storyboard.instantiateViewController(withIdentifier: "GroupBase1")
                                     vc.isModalInPresentation = true
                                     vc.modalPresentationStyle = .fullScreen
                                     
                                      self.vc!.present(vc, animated: true, completion: nil)
                                 }
                             }
                     }
                
                    
                 
                
            }
            else
            {
                 Utilities.showError(error: "Please Enter a Valid Number", observedObject: error)
            }
        }
        else
        {
           if(Utilities.validateNumber(value: userStorage.numWarnings))
            {
                //make sure the two picker options arent empty..if the user did not interact
                //with them then they will be
                
                if(userStorage.timePeriod.isEmpty)
                {
                    userStorage.timePeriod = "12"
                }
                if(userStorage.timeBetweenWarnings.isEmpty)
                {
                    userStorage.timeBetweenWarnings = "12"
                }
                 
                 db.collection("Groups").document(userStorage.selectedGroup).updateData([
                        "numWarnings" : Int(userStorage.numWarnings),
                        "startingTime" : NSDate().timeIntervalSince1970,
                        "timeBetweenWarnings": Int(userStorage.timeBetweenWarnings),
                        "timePeriod": Int(userStorage.timePeriod)
                    ])
                     { err in
                             if err != nil
                             {
                                 Utilities.showError(error: "Error Connecting to Database", observedObject: self.error)
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
        
        
    }
    
    func sendInvitations()
    {
        let userIDs = userStorage.groupUserIDs
        let db = Firestore.firestore()
        
        let dataToAdd = ["host": userStorage.hostName, "groupName": userStorage.newGroupName]
        
        for s in userIDs
        {
            //prevent sending invitation to the host...that would be annoying
            if(s != Auth.auth().currentUser!.uid)
            {
                db.collection("users").document(s).collection("invitation").document(userStorage.selectedGroup).setData(dataToAdd)
                { err in
                    if err != nil
                    {
                         Utilities.showError(error: "Error Connecting to Database",observedObject: self.error)
                     }
                     
                 }
            }
                
            
        }
        
    }

    
    
    mutating func updateUserStorage(userStorage: UserStorage)
    {
        self.userStorage = userStorage
    }
    
   
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}

