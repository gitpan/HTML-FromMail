
use strict;
use warnings;

package HTML::FromMail::Page;
use vars '$VERSION';
$VERSION = '0.01';
use base 'HTML::FromMail::Object';



sub lookup($$)
{   my ($self, $label, $args) = @_;
    $args->{formatter}->lookup($label, $args);
}

1;
