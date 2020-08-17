//
//  TimerFiles.swift
//  ArtUOKV2
//
//  Created by Sam Rosemore on 5/18/20.
//  Copyright © 2020 Sam Rosemore. All rights reserved.
//

import Foundation
import SwiftUI

class TimerFiles
{
    var userStorage:UserStorage
    
    init(userStorage: UserStorage)
    {
        self.userStorage = userStorage
    }
    
    func startHomeScreenTimer()
    {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) {
                   Timer in
                   
                   let currentTime:Double = NSDate().timeIntervalSince1970
                   let tempTimePeriod = Double(self.userStorage.timePeriod) ?? .nan
                   let temp:Double = self.userStorage.startingTime + (tempTimePeriod * 3600)
                   let numWarnings:Double = Double(self.userStorage.numWarnings) ?? .nan
                   let warningTime:Double = temp - (numWarnings * 3600)
            
            
                   let diff:Double = temp - currentTime
                    
                   self.userStorage.hoursLeft = String(Int((diff / 3600)))
        
                    if(Int((diff / 60)) % 60 < 10)
                    {
                        self.userStorage.minLeft = "0" + String(Int((diff / 60)) % 60)
                    }
                    else
                    {
                        self.userStorage.minLeft = String(Int((diff / 60)) % 60)
                    }
            
            
                    if(diff < 0)
                    {
                        self.userStorage.hoursLeft = "00"
                        self.userStorage.minLeft = "00"
                        self.userStorage.expiredFlag = true
                        print(self.userStorage.endDate)
                    }
                    else if(currentTime >= warningTime)
                    {
                        self.userStorage.warningFlag = true
                    }
                   
                    
                   
               }
    }
    
}
