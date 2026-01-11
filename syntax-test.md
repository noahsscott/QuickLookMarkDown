# Syntax Highlighting Test

This file tests if syntax highlighting is working.

## JavaScript Example

```javascript
// This is a comment
function calculateTotal(price, quantity) {
    const taxRate = 0.08;
    const subtotal = price * quantity;
    const tax = subtotal * taxRate;

    if (subtotal > 100) {
        return subtotal + tax - 10; // Discount for orders over $100
    }

    return subtotal + tax;
}

const total = calculateTotal(25.99, 3);
console.log("Total: $" + total.toFixed(2));
```

## Python Example

```python
# Calculate fibonacci numbers
def fibonacci(n):
    if n <= 1:
        return n
    return fibonacci(n-1) + fibonacci(n-2)

# Print first 10 fibonacci numbers
for i in range(10):
    print(f"Fibonacci({i}) = {fibonacci(i)}")
```

## Expected Colors

If syntax highlighting is working, you should see:
- **Keywords** (function, const, return, if, def) in one color
- **Strings** ("Total: $", comments) in another color
- **Numbers** (0.08, 25.99, 3, 100, 10) in another color
- **Function names** (calculateTotal, fibonacci) in another color
- **Comments** should be italicized and a different color
