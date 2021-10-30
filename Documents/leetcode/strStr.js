/**
 * @param {string} haystack
 * @param {string} needle
 * @return {number}
 */
 var strStr = function(haystack, needle) {
    if(!haystack.includes(needle)) return -1
    for(i=0;i<=haystack.length-needle.length;i++){
        if(haystack.substr(i,needle.length) == needle){
            return i
        }
    }
};

console.log(strStr("hello", "ll"));
console.log(strStr("aaaaaaa", "bba"));
console.log(strStr("abc", "c"));
console.log(strStr("",""));


