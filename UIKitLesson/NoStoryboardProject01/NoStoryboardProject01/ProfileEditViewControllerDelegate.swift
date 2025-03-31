//
//  ProfileEditViewControllerDelegate.swift
//  NoStoryboardProject01
//
//  Created by 원대한 on 3/17/25.
//


import Foundation

protocol ProfileEditViewControllerDelegate: AnyObject {
    func didUpdateProfile(name: String, genres: [String])
}