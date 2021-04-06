+++
title = "Notes on: Full Stack Open 2020"
author = ["Linus Sehn"]
draft = false
subtitle = "Deep Dive Into Modern Web Development Full stack open 2020 Start course Learn React, Redux, Node.js, MongoDB, GraphQL and TypeScript"
summary = "Deep Dive Into Modern Web Development with the University of Helsinki"
tags = ["fullstack", "web development", "css", "html", "mooc"]
+++

Source >> <https://fullstackopen.com/en/#course-contents>

Links >> [Notes on: Eloquent JavaScript]({{< relref "eloquent-javascript" >}})

{{< toc >}}


## Fundamentals of Web Apps {#fundamentals-of-web-apps}


### Traditional Web Applications {#traditional-web-applications}

Most of the code below represents bad practice nowadays.

This is the code running on [this website](https://fullstack-exampleapp.herokuapp.com/). It _dynamically_ generates the HTML
code based on the (changing) number of notes.

```javascript
const getFrontPageHtml = (noteCount) => {
  return(`
    <!DOCTYPE html>
    <html>
      <head>
      </head>
      <body>
        <div class='container'>
          <h1>Full stack example app</h1>
          <p>number of notes created ${noteCount}</p>
          <a href='/notes'>notes</a>
          <img src='kuva.png' width='200' />
        </div>
      </body>
    </html>
`)
}

app.get('/', (req, res) => {
  const page = getFrontPageHtml(notes.length)
  res.send(page)
})
```

Going to the [notes page](https://fullstack-exampleapp.herokuapp.com/notes), we find out that the head-section of the HTML contains
a script-tag, which makes your browser load a JavaScript file called `main.js`:

```javascript
var xhttp = new XMLHttpRequest()
// this fetches the .json object from the server and puts its contents into list.
// this function is a callback function, i.e. a function executed by the browser
// at the appropriate time, i.e. when the event has occured.
xhttp.onreadystatechange = function() {
  // checks whether operation is complete and if the HTTP status is 200
  if (this.readyState == 4 && this.status == 200) {
    const data = JSON.parse(this.responseText)
    // cause your console to log
    console.log(data)

    // create an unordered list (ul)
    var ul = document.createElement('ul')
    ul.setAttribute('class', 'notes')

    // witht the following list elements (li)
    data.forEach(function(note) {
      var li = document.createElement('li')

      ul.appendChild(li)
      li.appendChild(document.createTextNode(note.content))
    })

    document.getElementById('notes').appendChild(ul)
  }
}

xhttp.open('GET', '/data.json', true)
xhttp.send()
```


### Document Object Model (DOM) {#document-object-model--dom}

We can think of HTML-pages as tree structures. In the case of dynamic webpages,
[DOM](https://en.wikipedia.org/wiki/Document%5FObject%5FModel) is an Application Programming Interface (API) that acts as an interface
between JavaScript and the object-oriented document (of which the browser
renders a HTML representation) itself. Within a webpage, JavaScript can:

-   add, change, and remove any of the HTML elements and attributes
-   change any of the CSS styles
-   react to all the existing events
-   create new events


### Manipulate the document-object from console {#manipulate-the-document-object-from-console}

Turns out that we can manipulate the object from the browser console:

{{< figure src="/ox-hugo/2020-06-05_09-36-20_screenshot.png" >}}

The newly created note will render but disappear on a reload of the page since
we have not pushed the change to the server yet.


### Cascading Style Sheets (CSS) {#cascading-style-sheets--css}

CSS is a markup language that determines the style of a webpage. The `main.css`
file that is loaded as a stylesheet in the HTML on our example page defines two
class selectors. Class selectors match elements based on the contents of their
class attributes. Here is a general example followed by the `main.css` file.

```css
/* All elements with class="spacious" */
.spacious {
  margin: 2em;
}

/* All <li> elements with class="spacious" */
li.spacious {
  margin: 2em;
}

/* All <li> elements with a class list that includes both "spacious" and "elegant" */
/* For example, class="elegant retro spacious" */
li.spacious.elegant {
  margin: 2em;
}
```

```css
.container {
  padding: 10px;
  border: 1px solid;
}

.notes {
  color: blue;
}
```

There are also other attributes than `class`. For example, there is the `id`
attribute which is used by JavaScript to find the element.


### Summary on how the browser loads a page containing JavaScript {#summary-on-how-the-browser-loads-a-page-containing-javascript}

Let's revisit how the interplay between browser and server unfolds when the page
<https://fullstack-exampleapp.herokuapp.com/notes> is opened.
![](/ox-hugo/2020-06-05_09-50-47_screenshot.png)

1.  Fetch the HTML code defining the content and basic structure of the page
    using a HTTP GET request
2.  Links in the HTML cause other stuff to be fetched, in this case:
    -   the stylesheet `main.css` and
    -   the JavaScript file `main.js`
3.  Now, the JavaScript code is executed. Another HTTP GET request is made to
    fetch the JSON Data from <https://fullstack-exampleapp.herokuapp.com/data.json>
4.  When the data is fetched, the browser executes the _event handler_, which
    renders the notes to the page using the DOM-API.


### Forms and HTTP POST {#forms-and-http-post}

Using the form on the [notes page](https://fullstack-exampleapp.herokuapp.com/notes) to add a new note causes five HTTP requests:

1.  The first is an HTTP POST request to the server address ending in `new_note`
    to which the server replies with HTTP status code 302. This is a URL
    redirect, with which the server is asked to do a
2.  new HTTP GET request to the address defined in the header's _Location_, i.e.
    the address `notes`:
    ![](/ox-hugo/2020-06-05_10-05-14_screenshot.png)
3.  Fetching `main.css`
4.  Fetching `main.js`
5.  Fetching notes `data.json`

In the HTML code the, `form` tag has attributes `action` and `method`, which
stipulate that submitting the form is done as an HTTP POST request to the
address `new_note`.

On the server, we now need some simple code to handle the POST request.
Remember: This is code running on the server and not on the browser.

```javascript
// data is sent as the body of the POST request which
// can be accessed by the server via the req.body field
// of the request object (req)
app.post('/new_note', (req, res) => {
  // create new note object and add it to array along
  // with date
  notes.push({
    content: req.body.note,
    date: new Date(),
  })

  return res.redirect('/notes')
})
```

The server does not save the array containing `content` and `date` to a
database, so new notes vanish when Heroku restarts the service


### AJAX {#ajax}

The notes page from above uses a concept called Asynchronous JavaScript and XML
(AJAX) which became popular in the early 2000s. It describes a revolutionary
approach based on the advancements in browser technology that enabled the
fetching of content using JavaScript included within the HTML without the need
to rerender the entire page. On Wikipedia, it says that

> With Ajax, web applications can send and retrieve data from a server
> asynchronously (in the background) without interfering with the display and
> behavior of the existing page. By decoupling the data interchange layer from the
> presentation layer, Ajax allows web pages and, by extension, web applications,
> to change content dynamically without the need to reload the entire page.

Prior to AJAX, everything that one could see in the browser was rendered
HTML-code generated by the server that had to be rerendered once something
changed on the server.

While the notes page uses AJAX to display the notes, the application URLs
(`.../data.json`, `.../new_note`) reflect bad practice nowadays as they don't
follow the coventions of [RESTful APIs](https://restfulapi.net/), which will be covered later.

Nowadays, everything uses AJAX so the term has become somewhat meaningless.


### Single Page Applications (SPA) {#single-page-applications--spa}

While "traditional" web applications have all the logic running on the server
with the browser continually rerendering the HTML it fetches, SPAs consist of a
single HTML page, the contents of which are manipulated with JavaScript that
executes in the browser.

The [notes page](https://fullstack-exampleapp.herokuapp.com/notes) is almost there. However, as we saw above, adding new notes still
depends on the server dealing with a POST request and instructing the browser to
reload the page with a 302 redirect.

In the [SPA version of the notes page](https://fullstack-exampleapp.herokuapp.com/spa), we give the form an `id` tag such that we
can write JavaScript that handles the note creation process. Now, upon filling
out the form, the browser sends just one request with the content-type
`application/json`:

{{< figure src="/ox-hugo/2020-06-06_09-26-28_screenshot.png" >}}

Let's take a look at the part of  JavaScript code in `spa.js` dealing with the
form submission:

```javascript
// fetch the form-element from the page and register
// event handler to handle the form submit
var form = document.getElementById("notes_form")
form.onsubmit = function (e) {
  // prevent default handling of form, i.e. GET request
  e.preventDefault()

  // create a new note
  var note = {
    content: e.target.elements[0].value,
    date: new Date()
  }

  // add it to the notes list
  notes.push(note)
  e.target.elements[0].value = ""
  // rerender the note list
  redrawNotes()
  // send note to server
  sendToServer(note)
}
```

Nonetheless, even the SPA version of the page does not adhere to current best
practices.


### JavaScript Libraries {#javascript-libraries}

The application above is mainly coded in pure or "vanilla" JavaScript as it only
uses the DOM-API and built-in JavaScript features to manipulate the structure of
the page. There is a range of libraries containing tools that make it easier to
interact with the DOM-API. Some of the most popular include:

-   jQuery was used mainly back in the day for its cross-browser support but fell
    out of favour once VanillaJS and browsers can do most/all of the stuff it
    offered.
-   After BackboneJS, AngularJS became the de-facto standard of modern
    webdevelopment after its initial release by Google in 2012. Since Angular 2
    was not designed to be backwards compatible with prior versions, it became
    less popular.
-   Today, the most popular tool for implementing the browser-side logic of
    web-applications is Facebook's React library


### Exercises 0.1.-0.6. {#exercises-0-dot-1-dot-0-dot-6-dot}


#### 0.1 HTML {#0-dot-1-html}

Review the basics of HTML by reading [this tutorial](https://developer.mozilla.org/en-US/docs/Learn/Getting%5Fstarted%5Fwith%5Fthe%5Fweb/HTML%5Fbasics) from Mozilla.


#### 0.2: CSS {#0-dot-2-css}

Review the basics of CSS by reading [this tutorial](https://developer.mozilla.org/en-US/docs/Learn/Getting%5Fstarted%5Fwith%5Fthe%5Fweb/CSS%5Fbasics) from Mozilla.


#### 0.3: HTML forms {#0-dot-3-html-forms}

Learn about the basics of HTML forms by reading [Mozilla's tutorial "Your first
form"](https://developer.mozilla.org/en-US/docs/Learn/Forms/Your%5Ffirst%5Fform).


#### 0.4: new note {#0-dot-4-new-note}

In chapter Loading a page containing JavaScript - revised the chain of events
caused by opening the page <https://fullstack-exampleapp.herokuapp.com/notes> is
depicted as a sequence diagram

The diagram was made using [websequencediagrams](https://www.websequencediagrams.com/) service as follows:

```plaintext
browser->server: HTTP GET https://fullstack-exampleapp.herokuapp.com/notes
server-->browser: HTML-code
browser->server: HTTP GET https://fullstack-exampleapp.herokuapp.com/main.css
server-->browser: main.css
browser->server: HTTP GET https://fullstack-exampleapp.herokuapp.com/main.js
server-->browser: main.js

note over browser:
browser starts executing js-code
that requests JSON data from server
end note

browser->server: HTTP GET https://fullstack-exampleapp.herokuapp.com/data.json
server-->browser: [{ content: "HTML is easy", date: "2019-05-23" }, ...]

note over browser:
browser executes the event handler
that renders notes to display
end note
```

Create a similar diagram depicting the situation where the user creates a new
note on page <https://fullstack-exampleapp.herokuapp.com/notes> by writing
something into the text field and clicking the submit button.

If necessary, show operations on the browser or on the server as comments on the
diagram.

The diagram does not have to be a sequence diagram. Any sensible way of
presenting the events is fine.

All necessary information for doing this, and the next two exercises, can be
found from the text of this part. The idea of these exercises is to read the
text through once more, and to think through what is going on where. Reading the
application code is not necessary, but it is of course possible.


#### 0.5: Single Page App {#0-dot-5-single-page-app}

Create a diagram depicting the situation where the user goes to the single page
app version of the notes app at <https://fullstack-exampleapp.herokuapp.com/spa>.


#### 0.6: New Note {#0-dot-6-new-note}

Create a diagram depicting the situation where user creates a new note using the
single page version of the app.

This was the last exercise, and it's time to push your answers to GitHub and
mark the exercises as done in the submission application.

My solutions to the exercises are published [here](https://github.com/linozen/fso2020).


## Intro to React {#intro-to-react}


### Debugging React Apps {#debugging-react-apps}


#### Rules of Hooks {#rules-of-hooks}

Never use `useState` or `useEffect` inside a loop. Only ever call hook from
inside a function body defining a React component:

```javascript
const App = (props) => {
  // these are ok
  const [age, setAge] = useState(0)
  const [name, setName] = useState('Juha Tauriainen')

  if ( age > 10 ) {
    // this does not work!
    const [foobar, setFoobar] = useState(null)
  }

  for ( let i = 0; i < age; i++ ) {
    // also this is not good
    const [rightWay, setRightWay] = useState(false)
  }

  const notGood = () => {
    // and this is also illegal
    const [x, setX] = useState(-1000)
  }

  return (
    //...
  )
}
```


#### Event Handlers {#event-handlers}

Assume we develop this application:

```javascript
const App = (props) => {
  const [value, setValue] = useState(10)

  return (
    <div>
      {value}
      <button>reset to zero</button>
    </div>
  )
}

ReactDOM.render(
  <App />,
  document.getElementById('root')
)
```

The clicking of a button should reset the state stored in the `value` variable.

Thus, we need an even handler. Now, this is important: **An event handler must
always be a function or a reference to a function**. Nothing else works. Don't
use a function _call_, i.e. `setValue(0)` either (there is one exception, see
below). Only functions and references to functions such as:

```javascript
<button onClick={() => setValue(0)}>button</button>
```

or:

```javascript
const App = (props) => {
  const [value, setValue] = useState(10)

  // defining the function
  const handleClick = () => {
    console.log('clicked the button')
    setValue(0)
  }

  return (
    <div>
      {value}
      // referencing the function (not calling it)
      <button onClick={handleClick}>button</button>
    </div>
  )
}
```

You can also define an event handler to use a function that returns another
function. Function inception. Then you can actually use a function call in the
event handler because the returned object is a function. You can use this
functionality if you need generic functionality (e.g. greetings via the console) with
parameters (e.g. user names):

```javascript
const App = (props) => {
  const [value, setValue] = useState(10)

  const hello = (who) => {
    const handler = () => {
      console.log('hello', who)
    }
    return handler
  }

  return (
    <div>
      {value}
      <button onClick={hello('world')}>button</button>
      <button onClick={hello('react')}>button</button>
      <button onClick={hello('function')}>button</button>
    </div>
  )
}
```

A more compact way to write the `hello` function would be:

```javascript
const hello = (who) => () => {
  console.log('hello', who)
}
```

We can also pass event handlers to child components. So let's extract the button
into its own component:

```javascript
const Button = (props) => (
  // make sure the attributes correspond to the props passed to the component
  <button onClick={props.handleClick}>{props.text}</button>
)

const App = (props) => {
  const [value, setValue] = useState(10)

  const setToValue = (newValue) => {
    setValue(newValue)
  }

  return (
    <div>
      {value}
      <button handleClick={() => setToValue(1000) text="thousand"}>button</button>
      <button handleClick={() => setToValue(0) text="reset"}>button</button>
      <button handleClick={() => setToValue(value +1) text="increment"}>button</button>
    </div>
  )
}
```

Another important rule is to **never define components within components**. It's
nasty.


## Communicating with Server {#communicating-with-server}


### Rendering a collection, modules {#rendering-a-collection-modules}

> What's the difference between an experienced JavaScript programmer and a rookie? The experienced one uses `console.log` 10-100 times more.


#### JavaScript `const`, `let` and `var` {#javascript-const-let-and-var}

-   was slightly confused and then read [this article](https://dev.to/sarah%5Fchima/var-let-and-const--whats-the-difference-69e) which cleared up my
    understanding. It boils down to the fact that `var` should be avoided.
-   Both `let` and `const` are block-scoped and hoisted to the top. While
    variables declared with `let` can be updated but not redeclared,
    `const`-declared variables can be neither. However, you can update the
    property of a `const` object as so:

<!--listend-->

```javascript
const greeting = {
    message : "say Hi",
    times : 4
}

greeting.message = "Say Hello instead"
```


#### Functional Programming in JavaScript {#functional-programming-in-javascript}

-   Watch this [video series](https://www.youtube.com/playlist?list=PL0zVEGEvSaeEd9hlmCXrk5yUyqUag-n84). It's pretty good. Also watch [this](https://www.youtube.com/watch?v=e-5obm1G%5FFY) for a great
    explanation of `map` and `reduce`.
-   In every functional programming language, functions are values and you can
    exploit this by dividing your code into small and simple functions that can be
    _composed_ together using _higher order functions_ such `filter`, `reject`,
    `map` or `reduce`. See the following example for filter:

<!--listend-->

```javascript
var animals = [
    { name: 'Tom', species: 'dog' },
    { name: 'Timmy', species: 'dog' }
    { name: 'Tony', species 'bird'}
]

// old-school for-loop to filter dogs
let oldSchoolDogs=[]
for (var i = 0; i < animals.length; i++) {
    if (animals[i].species === 'dog')
        oldSchoolDogs.push(animals[i])}

// much cooler way
let isDog = function(animal) {
    return animal.species === 'dog'}

let dogs = animals.filter(isDog)
let nonDogs = animals.reject(isDog)
```

-   `map` does not throw objects out of an array like `filter` or `reject` based
    on a Boolean value. Instead it transforms them:

<!--listend-->

```javascript
// create new array only with the names and do some other transformation
let names = animals.map(function(animal) {
    return animal.name + " is a " + animal.species
})

// Let's do the same as an arrow function
let namesArrow = animals.map((animal) => { return animal.name })

// Get rid of return and brackets as it is a single expression in the function body
let namesArrowShort = animals.map((x) => x.name)
```

-   `reduce` is the swiss-army knife of list transformations. You can always fall
    back on it when the other built-in higher-order functions don't solve your
    problem.

<!--listend-->

```javascript
let orders = [
    {amount: 250},
    {amount: 400},
    {amount: 100},
    {amount: 325},
]

let totalAmount = orders.reduce(function(sum, order) {
    return sum + order.amount}, 0)

```


#### Anti-pattern: array indexes as keys {#anti-pattern-array-indexes-as-keys}

Avoid using the index of an array within the map function in React. See [here](https://medium.com/@robinpokorny/index-as-a-key-is-an-anti-pattern-e0349aece318) for
more infos. Possibly use [shortid](https://www.npmjs.com/package/shortid) for ID-creation.

```javascript
<ul>
  {notes.map((note, i) =>
    <li key={i}>
      {note.content}
    </li>
  )}
</ul>
```

Do it like this instead:

```javascript
<ul>
  {notes.map(note =>
    <li key={note.id}>
      {note.content}
    </li>
  )}
</ul>
```


### Forms {#forms}

-   See the example projects (esp. `phonebook`)


### Getting data from server {#getting-data-from-server}

-   Watch [this video](https://www.youtube.com/watch?v=8aGhZQkoFbQ) about event loops in JavaScript.
-   See the example projects in github and their final solutions (esp. `countries`)


### Altering data in server {#altering-data-in-server}

-   Routes are URLs + HTTP request types
-   Never mutate state directly. If a state is an array use a method like `concat`
    to create a new array (see `notes` app)
-   You need to understand promises. They are an integral part of modern
    JavaScript. The [third Chapter of You Don't Know JS](https://github.com/getify/You-Dont-Know-JS/blob/1st-ed/async%20%26%20performance/ch3.md) and [this article](https://javascript.info/promise-chaining) should be
    read and understood.


### Adding styles to React app {#adding-styles-to-react-app}


## Programming a Server with NodeJS and Express {#programming-a-server-with-nodejs-and-express}


### RESTful APIs {#restful-apis}

-   see this [article](https://martinfowler.com/articles/richardsonMaturityModel.html#level1) for a definition of the different levels of RESTful maturity.
    In this course, we are mostly operating at level 2.
    1.  Resources
    2.  HTTP verbs (`GET`, `POST`, `PUT` `DELETE`, `PATCH`)
    3.  Multimedia
-


### Difference between SQL and NoSQL {#difference-between-sql-and-nosql}

{{< youtube ruz-vK8IesE >}}


## Testing Express Servers, User Administration {#testing-express-servers-user-administration}


## Testing React Apps {#testing-react-apps}


## State Management with Redux {#state-management-with-redux}


## React Router, Custom Hooks, Styling App with CSS and Webpack {#react-router-custom-hooks-styling-app-with-css-and-webpack}


## GraphQL {#graphql}


## Typescript {#typescript}


## Resources {#resources}

<~/Exocortex/bib/library.bib>
