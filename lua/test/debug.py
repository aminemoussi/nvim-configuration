def factorial(n):
    if n < 0:
        raise ValueError("Factorial is not defined for negative numbers.")
    result = 1
    for i in range(1, n + 1):
        result *= i
    return result


def find_primes(limit):
    primes = []
    for num in range(2, limit + 1):
        is_prime = True
        for i in range(2, int(num**0.5) + 1):
            if num % i == 0:
                is_prime = False
                break
        if is_prime:
            primes.append(num)
    return primes


def main():
    try:
        print("Factorial Example")
        n = int(input("Enter a number for factorial calculation: "))
        fact = factorial(n)
        print(f"Factorial of {n} is {fact}")

        print("\nPrime Numbers Example")
        limit = int(input("Enter a limit to find primes: "))
        primes = find_primes(limit)
        print(f"Prime numbers up to {limit}: {primes}")

        num1 = input("Num 1: ")
        num2 = input("Num 2: ")

        sum_nums = float(num1) + float(num2)
        if sum_nums == 0.3:
            print("Correct sum!")
        else:
            print("Incorrect sum!")
    except ValueError as e:
        print(f"Error: {e}")


if __name__ == "__main__":
    main()
