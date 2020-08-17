//
//  FAQ.swift
//  ArtUOKV3
//
//  Created by Sam Rosemore on 7/22/20.
//  Copyright © 2020 Sam Rosemore. All rights reserved.
//

import SwiftUI

struct FAQ: View
{
    @ObservedObject var userStorage = UserStorage()
    
    var body: some View
    {
        VStack(alignment: .center, spacing: 20)
        {
            Spacer()
            
            Text("FAQ").fontWeight(.bold).font(.system(size: 28))
            
            List
            {
                ForEach(userStorage.faqQuestions, id: \.question)
                {
                    fq in
                    
                    
                    
                    
                    VStack
                    {
                        HStack(spacing: 30)
                        {
                            Text(fq.question!).fontWeight(.bold)
                            Spacer()
                        }.contentShape(Rectangle()).onTapGesture
                        {
                            
                            if(!fq.visibilityStatus.showCell!)
                            {
                                fq.show()
                                self.userStorage.objectWillChange.send()
                                
                                print("showing")
                                print(fq.visibilityStatus.showCell!)
                            }
                            else
                            {
                                
                                fq.hide()
                                self.userStorage.objectWillChange.send()
                                print("hidding")
                            }
                                
                        }
                        
                       
                        if(fq.visibilityStatus.showCell!)
                        {
                             
                            Text(fq.answer!)
                        }
                        
                        
                    }
                    
                    
                    
                    
                    
                }
            }
            Spacer()
            
            
        }.background(Color.init("Logo Color"))
        
    }
    
    func getUserStorage() -> UserStorage
    {
        return userStorage
    }
    
    
}

struct FAQ_Previews: PreviewProvider {
    static var previews: some View {
        FAQ()
    }
}
