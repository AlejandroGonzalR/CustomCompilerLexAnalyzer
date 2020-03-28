# PHAB, a simple language

Lexical and syntactic analyzer for custom C based language using Flex and Bison.

## Getting Started

You only need to run the build.sh file, then call the executable file using your terminal sending the wish file. 

```
./out/test.exec <your-file.phab>
```

### Prerequisites

An UNIX based OS, with Flex and Bison installed.

### Custom syntax

#### Declarations and assignments

Let for constants.

```
let hello : text -> "Hello World!"
```

Var for variables, evidently.

```
var myNumber : numeric -> 4
```

And for functions or methods

```
fun sayHello() {
    ... Do something
}
```

#### If statement

The word if and else were replaced by cond and so respectively.

```
cond (condition) {
    ... Do something
} so {
    ... Do another
}
```

#### For statement

Statement based on Kotlin's progression for loop.

```
since iterator -> 1 until 5 step 1 {
    ... Do something
}
```

#### While and do while statement

In this case, the word while is represented by loop key word, on the other hand the do word is mark off with act word. 

```
loop (condition) {
    ... Do something
}
```

And for the do while loop

```
act {
    ... Do something
} loop (condition)
```

For more precise details please check the [Lex](analyzer.l) file.

## Built With

* [Flex](https://github.com/westes/flex) - The Fast Lexical Analyzer - scanner generator for lexing in C and C++
* [Bison](https://www.gnu.org/software/bison/) - Open source parser generator
* [GCC](http://gcc.gnu.org/) - The GNU Compiler Collection

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
