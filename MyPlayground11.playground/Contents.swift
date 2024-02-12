import Foundation

let fruitsArray = ["apple", "mango", "blueberry", "orange"]
let vegArray = ["tomato", "potato", "mango", "blueberry"]


let commonVeg = fruitsArray.filter{vegArray.contains($0)}
    
let output = fruitsArray.filter{ vegArray.contains($0) }
print(output)

for countdown in stride(from: 3, to: 0, by: -1) {
    print("\(countdown)...")
}
