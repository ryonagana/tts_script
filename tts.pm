#!/usr/bin/perl

use utf8;
use strict;
use warnings;
use diagnostics;

use Data::Dumper;

use HTTP::Request;
use URI;
use LWP::Simple;


my $path = "";
$path = $ARGV[0];



my $language='pt'; #put your language here



sub print_error_output {
	
	my ($text) = @_;
	my $fp;
	
	open($fp, ">", "error.html") or die "File is Invalid";
	binmode($fp, "encoding(UTF-8)");
	print $fp $text;
	close ($fp);

}


sub translate {
    
    if(!defined $ARGV[0] || $ARGV[0] eq ""){
        die "output filename not found";
        exit;
   }
    
    my ($input)  = @_;
    my $fp;
    my $content = "";
   

    $content = <STDIN>;

  
    
    my $uri = URI->new('https://translate.google.com/translate_tts');
    $uri->query_form('q' => $content, 'ie' => 'UTF-8', 'client'=>'tw-ob', 'tl'=> $language );
    
    #print $uri;
    
   my $agent = LWP::UserAgent->new(env_proxy => 1, keep_alive => 1, timeout=>30);
   
   $agent->agent('Mozilla/5.0 (Windows NT 6.1; WOW64; rv:77.0) Gecko/20190101 Firefox/77.0');
   
   my $request = HTTP::Request->new('GET',$uri);
   my $response = $agent->request($request);
   my $sound_file = $response->decoded_content();
   
   my $code = $response->code();
   
   print "Response Code: $code\n\n";
   
   if(!$response->is_success){
		print "Invalid Response..\n\n";
		print_error_output($sound_file);
		exit;
   }
   

    
   
   open($fp, ">", $ARGV[0] . '.mp3') or die "invalid file";
   binmode ($fp, "encoding(UTF-8)");
   print $fp $sound_file;
   close($fp);
   print "\n$ARGV[0].mp3 success!\n\n";
  

}


sub list_dependencies{
  
  my $list =  join("\n", map { s|/|::|g; s|\.pm$||; $_ } keys %INC);

 
  my $fp;
  open($fp, ">","dependencies.txt") or die $!;
  
  print $fp $list;
  print $list;
  close($fp);
}




if($ARGV[0] eq "--deps" ){
  list_dependencies();
  exit;
}



translate(<STDIN>);



