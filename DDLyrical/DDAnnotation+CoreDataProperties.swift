//
//  DDAnnotation+CoreDataProperties.swift
//  
//
//  Created by Gu Jun on 2019/5/6.
//
//

import Foundation
import CoreData


extension DDAnnotation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DDAnnotation> {
        return NSFetchRequest<DDAnnotation>(entityName: "DDAnnotation")
    }

    @NSManaged public var text: String?
    @NSManaged public var begin: Int16
    @NSManaged public var end: Int16

}
