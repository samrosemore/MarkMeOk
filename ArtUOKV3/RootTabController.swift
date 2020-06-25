//
//  RootTabController.swift
//  ArtUOKV3
//
//  Created by Sam Rosemore on 6/12/20.
//  Copyright © 2020 Sam Rosemore. All rights reserved.
//

import Foundation
import UIKit

class RootTabController:UIViewController
{
    var groupName:String = ""
    var userStorage:UserStorage = UserStorage()
    var adminPriv:Bool = false;
    
    @IBSegueAction private func loadHome(_ coder: NSCoder) -> RevViewController?
    {
        let rvc:RevViewController = RevViewController(coder: coder)!
        rvc.transferData = DataChannel()
        rvc.transferData!.groupName = self.groupName
        rvc.userStorage = userStorage
    
        return rvc
    }

    @IBSegueAction private func loadSettings(_ coder: NSCoder) -> RevViewController?
    {
          let rvc:RevViewController = RevViewController(coder: coder)!
          rvc.transferData = DataChannel()
          rvc.transferData!.groupName = self.groupName
          rvc.userStorage = userStorage
      
          return rvc
    }
    @IBSegueAction private func loadEMC(_ coder: NSCoder) -> RevViewController?
    {
          let rvc:RevViewController = RevViewController(coder: coder)!
          rvc.transferData = DataChannel()
          rvc.transferData!.groupName = self.groupName
          rvc.userStorage = userStorage
      
          return rvc
    }
}

