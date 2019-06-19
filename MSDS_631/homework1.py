### Part 5

# 1 ----------------------------------------------------------
num_students = 1000
capacity_of_each_bus = 72

min_bus = num_students // capacity_of_each_bus + 1
print('You need a minimum of %d buses.' % min_bus)

# 2 ------------------------------------------------------------

last_bus = num_students % capacity_of_each_bus
cap_last_bus = last_bus / capacity_of_each_bus
print('Last bus has a capacity of %.2f' % cap_last_bus)

# 3 ------------------------------------------------------------

tot_cap = num_students // min_bus +1
print("Overall students crammed on a bus is %d" % tot_cap)

# 4 ------------------------------------------------------------
max_out = num_students%min_bus
print('There are %d maxed out buses.' % max_out)
