Imagine the case where we have a state variable Status. At the time of dev, Status can be in 1 of 3 states: Online, Offline, Away. How should one choose to programmatically represent this? Saw we are in the world of JavaScript. Well, we have two options: String or Int. So we can represent Status as

ONLINE -> 0 || "online"
OFFLINE -> 1 || "offline"
AWAY -> 2 || "away"

Okay Awesome. So now in every place we refer to these values we need to remember our abstraction.
In this example i chose to use an int to represent the status. We just as well could have chosen a string. For the most part, both choices are equivalent.

```js
if(status === 0) {
    //do thing
} else if(status === 1) {
    //do other thing
} else if(status === 2) {
    //do other other thing
}
```

This is bad b/c like stated earlier, we have to remember our abstraction in order for this work. And, if for whatever reason, we
decide to change the internals of our abstraction (we decided we want status to be represented as a string under the hood instead of an int) we have to now go back and change every single place that our old abstraction was used.

This is where constants can help. constants provide an abstraction over the internal implementation of our status.

```js
var ONLINE = 0;
var OFFLINE = 1;
var AWAY = 2;

if(status === ONLINE) {
    //do thing
} else if(status === OFFLINE) {

} else if(status === AWAY) {

}
```

or better yet. (this way the constants have a more explicit relationship to one another)

```js
var STATUS_TYPES = {
    ONLINE : 0,
    OFFLINE : 1,
    AWAY : 2
};

if(status === STATUS_TYPES.ONLINE) {
    //do thing
} else if(status === STATUS_TYPES.OFFLINE) {

} else if(status === STATUS_TYPES.AWAY) {

}
```

Okay. It looks like we have a nice abstraction here. We can now freely change the internals of the STATUS_TYPES like so.
```js
var STATUS_TYPES = {
    ONLINE : 'online',
    OFFLINE : 'offline',
    AWAY : 'away'
};

if(status === STATUS_TYPES.ONLINE) {
    //do thing
} else if(status === STATUS_TYPES.OFFLINE) {

} else if(status === STATUS_TYPES.AWAY) {

}
```

TODO
- Need to be more convincing...
- Need to talk about enums and why cleaner?/better?
- Need to talk about elm
