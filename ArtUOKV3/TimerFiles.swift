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
                    
                   let diff:Double = temp - currentTime
                   
                    let hours = ceil(diff / 3600)
                    
                    let minutes = Int(round(diff / 60)) % 60
                    
                   self.userStorage.hoursLeft = Int((diff / 3600))
                   self.userStorage.minLeft = Int((diff / 60)) % 60
                   
               }
    }
    
}
