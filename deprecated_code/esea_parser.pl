#!usr/bin/perl
#TEAM B is second element of the score arrays, TEAM A is first
#Program designed to rip box scores into CSVs to create feature vectors
#tom molinari
#top match is 4625233 as of 04 23 15
#redo from 3689381
use strict 'vars';
use warnings;
use LWP 5.64;
use WWW::Mechanize;
#$base . $curr_match for the new URLs
#used iterators : it, p, g, 
my @ct_score;
my @t_score;
my @frags;
my @match_stats;
my $maxmatch = 4832495;
my $base = 'https://play.esea.net/index.php?s=stats&d=match&id=';
my $curr_match = 3087896;
my $out_csv, my $outstr, my $temp, my $roundcount, my $player_count, my $sizeOf;
my $match_string = "League Match #";
my $gametype = '<img src="https://d1fj4sro0cm5nu.cloudfront.net/global/images/game_icons/25.gif" alt="Counter-Strike: Global Offensive" align="absmiddle">'; 
my $ff = "This match was forfeited by team";
my @map = '';
my $team_a_wins, my $sizor, ;
my $overturn = '<div class="module-header">Overturn Note</div>';
my $penalty_note = '<div class="module-header">Penalty Note</div>';
my $outstrA = "", my $outstrB = "";
my $append_mode = $ARGV[0];

#prints the header
my $header = "MatchID, Map, TeamAWins, TeamARounds, TeamBRounds, A1_frags, A1_assists, A1_deaths, A2_frags, A2_assists, A2_deaths, A3_frags, A3_assists, A3_deaths, A4_frags, A4_assists, A4_deaths, A5_frags, A5_assists, A5_deaths, B1_frags, B1_assists, B1_deaths, B2_frags, B2_assists, B2_deaths, B3_frags, B3_assists, B3_deaths, B4_frags, B4_assists, B4_deaths, B5_frags, B5_assists, B5_deaths\n"; 
my $url = $base . $curr_match;

if($append_mode){
	print "Append Mode!!!\n";
	open(OUTFILE, '>>esea.csv');
	$curr_match = $maxmatch + 1;
	$url = $base . $curr_match;
	$maxmatch = $ARGV[1];
}else{	
	open (OUTFILE, '>esea_5115.csv');
	print OUTFILE $header;
}

my $mech = WWW::Mechanize->new(agent => 'Mozilla/5.0 (Windows; U; Windows NT 6.1; nl; rv:1.9.2.13) Gecko/20101203 Firefox/3.6.13');
$mech->agent_alias('Windows Mozilla');
#Turns cookies on so we can get past the first time visiting splash page
#$browser->cookie_jar(HTTP::Cookies->new('file'=>'C:\Users\Tom\cookies.lwp', 'autosave'=>1));
#Two url grabs to ensure that we're getting the actual match page and not the welcome splash


while ($curr_match <= $maxmatch){
	#in order: creates new url, fetches HTML page, stores at in $temp to access and manipulate
	$mech->get($url);

	$temp = $mech->content();

	#ensures league match, remember to reenable 
	if((index($temp, $match_string) ne -1) &&(index($temp,$gametype) ne -1) && (index($temp,$ff) eq -1) && (index($temp,$overturn) eq -1)&& (index($temp,$penalty_note) eq -1)){
		print "YAH IT'S CSGO MATCH WITH NO OVERTURN OR FORFEIT OR PENALTY\n";
		$outstr = "";

		(@map) = $temp =~ m/\<div class=\"match-map\">(.*?)alt=\"(.*?)\">\<\/div>/g;
		print $map[1]."\n";

		#grab side scores for the teams, probably should calc in a foreach loop to see which team won [bc of OT] !!! Evens are Team A and Odds are Team B
		(@ct_score) = $temp =~ m/\<td class=\"ct stat\">(.*?)\<\/td\>/g;
		(@t_score) = $temp =~ m/\<td class=\"t stat\">(.*?)\<\/td\>/g;
		print "Match $curr_match \n";
		$sizor = @ct_score;
		$sizor = $sizor/2;
		my $teamArounds = 0;
		my $teamBrounds = 0;
		my $winnerRounds;
		for(my $roundLoopA = 0; $roundLoopA<$sizor; $roundLoopA++){
				$teamArounds = $ct_score[$roundLoopA]+$t_score[$roundLoopA]+$teamArounds;
				$teamBrounds = $t_score[$sizor+$roundLoopA]+$ct_score[$sizor+$roundLoopA]+$teamBrounds;
		}
		if($teamArounds > $teamBrounds){$team_a_wins = 1; $winnerRounds = $teamArounds;}#lazy conditionals to set winning team and captures the winning round total
		if($teamArounds < $teamBrounds){$team_a_wins = 0; $winnerRounds = $teamBrounds;}
		if($teamArounds != $teamBrounds){
		$outstr = "$team_a_wins,$teamArounds,$teamBrounds";
		$outstrA = "";
		$outstrB = "";

		#Need a roundcount so that we can make sure we get 10 guys that played every round
		#
		$roundcount = 0;
		foreach my $p (@ct_score){
			$roundcount += $p;
		}
		foreach my $g (@t_score){
			$roundcount += $g;
		}
		(@match_stats) = $temp =~ m/\<td class=\"stat\">(.*?)<\/td\>/g;

		$player_count = 0;
		$sizeOf = @match_stats;
		my $rws_flag = 0;
		my $it = 0;
		my $itflag = 0;
		my $playerflag = 0;
		while($rws_flag == 0 && $it+13<$sizeOf){
			$it = $it+1;

			if(index($match_stats[$it],'.') ne -1 && $match_stats[$it+13]==$roundcount){

					#Catches the stats for a particular player
				if($player_count <= 4){
					$outstrA = $outstrA.",".$match_stats[$it+1] .",".$match_stats[$it+2].",".$match_stats[$it+3];
					}
				elsif($player_count>4){
					$outstrB = $outstrB.",".$match_stats[$it+1] .",".$match_stats[$it+2].",".$match_stats[$it+3];
					}
				$player_count++;
				$it = $it+15;
				$itflag = 1;
				if($player_count == 10){
					$rws_flag = 1;
				}
			}
		}#stat capturing loop, offsets hardcoded bc of absolute stat positioning.
		$outstr =$curr_match.",".$map[1].",".$outstr.$outstrA.$outstrB."\n";
		print $player_count."-plyr count\n";
		if($player_count == 10 && $winnerRounds <= 16){
			print OUTFILE $outstr;
			print "Match recorded \n";
		}#guarantees that we get only matches with 10 players not in OT

		}#endif for ff/real match conditional
	}
	print "End match $curr_match \n";
	$curr_match = $curr_match+1;
	$url = $base . $curr_match;
	sleep 6;
}#end while
print "CLEAR\n";
close OUTFILE;

if($append_mode){
	print "Updating esea_parser.pl\n";
	my @args = ("edit.py","esea",$ARGV[1]);
	system(@args);
}

#USEFUL BUT NOT NEEDED HERE				
				#This will see if the page is null, if so we want to move on and forget about checking the match here
				#if($check eq ''){
				#	print "is null";
				#}
				#else{
				#	print "is match";
				#}
#}
