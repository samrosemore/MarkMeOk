//
//  SignUp.swift
//  ArtUOKV2
//
//  Created by Sam Rosemore on 7/22/20.
//  Copyright © 2020 Sam Rosemore. All rights reserved.
//

import SwiftUI
import FirebaseAuth
import Firebase
import FirebaseFirestore



struct SignUp: View
{
    
    
    @ObservedObject var userStorage = UserStorage()
    
    @ObservedObject var error = CustomError()
    var vc: RevViewController?
    
    
    var body: some View {
        VStack(alignment: .center, spacing: 30)
        {
             
            Spacer()
            
            Text("Sign Up").font(.system(size: 30))
            
            Spacer().frame(height:40)
            
            HStack{
                Spacer().frame(width: 30)
                VStack(alignment: .center, spacing: 30)
                {
                    CustomTextField(text: $userStorage.fullName, hintText: "Full Name", option: CustomTextField.GENERIC)
                    .padding()
                    
                    .frame(height: 40)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.init("Grayish"), lineWidth: 1))
                    
                    CustomTextField(text: $userStorage.email, hintText: "Email", option: CustomTextField.USERNAME).padding()
                    .frame(height: 40)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.init("Grayish"), lineWidth: 1))
                    
                    
                    
                    CustomTextField(text: $userStorage.password, hintText: "Password", option: CustomTextField.NEW_PASSWORD).padding()
                    
                    .frame(height: 40)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.init("Grayish"), lineWidth: 1))
                }
                Spacer().frame(width:30)
            }
            
            Button(action:
                {
                    self.signUpUser()
                })
            {
                Text("Sign Up").font(.system(size: 18)).foregroundColor(Color.white).padding(EdgeInsets(top: 20, leading: 50, bottom: 20, trailing: 50)).frame(width: 200).frame(height: 50)
            }.background(Color.init("Grayish"))
            
            Button(action: {
                self.vc!.attemptGoogleLogin()
            })
            {
                HStack
                {
                    Image("google")
                    Text("Sign In").font(.system(size: 18)).foregroundColor(Color.init("DarkGrayish"))
                    
                }.padding(EdgeInsets(top: 20, leading: 50, bottom: 20, trailing: 50)).frame(width: 200).frame(height:50).background(Color.white)
                
            }
            
            VStack(alignment:.center)
            {
                Text("By Signing Up/Logging in you agree to ").foregroundColor(Color.black).font(.system(size: 12))
                HStack(alignment: .firstTextBaseline, spacing: 0)
                {
                    
                    
                    Button(action:
                    {
                        let link = URL(string: "https://www.google.com/")!
                        UIApplication.shared.open(link)
                    })
                    {
                        Text("the Terms of Conditions ").foregroundColor(Color.black).font(.system(size: 12)).underline()
                    }
                    Text("and the ").foregroundColor(Color.black).font(.system(size: 12))
                    
                    Button(action: {
                        let link = URL(string: "https://www.google.com/")!
                        UIApplication.shared.open(link)
                        
                    })
                    {
                        Text("Privacy Policy").foregroundColor(Color.black).font(.system(size: 12)).underline()
                    }
                }
            }
             
            
            Text(self.error.message).font(.system(size: 16)).foregroundColor(Color.red)
            
            Spacer()
            
        }.background(Color.init("Logo Color"))
        

        
    }
    
    func signUpUser()
    {
        userStorage.email = userStorage.email.trimmingCharacters(in: .whitespacesAndNewlines)
        userStorage.email = userStorage.email.lowercased()
        userStorage.password = userStorage.password.trimmingCharacters(in: .whitespacesAndNewlines)
        userStorage.fullName = userStorage.fullName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        
        
               
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
                           let db = FirebaseFirestore.Firestore.firestore();
                            
                            //now store the extra user info
                            db.collection("users").document(Auth.auth().currentUser!.uid).setData(["fullName": self.userStorage.fullName, "email": self.userStorage.email, "Groups": [String](), "initialBootup": true])
                                { err in
                                    if let err = err
                                    {
                                        print("Error writing document: \(err)")
                                    } else {
                                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                        let newVC = storyboard.instantiateViewController(withIdentifier: "Login")
                                        newVC.isModalInPresentation = true
                                        newVC.modalPresentationStyle = .fullScreen
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
