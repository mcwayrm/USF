# yourName.py
# Flow Control with a while loop
player_name = ''
while player_name != 'your name':
    print('Please enter your name.')
    player_name = input()
print('So, you like riddles do you?')

# With a break statement instead
while True:
    print('Please type name')
    name = input()
    if name == 'your name':
        break
print('Thank god...')
