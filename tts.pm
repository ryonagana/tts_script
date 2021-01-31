#!/usr/bin/perl 

use strict;
use warnings;
use diagnostics;

use Data::Dumper;

use HTTP::Request;
use URI;
use LWP::Simple;


my $path = "";
$path = $ARGV[0] or die "no params";



my $language='pt'; #put your language here


sub translate {
    
    if(!defined $ARGV[1] || $ARGV[1] eq ""){
        die "output filename not found";
        exit;
   }
    

    my $fp;
    my $content = "";
    
    open($fp, '<', $path) or die "invalid file";
    

    
    while(<$fp>){
    
        $content .= $_;
    
    }
    
    close($fp);
    
    my $uri = URI->new('https://translate.google.com/translate_tts');
    $uri->query_form('q' => $content, 'ie' => 'UTF-8', 'client'=>'tw-ob', 'tl'=> $language );
    
    #print $uri;
    
   my $agent = LWP::UserAgent->new(env_proxy => 1, keep_alive => 1, timeout=>30);
   
   $agent->agent('Mozilla/5.0 (Windows NT 6.1; WOW64; rv:77.0) Gecko/20190101 Firefox/77.0');
   
   my $request = HTTP::Request->new('GET',$uri);
   my $response = $agent->request($request);
   my $sound_file = $response->decoded_content();
   

    
   
   open($fp, ">", $ARGV[1] . '.mp3') or die "invalid file";
   binmode $fp;
   print $fp $sound_file;
   close($fp);
   print "\n$ARGV[1].mp3 success!\n\n";
  

}

translate();



