# Javascript Inheritance === Code Resuse

-- TODO post on js composition
-- TODO post on composition vs inheritance

#### Intro to Inheritance
Classical vs Prototypal

- #### Intro
    - When people think of inheritance, it is most often tied to the notion of a Class. Welp. there is also this thing called Prototypal. and you have probably used it. it's called javascript. if you are entering javascript post es6 adoption (when browsers implemented the *class*) keyword, you may not know what a prototype is. if you already know, well, good. but are you using it right?

- #### Classical
    - History HERE
    - Benefits
        - Create System of Types
            - according to crockford's Javascript the good parts this creation of a system of types is nice in statically types programming languages because of the fact that classes can eliminate the need to cast to other types, which can be very beneficical because of that fact that casting is considered harmful due to the fact that when casting the safety provided by a type system is lost.
            - Class can not change at runtime (This is tied in part to the second point about creating a system of types.)
                - In this model, objects are entities that combine state (i.e., data), behavior (i.e., procedures, or methods) and _identity_ (unique existence among all other objects).
                Since Class can not change at runtime, there is a garuntee
                that an instance of a given class will forever remain an instance of a given class(this is not true necessarily for a Prototypal language, which is why I am referencing it here)
        - Code reuse
            - the most obvious (although not so obvious to indicate at this meta of a level, most people would say: "well it's because you want instances of the class to be able to do the same things", which is 100% correct, however, when i read that inheritance was all about code reuse, my mind was blown. i previously was trying to think about inheritance in the sense of what made the most sense on an abstract level(which is important for future code reviewers) arguably the creation of these abstract hierarchies is an important and possibly intended result, thinking about inheritance in terms of code resuse was nice.)
    - TL;DR
        - Class inherit from other Class
- #### Prototypal
    - History HERE
    - Benefits
        - Code reuse
        - Create System of Types
            - not really? what do prototype languages normally do? really since objects are inheriting from other objects, it is possible to see if two objects inherit from the same object. if you wanted to traverse down the inherit chain, go right ahead, but I am not sure if this is necessarily something that really needs to be taken advantage of
            - side note, how does typescript does its type checks? does it use instance of?
            - how and what do other proto inherit language do in relation to creating a system of types

    - TL;DR Objects inherit from other Objects.

### Javascript Specific Stuff
1.) Gotcha? But is it important?
constructor is not what is appears to be!
```
function Ninja(){}
function Person(){}
Ninja.prototype = new Person();
```

2.) Workaround
yay, easy fix, but did any of that really matter? to be honest. i dont know yet
```
function Ninja(){}
function Person(){}
Ninja.prototype = new Person();
Ninja.constructor = Ninja;
```

3.) Why this might not matter
instance of compares whether or a given Constructor functions prototype can be
found down the .__proto__ chain of a given object. the constructor on a prototype
is somewhat meaningless (unless of course you inted to use it for yourself in
some fashion, however I have yet to see find any use case)
- kinda not really
- talk about instanceof and how it might not do what you want considering prototype can change at runtime(this may be a powerful concept, but I have yet to see a use case; so for now, this is considered harmful in my eyes)
- no benefit from compile time checks (there are none)
- everything is dyanamic, so the benefit of not casting already exists in the language.

### Javascript Inheritance Patterns
    - mixu http://book.mixu.net/node/ch6.html
    - resig http://ejohn.org/blog/simple-javascript-inheritance/
    - crock chapter 5 in good parts
    - crock http://www.crockford.com/javascript/inheritance.html
    - crock https://gist.github.com/coolaj86/364168
    - crock http://weblogs.asp.net/bleroy/crockford%E2%80%99s-2014-object-creation-pattern / http://bdadam.com/blog/video-douglas-crockford-about-the-new-good-parts.html
    - rando https://github.com/Olical/Heir/blob/master/heir.js
```javascript  f
function your_constructor(spec) {
    let {member1, member2, memberN = spec;
    let {other1, other2, otherN} = other_constructor(spec);

    method1 = function () {
        // Blah1
    };

    method2 = function() {
        // Blah2
    };

    methodN = function () {
        // BlahN
    };
    return Object.freeze({
        public_api1,
        public_api2,
        public_apiN,
    });
}
```
### Conclusion
In conclusion. In my mind. I see javascript inheritance as synonymous with code resuse. There are places where it may be possible to implement some safety checks into functions and such to check for types, but these techniques I am not yet familiar with. And, these techniques would only be able to help at runtime (which is still nice for debugging) so. to me. in my mind. javascript inheritance is currently all about code resuse.
