Custom Boolean
==============

Cute hack to have if/else_if/else conditions with user-defined truthiness

Normal conditionals:
--------------------
    if!(0) { puts 'true' }.
    else! { puts 'false' }

    #=> 'true'

A Pythonic truthiness:
----------------------

    # redefine truthiness with the `truth_test` method
    CustomBoolean.truth_test = proc { |b| b && b != 0 && b != [] }

    if!(0) { puts 'true' }.
    else! { puts 'false' }

    #=> false

A full example:
------------------------

    x = 5
    if!(x == 4) {
        puts 'x is 4' 
    }.
    else_if!(x == 5) {
        puts 'x is 5'
    }.
    else! {
        puts 'x is neither 4 nor 5'
    }

    #=> "x is 5"
