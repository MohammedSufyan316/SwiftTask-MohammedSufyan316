//
//  SettingsViewController.swift
//  SmartTaskManager
//
//  Created by CDMStudent on 3/16/25.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var darkModeSwitch: UISwitch!
    
    @IBOutlet weak var disableEditSwitch: UISwitch!
    
    @IBOutlet weak var resetToDefaultSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let defaults = UserDefaults.standard
          
          if defaults.object(forKey: "darkModeEnabled") == nil {
              defaults.set(false, forKey: "darkModeEnabled")
          }
          if defaults.object(forKey: "disableEditingEnabled") == nil {
              defaults.set(false, forKey: "disableEditingEnabled")
          }
          
          // Load saved settings (all off by default on first launch)
          darkModeSwitch.isOn = false    // defaults.bool(forKey: "darkModeEnabled")
          disableEditSwitch.isOn = defaults.bool(forKey: "disableEditingEnabled")
          resetToDefaultSwitch.isOn = false  // Always off
          
          applyDarkMode(darkModeSwitch.isOn)
        
    }
    
    @IBAction func darkModeSwitchChanged(_ sender: UISwitch) {
        let isDarkMode = sender.isOn
        UserDefaults.standard.set(isDarkMode, forKey: "darkModeEnabled")
        applyDarkMode(isDarkMode)
    }
    
    func applyDarkMode(_ enabled: Bool) {
         view.window?.overrideUserInterfaceStyle = enabled ? .dark : .light
     }
    

    @IBAction func disableEditSwitchChanged(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "disableEditingEnabled")
    }
    
    @IBAction func resetToDefaultSwitchChanged(_ sender: UISwitch) {
        let defaults = UserDefaults.standard
        
        // Turn off both settings
        darkModeSwitch.setOn(false, animated: true)
        disableEditSwitch.setOn(false, animated: true)
        
        defaults.set(false, forKey: "darkModeEnabled")
        defaults.set(false, forKey: "disableEditingEnabled")
        
        applyDarkMode(false)
        NotificationCenter.default.post(name: Notification.Name("DisableEditingChanged"), object: nil)
        
        // Reset itself
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.resetToDefaultSwitch.setOn(false, animated: true)
        }
    }
    
}
