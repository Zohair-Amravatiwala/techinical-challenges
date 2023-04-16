// var inputObj = { "a" : { "b" : {"c" : "d" } } }
// var inputKey = "a/b/c"

var args = process.argv.slice(2);

var inputObj = args[0];
var inputKey = args[1];

getValue = function(obj, key) {
    key = key.replace(/\[(\w+)\]/g, '/$1'); // convert index of arrays into properties

    key = key.replace(/^\./, '');           // Remove leading dot

    var keyArray = key.split('/');
    var KeyArrayLength = keyArray.length;

    for (var i = 0; i < KeyArrayLength; ++i) {

        var prop = keyArray[i];
        if (prop in obj) {
            obj = obj[prop];
        } else {
            return;
        }
    }
    return obj;
}

console.log(getValue(inputObj, "a/b/c"));

// #Note: To test run it using Nodejs. 
// node .\nestedObject.js '{ "a" : { "b" : {"c" : "d" } } }' "a/b/c"