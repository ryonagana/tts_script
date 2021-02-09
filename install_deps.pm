require warnings;
require strict;




my $depend_file = "dependencies.txt";
my $fp;


open($fp, '<', $depend_file) or die $!;



sub install_module{

  my ($module) = @_;
  print "Trying to install $module";
  system("perl -MCPAN -e \"install  $module\"");


}


while(<$fp>){
  
    eval {  require  $_   }
      or do {
      print "Missing package $_";
      install_module($_);
    }

}









