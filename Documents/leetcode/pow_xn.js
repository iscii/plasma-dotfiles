/**
 * @param {number} x
 * @param {number} n
 * @return {number}
 */
var myPow = function(x, n) {
    return x**n;
};

/**
 * @param {number} x
 * @param {number} n
 * @return {number}
 */
var myPow = function(x, n) {
    if(n==0) return 1;
    if(n<0) return 1.0/x*myPow(x,n+1);
    return x * myPow(x, n-1);
};

console.log(5**-4);
console.log("5^-2 = " + myPow(5,-2));
//console.log(myPow(0.00001,2147483647));