//
//  ContentView.swift
//  practice-imageCropping
//
//  Created by sachin jeph on 12/06/22.
//

import SwiftUI
import CoreData




struct ContentView:View{
    
    @State var aspectRatio : CGFloat = 4/5
    
    var body : some View{
        ScrollView(.vertical){
            
            HStack{
                Button(action:{
                    aspectRatio = 4/5
                }){
                    Text("4:5")
                }
                
                Button(action:{
                    aspectRatio = 1/1
                }){
                    Text("1:1")
                }
                
                Button(action:{
                    aspectRatio = 1.91/1
                }){
                    Text("1.91:1")
                }
            
                
            }
              
                ScrollableImageView(aspectRatio: $aspectRatio)
               
        }
    }
}

struct ScrollableImageView:View{
    @Binding var aspectRatio : CGFloat
    var body : some View{
        ScrollableImage()
          .aspectRatio(aspectRatio, contentMode: .fit)
              .frame(height: 400)
              .clipped()
    }
}



