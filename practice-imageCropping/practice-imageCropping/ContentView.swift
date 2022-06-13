//
//  ContentView.swift
//  practice-imageCropping
//
//  Created by sachin jeph on 12/06/22.
//

import SwiftUI
import CoreData


struct imge:View {
    var body : some View{
        VStack{
Image("img")
    .aspectRatio(4/3, contentMode: .fit)
        .frame(height: 400)
            .clipped()
    }
}
}



struct ContentView:View{
    
    @State var aspectRatio : CGFloat = 4/5
    
    var body : some View{
       
            
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
              
        ScrollableImageView(aspectRatio: $aspectRatio, scrollableImage: ScrollableImage(image:UIImage(named: "img")!))
               
//        Button(action:{
//            let scrollableImage = ScrollableImageView(aspectRatio: $aspectRatio, image : UIImage(named: "img")!)
//         ///   let scrollableImage = getImageView()
//
//           let image = scrollableImage.snapshot()
//           // let image = ScrollableImageView(aspectRatio: $aspectRatio, image : UIImage(named: "img")!).getImage()
//            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
//        }){
//            Text("Save")
//        }
//
    }
    
}

struct ScrollableImageView:View{
    @Binding var aspectRatio : CGFloat
    var scrollableImage : ScrollableImage
   // var image : UIImage
    var body : some View{
        scrollableImage
          .aspectRatio(aspectRatio, contentMode: .fit)
              .frame(height: 400)
              .clipped()
              
        Button(action:{
            if let imageToSave = scrollableImage.getImage(aspectRatio : aspectRatio){
            UIImageWriteToSavedPhotosAlbum(imageToSave, nil, nil, nil)
            }
        }){
            Text("Save")
        }
              
    }
}

extension View {
    func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view
        
        //view?.bounds = controller.boun
        
        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear

        let renderer = UIGraphicsImageRenderer(size: targetSize)

        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}
