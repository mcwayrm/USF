# Vampire.py
# Flow Control with an if statement
name = input('Please type your name: ')
age = int(input('What is your age? '))
if name == 'Alice':
    print('Hi, Alice!')
elif age < 12:
    print('You aren\'t alice kiddo.')
elif age > 2000:
    print('Unlike you, Alice is not an undead, immortal vampire!')
elif age > 100:
    print('You are not Alice, grannie!')
else:
    print('Hello stranger...')
