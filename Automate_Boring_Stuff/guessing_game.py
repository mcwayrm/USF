#   Guessing Game

import random as rd
secret_number = rd.randint(1, 100)
print('I am thinking of a number between 1 and 100.')

for guess_taken in range(1, 10):
    print('Take a guess...')
    guess = int(input())

    if guess < secret_number:
        print('Your guess is too low.')
    elif guess > secret_number:
        print('Your guess is too high')
    else:
        break # The correct answer
if guess == secret_number:
    print('Good job! Your a guessing machine. My number was indeed ' + str(secret_number)  + '! It took you ' + str(guess_taken) + ' guesses to get it right.')
else:
    print('Nope. You did not get it. It was ' + str(secret_number))
