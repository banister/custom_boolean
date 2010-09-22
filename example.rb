require './lib/custom_boolean'

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
