//
//  CustomTextField.swift
//  ArtUOKV3
//
//  Copyright © 2020 Sam Rosemore. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

struct CustomTextField: UIViewRepresentable
{
    typealias UIViewType = TextField
    
    class Coordinator: NSObject, UITextFieldDelegate
    {
        
        
        
        var parent:CustomTextField
        
        
        

        init(textfield: CustomTextField)
        {
            self.parent = textfield
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            parent.text = textField.text ?? ""
        }
        func textFieldDidBeginEditing(_ textField: UITextField)
        {
            
            for b in 0...(parent.focus.count - 1)
            {
                if(b == parent.tag)
                {
                    parent.focus[b] = true
                }
                else
                {
                    parent.focus[b] = false
                }
            }
            
            if(textField.text == parent.hintText)
            {
               textField.text = ""
            }
        }
        func textFieldDidEndEditing(_ textField: UITextField) {
            if(textField.text == "")
            {
                textField.text = parent.hintText
            }
        }
        func textFieldShouldReturn(_ textField: UITextField) -> Bool
        {
            //want to do this but not sure how many textfield to account for (could be 2 or 3)
            /*
             if parent.tag == 0 {
                 parent.isfocusAble = [false, true]
                 parent.text = textField.text ?? ""
             } else if parent.tag == 1 {
                 parent.isfocusAble = [false, false]
                 parent.text = textField.text ?? ""
             */
            let nextTag = parent.tag + 1
            if(nextTag < parent.focus.count)
            {
                for b in 0...(parent.focus.count - 1)
                {
                    if(b == nextTag)
                    {
                        parent.focus[b] = true
                    }
                    else
                    {
                        parent.focus[b] = false
                    }
                }
            }
            else
            {
                for b in 0...(parent.focus.count - 1)
                {
                  
                    parent.focus[b] = false

                }
            }
            
            return true
        }
        
    }

    @Binding var text: String
    
    var hintText:String
    var option:Int
    var tag:Int
    @Binding var focus:[Bool]
    
    
    
    static var GENERIC = 0
    static var NEW_PASSWORD = 1
    static var PASSWORD = 2
    static var USERNAME = 3
    
 
    
    

    func makeUIView(context: UIViewRepresentableContext<CustomTextField>) ->  UITextField {
        let textField = UITextField(frame: .zero)
        textField.textColor = .black
        textField.text = hintText
        textField.delegate = context.coordinator
        
        textField.tag = tag
        
        
        if(option == CustomTextField.NEW_PASSWORD)
        {
            //this annoyed me :(
        }
        else if(option == CustomTextField.PASSWORD)
        {
            textField.textContentType = .password
            textField.isSecureTextEntry = true
        }
        else if(option == CustomTextField.USERNAME)
        {
            textField.textContentType = .username
            textField.keyboardType = .emailAddress
        }
        
        return textField
    }

    func makeCoordinator() -> CustomTextField.Coordinator {
        return Coordinator(textfield: self)
    }

    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<CustomTextField>)
    {
        if focus[tag]
        {
            uiView.becomeFirstResponder()
        } else {
            uiView.resignFirstResponder()
        }
        

        /*
        if  context.coordinator.isFirstResponder
        {
            uiView.becomeFirstResponder()
        }
 */
        
    }
}
