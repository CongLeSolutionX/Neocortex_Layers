//
//MIT License
//
//Copyright © 2025 Cong Le
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all
//copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//SOFTWARE.
//
//
//  NeocortexLayersView.swift
//  Neocortex_Layers
//
//  Created by Cong Le on 6/29/25.
//


import SwiftUI

// MARK: - Data Model
/// Represents a single layer of the cerebral cortex, conforming to `Identifiable` for use in SwiftUI lists.
/// This struct encapsulates all the biological data associated with a cortical layer.
struct CorticalLayer: Identifiable, Equatable {
    /// A unique identifier for each layer instance, required by `ForEach`.
    let id = UUID()
    
    /// The formal name of the layer (e.g., "Layer I").
    let name: String
    
    /// The common or descriptive name of the layer (e.g., "Molecular Layer").
    let commonName: String
    
    /// A list of the primary cell types found within this layer.
    let keyCellTypes: [String]
    
    /// The developmental timeline for this layer's formation in mouse embryos, a common model organism.
    let formationTimingMouse: String
    
    /// Key genetic or protein markers used to identify this layer in scientific research.
    let keyMarkers: [String]
    
    /// A distinct color used for visual representation in the UI.
    let color: Color
}


// MARK: - Main View
/// A SwiftUI view that visualizes the six layers of the neocortex.
/// It displays the layers in their anatomical order and allows users to tap on each layer
/// to reveal detailed information about its composition and development.
struct NeocortexLayersView: View {
    
    // --- Data Source ---
    /// An array of `CorticalLayer` objects, serving as the single source of truth for the view.
    /// This data is based on the information provided in the corticogenesis documentation.
    private let corticalLayers: [CorticalLayer] = [
        CorticalLayer(name: "Layer I", commonName: "Molecular Layer", keyCellTypes: ["Cajal-Retzius cells", "Pyramidal cells"], formationTimingMouse: "E10.5 - E12.5", keyMarkers: ["Reelin", "T-box brain 1"], color: .purple),
        CorticalLayer(name: "Layer II", commonName: "External Granular Layer", keyCellTypes: ["Pyramidal neurons", "Stellate cells", "Astrocytes"], formationTimingMouse: "E13.5 - E16", keyMarkers: ["SATB2", "CUX1"], color: .blue),
        CorticalLayer(name: "Layer III", commonName: "External Pyramidal Layer", keyCellTypes: ["Pyramidal neurons", "Stellate cells"], formationTimingMouse: "E13.5 - E16", keyMarkers: ["SATB2", "CUX1"], color: .cyan),
        CorticalLayer(name: "Layer IV", commonName: "Internal Granular Layer", keyCellTypes: ["Stellate cells", "Pyramidal neurons"], formationTimingMouse: "E11.5 - E14.5", keyMarkers: ["TBR1", "OTX1"], color: .green),
        CorticalLayer(name: "Layer V", commonName: "Internal Pyramidal Layer", keyCellTypes: ["Pyramidal neurons", "Radial glia"], formationTimingMouse: "E11.5 - E14.5", keyMarkers: ["TBR1", "CTIP2", "OTX1"], color: .orange),
        CorticalLayer(name: "Layer VI", commonName: "Multiform Layer", keyCellTypes: ["Pyramidal neurons", "Radial glia"], formationTimingMouse: "E11.5 - E14.5", keyMarkers: ["TBR1", "OTX1"], color: .red)
    ]
    
    // --- State ---
    /// Tracks the `id` of the currently selected layer to control the accordion UI effect.
    /// When `nil`, all layers are collapsed. When set to a layer's `id`, that layer expands.
    @State private var selectedLayerID: UUID?

    // --- Body ---
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 12) {
                    // --- Header ---
                    VStack {
                        Image(systemName: "brain.head.profile").font(.system(size: 40)).foregroundColor(.accentColor)
                        Text("The 6 Layers of the Neocortex")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                        
                        Text("Corticogenesis results in a highly organized, six-layered structure. The layers are formed in an 'inside-out' sequence (VI → V → IV → III → II). Tap a layer below to learn more.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.top, 2)
                    }
                    .padding(.bottom)
                    
                    // --- Layers List ---
                    // Dynamically create a view for each layer from the data source.
                    ForEach(corticalLayers) { layer in
                        LayerRowView(layer: layer, selectedLayerID: $selectedLayerID)
                    }
                }
                .padding()
            }
            .navigationTitle("Cortex Development 🧠")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}


// MARK: - Reusable Components
/// A view that represents a single, tappable row for a cortical layer.
/// It displays a summary and can be expanded to show detailed information.
private struct LayerRowView: View {
    let layer: CorticalLayer
    @Binding var selectedLayerID: UUID?
    
    /// A computed property to determine if this row is the currently selected one.
    private var isSelected: Bool {
        selectedLayerID == layer.id
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // --- Tappable Header Section ---
            // This part is always visible.
            HStack {
                Text(layer.name)
                    .font(.title2)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                
                Text(layer.commonName)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white.opacity(0.85))
                
                Spacer()
                
                Image(systemName: isSelected ? "chevron.down.circle.fill" : "chevron.right.circle.fill")
                    .font(.title2)
                    .foregroundColor(.white.opacity(0.7))
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(layer.color.gradient)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            // Accessibility for the header element.
            .accessibilityElement(children: .combine)
            .accessibilityLabel("\(layer.name): \(layer.commonName)")
            .accessibilityHint(isSelected ? "Tap to collapse details." : "Tap to expand details.")
            
            // --- Expandable Details Section ---
            // This `VStack` is conditionally shown based on the `isSelected` state.
            if isSelected {
                VStack(alignment: .leading, spacing: 14) {
                    DetailItemView(symbolName: "person.3.sequence.fill", label: "Key Cell Types", values: layer.keyCellTypes)
                    DetailItemView(symbolName: "calendar.badge.clock", label: "Formation Timing (Mouse)", values: [layer.formationTimingMouse])
                    DetailItemView(symbolName: "line.3.crossed.swirl.circle.fill", label: "Key Genetic Markers", values: layer.keyMarkers)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemGray6))
                 // Ensures the details view has rounded bottom corners to match the container.
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .offset(y: -10) // Tucks the details under the header slightly.
                .transition(.asymmetric(
                    insertion: .opacity.combined(with: .move(edge: .top)),
                    removal: .opacity.animation(.easeOut(duration: 0.2)))
                )
            }
        }
        .onTapGesture {
            // Animate the change in selection state.
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                // If the current layer is already selected, tapping it will deselect it (collapse).
                // Otherwise, it becomes the new selected layer (expand).
                selectedLayerID = isSelected ? nil : layer.id
            }
        }
    }
}


/// A small, reusable view to display a single piece of detail with an SF Symbol icon.
private struct DetailItemView: View {
    let symbolName: String
    let label: String
    let values: [String]
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: symbolName)
                .font(.headline)
                .frame(width: 25)
                .foregroundColor(.accentColor)
            
            VStack(alignment: .leading) {
                Text(label)
                    .fontWeight(.bold)
                // Joins the array of values into a single comma-separated string for display.
                Text(values.joined(separator: ", "))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            // Add accessibility to each detail row.
            .accessibilityElement(children: .combine)
            .accessibilityLabel(label)
            .accessibilityValue(values.joined(separator: ", "))
        }
    }
}


// MARK: - Xcode Preview
#Preview {
    NeocortexLayersView()
}
