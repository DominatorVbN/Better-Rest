//
//  Backgroundmodifiers.swift
//  Better Rest
//
//  Created by dominator on 01/11/19.
//  Copyright © 2019 dominator. All rights reserved.
//

import SwiftUI

struct BackgroundModifer: ViewModifier{
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color(UIColor.systemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 3))
            .shadow(color: Color(UIColor.systemGray), radius: 2, x: 0, y: 1)
            .padding([.top,.leading,.trailing])
        
    }
}
extension View{
    func addBackgroundStyle() -> some View{
        self.modifier(BackgroundModifer())
    }
}
