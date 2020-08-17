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
import FirebaseFirestore

struct HomeScreen: View
{
    
    
    @ObservedObject var userStorage = UserStorage()
    
    var body: some View
    {
        
        ZStack
            {
                
                Color.init("Logo Color")
                
                
                VStack(alignment: .center, spacing: 50)
                {
                    Spacer()
                    
                    //display group name
                    Text(userStorage.groupName).bold().font(.system(size: 28)).foregroundColor(Color.black)
                    
                    if(!self.userStorage.startTimer)
                    {
                        Text("Timer Will Start When More Than One User Joins")
                            .multilineTextAlignment(.center)
                           .font(.system(size: 18))
                           .foregroundColor(Color.black)
                           .padding(40).background(Circle().fill(Color.init("Grayish")).frame(width: 160))
                    }
                        
                    else if(self.userStorage.expiredFlag)
                    {
                        Text(String(userStorage.hoursLeft) + ":" + String(userStorage.minLeft))
                        .fontWeight(.bold)
                        .font(.title)
                        .font(.system(size: 40))
                        .foregroundColor(Color.red)
                        .padding(80).background(Circle().fill(Color.init("Grayish")).frame(width: 160, height: 160))
                        
                        Text("the timer has expired at " + String(userStorage.endDate)).font(.system(size: 14)).foregroundColor(Color.black)
                        
                    }
                    else if(self.userStorage.warningFlag)
                    {
                        Text(String(userStorage.hoursLeft) + ":" + String(userStorage.minLeft))
                        .fontWeight(.bold)
                        .font(.title)
                        .font(.system(size: 40))
                        .foregroundColor(Color.orange)
                        .padding(80).background(Circle().fill(Color.init("Grayish")).frame(width: 160, height: 160))
                    }
                    else
                    {
                        Text(String(userStorage.hoursLeft) + ":" + String(userStorage.minLeft))
                        .fontWeight(.bold)
                        .font(.title)
                        .font(.system(size: 40))
                        .foregroundColor(Color.init("DarkText"))
                        .padding(80).background(Circle().fill(Color.init("Grayish")).frame(width: 160, height: 160))
                    }
                    
                    
                        
                        Spacer()
                    
                            Button(action:
                        {
                            
                            print("checkIn")
                            //checkIn
                            
                            //first reset internal storage
                            self.userStorage.startingTime = NSDate().timeIntervalSince1970
                            self.userStorage.expiredFlag = false
                            self.userStorage.warningFlag = false
                            //update database
                            let db = Firestore.firestore()
                            
                            
                            let ref = db.collection("Groups").document(self.userStorage.selectedGroup)
                            
                            ref.updateData([
                                "startingTime" : NSDate().timeIntervalSince1970
                            ])
                            
                        })
                        {
                            Text("Check In").foregroundColor(Color.white)
                        }.padding(EdgeInsets(top: 15, leading: 40, bottom: 15, trailing: 40)).background(Color.init("Grayish"))
                            
                            Spacer().frame(height: 30)
                    
                    
                    
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
