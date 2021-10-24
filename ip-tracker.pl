use strict;
use warnings;
use Socket;
use Term::ANSIColor;
use WWW::Mechanize;
use JSON;

use Tk;

my $param = '';

my $mw = Tk::MainWindow->new;

$mw->Label(-text=>'Please enter IP([target IP] or [domain] or [host]):')->pack;
$mw->Entry(-textvariable=>\$param)->pack;
$mw->Button(-text=>'Track IP',
            -command=>sub{
                Tracking($param)
            })->pack;

MainLoop();

sub Tracking
{
    print color 'bold bright_green';
    my @iphost=$param;
    my @ip = inet_ntoa(scalar gethostbyname("@iphost")or die "IP or Host invalid!\n");
    my @hn = scalar gethostbyaddr(inet_aton(@ip),AF_INET);
    
    my $GET=WWW::Mechanize->new();
    $GET->get("http://ip-api.com/json/@ip"); # JSON API OF IP-API.COM
    my $json = $GET->content();    
    
    my $info = decode_json($json);
    # Json API Response :
    # A successful request will return, by default, the following:
    #{
    #    "status": "success",
    #    "country": "COUNTRY",
    #    "countryCode": "COUNTRY CODE",
    #    "region": "REGION CODE",
    #    "regionName": "REGION NAME",
    #    "city": "CITY",
    #    "zip": "ZIP CODE",
    #    "lat": LATITUDE,
    #    "lon": LONGITUDE,
    #    "timezone": "TIME ZONE",
    #    "isp": "ISP NAME",
    #    "org": "ORGANIZATION NAME",
    #    "as": "AS NUMBER / NAME",
    #   "query": "IP ADDRESS USED FOR QUERY"
    # }
    # INFOS OF JSON API ...
    
    $mw->Label(-text=>"ORG: $info->{'as'}",)->pack;
    $mw->Label(-text=>"ISP: $info->{'isp'}")->pack;
    $mw->Label(-text=>"Country: $info->{'country'} - $info->{'countryCode'}")->pack;
    $mw->Label(-text=>"Region: $info->{'regionName'} -  $info->{'region'}")->pack;
    $mw->Label(-text=>"City: $info->{'city'}")->pack;
    $mw->Label(-text=>"Location: Might not be accurate",-foreground => "red",)->pack;
    $mw->Label(-text=>"Geo: Latitude: $info->{'lat'} - Longitude:  $info->{'lon'}")->pack;
    $mw->Label(-text=>"City: $info->{'city'}")->pack;
    $mw->Label(-text=>"As number/name: as:  $info->{'as'} - Long:  $info->{'as'}")->pack;
    $mw->Label(-text=>"ORG name: $info->{'as'}")->pack;
    $mw->Label(-text=>"Country code: $info->{'countryCode'}")->pack;
    $mw->Label(-text=>"Status: $info->{'status'}",-foreground => "red",)->pack;

    print color 'bold bright_white';
    print "     [!] IP: ", $info->{'query'}, "\n";
    print color 'bold bright_red';
    print "-----------------------------------------\n"; 
    print color 'bold bright_green';
    print "     [+] ORG: ", $info->{'as'}, "\n";
    print "     [+] ISP: ", $info->{'isp'}, "\n";
    print "     [+] Country: ", $info->{'country'}," - ", $info->{'countryCode'}, "\n";
    print "     [+] Region: ", $info->{'regionName'}, " - " , $info->{'region'}, "\n";
    print "     [+] City: ", $info->{'city'}, "\n";
    print color 'red';
    print q{     [!] Location: Might not be accurate }; "\n";
    print color 'bold bright_blue';
    print "     [+] Geo: ", "Latitude: " , $info->{'lat'}, " - Longitude: ", $info->{'lon'}, "\n";
    print "     [+] Geolocation: ", "Lat: " , $info->{'lat'}, " - Lat: ", $info->{'lat'}, "\n";
    print color 'bold bright_green';
    print "     [+] Timezone: ", "timezone: " , $info->{'timezone'}, " - Long: ", $info->{'timezone'}, "\n";
    print "     [+] As number/name: ", "as: " , $info->{'as'}, " - Long: ", $info->{'as'}, "\n";
    print "     [+] ORG name: ", $info->{'as'}, "\n";
    print "     [+] Country code: ", $info->{'countryCode'}, "\n";
    print color 'bold bright_red';
    print "     [+] Status: ", $info->{'status'}, "\n"; 
    print "\n";
    # EOF
}
