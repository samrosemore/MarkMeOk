//
//  ResetPassword.swift
//  ArtUOKV3
//
//  Created by Sam Rosemore on 7/22/20.
//  Copyright © 2020 Sam Rosemore. All rights reserved.
//

import SwiftUI
import FirebaseAuth

struct ResetPassword: View
{
    @State var email:String = "";
    @ObservedObject var error:CustomError = CustomError()
    var vc:RevViewController?
    
    var body: some View
    {
        VStack(alignment: .center, spacing: 20)
        {
            Spacer()
            Text("Reset Your Password").font(.system(size: 24))
            Spacer().frame(height:20)
            CustomTextField(text: $email, hintText: "Email", option: CustomTextField.USERNAME).frame(height: 60)
            .foregroundColor(.black)
            .background(Color.init("Whiteish"))
            .cornerRadius(4.0)
            .padding(EdgeInsets(top: 0, leading: 10, bottom: 15, trailing: 10)).tag(0)
            
            Button(action: {
                Auth.auth().sendPasswordReset(withEmail: self.email) { error in
                    if error == nil
                    {
                        //send user back to login screen
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let newVC = storyboard.instantiateViewController(withIdentifier: "Login")
                        newVC.isModalInPresentation = true
                        newVC.modalPresentationStyle = .fullScreen
                        self.vc!.present(newVC, animated: true, completion: nil)
                    }
                    else {
                        //show alert message
                        self.error.message = "error sending email....please try again and check for typos"
                    }
                }
            }) {
                  Text("Login").foregroundColor(Color.white).padding(.horizontal, 50).padding()
                
            }.background(Color.init("Grayish"))
            
            Text(self.error.message).font(.system(size: 22)).foregroundColor(Color.red)
            
            Spacer()
        }.background(Color.init("Logo Color"))
        
    }
    mutating func setVC(vc:RevViewController)
    {
        self.vc = vc
    }
}


struct ResetPassword_Previews: PreviewProvider {
    static var previews: some View {
        ResetPassword()
    }
}
