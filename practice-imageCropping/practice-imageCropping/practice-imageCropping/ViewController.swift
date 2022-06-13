//
//  ViewController.swift
//  PhotoScroller
//
//  Created by Seyed Samad Gholamzadeh on 1/14/18.
//  Copyright © 2018 Seyed Samad Gholamzadeh. All rights reserved.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {
    
    var imageScrollView: ImageScrollView!
    var image : UIImage
    
    init(image : UIImage){
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //1. Initialize imageScrollView and adding it to viewControllers view
        self.imageScrollView = ImageScrollView(frame: self.view.bounds)
        self.view.addSubview(self.imageScrollView)
        self.layoutImageScrollView()
        
        //2. Making an image from our photo path
        //let imagePath = Bundle.main.path(forResource: "img", ofType: "png")!
        //let image = UIImage(named: "img")!
        
        //3. Ask imageScrollView to show image
        self.imageScrollView.display(image)
        print(self.imageScrollView.contentOffset)//pp
        print(self.imageScrollView.zoomScale)//pp
        
        
    }
    
    func getImage(aspectRatio : CGFloat)->UIImage?{
        
        if imageScrollView == nil{
            return nil
        }
        
        /////////
        //        let realImageRect = imageScrollView.zoomView.realImageRect()
        //
        //
        //   /*     let cropRect = CGRect(x: imageScrollView.frame.origin.x - realImageRect.origin.x,
        //                              y: imageScrollView.frame.origin.y - realImageRect.origin.y,
        //                              width: imageScrollView.frame.width,
        //                              height: imageScrollView.frame.height)
        //        */
        //
        //        guard let cropRect = imageScrollView.getZoomRect() else{
        //            print("crop rect not created")
        //            return nil
        //        }
        //
        //        let croppedImage = ImageCropHandler.sharedInstance.cropImage(image,
        //                                                                     toRect: cropRect,
        //                                                                     imageViewWidth: imageScrollView.zoomView.frame.width,
        //                                                                     imageViewHeight: imageScrollView.zoomView.frame.height)
        //
        //
        //        return croppedImage
        /////////////
        //   let realImageRect = imageScrollView.image
        
        return image.crop(from: imageScrollView,aspectRatio : aspectRatio)
        
        //return img!.imageResized(to: croppedImgSize!)
        
        
        
        //let x = imageScrollView.contentInset.top
        //        let xOffset = self.imageScrollView.contentInset.top
        //        let yOffset = self.imageScrollView.contentInset.left
        
        
        
        
        /*
         let factor = image.size.width/imageScrollView.frame.width
         
         let xOffset = self.imageScrollView.contentOffset.x*factor
         let yOffset = self.imageScrollView.contentOffset.y*factor
         
         
         let zv = self.imageScrollView.zoomView.frame
         let zoomScale : CGFloat = self.imageScrollView.zoomScale
         //pp
         
         
         let cgImage : CGImage = image.cgImage!
         let dim  : CGFloat = getDimension(w: CGFloat(cgImage.width), h: CGFloat(cgImage.height))
         if let cImage = cgImage.cropping(to: zv){
         
         print("HHH", zoomScale*dim)
         let croppedImage = UIImage(cgImage: cImage)
         return croppedImage
         }
         
         return nil
         */
    }
    
    
    
    //This function just gets the larger of two values, when comparing two inputs. It is typically executed by submitting a width and height of a view to return the larger of the two
    func getDimension(w:CGFloat,h:CGFloat) -> CGFloat{
        if h > w {
            return w
        } else {
            return h
        }
        
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        self.restoreStatesForRotation(in: size)
    }
    
    
    
    func restoreStatesForRotation(in bounds: CGRect) {
        // recalculate contentSize based on current orientation
        let restorePoint = imageScrollView.pointToCenterAfterRotation()
        let restoreScale = imageScrollView.scaleToRestoreAfterRotation()
        imageScrollView.frame = bounds
        imageScrollView.setMaxMinZoomScaleForCurrentBounds()
        imageScrollView.restoreCenterPoint(to: restorePoint, oldScale: restoreScale)
    }
    
    func restoreStatesForRotation(in size: CGSize) {
        var bounds = self.view.bounds
        if bounds.size != size {
            bounds.size = size
            self.restoreStatesForRotation(in: bounds)
        }
    }
    
    
    func layoutImageScrollView() {
        self.imageScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        let top = NSLayoutConstraint(item: self.imageScrollView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 0.0)
        let left = NSLayoutConstraint(item: self.imageScrollView, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1.0, constant: 0.0)
        
        let bottom = NSLayoutConstraint(item: self.imageScrollView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        let right = NSLayoutConstraint(item: self.imageScrollView, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1.0, constant: 0.0)
        
        self.view.addConstraints([top, left, bottom, right])
    }
    
    
}




