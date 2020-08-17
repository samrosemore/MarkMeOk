//
//  ContentView.swift
//  ArtUOKV2
//
//  Created by Sam Rosemore on 5/13/20.
//  Copyright © 2020 Sam Rosemore. All rights reserved.
//

import SwiftUI

struct ContentView: View
{
    var vc:RevViewController?
    
    
    var body: some View
    {
        VStack(alignment: .center, spacing:50)
        {
            
            Image("MarkMeOkay(logo)01").resizable().scaledToFit()
            
            Spacer()
           
            
            HStack(alignment: .center, spacing: 25)
            {
                Button(action:
                {
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let newVc = storyboard.instantiateViewController(withIdentifier: "Tutorial")
                    
                    self.vc!.present(newVc, animated: true, completion: nil)
                    
                }) {
                    Text("Tutorial").foregroundColor(Color.white).padding(.horizontal, 25).padding()
                }.background(Color.init("Grayish"))
                
                Button(action:
                {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let newVc = storyboard.instantiateViewController(withIdentifier:"SignUp")
                    
                    self.vc!.present(newVc, animated: true, completion: nil)
                }) {
                    Text("Set Up an Account").foregroundColor(Color.white).padding(.horizontal, 25).padding()
                }.background(Color.init("Grayish"))
                
            }
            
            Spacer().frame(height: 50)
            
            
        }.background(Color.init("Logo Color"))
        
        
    }
    mutating func setVC(vc: RevViewController)
    {
        self.vc = vc
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
