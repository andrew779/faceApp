//
//  EmotionsViewController.swift
//  face
//
//  Created by Wenzhong Zheng on 2017-08-16.
//  Copyright © 2017 Wenzhong. All rights reserved.
//

import UIKit

class EmotionsViewController: UITableViewController, UIPopoverPresentationControllerDelegate {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
 
    @IBAction func addEmotionalFace(from segue: UIStoryboardSegue) {
        if let editor = segue.source as? ExpressionEditorViewController {
            emotionalFaces.append((editor.name, editor.expression))
            tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destinationVC = segue.destination
        if let navigationController = destinationVC as? UINavigationController {
            destinationVC = navigationController.visibleViewController ?? destinationVC
        }
        if let faceViewController = destinationVC as? FaceViewController,
            let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell){
            faceViewController.expression = emotionalFaces[indexPath.row].expression
            faceViewController.navigationItem.title = emotionalFaces[indexPath.row].name
        } else if destinationVC is ExpressionEditorViewController {
            if let popoverPresentationController = segue.destination.popoverPresentationController {
                popoverPresentationController.delegate = self
            }
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        if traitCollection.verticalSizeClass == .compact {
            return .none
        } else if traitCollection.horizontalSizeClass == .compact {
            return .overFullScreen
        } else {
            return .none
        }
    }
    
    
    
    
    
    private var emotionalFaces: [(name:String, expression: FacialExpression)] = [
        ("sad", FacialExpression(eyes:.closed, mouth: .frown)),
        ("happy", FacialExpression(eyes:.open, mouth: .smile)),
        ("worried", FacialExpression(eyes:.open, mouth: .smirk))
    ]
    
    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emotionalFaces.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Emotion Cell", for: indexPath)
        cell.textLabel?.text = emotionalFaces[indexPath.row].name
        return cell
    }
}
