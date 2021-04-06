+++
title = "Notes on: The Go Programming Language (Donovan & Kernighan, 2016)"
author = ["Linus Sehn"]
draft = false
subtitle = ""
summary = "If you want to program in Go, you should be reading this book"
tags = ["go", "programming", "cs", "book"]
share = true
profile = true
commentable = true
editable = false
+++

Links >> <https://gopl.io>

{{< toc >}}

The following is my synopsis of the authoritative introduction to [Go](https://golang.org/), namely
[The Go Programming Language](http://www.gopl.io/) authored by Google's Alan Donovan and Bell Labs'
Brian Kerningham ([Donovan and Kernighan 2016](#orgfd86807)).


## Preface {#preface}

-   Go balances expressiveness with safety: fast runtime but few crashes due to
    type errors.
-   Go runs pretty much anywhere.


### The Origins of Go {#the-origins-of-go}

{{< figure src="/ox-hugo/_20201021_151319screenshot.png" >}}

The authors describe Go's ancestry (from C) as follows:

> From C, Go in herited its expression syntax, control-flow statements, basic
> data types, call-by-value parameter passing, pointers, and above all, C’s
> emphasis on programs that compile to efficient machine code and cooperate
> naturally wit h the abstractions of current operating systems.

From the lineage on the left of the tree, i.e. _communicating sequential
processes_ (CSP) Squeak, Newsquek and Alef, Go inherited the concept of
concurrency. [Concurreny](https://en.wikipedia.org/wiki/Concurrency%5F(computer%5Fscience)) is "the ability of different parts or units of a
program, algorithm, or problem to be executed out-of-order or in partial order,
without affecting the final outcome".


### Simplicity {#simplicity}

-   In the long run, simplicity is the key to good software. But, simplicity
    is multiplicative. With each fix that makes one part of the code more complex,
    other parts of the code are bound to become more complex as well.
-   Simplicity is easy to neglect and requires more work in the beginning of a
    project. It also requires dscipline over the whole project lifetime.


## Tutorial {#tutorial}


### Hello World {#hello-world}

-   Go handles unicode natively (see example below)
-   `go build helloworld.go` builds an executable binary helloworld that can be
    run without any further processing

<!--listend-->

```go
package main

import "fmt"

func main() {
	fmt.Println("Hello, 世界")
}
```

-   Go code is organized into _packages_, such as the `fmt` package above from
    which we take the `Println` function to print a some values with a newline
    character at the end.
-   The `main` package is special. It contains the special function `main` which
    defines what our program does.
-   The `import` statement defines which packages are needed for the compilation
    of the program. The program won't compile if imports are missing or if there
    are superfluous ones.


### Command-Line Arguments {#command-line-arguments}

-   The `os` package provides functions and values provided by the OS of the user
    in a platform-independent manner
-   `os.Args` is a _slice_ of strings. A slice is "a dynamically sized sequence of
    array elements where individual elements can be accessed as `s[i]` and a
    contiguous subsequence as `s[m:n]`"
-   Go uses _half-open intervals_ which include the first index but exclude the
    last.
-   The program below mimics the UNIX command `echo`, which simply prints its
    command-line arguments:

<!--listend-->

```go
// Echo1 prints its command-line arguments.
package main

import (
	"fmt"
	"os"
)

func main() {
	// implicitly initialise s and sep as empty strings
	var s, sep string
	// loop through os.Args
	for i := 1; i < len(os.Args); i++ {
		// use assignments statement to concatenate old value of s with sep and
		// os.Args[i] and then assign it back to s
		s += sep + os.Args[i]
		// insert space after first loop
		sep = " "
	}
	fmt.Println(s)
}
```

The `for` loop is the only loop statement in Go! Its general form is:

```go
for initialization; condition; post {
	// zero or more statements
}
```

A traditional while loop has this form:

```go
for condition {
	// ...
}
```

-   If you omit the condition entirely, you get an infinite loop.
-   It is also possible to loop through a _range_ of values from a string or a
    slice. The following rewrite of the Echo1 program above illustrates this:

<!--listend-->

```go
// Echo2 prints its command-line arguments.
package main

import (
	"fmt"
	"os"
)

func main() {
	// explicitly initialise s and sep as empty strings
	s, sep := "", ""
	// for each iteration, range gives us a pair of values, the index and the
	// values of the element at that index
	for _, arg := range os.Args[1:] {
		s += sep + arg
		sep = " "
	}
	fmt.Println(s)
}
```

In the code above, the _blank identifier_ (`_`) allows us to discard the index
of the `range` that we loop through. I needed to read about the blank identifier
[here](https://golangdocs.com/blank-identifier-in-golang) to get the idea.


#### Variable Declarations {#variable-declarations}

```go
// compact but only allowed inside a function and not for package-level
// variables
s := ""
// implicit initilisation
var s string
// rarely used except for when declaring multiple variables
var s = ""
// explicit about the variables type, which is redundant if it is the same as
// that of the initial value but neccessary if they are not
var s string = ""
```

In practice, use either the first or second option.


#### Efficiency {#efficiency}

A more efficient way to write the echo program would be one that does not need
so much garbage collection as the one above. Currently, we re-assign the
variable `s` every time we iterate through the loop. This can be optimised using
the `Join` function from the `strings` package:

```go
package main

import (
	"fmt"
	"os"
	"strings"
)

//!+
func main() {
	fmt.Println(strings.Join(os.Args[1:], " "))
}
```


#### Exercises {#exercises}

**Exercise 1.2**: Modify the echo program to also print `os.Args[0]`, the name of
the command that invoked it.

```go
package main

import (
	"fmt"
	"os"
	"strings"
)

func main() {
	// simply change 1 to 0
	fmt.Println(strings.Join(os.Args[0:], " "))
}
```

**Exercise 1.2**: Modify the program to print the index and value of each of its
arguments, one per line.

```go
package main

import (
	"fmt"
	"os"
)

func main() {
	// simply use both the index and the argument and print them
	for i, arg := range os.Args[1:] {
		fmt.Println(i, arg)
	}
}
```

**Exercise 1.3**: Experiment to measure the difference in running time between our
potentially inefficient versions and the one that uses `strings.Join`. (Section
1.6 illustrates part of the `time` package, and Section 11.4 shows how to write
benchmark tests for systematic performance evaluation.)

I implemented benchmarking functions in files named `main_test.go` for each
version (using `string.Join`, using `range` and the first, most simple
version):

```go
package main

import (
	"os"
	"testing"
)

func BenchmarkLoop(b *testing.B) {
	for i := 1; i < b.N; i++ {
		os.Args = append(os.Args, `./some/resource/fred`)
		main()
	}
}

```

Turns out that the version with `string.Joing` did consistently perform best.
The solution above might be


### Finding Duplicate Lines {#finding-duplicate-lines}

Let us introduce some more standard packages and useful functions. Consider the
following piece of code that takes lines from standard input and outputs
duplicate lines:

```go
package main

import (
	"bufio"
	"fmt"
	"os"
)

func main() {
	counts := make(map[string]int)
	input := bufio.NewScanner(os.Stdin)
	// returns true if there is a line and false if there is no more input
	// (Ctrl + D)
	for input.Scan() {
		// for each new line add a new key/value pair, the contents of the line
		// being the key and the number of times it occured being the value
		counts[input.Text()]++
	}
	// NOTE: ignoring potential errors from input.Err()
	for line, n := range counts {
		if n > 1 {
			// produces formatted output from a list of expressions
			fmt.Printf("%d\t%s\n", n, line)
		}
	}
}
```

Here, the authors make use of a _map_, which is the [built-in associative data
type](https://gobyexample.com/maps). It holds a set of key/value pairs. The key can be of any type that can be
compared; usually it is a string. The value can be of any type.

`bufio` provides us with useful input and output tools. Above we use the
`Scanner` type that reads input and then breaks it into lines or words.

| verb       | spec                                                                 |
|------------|----------------------------------------------------------------------|
| %d         | decimal integer                                                      |
| %x, %o, %b | integer in hexadecimal, octal or binary                              |
| %f, %g, %e | floating point number: `3.141593` `3.141592653589793` `3.141593e+00` |
| %t         | boolean                                                              |
| %c         | string                                                               |
| %q         | quoted string                                                        |
| %v         | any value in natural format                                          |
| %T         | type of any value                                                    |
| %%         | literal percent sign (no operand)                                    |

Now, we expand the program to handle not only standard input but also a list of
file names using `os.Open`:

```go
package main

import (
	"bufio"
	"fmt"
	"os"
)

func main() {
	counts := make(map[string]int)
	files := os.Args[1:]
	if len(files) == 0 {
		countLines(os.Stdin, counts)
	} else {
		for _, arg := range files {
			f, err := os.Open(arg)
			// error handling
			if err != nil {
				fmt.Fprintf(os.Stderr, "dup2: %v\n", err)
				continue
			}
			countLines(f, counts)
			f.Close()
		}
	}
	for line, n := range counts {
		if n > 1 {
			fmt.Printf("%d\t%s\n", n, line)
		}
	}
}

func countLines(f *os.File, counts map[string]int) {
	input := bufio.NewScanner(f)
	for input.Scan() {
		counts[input.Text()]++
	}
	// NOTE: ignoring potential errors from input.Err()
}
```


## Program Structure {#program-structure}


## Basic Data Types {#basic-data-types}


## Composite Types {#composite-types}


## Functions {#functions}


## Methods {#methods}


## Interfaces {#interfaces}


## Testing {#testing}


## Reflection {#reflection}


## Low-level Programming {#low-level-programming}


## Resources {#resources}


### Bibliography {#bibliography}

<a id="orgfd86807"></a>Donovan, Alan A. A., and Brian W. Kernighan. 2016. _The Go Programming Language_. First printing, October 2015. Addison-Wesley Professional Computing Series. New York: Addison-Wesley.
