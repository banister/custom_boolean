require '../lib/custom_boolean'

x = :delighted
y = :aroused

if?(x == :sad) {
  puts 'evaluates to true' 
}.
else_if(x == :delighted) {
  if?(y == :happy) {
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

