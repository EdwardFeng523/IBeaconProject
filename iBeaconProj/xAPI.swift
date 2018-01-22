//
//  xAPI.swift
//  iBeaconProj
//
//  Created by Edward Feng on 1/19/18.
//  Copyright © 2018 Edward Feng. All rights reserved.
//

import Foundation

func sendStatement() {
    
    
    var options = [AnyHashable: Any]()
    var lrs = [AnyHashable: Any]()
    lrs["endpoint"] = "https://watershedlrs.com/api/organizations/3761/lrs/"
    lrs["auth"] = "Basic NzZkN2UxNjE4YTJhZmI6YmFjMzFmMGU0MzRkOTk="
    // just add one LRS for now
    options["recordStore"] = [lrs]
    let tincan = RSTinCanConnector(options: options)
    // create a TCActor with the user's information
    let actor = TCAgent(name: "David", withMbox: "mailto:david.crawshay@halliburton.com", withAccount: nil)
    
 
    // create a very basic TCActivityDefinition that doesn't contain any extensions or interaction detail.
    let actDef = TCActivityDefinition(name: TCLocalizedValues(languageCode: "en-US", withValue: "http://tincanapi.com/testCourse"),
                                      withDescription: TCLocalizedValues(languageCode: "en-US", withValue: "Entered machine zone"), withType: "http://adlnet.gov/expapi/activities/machinezone", withExtensions: nil, withInteractionType: nil, withCorrectResponsesPattern: nil, withChoices: nil, withScale: nil, withTarget: nil, withSteps: nil)
    
    let activity = TCActivity(id: "http://tincanapi.com/machine", with: actDef)
    let verb = TCVerb(id: "http://adlnet.gov/expapi/verbs/entered", withVerbDisplay: TCLocalizedValues(languageCode: "en-US", withValue: "entered"))

    let statementToSend = TCStatement(id: TCUtil.getUUID(), withActor: actor, withTarget: activity, with: verb, with: nil, with: nil)
    tincan!.send(statementToSend, withCompletionBlock: {() -> Void in
        // do your completion stuff here
    }, withErrorBlock: {(_ error: TCError?) -> Void in
        print("ERROR: \(error!.localizedDescription)")
    })

}

