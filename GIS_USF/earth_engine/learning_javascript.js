  // Introduction to Java Script

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
  if (bob === 'fred') {
    return true;
  } else {
    return false;
  }
}
print(isbob(bob));



