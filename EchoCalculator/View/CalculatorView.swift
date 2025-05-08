import SwiftUI

struct CalculatorView: View {
    @StateObject private var viewModel = CalculatorViewModel()
    @State private var showHistory = false // Toggle for history view

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        GeometryReader { geometry in
            let isLandscape = geometry.size.width > geometry.size.height

            Group {
                if isLandscape {
                    // Landscape layout
                    HStack {
                        displaySection(width: geometry.size.width * 0.4)
                        buttonsSection(width: geometry.size.width * 0.6, height: geometry.size.height)
                    }
                    .edgesIgnoringSafeArea(.bottom)
                } else {
                    // Portrait layout
                    VStack(spacing: 0) {
                        displaySection(width: geometry.size.width)
                        buttonsSection(width: geometry.size.width, height: geometry.size.height)
                            .frame(maxHeight: .infinity)
                    }
                    .frame(maxHeight: .infinity, alignment: .bottom)
                }
            }
            .background(Color("Background"))
        }
    }

    // Display input/result/history
    private func displaySection(width: CGFloat) -> some View {
        VStack(alignment: .trailing, spacing: 12) {
            HStack {
                Spacer()
                Button(action: {
                    showHistory.toggle()
                }) {
                    Image(systemName: "clock.arrow.circlepath")
                        .font(.title2)
                        .padding()
                }
            }

            Text(viewModel.model.input.isEmpty ? "0" : viewModel.model.input)
                .font(.system(size: width * 0.08, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.horizontal)
                .foregroundColor(Color.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.5)

            Text(viewModel.model.result)
                .font(.system(size: width * 0.06))
                .frame(maxWidth: .infinity, alignment: .trailing)
                .foregroundColor(.secondary)
                .padding(.horizontal)

            if showHistory {
                ScrollView {
                    VStack(alignment: .trailing, spacing: 8) {
                        ForEach(viewModel.model.history.reversed(), id: \.self) { entry in
                            Text(entry)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .padding(.trailing)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding(.bottom, 10)
            }
        }
    }

    // Button grid layout
    private func buttonsSection(width: CGFloat, height: CGFloat) -> some View {
        VStack(spacing: 12) {
            ForEach(viewModel.buttons, id: \.self) { row in
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(row, id: \.self) { button in
                        Button(action: {
                            viewModel.handleTap(button)
                        }) {
                            Text(button)
                                .font(.system(size: width * 0.08, weight: .medium))
                                .frame(minWidth: 0,
                                       maxWidth: .infinity,
                                       minHeight: (height * 0.14)) // Flexible button height
                                .background(Color.blue)
                                .foregroundColor(Color.white)
                                .cornerRadius(12)
                                .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)
                        }
                    }
                }
            }
        }
        .frame(maxHeight: .infinity)
        .padding(.horizontal)
    }
}

#Preview {
    CalculatorView()
}
