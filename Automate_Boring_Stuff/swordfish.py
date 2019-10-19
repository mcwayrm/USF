# swordfish.py
# Flow Control with a continue statement
while True:
    print('Who goes there?')
    goer_of_there = input()
    if goer_of_there != 'Joe':
        continue
    print('Hello, Joesph. Are you the key master?')
    password = input('fishy password')
    if password == 'swordfish':
        break
print('Access granted')
