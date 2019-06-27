# Homework 2 and 3
# Brandon and Ryan

## Part 1
my_points = 53
possible_points = 79


## 1.1
def auto_grader(points_earn, tot_points):
    grade = round(points_earn / tot_points, 2)
    return (grade)


score = auto_grader(my_points, possible_points)
print(score)


## 1.2a
def pass_fail(score, threshold):
    if (score >= threshold):
        passed = True
    else:
        passed = False


## 1.2b
def print_pass(score):
    passed = pass_fail(score, .7)
    if passed == True:
        print('You passed with a {} with a {} cut off.'.format(score, .7))
    else:
        print('You failed with a {} with a {} cut off.'.format(score, .7))


print_pass(score)


## 1.3
def print_letter_grade(score):
    if (score >= .9):
        letter_grade = "A"
    elif (score < .9 and score >= .8):
        letter_grade = "B"
    elif (score < .9 and score >= .8):
        letter_grade = "B"
    elif (score < .8 and score >= .7):
        letter_grade = "C"
    elif (score < .7 and score >= .6):
        letter_grade = "D"
    else:
        letter_grade = "F"
    return letter_grade


## 1.4
def print_letter_grade_2(score):
    letter = print_letter_grade(score)
    rounded = round(score * 100, 0)
    if rounded == 100:
        specific = "+"
    elif rounded <= 60:
        specific = ""
    elif rounded % 10 <= 2:
        specific = "-"
    elif rounded % 10 >= 7:
        specific = "+"
    else:
        specific = ''
    specific_letter = letter + specific
    return specific_letter


## 1.5
grade_type = 'pass_fail'


def evaluate_grade(score, grade_type):
    if grade_type == 'pass_fail':
        if (score >= .7):
            passed = True
            print('Pass')
        else:
            passed = False
            print('Fail')
    elif grade_type == "graded":
        graded = print_letter_grade_2(score)
        print(graded)
    return score, passed


random_numbers = [.4, .5, .74, .85, .98]
for i in random_numbers:
    print_pass(i)
    print_letter_grade(i)
    print_letter_grade_2(i)
    print(evaluate_grade(i, 'pass_fail'))

## 2.1
number = 54854788396
def perfect_square(num):
    square = num ** .5
    if square == int(square):
        return True
        # print('{} is a perfect square.' .format(num))
    else:
        return False
        # print('{} is not a perfect square' . format(num))


mor_nums = [9, 34, 80980980, 293208023, 324234320, 234098234, 23409823]
for i in mor_nums:
    print(perfect_square(i))
print(perfect_square(number))


# 2.2
def make_perf(num):
    square = num ** 0.5
    next_square = int(square) + 1
    next_num = next_square ** 2
    diff = next_num - num
    return diff

print(type(make_perf(5)))

# 2.3
def print_perf(num):
    if(perfect_square(num) == True):
        print("{} is a already a perfect square" .format(num))
    else:
        diff = make_perf(num)
        print('{} is not a perfect square, and require {} more to be a perfect square.' .format(num, diff))

print_perf(number)

# 3.1
first_fiv = []
for i in range(5):
    first_fiv.append(i)
print(first_fiv)

# 3.2
for i in range(1,11):
    if i%2 == 0:
        print('%d is even.' % i)
    else:
        print('{} is odd' .format(i))

total = 0
for i in range(11):
    total += (i ** 2)
    print(total)

# 3.4
total_2 = 0
for i in range(1001):
    if i % 3 == 0 or i % 5 == 0:
        total_2 += i
print(total_2)

# 3.5
total_2 = 0
for i in range(1001):
    if i % 3 == 0 and i % 5 == 0:
        total_2 += i
print(total_2)

# 3.6
list_perf_squares = []
for i in range(1001):
    root = i ** 0.5
    if root == int(root):
        list_perf_squares.append(i)
print(list_perf_squares)
print(len(list_perf_squares))

# 3.7
even_prod = 1
odd_prod = 1
for i in range(21):
    if i > 0:
        if i % 2 == 0:
            even_prod *= i
        else:
            odd_prod *= i
print('even', '=', even_prod)
print('odd', '=', odd_prod)

# 3.8
div_2 = []
div_3 = []
div_4 = []
div_5 = []
div_6 = []
div_7 = []
div_8 = []
div_9 = []
div_10 = []
for i in range(101):
    if i % 2 == 0:
        div_2.append(i)
    if i % 3 == 0:
        div_3.append(i)
    if i % 4 == 0:
        div_4.append(i)
    if i % 5 == 0:
        div_5.append(i)
    if i % 6 == 0:
        div_6.append(i)
    if i % 7 == 0:
        div_7.append(i)
    if i % 8 == 0:
        div_8.append(i)
    if i % 9 == 0:
        div_9.append(i)
    if i % 10 == 0:
        div_10.append(i)
print(div_2,div_3,div_4,div_5,div_6,div_7,div_8,div_9,div_10)

# 4.1
def generate_missing_number_list():
    import random
    nums = random.sample(list(range(1,100)), 10) * 2
    nums.pop()
    # random.shuffle(nums)
    print(nums)
    return nums
numbers = generate_missing_number_list()

nums_dict = {}
for number in numbers:
    nums_dict[number] = 0
print(nums_dict)
for number in numbers:
    nums_dict[number] += 1
print(nums_dict)
for number in numbers:
    if nums_dict[number] == 1:
        missing_num = number
        print(missing_num)
        break

# 5.1
# import uuid
# import numpy as np
# ids = [str(uuid.uuid4()) for _ in range(100)]
# points = [min(75, round(np.random.normal(.8,.1)*75)) for _ in range(100)]
# grade_type = [np.random.choice(['pass_fail', 'graded'], p=[.1,.9]) for _ in range(100)]
#
# student_grades = []
# for i in range(len(ids)):
#     student_points = points[i]
#     student_grade_type = grade_type[i]
#     student_score = compute_score(student_points, 75)
#     student_result = determine_transcript_result(student_score, student_grade_type)
#     all_student_results.append(student_result)
# all_student_results

# 6.1
import json
student_info = json.load(open('data_hw2_part_3.json'))
print(type(student_info))
print(student_info[2])
student_keys = student_info[2].keys()
print(student_keys)

# 6.2
all_majors = [student['major'] for student in student_info]
unique_majors = set(all_majors)
print(unique_majors)
print(len(unique_majors))

# 6.3
all_gender = [student['gender'] for student in student_info]
unique_gender = set(all_gender)
count_major_by_gender = {}
for i in unique_gender:
    count_major_by_gender[i]= {}
    for x in unique_majors:
        count_major_by_gender[i][x]= 0
for stud in student_info:
    gender = stud['gender']
    major = stud['major']
    count_major_by_gender[gender][major] += 1
print(count_major_by_gender)

def determine_largest_value_in_dict(dict_of_values):
    largest = {'key': None, 'value': -10000}
    for key in dict_of_values:
        value = dict_of_values[key]
        if value > largest['value']:
            largest['value'] = value
            largest['key'] = key
    return largest
largest_major_by_gender = {}
for gender in count_major_by_gender:
    largest_major_by_gender[gender] = {}
    gender_dict = count_major_by_gender[gender]
    largest_major_dict = determine_largest_value_in_dict(gender_dict)
    largest_major_by_gender[gender]['major'] = largest_major_dict['key']
    largest_major_by_gender[gender]['major_count'] = largest_major_dict['value']
print(largest_major_by_gender)

