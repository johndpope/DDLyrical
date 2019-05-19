//
//  DDSegment+CoreDataProperties.swift
//  
//
//  Created by Gu Jun on 2019/5/19.
//
//

import Foundation
import CoreData


extension DDSegment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DDSegment> {
        return NSFetchRequest<DDSegment>(entityName: "DDSegment")
    }

    @NSManaged public var segment: String?
    @NSManaged public var line: DDLine?

}
