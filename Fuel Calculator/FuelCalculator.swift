import Foundation

struct FuelCalculator {
    
    static func calculate(petrol: Double, ethanol: Double) -> String {
        
        let ethanolRatio = ethanol / petrol
        
        if ethanolRatio <= 0.700001 {
            return "Ethanol is the better option."
        } else {
            return "Petrol is the better option."
        }
    }
    
    static func percentage(petrol: Double, ethanol: Double) -> String {
        
        let ethanolPercentage = (ethanol / petrol) * 100
        
        return String(format: "%.1f%% of the petrol price", ethanolPercentage)
    }
}
