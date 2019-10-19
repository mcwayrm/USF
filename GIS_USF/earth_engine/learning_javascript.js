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

