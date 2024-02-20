//
//  Favourite+CoreDataProperties.swift
//  SmartMovie
//
//  Created by BachNguyen on 01/04/2023.
//
//

import Foundation
import CoreData

extension Favourite {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favourite> {
        return NSFetchRequest<Favourite>(entityName: "Favourite")
    }

    @NSManaged public var idMovie: Int32

}

extension Favourite: Identifiable {
}
