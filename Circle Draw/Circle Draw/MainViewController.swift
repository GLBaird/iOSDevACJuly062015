//
//  MainViewController.swift
//  Circle Draw
//
//  Created by Leon Baird on 07/07/2015.
//  Copyright (c) 2015 Leon Baird. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, ColorMixerViewControllerDelegate {

    // outlets
    @IBOutlet weak var circle: CircleView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "ColorMixer" {
            let colorMixer = segue.destinationViewController as! ColorMixerViewController
            colorMixer.colorMixed = circle.color
            if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
                colorMixer.delegate = self
            }
        }
        
    }
    
    // unwind segue
    
    @IBAction func closeColorMixer(segue:UIStoryboardSegue) {
        let colorMixer = segue.sourceViewController as! ColorMixerViewController
        circle.color = colorMixer.colorMixed!
        circle.setNeedsDisplay()
    }
    
    // MARK: - Color Mixer Delegate Methods
    
    func colorMixerHasMixedNewColor(color: UIColor, mixer: ColorMixerViewController) {
        circle.color = color
        circle.setNeedsDisplay()
    }
    

}
