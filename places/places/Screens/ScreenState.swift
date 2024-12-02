//
//  ScreenState.swift
//  Places
//
//  Created by Sergey Bendak on 2.12.2024.
//

enum ScreenState {
    case loading
    case success([DisplayLocation])
    case error(String)
}
