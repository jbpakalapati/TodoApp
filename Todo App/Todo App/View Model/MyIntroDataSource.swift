//
//  MyIntroDataSource.swift
//  Todo App
//
//  Created by MacBook  on 1/26/23.
//

import Foundation
import IntroScreen

struct MyIntroDataSource: IntroDataSource {
    
    let numberOfPages = 4
    
    // Set to true, if you want to fade out the last page color into black.
    let fadeOutLastPage: Bool = false
    
    func viewController(at index: Int) -> IntroPageViewController? {
        switch index {
        case 0:
            return DefaultIntroPageViewController(
                index: index,
                hue: 12/360,
                title: "SignUp & Login",
                subtitle: "Create a user for to use this To-Do App",
                image: UIImage(named: "2")!
            )
        case 1:
            return DefaultIntroPageViewController(
                index: index,
                hue: 40/360,
                title: "TO-DO List Items",
                subtitle: "Add your To-Do list items",
                image: UIImage(named: "3")!
            )
        case 2:
            return DefaultIntroPageViewController(
                index: index,
                hue: 60/360,
                title: "Edit & Change",
                subtitle: "Make changes to your To-Do list items",
                image: UIImage(named: "4")!
            )
        case 3:
            return DefaultIntroPageViewController(
                index: index,
                hue: 90/360,
                title: "Notifications",
                subtitle: "Get notified once your To-Do is completed",
                image: UIImage(named: "5")!
            )
        default:
            return nil
        }
    }
}
