import SwiftUI
import Firebase



struct Settings: View {
    
    
    
    @ObservedObject var userStorage = UserStorage()
    
    @ObservedObject var error = Error()
    var vc: RevViewController?
    

    
    var body: some View
    {
                          
        ZStack
            {
                
                Color.init("Logo Color")
                    
                    VStack(alignment: .center, spacing: 5)
                    {
                        

                        HStack
                            {
                                Spacer()
                                Text("Settings").font(.system(size: 30))
                                Spacer()
                        }.frame(height: 100)
                        
                        
                        Spacer().frame(height:30)
                        
                        //for when the user is already logged in
                        Text("Time Period to Check In")
                        if(userStorage.preset)
                        {
                            Picker(selection: $userStorage.timePeriod, label: Text("").padding(0))
                           {
                               Text("Defualt = " + userStorage.timePeriod + " Hours ").tag(userStorage.timePeriod)
                               Text("12 Hours").tag("12")
                               Text("18 Hours").tag("18")
                               Text("24 Hours").tag("24")
                               Text("48 Hours").tag("48")
                               Text("72 Hours").tag("72")
                               
                            }.frame(width: 200, height:100)
                                .clipped().padding(.bottom, 20)
                            
                            
                           Text("Time Period to Check In")
                           TextField("Number of Warnings", text: $userStorage.numWarnings).padding()
                            .background(Color.init("Whiteish"))
                            .cornerRadius(4.0).padding(.trailing, 40).padding(EdgeInsets(top: 0, leading: 10, bottom: 15, trailing: 10))
                            
                           
                           
                           
                           Text("Time Between the Warnings")
    
                           Picker(selection: $userStorage.timeBetweenWarnings, label: Text("").padding(0))
                           {
                               Text("Defualt = " + userStorage.timeBetweenWarnings + " Hours ").tag(userStorage.timeBetweenWarnings)
                               Text("1 Hours").tag("1")
                               Text("2 Hours").tag("2")
                               Text("3 Hours").tag("3")
                               Text("4 Hours").tag("4")
                               
                               
                           }.frame(width: 200, height:100)
                           .clipped()
                        }
                        //for initial sign up
                        else
                        {
                            Picker(selection: $userStorage.timePeriod, label: Text("").padding(0))
                            {
                                Text("12 Hours").tag("12")
                                Text("18 Hours").tag("18")
                                Text("24 Hours").tag("24")
                                Text("48 Hours").tag("48")
                                Text("72 Hours").tag("72")
                                
                            }.frame(width: 200, height:100)
                            .clipped().padding(.bottom, 20)
                            
                            TextField("Number of Warnings", text: $userStorage.numWarnings).padding()
                            .background(Color.init("Whiteish"))
                            .cornerRadius(4.0).padding(EdgeInsets(top: 0, leading: 20, bottom: 15, trailing: 20))
                            
                            
                            Text("Time Between the Warnings")
                            
                            Picker(selection: $userStorage.timeBetweenWarnings, label: Text("").padding(0))
                            {
                                Text("1 Hours").tag("1")
                                Text("2 Hours").tag("2")
                                Text("3 Hours").tag("3")
                                Text("4 Hours").tag("4")
                                
                            }.frame(width: 200, height:100)
                            .clipped()
                            
                        }
                        
                        Spacer().frame(height: 40)
                        
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
                        HStack
                        {
                                Spacer()
                                Text(self.error.message).font(.system(size: 16)).foregroundColor(Color.red)
                                Spacer()
                                
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
           
        
        if(userStorage.adminPriv || !userStorage.preset)
        {
            if(Utilities.validateNumber(value: userStorage.numWarnings))
            {
                 
                 db.collection("Groups").document(userStorage.selectedGroup).setData([
                        "numWarnings" : Int(userStorage.numWarnings),
                        "startingTime" : NSDate().timeIntervalSince1970,
                        "timeBetweenWarnings": Int(userStorage.timeBetweenWarnings),
                        "timePeriod": Int(userStorage.timePeriod)
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
                                     let vc = storyboard.instantiateViewController(withIdentifier: "GroupsScreen")
                                     
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
        
        
    }
    
    func sendInvitations()
    {
        let userIDs = userStorage.groupUserIDs
        let db = Firestore.firestore()
        
        let dataToAdd = ["host": userStorage.hostName, "groupName": userStorage.newGroupName]
        
        for var s in userIDs
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

