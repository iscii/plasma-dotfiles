/**
 * @param {number} x
 * @return {boolean}
 */
var isPalindrome = function(x) {
    return parseInt([...x.toString()].reverse().join("")) == x;
};

console.log(isPalindrome(12231));   