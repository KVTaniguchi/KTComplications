//
//  ComplicationController.swift
//  KTComplicationsWatchDemp Extension
//
//  Created by Kevin Taniguchi on 6/12/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import ClockKit
import WatchConnectivity

class ComplicationController: NSObject, CLKComplicationDataSource, WCSessionDelegate {
    
    // MARK: - Timeline Configuration
    
    func getSupportedTimeTravelDirectionsForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.Forward, .Backward])
    }
    
    func getTimelineStartDateForComplication(complication: CLKComplication, withHandler handler: (NSDate?) -> Void) {
        handler(nil)
    }
    
    func getTimelineEndDateForComplication(complication: CLKComplication, withHandler handler: (NSDate?) -> Void) {
        handler(nil)
    }
    
    func getPrivacyBehaviorForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.ShowOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntryForComplication(complication: CLKComplication, withHandler handler: ((CLKComplicationTimelineEntry?) -> Void)) {
        // Call the handler with the current timeline entry
        handler(nil)
    }
    
    func getTimelineEntriesForComplication(complication: CLKComplication, beforeDate date: NSDate, limit: Int, withHandler handler: (([CLKComplicationTimelineEntry]?) -> Void)) {
        // Call the handler with the timeline entries prior to the given date
        handler(nil)
    }
    
    func getTimelineEntriesForComplication(complication: CLKComplication, afterDate date: NSDate, limit: Int, withHandler handler: (([CLKComplicationTimelineEntry]?) -> Void)) {
        // Call the handler with the timeline entries after to the given date
        handler(nil)
    }
    
    // MARK: - Update Scheduling
    
    func getNextRequestedUpdateDateWithHandler(handler: (NSDate?) -> Void) {
        // Call the handler with the date when you would next like to be given the opportunity to update your complication content
        handler(nil);
    }
    
    // MARK: - Placeholder Templates
    
    func getPlaceholderTemplateForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        handler(nil)
    }
    
    func setUpWCSession () {
        guard WCSession.isSupported() else { return }
        WCSession.defaultSession().delegate = self
        WCSession.defaultSession().activateSession()
    }
    
    func updateComplication() {
        setUpWCSession()
        let clkServer = CLKComplicationServer.sharedInstance()
        guard let activeComps = clkServer.activeComplications else { return }
        for comp in activeComps {
            clkServer.reloadTimelineForComplication(comp)
        }
    }
    
    func timelineEntryForFamily(family: CLKComplicationFamily, imageURL: NSURL?, message: String?) -> CLKComplicationTimelineEntry? {
        switch family {
        case .CircularSmall:
            guard let simpleTemplate = templateForFamily(.CircularSmall) else { return nil }
            return CLKComplicationTimelineEntry(date: NSDate(), complicationTemplate: simpleTemplate)
        case .ModularLarge:
            guard let modLargeTemplate = templateForFamily(.ModularLarge) else { return nil }
            return CLKComplicationTimelineEntry(date: NSDate(), complicationTemplate: modLargeTemplate)
        case .ModularSmall:
            guard let modSmallTemplate = templateForFamily(.ModularSmall) else { return nil }
            return CLKComplicationTimelineEntry(date: NSDate(), complicationTemplate: modSmallTemplate)
        case .UtilitarianLarge:
            guard let utilLargeTemplate = templateForFamily(.UtilitarianLarge) else { return nil }
            return CLKComplicationTimelineEntry(date: NSDate(), complicationTemplate: utilLargeTemplate)
        case .UtilitarianSmall:
            guard let utilSmallTemplate = templateForFamily(.UtilitarianSmall) else { return nil }
            return CLKComplicationTimelineEntry(date: NSDate(), complicationTemplate: utilSmallTemplate)
        }
    }
    
    func templateForFamily(family : CLKComplicationFamily) -> CLKComplicationTemplate? {
        let isLargeWatch = WKInterfaceDevice.currentDevice().screenBounds.width > 136 ? true : false
        
        switch family {
        case .CircularSmall:
            if let data = compData {
                let template = CLKComplicationTemplateCircularSmallSimpleImage()
                guard let image = getImageFromDataWithDimension(isLargeWatch ? 36 : 32, data: data) else { break }
                template.imageProvider = CLKImageProvider(onePieceImage: image)
                return template
            }
            else if let imgURL = imageURL {
                let template = CLKComplicationTemplateCircularSmallSimpleImage()
                guard let image = getImageWithDimension(isLargeWatch ? 36.0 : 32.0, fileURL: imgURL) else { break }
                template.imageProvider = CLKImageProvider(onePieceImage: image)
                return template
            }
            else if let msg = smallMsg {
                let template = CLKComplicationTemplateCircularSmallSimpleText()
                template.textProvider = CLKSimpleTextProvider(text: msg)
                return template
            }
        case .ModularLarge:
            let template = CLKComplicationTemplateModularLargeTallBody()
            template.bodyTextProvider = CLKSimpleTextProvider(text: longMsg)
            template.headerTextProvider = CLKSimpleTextProvider(text: " ")
            return template
        case .ModularSmall:
            if let data = compData {
                let template = CLKComplicationTemplateModularSmallSimpleImage()
                guard let image = UIImage(data: data) else { break }
                template.imageProvider = CLKImageProvider(onePieceImage: image)
                return template
            }
            else if let url = imageURL {
                let template = CLKComplicationTemplateModularSmallSimpleImage()
                guard let image = getImageWithDimension(isLargeWatch ? 58 : 52, fileURL: url) else { break }
                template.imageProvider = CLKImageProvider(onePieceImage: image)
                return template
            }
            else if let msg = smallMsg {
                let template = CLKComplicationTemplateModularSmallSimpleText()
                template.textProvider = CLKSimpleTextProvider(text: msg)
                return template
            }
        case .UtilitarianLarge:
            let template = CLKComplicationTemplateUtilitarianLargeFlat()
            if let data = compData {
                guard let image = getImageFromDataWithDimension(isLargeWatch ? 20 : 18, data: data) else { break }
                template.imageProvider = CLKImageProvider(onePieceImage: image)
            }
            else if let url = imageURL {
                let image = getImageWithDimension(isLargeWatch ? 20.0 : 18.0, fileURL: url)
                guard let img = image else { break }
                template.imageProvider = CLKImageProvider(onePieceImage: img)
            }
            template.textProvider = CLKSimpleTextProvider(text: longMsg)
            
            return template
        case .UtilitarianSmall:
            let template = CLKComplicationTemplateUtilitarianSmallFlat()
            if let data = compData {
                guard let image = getImageFromDataWithDimension(isLargeWatch ? 20 : 18, data: data) else { break }
                template.imageProvider = CLKImageProvider(onePieceImage: image)
                return template
            }
            else if let url = imageURL {
                let image = getImageWithDimension(isLargeWatch ? 20.0 : 18.0, fileURL: url)
                guard let img = image else { break }
                template.imageProvider = CLKImageProvider(onePieceImage: img)
            }
            if let text = smallMsg {
                template.textProvider = CLKSimpleTextProvider(text: text)
            }
            return template
        }
        
        return nil
    }

    
}
