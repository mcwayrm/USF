/*********************************
    Introduction to Java Script
**********************************/

/*********************************
        Grammar and Types
**********************************/

// Greet Me function
(function(){
  "use strict";
  /* Start of your code */
  function greetMe(yourName) {
    alert('Hello ' + yourName);
  }
  
  greetMe('World');
  /* End of your code */
})();

// determine length
var bob = 'What a weird dude';
print(bob.length);

// Simple function build, note equality it '==='
function isbob(bob) {
  if (bob == 'fred') {
    return true;
  } else {
    return false;
  }
}
print(isbob(bob));


/*********************************
  Control Flow and Error Handling
**********************************/

// Switch Statement
var fruittype = 'Apples';
switch (fruittype) {
  case 'Oranges':
    console.log('Oranges are $0.59 a pound.');
    break;
  case 'Apples':
    console.log('Apples are $0.32 a pound.');
    break;
  case 'Bananas':
    console.log('Bananas are $0.48 a pound.');
    break;
  case 'Cherries':
    console.log('Cherries are $3.00 a pound.');
    break;
  case 'Mangoes':
    console.log('Mangoes are $0.56 a pound.');
    break;
  case 'Papayas':
    console.log('Mangoes and papayas are $2.79 a pound.');
    break;
  default:
   console.log('Sorry, we are out of ' + fruittype + '.');
}
console.log("Is there anything else you'd like?");

//    Exceptions: Throw and try... catch
var myMonth = 'None Exsistent Month';
function getMonthName(mo) {
  // (1 = Jan, 12 = Dec)
  mo = mo - 1; 
  var months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul',
                'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  if (months[mo]) {
    return months[mo];
  } else {
    // throw keyword
    throw 'Invalid Month No.'; 
  }
}
// statements to try
try { 
  var monthName = getMonthName(myMonth);
}
catch (e) {
  monthName = 'unknown';
  // pass exception object to error handler -> your own function
  console.log(myMonth + ' is unknown.'); 
}

/*********************************
    Loops and Iteration
**********************************/

// Simple For Loop
for (let step = 0; step < 5; step++) {
  // Runs 5 times, with values of step 0 through 4.
  console.log('Walking east one step', step);
}

// Do While Loop
let i = 0;
do {
  i += 1;
  console.log(i);
} while (i < 5);

// While Loop
let n = 0;
let x = 0;
while (n < 3) {
  n++;
  x += n;
}

// Labels
// markLoop:
// while (theMark === true) {
//   doSomething();
// }

// Break Statement
var a = [2, 3, 5, 8];
for (let i = 0; i < a.length; i++) {
  if (a[i] === 5) {
    print('Element ', i, 'in ', a, 'is 5.');
    break;
  }
}

// Break with a Label
let t = 0;
let z = 0;
labelCancelLoops: while (true) {
  console.log('Outer loops: ' + t);
  t += 1;
  z = 1;
  while (true) {
    console.log('Inner loops: ' + z);
    z += 1;
    if (z === 10 && t === 10) {
      break labelCancelLoops;
    } else if (z === 10) {
      break;
    }
  }
}

// Continue Statement
let i2 = 0;
let j = 10;
checkiandj:
  while (i2 < 4) {
    console.log(i2);
    i2 += 1;
    checkj:
      while (j > 4) {
        console.log(j);
        j -= 1;
        if ((j % 2) === 0) {
          continue checkj;
        }
        console.log(j + ' is odd.');
      }
      console.log('i = ' + i2);
      console.log('j = ' + j);
  }
