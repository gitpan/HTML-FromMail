#!/usr/bin/perl
#
# Call    msg2html [-v] n filename  (file contains message without From line)
#   or    msg2html [-v] n <message  (message at stdin)
# where  "n"  is 1 or 2, refering to template directory magic-tpl1 or 2
#        -v = verbose
sub usage() { die "Usage: $0 [-v] 1|2 [filename]" }

# example:
#     msg2html -v 2 <msg

use strict;
use warnings;

# Select the browser you use, to display the result
my $display = sub {
   "galeon -x $_[0]"
#  "mozilla -remote 'openFile($_[0])'"
#  "netscape -remote 'openFile($_[0])'"
};

my $verbose = @ARGV && $ARGV[0] eq '-v' ? shift @ARGV : 0;
usage unless @ARGV;

#my $template_system;     # use default = OODoc
my $template_system = 'HTML::FromMail::Format::Magic';
#my $template_system = 'HTML::FromMail::Format::OODoc';

my $n       = shift @ARGV;

# Relative directory with template files.  The template used is
# examples/magic1/message/index.html
my $templates = "demo_templ$n";

# Only for my own home test environment
use lib qw(lib ../lib);
use lib '/home/markov/shared/perl/MailBox3/lib';   # Mail::Box
use lib '/home/markov/shared/perl/Template/lib';   # OODoc::Template

# Here the real work starts
use Mail::Message;
use HTML::FromMail;

use File::Temp 'tempdir';

#
# Get the message
#

my ($filename, $file);
if(@ARGV)
{   $filename = shift @ARGV;
    open $file, '<', $filename
      or die "Cannot read message from $file\n";
}
else
{   $filename = "stdin";
    $file = \*STDIN;
}

my $msg = Mail::Message->read($file);
die "No message read.\n" unless $msg;

$msg->printStructure if $verbose;

#
# Look for the templates to be used.  Usually this is simple, but in
# the case of this example script, I cannot hard-code the path.
#

$templates = File::Spec->catdir('examples', $templates)
   unless -d $templates;

die "Cannot find templates in $templates for the example. In which directory are you?\n"
   unless -d $templates;

print "Taking templates from $templates\n" if $verbose;

#
# Start the formatter
#

my $temp  = tempdir;
print "Producing output in $temp.\n" if $verbose;

my @template_system
  = defined $template_system ? (formatter => $template_system) : ();

my $fmt   = HTML::FromMail->new
 ( templates => $templates
 , @template_system
 );

my $start = $fmt->export($msg, output => $temp);

die "Failed to produce html.\n" unless defined $start;

#
# Force open browser to load the produced page
#

print "Displaying $start\n" if $verbose;

system($display->($start))==0
  or die "Couldn't send instruction to the browser.\n";

print "Ready!\n" if $verbose;
