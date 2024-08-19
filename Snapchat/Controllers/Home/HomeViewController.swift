//
//  HomeViewController.swift
//  Snapchat
//
//  Created by Zafran Mac on 02/12/2023.
//

import UIKit
import SQLite3

class HomeViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    @IBOutlet weak var imageview:UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.hidesBarsOnTap = true
        // Add tap gesture recognizer to the profile image view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        imageview.addGestureRecognizer(tapGesture)
        imageview.isUserInteractionEnabled = true
        
        
        if let imageData = DatabaseManager.shared.loadImageFromDatabase2() {
            imageview.image = UIImage(data: Data(imageData))
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let imageData = DatabaseManager.shared.loadImageFromDatabase2() {
            imageview.image = UIImage(data: Data(imageData))
        }
        navigationController?.navigationBar.isHidden = true
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // Hide the navigation bar on tap
        navigationController?.navigationBar.isHidden = false
    }
    @IBAction func nextButtonTapped(_ sender: Any) {
        imageViewTapped()
    }
    
    
    @objc func profileImageTapped() {
        // Create an instance of the ProfileViewController from the Main storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let profileViewController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        //profileViewController.modalPresentationStyle = .fullScreen
        //self.present(profileViewController, animated: true)
        self.navigationController?.pushViewController(profileViewController, animated: true)
    }
    
    @objc func imageViewTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            if let imageData = pickedImage.pngData() {
                DatabaseManager.shared.saveImageToDatabase(table: "Mainprofiles", imageData: imageData) { success in
                    if success {
                        self.loadImageAndUpdateUI()
                    } else {
                        print("Failed to save image to database.")
                    }
                }
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func loadImageAndUpdateUI() {
        DispatchQueue.main.async {
            if let imageData = DatabaseManager.shared.loadImageFromDatabase2() {
                self.imageview.image = UIImage(data: Data(imageData))
                
            }
        }
    }
    
    
}
