require '../lib/custom_boolean'

CustomBoolean.truth_test = CustomBoolean::PERL_TRUTH

x = "0"
if?(negate(x)) {
  puts 'evaluates to true' 
}.
else {
  puts 'reached else'
}
