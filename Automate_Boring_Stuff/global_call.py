# Calling a Global

def spam():
    global eggs
    eggs = 'spam'
eggs = 'global'
spam()
print(eggs)
