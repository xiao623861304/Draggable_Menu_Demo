//
//  DraggableSnappingMenuBar.swift
//  Draggable_Menu_Demo
//
//  Created by yan feng on 5/1/25.
//

import SwiftUI

struct DraggableSnappingMenuBar: View {
    @State private var position: CGPoint = CGPoint(x: 0, y: 0)
    @GestureState private var dragOffset: CGSize = .zero
    @State private var layoutDirection: Axis = .vertical
    @State private var selectedID: Int? = nil

    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let screenHeight = geometry.size.height
            let padding: CGFloat = 20

            let isHorizontal = layoutDirection == .horizontal
            let sidebarWidth: CGFloat = isHorizontal ? UIScreen.main.bounds.width : 200
            let sidebarHeight: CGFloat = isHorizontal ? 200 : UIScreen.main.bounds.height

            Group {
                content
            }
            .padding()
            .frame(width: sidebarWidth, height: sidebarHeight)
            .background(Color.teal)
            .offset(x: dragOffset.width, y: dragOffset.height)
            .position(position)
            .gesture(
                DragGesture()
                    .updating($dragOffset) { value, state, _ in
                        state = value.translation
                    }
                    .onEnded { value in
                        let newX = position.x + value.translation.width
                        let newY = position.y + value.translation.height

                        let distances: [Edge: CGFloat] = [
                            .top: newY,
                            .bottom: screenHeight - newY,
                            .leading: newX,
                            .trailing: screenWidth - newX
                        ]

                        if let nearest = distances.min(by: { $0.value < $1.value })?.key {
                            var snappedX = newX
                            var snappedY = newY
                            var newAxis: Axis = .vertical

                            switch nearest {
                            case .top:
                                snappedY = padding
                                newAxis = .horizontal
                            case .bottom:
                                snappedY = screenHeight - padding
                                newAxis = .horizontal
                            case .leading:
                                snappedX = padding
                                newAxis = .vertical
                            case .trailing:
                                snappedX = screenWidth - padding
                                newAxis = .vertical
                            }

                            withAnimation() {
                                position = CGPoint(x: snappedX, y: snappedY)
                                layoutDirection = newAxis
                            }
                        }
                    }
            )
        }
    }

    // MARK: - 内部内容视图
    var content: some View {
        Group {
            if layoutDirection == .vertical {
                VStack(spacing: 20) {
                    ForEach(0..<8) { index in
                        Button {
                            selectedID = index
                        } label: {
                            Text("Button_\(index)")
                                .foregroundColor(selectedID == index ? .white : .black)
                        }
                        Spacer(minLength: 10)
                    }
                }
            } else {
                HStack(spacing: 20) {
                    ForEach(0..<8) { index in
                        Button {
                            selectedID = index
                        } label: {
                            Text("Button_\(index)")
                                .foregroundColor(selectedID == index ? .white : .black)
                        }
                    }
                }
            }
        }
        .font(.headline)
        .foregroundColor(.white)
    }
}




struct DraggableSnappingMenuBar_Previews: PreviewProvider {
    static var previews: some View {
        DraggableSnappingMenuBar()
    }
}
