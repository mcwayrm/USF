#   Divide by Zero and Handle an Error

def divide(divideBy):
    try:
        return 42/ divideBy
    except ZeroDivisionError:
        print('Error: Invalid argument.')
print(divide(2))
print(divide(9))
print(divide(3))
print(divide(0))
