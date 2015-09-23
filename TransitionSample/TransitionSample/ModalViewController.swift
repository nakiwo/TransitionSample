//
//  ModalViewController.swift
//  TransitionSample
//
//  Created by Yuichi Fujishige on 2015/09/18.
//  Copyright © 2015 Yuichi Fujishige. All rights reserved.
//

import UIKit

final class ModalViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "backToRoot" {
        }
    }
}
