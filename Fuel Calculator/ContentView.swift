import SwiftUI

struct ContentView: View {
    
    @State private var petrolPrice = ""
    @State private var ethanolPrice = ""
    
    @State private var result = ""
    @State private var percentage = ""
    
    @State private var showingError = false
    
    private var isEthanolBetter: Bool {
        result == "Ethanol is the better option."
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    
                    // MARK: - Logo
                    
                    Image(.appLogo)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 90, height: 90)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                        .padding(.top, 10)
                    
                    // MARK: - Header
                    
                    VStack(spacing: 8) {
                        Text("Fuel Calculator")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("Find the best fuel option for your car")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    
                    // MARK: - Fuel Prices
                    
                    VStack(spacing: 16) {
                        
                        FuelPriceField(
                            title: "Petrol",
                            placeholder: "Enter petrol price",
                            text: $petrolPrice
                        )
                        
                        FuelPriceField(
                            title: "Ethanol",
                            placeholder: "Enter ethanol price",
                            text: $ethanolPrice
                        )
                    }
                    
                    // MARK: - Calculate Button
                    
                    Button {
                        calculatePrice()
                    } label: {
                        Text("Compare Fuel Prices")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 4)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    
                    // MARK: - Result
                    
                    if !result.isEmpty {
                        ResultCard(
                            result: result,
                            percentage: percentage,
                            isEthanolBetter: isEthanolBetter
                        )
                    }
                    
                    Spacer(minLength: 20)
                }
                .padding(.horizontal)
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Invalid price", isPresented: $showingError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Please enter valid fuel prices greater than zero.")
            }
        }
    }
    
    // MARK: - Calculation
    
    private func calculatePrice() {
        
        let petrolText = petrolPrice
            .replacingOccurrences(of: ",", with: ".")
        
        let ethanolText = ethanolPrice
            .replacingOccurrences(of: ",", with: ".")
        
        guard let petrol = Double(petrolText),
              let ethanol = Double(ethanolText),
              petrol > 0,
              ethanol > 0 else {
            
            result = ""
            percentage = ""
            showingError = true
            return
        }
        
        let ethanolPercentage = (ethanol / petrol) * 100
        
        percentage = String(format: "%.1f%% of the petrol price", ethanolPercentage)
        
        let EthanolRatio = ethanol / petrol
        
        if ethanol / petrol <= 0.700001 {
            result = "Ethanol is the better option."
        } else {
            result = "Petrol is the better option."
        }
    }
}

// MARK: - Fuel Price Field

struct FuelPriceField: View {
    
    let title: String
    let placeholder: String
    
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            Text(title)
                .font(.headline)
            
            HStack {
                
                Text("R$")
                    .foregroundStyle(.secondary)
                
                TextField(placeholder, text: $text)
                    .keyboardType(.decimalPad)
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

// MARK: - Result Card

struct ResultCard: View {
    
    let result: String
    let percentage: String
    let isEthanolBetter: Bool
    
    var body: some View {
        VStack(spacing: 12) {
            
            Image(
                systemName: isEthanolBetter
                ? "checkmark.circle.fill"
                : "fuelpump.fill"
            )
            .font(.system(size: 36))
            
            Text(result)
                .font(.headline)
                .multilineTextAlignment(.center)
            
            Text(percentage)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            Text("Based on the 70% fuel price rule.")
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    ContentView()
}

