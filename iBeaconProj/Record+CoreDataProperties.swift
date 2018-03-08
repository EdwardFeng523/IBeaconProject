//
//  Record+CoreDataProperties.swift
//  iBeaconProj
//
//  Created by Edward Feng on 2/8/18.
//  Copyright © 2018 Edward Feng. All rights reserved.
//
//

import Foundation
import CoreData


extension Record {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Record> {
        return NSFetchRequest<Record>(entityName: "Record")
    }

    @NSManaged public var text: String?
    @NSManaged public var person: String?
    @NSManaged public var mail: String?
    @NSManaged public var region: String?
    @NSManaged public var entered: Bool
    @NSManaged public var time: String?

}
