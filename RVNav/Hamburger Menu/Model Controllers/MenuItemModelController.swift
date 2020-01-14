//
//  MenuItemModelController.swift
//  RVNav
//
//  Created by Lambda_School_Loaner_214 on 1/13/20.
//  Copyright © 2020 RVNav. All rights reserved.
//

import Foundation

class MenuItemController {
    private(set) var menuItems: [MenuItem] = []
    private static let sectionNames = ["MAP VIEWS","ROUTING PREFERENCES","PROFILE"]
    var sections: [MenuItemSection] = []
    
    init () {
        //Creat Sections
        self.sections.append(MenuItemSection(name: MenuItemController.sectionNames[0], order: 0, menuItems: [
            MenuItem(label: "Satelite", imageName: "satelite", order: 0),
            MenuItem(label: "Terrain", imageName: "terrain", order: 1)]))
        self.sections.append(MenuItemSection(name: MenuItemController.sectionNames[1], order: 1, menuItems: [
            MenuItem(label: "My Vehicles", imageName: "car", order: 0),
            MenuItem(label: "Saved Routes", imageName: "savedroute", order: 1),
            MenuItem(label: "Routing options", imageName: "settings", order: 2)]))
        self.sections.append(MenuItemSection(name: MenuItemController.sectionNames[2], order: 2, menuItems: [
            MenuItem(label: "Logout", imageName: "log-out", order: 0)]))
        
        self.menuItems = []
    }
    
    convenience init(with list: [MenuItem]) {
        self.init()
        self.menuItems = list
    }
    
    func addMenuItem (item: MenuItem) {
        menuItems.append(item)
    }
    
    func getMenuItem (for index: IndexPath) -> MenuItem {
        return sections[index.section].menuItems[index.row]
    }
    
}
