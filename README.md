# iOS-Core-Audio-Timer
A static library for iOS that provides a super-accurate timer using the Core Audio I/O unit. This library would be useful for anyone building a project that requires accurate, repeated timings, such as a drum machine.

## Usage
1. Add SuperTimer.h and SuperTimer.m to your project by dragging them to the project navigator and making sure 'Add To Targets' is ticked for your project.

2. In your project's .h file, import the library using:
`#import "SuperTimer.h"`

3. In your project's .h file, create a new retain/strong property for the timer:
`@property (retain) SuperTimer *superTimer;`

4. In your project's .m file, init the timer, with an interval and custom code block:
```
_superTimer = [[SuperTimer alloc] initWithInterval:INTERVAL :^{
    NSLog(@"TICK");
}];
```

## Intervals
Because of the way the I/O Audio unit operates, intervals must be divisible by the device's default buffer length. This is usually 512 samples when running at 44.1KHz. If the interval provided by the user is not divisible by 512, it will be rounded to the closest usable figure. This is output in the log, so it might take some experimentation. Below are some example figures:

Input (samples) | Period (seconds)
-------------   | -------------
512				| 0.012s
22,050			| 0.084s
44032			| 0.998s

This obviously means that whilst this is perfect for accurate rhythm generation, it's less useful for relating to time (seconds etc).

#Setting the interval and completion block
It is also possible to set the interval and completition block retroactively using:
```
[_superTimer setInterval:INTERVAL];
[_superTimer setCompletion:^{
    NSLog(@"TOCK");
}];
```

## Author
Developed and maintained by Tim Edwards ([@timwredwards](https://twitter.com/timwredwards))
