# exitExample.py
# Flow Control by terminating the program
import sys
while True:
    print('Type exit to exit')
    response = input()
    if response == 'exit':
        sys.exit()
    print('You typed ' + response + ' and not exit.')
