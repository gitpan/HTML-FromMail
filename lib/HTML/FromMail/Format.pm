
use strict;
use warnings;

package HTML::FromMail::Format;
use vars '$VERSION';
$VERSION = '0.10';
use base 'Mail::Reporter';


sub init($)
{   my ($self, $args) = @_;

    $self->SUPER::init($args) or return;

    $self;
}


sub containerText($) { shift->notImplemented }


sub processText($$) { shift->notImplemented }


sub lookup($$) { shift->notImplemented }


sub onFinalToken($) { 0 }

1;
