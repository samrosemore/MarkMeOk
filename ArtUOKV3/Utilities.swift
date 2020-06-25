//
//  Utilities.swift
//  ArtUOKV3
//
//  Created by Sam Rosemore on 5/24/20.
//  Copyright © 2020 Sam Rosemore. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI
import FirebaseFirestore

class Utilities
{
    class func showError(error: String, errorLbl: UILabel)
    {
        errorLbl.alpha = 1
        errorLbl.text = error
        
    }

    class func showError(error: String, observedObject: Error)
    {
        observedObject.message = error
    }

    class func validateEmail(testStr: String) -> Bool
    {
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            let result = emailTest.evaluate(with: testStr)
            return result
        
    }

    class func validatePhoneNumber(value: String) ->Bool
    {
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        if phoneTest.evaluate(with: value)
            {
                 return (true)
            }
              
            return false
    }
    //000-000-0000
    class func parsePhoneNumber(strPhone: String) -> Int
    {
        let index0 = strPhone.index(strPhone.startIndex, offsetBy: 3)
        let substring0 = String(strPhone[..<index0])
        
        let start = strPhone.index(strPhone.startIndex, offsetBy: 4)
        let end = strPhone.index(strPhone.endIndex, offsetBy: -5)
        let range = start..<end
        let substring1 = String(strPhone[range])
        
        let index1 = strPhone.index(strPhone.endIndex, offsetBy: -4)
        let substring2 = String(strPhone[index1...])
        
        let total = substring0 + substring1 + substring2
        
        let phoneNumber = Int(total)
        
        return phoneNumber!
        
    }

    class func validatePassword(value:String) -> Bool
    {
        return (value.count > 6)
    }

    class func validateNumber(value:String) -> Bool
    {
        let letters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyz")

        
        let range = value.lowercased().rangeOfCharacter(from: letters)

        // range will be nil if no letters is found
        //if it is nil than this string has a valid number
      
        //not nil
        if range != nil
        {
            return false
        }
        //nil
        else {
           return true
        }
    }
    class func unstringify(value:String) -> [String]
    {
        var array = value.components(separatedBy: ",")
        
        let vowels: Set<Character> = [","]
        //remove commas from the string
        for var string in array
        {
            string.removeAll(where: {vowels.contains($0)})
            
        }
        array = array.filter({ $0 != ""})
        
        return array
    }
    class func restringify(array:[String]) -> String
    {
        var result:String = ""
        for string in array
        {
            result += (string + ",")
        }
        return result
    }
    
    

    
}

