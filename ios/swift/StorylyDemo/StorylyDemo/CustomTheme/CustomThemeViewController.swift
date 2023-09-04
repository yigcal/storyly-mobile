//
//  CustomThemeViewController.swift
//  StorylyDemo
//
//  Created by Haldun Fadillioglu on 2.02.2021.
//  Copyright © 2021 App Samurai Inc. All rights reserved.
//

import UIKit
import Storyly

class CustomThemeViewController: UIViewController {

    @IBOutlet weak var storylyViewDefaultTheme: StorylyView!
    @IBOutlet weak var storylyViewCustomTheme: StorylyView!

    override func viewDidLoad() {
        super.viewDidLoad()

        storylyViewDefaultTheme.storylyInit = StorylyInit(storylyId: STORYLY_INSTANCE_TOKEN)
        storylyViewDefaultTheme.rootViewController = self
        
        storylyViewCustomTheme.storylyInit = StorylyInit(storylyId: STORYLY_INSTANCE_TOKEN)
        storylyViewCustomTheme.rootViewController = self
    }
}