extension UIImage {
    
    func crop(from scrollView: UIScrollView, aspectRatio : CGFloat) -> UIImage? {
        
        
        var compensation : CGFloat
        
        
        //        let ar1 : CGFloat = 4/5
        //        let ar2 : CGFloat = 1/1
        //        let ar3 : CGFloat = 1.91/1
        
        if self.size.width>=self.size.height{
            
            let compensation1 = self.size.width/self.size.height//width is greater than height by the this factor,
            //so first equal width and height using compensation1 - this is probably the reason for cropped image distortion
            
            compensation = 1/compensation1
            
            //aspectRatio = ar1
        }else{
            
            compensation = self.size.height/self.size.width//width is smaller than height by the this factor
            
            
            //  aspectRatio = 1/ar1
        }
        
        
        /*
         cropRect = image.x - imageView.x
         zoomFacttor = (image.width+2*cropRect)^2/image.width^2
         */
        //here issue with zoomScale -> cropped image zoom is not correct
        //0.1 zoomScale means the cropped image is showing only 10% of the original image
        
        print(scrollView.zoomScale)
        let zoom: CGFloat =  (1/(scrollView.zoomScale.truncate(places: 1)))
        let xOffset: CGFloat = (size.width / scrollView.contentSize.width) * scrollView.contentOffset.x
        let yOffset: CGFloat = (size.height / scrollView.contentSize.height) * scrollView.contentOffset.y
        
        
        print(zoom, " and compen ",compensation)
        var w = CGFloat(cgImage!.width) * zoom  * scale * aspectRatio * compensation
        var h = CGFloat(cgImage!.height) * zoom * scale
        
        if w>2000{//just to decrease the image size
            //5000 is too many points-> makes very large image size
            print(w)
            w /= 10
            print(w)
        }
        
        if h>2000{
            h /= 10
        }
        
        print(CGFloat(cgImage!.width) , " " , zoom, " * ", " ", scale, " ",compensation )
        
        
        let croppedImgSize = CGSize(width: w, height: h)
        
        
        print(w, " ", h, " aspect before ", w/h)
        // return nil
        let cropRect = CGRect(x: xOffset * scale, y: yOffset * scale, width: w, height: h)
        
        guard let croppedImageRef = cgImage?.cropping(to: cropRect) else { return nil }
        let croppedImage = UIImage(cgImage: croppedImageRef, scale: scale, orientation: imageOrientation)
        
        
        let resultImage = croppedImage.imageResized(to: croppedImgSize)
        
        
        // print(resultImage.cgImage!.width/3, " ", resultImage.cgImage!.height/3, " aspect ", Float(resultImage.cgImage!.width)/Float(resultImage.cgImage!.height))
        
        
        return resultImage
        
    }
    
}
extension UIImage {
    func imageResized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}

//NOT IN USE
extension UIImage {
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

extension CGFloat {
    func truncate(places : Int)-> CGFloat {
        return CGFloat(floor(pow(10.0, CGFloat(places)) * self)/pow(10.0, CGFloat(places)))
    }
}

