//
//  HomeScreen.swift
//  ArtUOKV2
//
//  Created by Sam Rosemore on 5/13/20.
//  Copyright © 2020 Sam Rosemore. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct HomeScreen: View
{
    
    
    @ObservedObject var userStorage = UserStorage()
    
    var body: some View
    {
        
        ZStack
            {
                Color.init("Logo  Color")
                
                VStack(alignment: .center, spacing: 50)
                {
                    Text(String(userStorage.hoursLeft) + ":" + String(userStorage.minLeft))
                        .fontWeight(.bold)
                        .font(.title)
                        .padding(40)
                        .overlay(
                            Circle()
                                .stroke(Color.purple, lineWidth: 5)
                                .frame(width: 100, height: 100, alignment: .center)
                        )
                    
                    Button(action: {
                        
                        print("checkIn")
                        //checkIn
                        
                        //first reset internal storage
                        self.userStorage.startingTime = NSDate().timeIntervalSince1970
                        
                        //update database
                        let db = Firestore.firestore()
                        
                        
                        let ref = db.collection("Groups").document(self.userStorage.selectedGroup)
                        
                        ref.updateData([
                            "startingTime" : NSDate().timeIntervalSince1970
                        ])
                        
                    }) {
                        Text("Check In").foregroundColor(Color.white).padding()
                    }.background(Color.init("Grayish"))
                    
                    Spacer().frame(height: 30)
                    
                    Text("Icons By Icon8").foregroundColor(Color.white).font(.system(size: 14))
                    
                }
                
        }
            
            
        
        
            
            



        
        
    }
    
    func getData() ->(UserStorage)
    {
        return userStorage
    }
    mutating func updateUserStorage(userStorage: UserStorage)
    {
        self.userStorage = userStorage
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
