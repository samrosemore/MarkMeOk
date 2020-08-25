//
//  Login.swift
//  ArtUOKV2
//
//  Created by Sam Rosemore on 5/13/20.
//  Copyright © 2020 Sam Rosemore. All rights reserved.
//

import UIKit
import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseInstanceID
import FirebaseFirestore
import GoogleSignIn
import AuthenticationServices
 
struct Login: View
{
    @State private var username: String = ""
    @State private var password: String = ""
    
    @ObservedObject var userStorage = UserStorage()
    @ObservedObject var error = CustomError()
    
    @State var focus:[Bool] = [false, false]
    
    var vc: RevViewController?
    
    var body: some View {
        VStack(alignment: .center, spacing: 30)
        {
            Spacer().frame(height:20)
             
             Image("MarkMeOkay(logo)01").resizable().scaledToFit()
            
            
            HStack(alignment: .center)
                {
                    Spacer().frame(width: 30)
                    
                    VStack(alignment: .center, spacing: 30)
                    {
                        CustomTextField(text: $userStorage.email, hintText: "Email", option: CustomTextField.USERNAME, tag: 0, focus: $focus).padding()
                        .frame(height: 40)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.init("Grayish"), lineWidth: 1)).tag(0)
                        CustomTextField(text: $userStorage.password, hintText:    "Password", option: CustomTextField.PASSWORD, tag: 1, focus: $focus)
                        .padding()
                        .frame(height: 40)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.init("Grayish"), lineWidth: 1)).tag(1)
                    }
                    
                    
                        
                    /*
                    ZStack(alignment: .leading)
                    {
                        TextField("", text: $userStorage.email).padding()
                            .foregroundColor(.black)
                        .background(Color.init("Whiteish"))
                        .cornerRadius(4.0)
                        .padding(EdgeInsets(top: 0, leading: 10, bottom: 15, trailing: 10))
                        .onTapGesture
                        {
                            if self.userStorage.email.isEmpty
                            {
                                self.userStorage.email = " "
                            }
                            
                        }
                        if(userStorage.email.isEmpty)
                        {
                            Text("Email").padding().foregroundColor(.black).background(Color.init("Whiteish"))
                            .cornerRadius(4.0)
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 15, trailing: 40))
                            .onTapGesture
                            {
                                if self.userStorage.email.isEmpty
                                {
                                    self.userStorage.email = " "
                                }
                                
                            }
                        }
                    }
                    */
                    
                    Spacer().frame(width:30)
                }
            
            Button(action:
                {
                    self.loginUser()
                })
            {
                Text("Login").font(.system(size: 18)).foregroundColor(Color.white).padding(EdgeInsets(top: 20, leading: 50, bottom: 20, trailing: 50)).frame(width: 200).frame(height: 50)
                
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
            SignInWithApple().padding(EdgeInsets(top: 20, leading: 50, bottom: 20, trailing: 50)).frame(width: 200).frame(height:50).onTapGesture
            {
                self.vc!.startSignInWithAppleFlow()
            }
            
            
            
            HStack(alignment: .center, spacing: 20)
            {
                Button(action:
                {
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let newVC = storyBoard.instantiateViewController(identifier: "SignUp")
                    self.vc!.present(newVC, animated: true, completion: nil)
                    
                })
                {
                    Text("Sign Up?").foregroundColor(Color.blue).padding(10)
                }
                
                Button(action:
                {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let newVc = storyboard.instantiateViewController(withIdentifier:"resetPassword")
                    
                    self.vc!.present(newVc, animated: true, completion: nil)
                }) {
                    Text("Reset Password?").foregroundColor(Color.blue).padding(10)
                }
                
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
            
            
            
            
        
            Text(self.error.message).font(.system(size: 20)).foregroundColor(Color.red)
            
            
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
        
        userStorage.email = userStorage.email.lowercased()
        Auth.auth().signIn(withEmail: userStorage.email.trimmingCharacters(in: .whitespacesAndNewlines), password: userStorage.password.trimmingCharacters(in: .whitespacesAndNewlines))
        {
            (result, error) in
            
            if error != nil
            {
                Utilities.showError(error: "wrong username/password combination", observedObject: self.error)
            }
            else
            {
                
                let storyboard = UIStoryboard(name: "GroupsListings", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "GroupBase1")
                vc.isModalInPresentation = true
                vc.modalPresentationStyle = .fullScreen
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

// 1
final class SignInWithApple: UIViewRepresentable {
    
    
  // 2
  func makeUIView(context: Context) -> ASAuthorizationAppleIDButton
  {
    // 3
    return ASAuthorizationAppleIDButton()
  }
  
  // 4
  func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context)
  {
    
  }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}
