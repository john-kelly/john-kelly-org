What is a closure?

First. We must establish a distinction between Lexical Scope and Dynamic Scope.
Focus on Lexical Scoping, for this is the scoping relevant to Closures

Lexical Scope (also called static scope)
  In lexical scoped languages, name resolution depends on WHERE in the program
  the given function is DEFINED. With lexical scope a variable's definition
  is resolved by searching its containing block or function, then if that fails
  searching the parent block or function, and so on.

This definition is really only here for completeness and perspective/context.
The truth of the matter is that I have never used a dynamically scoped language
outside of toy programs.
Dynamic Scope
  In dynamic scoped languages, name resolution depends on WHERE in the program
  the given function is CALLED. With dynamic scope a variable's definition
  is resolved by searching the calling function, then the function which called
  that calling function, and so on.


Our focus is Lexical Scope.
In Lexical Scoping, name lookup is a series of steps down a sequence of
parent/child scopes If a given scope can not resolve a variable, it searches
its parent scope for said variable, so on and so forth. This example in
javascript portrays this point.

```javascript
(function grand() {
    var grandparentVar = 1;
    function parent() {
        var parentVar = 2;

        function child() {
            var childVar = 3;
            try {
                console.log('Child Environment');
                console.log('grandparentVar: ' + grandparentVar);
                console.log('parentVar: ' + parentVar);
                console.log('childVar: ' + childVar);
            } catch (e) {
                console.log('Error in Child Environment');
                console.log(e);
            }
        }
        try {
            console.log('Parent Environment');
            console.log('grandparentVar: ' + grandparentVar);
            console.log('parentVar: ' + parentVar);
            console.log('childVar: ' + childVar);
        } catch (e) {
            console.log('Error in Parent Environment');
            console.log(e);
        }

        return child;
    }
    try {
        console.log('Global Environment');
        console.log('grandparentVar: ' + grandparentVar);
        console.log('parentVar: ' + parentVar);
        console.log('childVar: ' + childVar);
    } catch (e) {
        console.log('Error in Global Environment');
        console.log(e);
    }
    return parent
})()()();
```

This example portrays two key concepts. First being that which was described
above, child scopes search their parent scopes if they are unable to resolve a
variable. The second being that if an scope is unable to resolve a variable
after searching its chain of parent scopes, an error will occur.

In order to begin to explain what a closure is, one must first have a strong
grasp of what happens when a function is called in a functionally scoped
programming language.

When a function is called a few things happen. First and foremost, a NEW scope
is created. Always remember this fact for it is an important concept that will
aid in future understanding. Second, all arguments passed to the function are
bound to the new scope with the names of the formal parameters. Third, execute
the body of the function. That is it. If you can remember that, you are golden.

TODO
Draw out the above example!!! And create a sketch thing for it or something
