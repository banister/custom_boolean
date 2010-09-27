require './lib/custom_boolean'

x = 7
if!(x == 4) {
  puts 'x is 4' 
}.
else_if(x == 5) {
  puts "x is #{x} (first else_if)"
}.
else_if(x == 7) {
  puts "x is #{x} (second else_if)"
}.
else_if(x == 10) {
  puts 'x is #{x} (third else_if)'
}.
else {
  puts 'reached else'
}
