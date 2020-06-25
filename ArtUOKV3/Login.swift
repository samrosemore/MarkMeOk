//
//  Login.swift
//  ArtUOKV2
//
//  Created by Sam Rosemore on 5/13/20.
//  Copyright © 2020 Sam Rosemore. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct Login: View
{
    @State private var username: String = ""
    @State private var password: String = ""
    
    @ObservedObject var userStorage = UserStorage()
    @ObservedObject var error = Error()
    var vc: RevViewController?
    
    var body: some View {
        VStack(alignment: .center, spacing: 50)
        {
            Spacer()
            
            Text("Login").font(.system(size: 30))
            
            Spacer().frame(height:-10)
            
            HStack(alignment: .center)
                {
                    Spacer()
                    
                    
                    TextField("Email", text: $userStorage.email).padding()
                        .background(Color.init("Whiteish"))
                    .cornerRadius(4.0)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 15, trailing: 0))
                    
                    Spacer()
            }
            HStack(alignment: .center)
                {
                    Spacer()
                    
                    TextField("Password", text: $userStorage.password).padding()
                    .background(Color.init("Whiteish"))
                    .cornerRadius(4.0)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 15, trailing: 0))
                    
                    Spacer()
            }
            
            
            Button(action:
                {
                    self.loginUser()
                })
            {
                Text("Login").foregroundColor(Color.white).padding(.horizontal, 50).padding()
            }.background(Color.init("Grayish"))
            Text(self.error.message).font(.system(size: 16)).foregroundColor(Color.red)
            
            Spacer()
        }.background(Color.init("Logo Color"))
    }
    
    mutating func setVC(vc: RevViewController)
    {
        self.vc = vc
    }
    
    func getData() -> (UserStorage)
    {
        return userStorage
    }
    func loginUser()
    {
        
        Auth.auth().signIn(withEmail: userStorage.email, password: userStorage.password)
        {
            (result, error) in
            
            if error != nil
            {
                Utilities.showError(error: "wrong username/password combination", observedObject: self.error)
            }
            else
            {
                
                let storyboard = UIStoryboard(name: "GroupsListings", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "GroupsScreen")
                
                self.vc!.present(vc, animated: true, completion: nil)
                
                //register device for notifications
                InstanceID.instanceID().instanceID(handler: {
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
            }
        }
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}
