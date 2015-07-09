//
//  ColorMixerViewController.swift
//  Circle Draw
//
//  Created by Leon Baird on 07/07/2015.
//  Copyright (c) 2015 Leon Baird. All rights reserved.
//

import UIKit

class ColorMixerViewController: UIViewController {

    // outlets
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var sliderRed: UISlider!
    @IBOutlet weak var sliderGreen: UISlider!
    @IBOutlet weak var sliderBlue: UISlider!
    @IBOutlet weak var colorPreview: UIView!
    
    // colour value
    var colorMixed:UIColor?
    
    var delegate:ColorMixerViewControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // setup mixer
        if let color = colorMixed {
            colorPreview.backgroundColor = color
            
            // get component values
            var red:CGFloat = 0.0,
                green:CGFloat = 0.0,
                blue:CGFloat = 0.0
            
            color.getRed(&red, green: &green, blue: &blue, alpha: nil)

            sliderRed.value = Float(red)
            sliderGreen.value = Float(green)
            sliderBlue.value = Float(blue)
        }
        
        // get rid of done if on ipad
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            navItem.rightBarButtonItem = nil
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Action methods
    
    @IBAction func sliderValueHasChanged(sender:UISlider) {
        colorMixed = UIColor(
            red: CGFloat(sliderRed.value),
            green: CGFloat(sliderGreen.value),
            blue: CGFloat(sliderBlue.value),
            alpha: 1.0
        )
        colorPreview.backgroundColor = colorMixed
        delegate?.colorMixerHasMixedNewColor(colorMixed!, mixer: self)
    }
}


protocol ColorMixerViewControllerDelegate {
    // Implement to get real time update on mixed color
    func colorMixerHasMixedNewColor(color:UIColor, mixer:ColorMixerViewController)
}
