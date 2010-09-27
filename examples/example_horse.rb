require '../lib/custom_boolean'

# only :horse is true
CustomBoolean.truth_test = proc { |b| b == :horse }

if?(true) {
  puts 'evaluates to true' 
}.
else {
  puts 'reached else'
}

if?(:horse) {
  puts 'evaluates to true' 
}.
else {
  puts 'reached else'
}
