//
//  ContactsViewController.swift
//  My Contact List
//
//  Created by Alex Bringuel on 4/1/25.
//

import UIKit

class ContactsViewController: UIViewController {

    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    
    
    @IBOutlet weak var txtState: UITextField!
    
    @IBOutlet weak var sgmtEditMode: UISegmentedControl!
    
    @IBOutlet weak var btnChange: UIButton!
    
    
    @IBOutlet weak var txtEmail: UITextField!
    
    
    @IBOutlet weak var txtPhone: UITextField!
    
    @IBOutlet weak var txtCell: UITextField!
    
    @IBOutlet weak var txtZip: UITextField!
    
    @IBOutlet weak var lblBirthdaye: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    

    
    override func viewDidLoad() {
            super.viewDidLoad()
            registerKeyBoardNotifications()
            sgmtEditMode.addTarget(self, action: #selector(changeEditMode(sender:)), for: .valueChanged)
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            self.unregisterKeyBoardNotifications()
        }

        func registerKeyBoardNotifications() {
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(keyboardDidShow(notification:)),
                                                   name: UIResponder.keyboardDidShowNotification,
                                                   object: nil)
            
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(keyboardWillHide(notification:)),
                                                   name: UIResponder.keyboardWillHideNotification,
                                                   object: nil)
        }
        
        func unregisterKeyBoardNotifications() {
            NotificationCenter.default.removeObserver(self)
        }
        
        @objc func keyboardDidShow(notification: NSNotification) {
            if let userInfo = notification.userInfo,
               let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                
                let keyboardSize = keyboardFrame.cgRectValue.size
                var contentInset = scrollView.contentInset
                contentInset.bottom = keyboardSize.height
                scrollView.contentInset = contentInset
                scrollView.scrollIndicatorInsets = contentInset
            }
        }

        @objc func keyboardWillHide(notification: NSNotification) {
            var contentInset = scrollView.contentInset
            contentInset.bottom = 0
            scrollView.contentInset = contentInset
            scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
        }
        
        // adding button stuff for birthday now
        override func didReceiveMemoryWarning(){
            super.didReceiveMemoryWarning()
        }
        
        @IBAction func changeEditMode(sender: Any) {
            let textFields: [UITextField] =
            [txtZip, txtCell, txtCity, txtName, txtEmail, txtPhone, txtState, txtAddress]

            if sgmtEditMode.selectedSegmentIndex == 0 {
                for textField in textFields {
                    textField.isEnabled = false
                    textField.borderStyle = .none
                }
                btnChange.isHidden = true
            }
            else if sgmtEditMode.selectedSegmentIndex == 1 {
                for textField in textFields {
                    textField.isEnabled = true
                    textField.borderStyle = .roundedRect
                }
                btnChange.isHidden = false
            }
        }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
