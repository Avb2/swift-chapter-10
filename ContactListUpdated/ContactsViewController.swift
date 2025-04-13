//
//  ContactsViewController.swift
//  ContactListUpdated
//
//  Created by Alex Bringuel on 4/7/25.
//
import UIKit

class ContactsViewController: UIViewController {
    @IBOutlet weak var sgmtEditMode: UISegmentedControl!
    
    @IBOutlet weak var txtName: UITextField!
    
    @IBOutlet weak var txtAddress: UITextField!
    
    @IBOutlet weak var txtCity: UITextField!
    
    @IBOutlet weak var txtState: UITextField!
    
    @IBOutlet weak var txtZip: UITextField!
    
    @IBOutlet weak var txtCell: UITextField!
    
    @IBOutlet weak var txtPhone: UITextField!
    
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var btnChange: UIButton!
    @IBOutlet weak var labelBirthdate: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.changeEditMode(self)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func changeEditMode(_ sender: Any) {
        let textFields: [UITextField] = [txtName, txtAddress, txtCity, txtState, txtZip, txtPhone, txtCell, txtEmail]
        
        if sgmtEditMode.selectedSegmentIndex == 0 {
            for textField in textFields {
                textField.isEnabled = false
                textField.borderStyle = UITextField.BorderStyle.none
            }
            btnChange.isHidden = false
        }
        
        if sgmtEditMode.selectedSegmentIndex == 1 {
            for textField in textFields {
                textField.isEnabled = true
                textField.borderStyle = UITextField.BorderStyle.roundedRect
            }
            btnChange.isHidden = false
        }
    }
    

}
