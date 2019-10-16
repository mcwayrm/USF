  // My name is Ryan McWay and this is my script.

// This is a text

var mydog = "Rascal";
print(mydog);

// This is a number
var age = 20;
print(age);

print('My dogs name is ' + mydog + " and she is " + age);

// Practice indexing from a list
var my_list = ['poverty', 'duflo', 'southeast asia'];
print(my_list[1]);

// Playing around with a dictionary
var my_dict = {'food': 'bead', 'dog': mydog, 'number': age};
    // Can index in two differnt ways
print(my_dict['dog']);
print(my_dict.dog);

// Getting into functions
var say_hello = function(string) {
  var uppercase_name = string.toUpperCase()
  return 'Hello ' + uppercase_name + '!';
};
print(say_hello('david'))
