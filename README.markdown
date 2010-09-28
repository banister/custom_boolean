Custom Boolean
==============

Cute hack to have if/else_if/else conditions with user-defined
truthiness.

* Implements various preset truth tests: Ruby, Python, Perl, C, Strict Boolean.
* Provides ability to completely customize truthiness.
* Provides common Boolean Operators (and, or, not) compatible with CustomBoolean
* [Read the documentation](http://rdoc.info/github/banister/custom_boolean/master/frames)
* [See the source code](http://github.com/banister/custom_boolean)

Normal conditionalPPPNNNNPs:
--------------------
    if!(0) { 
        puts 'true' 
    }.
    else { 
        puts 'false' 
    }

    #=> 'true'

A Pythonic truthiness:
----------------------

    # redefine truthiness with the `truth_test` method
    CustomBoolean.truth_test = CustomBoolean::PYTHON_TRUTH

    if!(0) { 
        puts 'true' 
    }.
    else { 
        puts 'false' 
    }

    #=> false

A full example:
------------------------

    x = 5
    if!(x == 4) {
        puts 'x is 4' 
    }.
    else_if(x == 5) {
        puts 'x is 5'
    }.
    else {
        puts 'x is neither 4 nor 5'
    }

    #=> "x is 5"


Nested ifs work fine:
-------------------------

    x = :delighted
    y = :aroused
    
    if!(x == :sad) {
      puts 'evaluates to true' 
    }.
    else_if(x == :delighted) {
      if!(y == :happy) {
        puts 'delighted and happy'
      }.
      else_if(y == :aroused) {
        puts 'delighted and aroused'
      }.
      else { puts 'just delighted' }
    }.
    else {
      puts 'not delighted'
    }
    #=> "delighted and aroused"

If expressions
----------------

    # prefixing `if!` with `+` invokes if-expression behaviour
    +if!(false) {
      :hello
    }.
    else {
      :goodbye
    }
    #=> :goodbye

Full list of preset CustomBoolean truth tests
----------------------------------------------

    CustomBoolean::RUBY_TRUTH  # the default
    CustomBoolean::PYTHON_TRUTH 
    CustomBoolean::PERL_TRUTH 
    CustomBoolean::C_TRUTH
    CustomBoolean::STRICT_TRUTH # (`true` or `false` only)

Use as follows:

    CustomBoolean.truth_test = CustomBoolean::C_TRUTH

    +if!(0) {
      true
    }.
    else {
      false
    }
    #=> false
       

Customizable truthiness
-------------------------

`CustomBoolean.truth_test` can be set to an arbitrary Proc:
    
    # only :horse is true
    CustomBoolean.truth_test = proc { |b| b == :horse }
    
    if!(true) {
      puts 'evaluates to true' 
    }.
    else {
      puts 'reached else'
    }
    # => 'reached else
    
    if!(:horse) {
      puts 'evaluates to true' 
    }.
    else {
      puts 'reached else'
    }
    #=> 'evaluates to true'


Boolean operators
-----------------

The ordinary && and || and ! operators do not implement
CustomBoolean truthiness. Instead use Object#and, Object#or, and
Object#negate (or Object#& and Object#| and true.& and false.|, etc)

    # use perl truthiness where "0" is false
    CustomBoolean.truth_test = CustomBoolean::PERL_TRUTH

    +if!(true & "0") {
      true
    }.
    else {
      false
    }
    #=> false

    # Or use Object#and
    +if!(true.and "0") {...}

    # Use negate (rather than not)
    +if!(negate("0")) { true } ##=> true   
    
Testing truthiness of expressions
----------------------------------

You can test the truthiness of an expression without using the
full machinery of if!/else_if/else. Just use the
`CustomBoolean.truthy?()` function:

    CustomBoolean.truth_test = CustomBoolean::PERL_TRUTH
    CustomBoolean.truthy?("0") #=> false
    
Feedback
-----------

Problems or bugs, file an issue!

Have fun!
