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
        
        @Binding var text: String
        
        var hintText :String
        var option:Int
        

        init(hintText: String, text: Binding<String>, option:Int)
        {
            _text = text
            self.option = option
            self.hintText = hintText
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            text = textField.text ?? ""
        }
        func textFieldDidBeginEditing(_ textField: UITextField)
        {
            if(textField.text == hintText)
            {
               textField.text = ""
            }
        }
        func textFieldDidEndEditing(_ textField: UITextField) {
            if(textField.text == "")
            {
                textField.text = hintText
            }
        }
        func textFieldShouldReturn(_ textField: UITextField) -> Bool
        {
            let nextTag = textField.tag + 1

            if let nextResponder = textField.superview?.viewWithTag(nextTag)
            {
                nextResponder.becomeFirstResponder()
            }
            else
            {
                textField.resignFirstResponder()
            }
            return true
        }
        
    }

    @Binding var text: String
    
    var hintText:String
    var option:Int
    
    static var GENERIC = 0
    static var NEW_PASSWORD = 1
    static var PASSWORD = 2
    static var USERNAME = 3
    
    

    func makeUIView(context: UIViewRepresentableContext<CustomTextField>) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.textColor = .black
        textField.text = hintText
        textField.delegate = context.coordinator
        
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
        return Coordinator(hintText: hintText, text: $text, option: option)
    }

    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<CustomTextField>) {
        
        /*
        if isFirstResponder && !context.coordinator.didBecomeFirstResponder  {
            uiView.becomeFirstResponder()
            context.coordinator.didBecomeFirstResponder = true
        }
        */
    }
}
