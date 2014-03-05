# angular-table [![Build Status](https://travis-ci.org/samu/angular-table.png?branch=master)](https://travis-ci.org/samu/angular-table)

[DEMO](http://samu.github.io/angular-table/examples.html)

Angular directive which allows to declare sortable tables and to add
pagination with very little effort.

## Features
  * Makes columns sortable
  * Adds pagination
  * Implicitly renders cell contents by name convention and allows custom cell content if needed
  * Implicitly renders header titles by name convention and allows custom header content if needed

## Dependencies
This directive depends on angular only. No jQuery or Bootstrap required! It has been
tested on angular 1.2, but it should also work with 1.1 releases.

## How
Lets assume we have an array containing objects representing people. A person object has the
following format:

```javascript
{name: ..., age: ..., birthdate: ...}
```

The list contains about 100 entries and we would like to represent that data in a nice, sortable
html table and eventually make it paginated so we don't have to scroll like a madman. With
`angular-table` in our toolbelt, this task becomes easy. Lets write some markup:

```html
  <table at-table at-list="people">
  <thead></thead>
  <tbody>
    <tr>
      <td at-implicit at-attribute="name"></td>
      <td at-implicit at-attribute="age"></td>
      <td at-implicit at-attribute="birthdate"></td>
    </tr>
  </tbody>
</table>
```

This renders a simple html table with an automatically generated header, showing every entry in
our list. Four attributes have been used that need further explanation:

  * `at-table` indicate that we want to use the `angular-table` directive to extend
  our table
  * `at-list` point to the data source in our scope
  * `at-attribute` the attribute in each object the respective columns are dedicated to
  * `at-implicit` implicitly render the content of each object's attribute defined in `at-attribute`

Our table looks kind of unspectacular by now, so lets use some css, assuming we have twitter
bootstrap in our sources:

```html
<table class="table table-striped" ...>...</table>
```

Now that looks better! Next, lets make the birthdate column sortable. We want to see the
youngest people first, therefore sort descending:

```html
<td at-implicit at-attribute="birthdate" at-sortable at-initial-sorting="desc"></td>
```

And thats it, our table is sortable by birthdate instantly! We can make the other columns
sortable aswell, by using the `at-sortable` attribute only.

Our list of people is kind of long though, and we hate scrolling, so breaking up the table into
smaller chunks and making it possible to go through it with a pagination would be cool. A task
done within seconds: We need to define two additional keywords in our table ...

```html
<table ... at-config="config" at-paginated>...</table>
```

... and add an additional element to our view ...

```html
<at-pagination at-config="config" at-list="people"></at-pagination>
```

and end up with a sortable, paginated table!

## Hacking on angular-table
### Coffee Script
This directive is written in Coffee Script. If you want to contribute, please make sure to
do the changes in the coffee sources only! If you are familiar with Javascript but not with
Coffee Script, I highly recommend you to [take look at it and try it out](http://coffeescript.org).
It has a powerful and beautiful syntax and is easy to learn, You'll need no more than ~2 hours to learn all the basic concepts.

### TDD
The code for this directive is well covered with tests, which can be run with PhantomJS and
Karma. run `npm install` to install the required packages. Then, run `karma start` to run
the tests.
