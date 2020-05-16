//
//  EventLayer.swift
//  QVRWeekView
//
//  Created by Reinert Lemmens on 25/08/2019.
//

import Foundation
import SDWebImage

class EventLayer: CALayer {
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(withFrame frame: CGRect, layout: DayViewCellLayout, andEvent event: EventData, withImage: Bool = false, isPlain: Bool = false) {
        super.init()
        self.bounds = frame
        self.frame = frame
        
        // Configure gradient and colour layer
        if let gradient = event.getGradientLayer(withFrame: frame) {
            self.backgroundColor = UIColor.clear.cgColor
            self.addSublayer(gradient)
            
            self.masksToBounds = true
            self.cornerRadius = 4
        } else {
            self.backgroundColor = event.color.cgColor
        }
        
        if !isPlain{
            if withImage{
                // Configure event layer with image
                let imageWidthHeight = frame.height > frame.width ? frame.width/2 : frame.height/2
                
                let imageLayer = CALayer()
                imageLayer.backgroundColor = UIColor.clear.cgColor
                imageLayer.frame = CGRect(x: self.bounds.midX - imageWidthHeight/2,
                                          y: self.bounds.midY - imageWidthHeight/2,
                                          width: imageWidthHeight,
                                          height: imageWidthHeight)
                
                let urlString = URL(string: event.imageURLString)
                SDWebImageManager.shared?.imageDownloader.downloadImage(with: urlString, options: .continueInBackground, progress: nil, completed: { (image, _, _, _) in
                    
                    imageLayer.contents = image?.cgImage
                })
                
                self.addSublayer(imageLayer)
            }else{
                // Configure event text layer
                let eventTextLayer = CATextLayer()
                eventTextLayer.isWrapped = true
                eventTextLayer.contentsScale = UIScreen.main.scale
                eventTextLayer.string = event.getDisplayString(withMainFont: layout.eventLabelFont,
                                                               infoFont: layout.eventLabelInfoFont,
                                                               andColor: layout.eventLabelTextColor)
                
                let xPadding = layout.eventLabelHorizontalTextPadding
                let yPadding = layout.eventLabelVerticalTextPadding
                eventTextLayer.frame = CGRect(x: frame.origin.x + xPadding,
                                              y: frame.origin.y + yPadding,
                                              width: frame.width - 2*xPadding,
                                              height: frame.height - 2*yPadding)
                self.addSublayer(eventTextLayer)
            }
        }
    }
}
