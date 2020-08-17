//
//  Disclamer.swift
//  ArtUOKV3
//
//  Created by Sam Rosemore on 7/22/20.
//  Copyright © 2020 Sam Rosemore. All rights reserved.
//

import SwiftUI
import UIKit

struct Disclamer: View
{
    @State var text:String = ""
    
    var vc:RevViewController?
    
    var body: some View {
        VStack(alignment: .center, spacing: 20)
        {
            Spacer()
            Text("Legal Disclamer")
            
            Spacer()
            
            Button(action:
            {
                    let url = URL(string: "https://www.google.com/")
                           
                    UIApplication.shared.open(url!) { (result) in
                        if result
                        {
                           // The URL was delivered successfully!
                        }
                    }
            })
            {
                Text("View Disclamer Here").font(.system(size: 14)).foregroundColor(.blue)
                
            }
            
            Spacer().frame(height:30)
            
        
            
            HStack
            {
                TextField("*Please Sign Here", text: $text).padding().frame(width: 200)
                
                Button(action:
                {
                    if(self.text != "")
                    {
                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        let newVC = storyBoard.instantiateViewController(identifier: "SignUp")
                        self.vc!.present(newVC, animated: true, completion: nil)
                    }
                    
                }){
                    Text("Continue").padding().foregroundColor(Color.black)
                }.background(Color.init("Grayish"))
            }
            Text("*Signing Your Name Legally Binds You To the Disclamer Stated Above")
        
            Spacer().frame(height: 10)
        }
        
    }
    
    mutating func setVC(vc:RevViewController)
    {
        self.vc = vc
    }
}

struct Disclamer_Previews: PreviewProvider {
    static var previews: some View {
        Disclamer()
    }
}
