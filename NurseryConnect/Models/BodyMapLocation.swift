//
//  BodyMapLocation.swift
//  NurseryConnect
//

import Foundation

enum BodyMapLocation: String, CaseIterable, Identifiable {
    case head, face, neck, leftArm, rightArm, leftHand, rightHand
    case torso, back, leftLeg, rightLeg, leftFoot, rightFoot

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .head: return "Head"
        case .face: return "Face"
        case .neck: return "Neck"
        case .leftArm: return "Left Arm"
        case .rightArm: return "Right Arm"
        case .leftHand: return "Left Hand"
        case .rightHand: return "Right Hand"
        case .torso: return "Torso"
        case .back: return "Back"
        case .leftLeg: return "Left Leg"
        case .rightLeg: return "Right Leg"
        case .leftFoot: return "Left Foot"
        case .rightFoot: return "Right Foot"
        }
    }
}
