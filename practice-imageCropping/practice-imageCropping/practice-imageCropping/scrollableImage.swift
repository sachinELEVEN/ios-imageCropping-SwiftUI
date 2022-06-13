
import SwiftUI


struct ScrollableImage : UIViewControllerRepresentable{
    
    var image : UIImage
    let vc : ViewController
    
    init(image : UIImage){
        self.image = image
        self.vc = ViewController(image: image)
    }
    
    
    func makeUIViewController(context: Context) -> UIViewController {
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
    
    func getImage(aspectRatio : CGFloat)->UIImage?{
        return vc.getImage(aspectRatio: aspectRatio)
    }
    
   
    

}
