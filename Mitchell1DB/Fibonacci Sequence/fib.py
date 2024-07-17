def is_fibonacci_number(n):
    # Build list with Fibonacci numbers up to 100
    a, b = 0, 1
    nums = []
    while a <= 100:
        nums.append(a)
        a, b = b, a + b
    return n in nums

while True:
    user_input = input("Enter a number between 1 and 100 or type 'exit' or 'quit' to exit the program: ")
    
    if user_input.lower() == 'exit' or user_input.lower() == 'quit' :
        print("Exiting the program. Goodbye!")
        break
    
    if user_input.isdigit():
        number = int(user_input)
        if 1 <= number <= 100:
            if is_fibonacci_number(number):
                print(f"{number} is in the Fibonacci sequence.")
            else:
                print(f"{number} is not in the Fibonacci sequence.")
        else:
            print("Number out of range. Please enter a number between 1 and 100.")
    else:
        print("Invalid input. Please enter a valid number between 1 and 100 or type 'exit' to quit.")
