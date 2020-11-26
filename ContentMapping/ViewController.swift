//
//  ViewController.swift
//  ContentMapping
//
//  Created by Kevin van den Hoek on 26/11/2020.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var labelYPos: CGFloat = 100 * scale // dirty solution to lay out labels below eachother without autolayout
    var scale: CGFloat { (view.bounds.width / 375) }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let topLevelSections = TableOfContentsMapper().map(
            elementTypes: ["h1", "h2", "h3"],
            in: Document(
                with: [
                    Document.Element(type: "h1", text: "Busta"),
                    Document.Element(type: "h2", text: "Oen"),
                    Document.Element(type: "h3", text: "Hoe kon je dat doen?"),
                    Document.Element(type: "h1", text: "MC"),
                    Document.Element(type: "h3", text: "Geen rat"),
                    Document.Element(type: "h2", text: "Geen oen"),
                    Document.Element(type: "h1", text: "Terneuzen"),
                    Document.Element(type: "h2", text: "Kneuzen?"),
                    Document.Element(type: "h2", text: "Stemmen van meisjes"),
                    Document.Element(type: "h3", text: "Hand over je dij"),
                    Document.Element(type: "h2", text: "Billy"),
                    Document.Element(type: "h1", text: "Martijn"),
                    Document.Element(type: "h2", text: "Groepje achter me aan"),
                    Document.Element(type: "h3", text: "Toch blijf ik staan")
                ]
            )
        )
        topLevelSections.forEach({
            addLabel(for: $0)
            labelYPos += 26 * scale
        })
    }
    
    /// Adds a text to the view
    func addLabel(for section: DocumentSection) {
        let label = UILabel()
        label.text = section.title
        label.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        label.font = .for(section, scale: scale)
        label.alpha = 1 - (CGFloat(section.level) * 0.3)
        
        view.addSubview(label)
        let inset: CGFloat = 20
        let x: CGFloat = inset + (CGFloat(section.level) * inset)
        let labelHeight: CGFloat = 30 * scale
        label.frame = CGRect(
            x: x,
            y: labelYPos,
            width: view.bounds.width - (x + inset),
            height: labelHeight
        )
        
        labelYPos += labelHeight
        section.subsections.forEach({ addLabel(for: $0) })
    }
}

// MARK: Font helpers
private extension UIFont {
    
    static func `for`(_ section: DocumentSection, scale: CGFloat) -> UIFont {
        return UIFont.monospacedSystemFont(ofSize: 20 * scale, weight: weight(for: section))
    }
    
    private static func weight(for section: DocumentSection) -> UIFont.Weight {
        switch section.level {
        case 0:
            return .bold
        case 1:
            return .medium
        default:
            return .regular
        }
    }
}
