//
//  SignUp.swift
//  ArtUOKV2
//
//  Created by Sam Rosemore on 5/13/20.
//  Copyright © 2020 Justin Rosemore. All rights reserved.
//

import SwiftUI
import FirebaseAuth
import Firebase



struct SignUp: View
{
    
    
    @ObservedObject var userStorage = UserStorage()
    
    @ObservedObject var error = Error()
    var vc: RevViewController?
    
    
    var body: some View {
        VStack(alignment: .center, spacing: 30)
        {
             
            Spacer().frame(height: 10)
            
            Text("Sign Up").font(.system(size: 30))
            
            
            TextField("John Doe", text: $userStorage.fullName).padding()
                .background(Color.init("Whiteish"))
            .cornerRadius(4.0)
            .padding(EdgeInsets(top: 0, leading: 10, bottom: 15, trailing: 10))
            
            TextField("johnDoe@gmail.com", text: $userStorage.email).padding()
            .background(Color.init("Whiteish"))
            .cornerRadius(4.0)
            .padding(EdgeInsets(top: 0, leading: 10, bottom: 15, trailing: 10))
            
            TextField("joDoe", text: $userStorage.username).padding()
            .background(Color.init("Whiteish"))
            .cornerRadius(4.0)
            .padding(EdgeInsets(top: 0, leading: 10, bottom: 15, trailing: 10))
            
            TextField("1234", text: $userStorage.password).padding()
            .background(Color.init("Whiteish"))
            .cornerRadius(4.0)
            .padding(EdgeInsets(top: 0, leading: 10, bottom: 15, trailing: 10))
              
            
            
            
            
                
            Spacer()
            
            
            
            Button(action:
                {
                    self.signUpUser()
                })
            {
                Text("Sign Up").foregroundColor(Color.white).padding()
            }.background(Color.init("Grayish"))
             
            
            Text(self.error.message).font(.system(size: 16)).foregroundColor(Color.red)
            
            Spacer()
            
        }.background(Color.init("Logo Color"))
        

        
    }
    
    func signUpUser()
    {
        
               
        if(Utilities.validateEmail(testStr: userStorage.email))
               {
                if(Utilities.validatePassword(value: userStorage.password))
                   {
                    Auth.auth().createUser(withEmail: userStorage.email, password: userStorage.password) {(result, error) in
                       
                           if error != nil
                           {
                               print(error!)
                               print("error creating user")
                               
                                Utilities.showError(error: "username is already taken",  observedObject: self.error)
                           }
                           else
                           {
                            let db = Firestore.firestore()
                            //now store the extra user info
                            db.collection("users").document(Auth.auth().currentUser!.uid).setData(["fullName": self.userStorage.fullName, "email": self.userStorage.email, "Groups": ""])
                                { err in
                                    if let err = err
                                    {
                                        print("Error writing document: \(err)")
                                    } else {
                                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                        let newVC = storyboard.instantiateViewController(withIdentifier: "Login")
                                        
                                        self.vc!.present(newVC, animated: true, completion: nil)
                                        print("created new user")
                                    }
                                }
                            
                             
                            
                           }
                       
                       }
                   }
                   else
                   {
                    Utilities.showError(error: "password must be > 6 characters", observedObject: error)
                   }
                   
               }
               else
               {
                Utilities.showError(error: "please enter a valid email", observedObject: self.error)
               }
       
    }
    
    func getData() -> (UserStorage)
    {
        return self.userStorage
    }
    mutating func setVC(vc:RevViewController)
    {
        self.vc = vc
    }
    
}



struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        SignUp()
    }
}
