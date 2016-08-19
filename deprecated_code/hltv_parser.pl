#!usr/bin/perl
#NEED TO FIX: GETTING THE NON-RATE STATS
#NEED TO IMPLEMENT: GETTING THE FUN STATS (LIKE RATING N HS N ENTRIES N TRADING)
#TEAM B is second element of the score arrays, TEAM A is first
#Program designed to rip box scores into CSVs to create feature vectors
#tom molinari
#top match is 
use strict 'vars';
use warnings;
use LWP 5.64;
use WWW::Mechanize;
#$base . $curr_match for the new URLs
#used iterators : it, p, g, 
my $winner;
my $loser;
my @loser_a;
my @frags;
my @match_stats;
my @teams;
my @players;
my @map;
my $team_a_win = 3;
my $placeholder = 0;
#http://www.hltv.org/?pageid=188&matchid=12868&eventid=0&gameid=2
my $maxmatch = ;
my $curr_match = 13208, my $closing_url = '&eventid=0&gameid=2', my $leading_url = 'http://www.hltv.org/?pageid=188&matchid=';
my $out_csv, my $outstr, my $outstrB = "", my $outstrA = "", my $temp = 0, my $roundcount, my $player_count, my $sizeOf;
my $win_string = '<span style="color:green;">';
my $gametype = '<div class="covSmallHeadline" style="font-weight:normal;width:50px;float:left;">Game</div><div class="covSmallHeadline" style="font-weight:normal;width:230px;float:left;text-align:right;">Counter-Strike: Global Offensive</div>';
my $notesea = '<span title="ESEA Invite Season';
my $isgame = 0;
my $append_mode = $ARGV[0];
my $header = "MatchID, Map,TeamAWins, TeamARounds, TeamBRounds, A1_frags, A1_assists, A1_deaths, A2_frags, A2_assists, A2_deaths, A3_frags, A3_assists, A3_deaths, A4_frags, A4_assists, A4_deaths, A5_frags, A5_assists, A5_deaths, B1_frags, B1_assists, B1_deaths, B2_frags, B2_assists, B2_deaths, B3_frags, B3_assists, B3_deaths, B4_frags, B4_assists, B4_deaths, B5_frags, B5_assists, B5_deaths\n"; 


my $url = $leading_url . "$curr_match" . $closing_url;
my $mech = WWW::Mechanize->new();
$mech->agent_alias('Windows Mozilla');

if($append_mode){
	print "Append Mode!\n";
	open (OUTFILE, '>>hltv.csv');
	$curr_match = $maxmatch + 1;
	$url = $leading_url . "$curr_match" . $closing_url;
	$maxmatch = $ARGV[1];
}else{
	print "Generating new data file";
	open (OUTFILE, '>hltv_new.csv');
	print OUTFILE $header; 
}


while($curr_match <= $maxmatch){
	$mech->get($url);
	$temp = $mech->content();
	#Should use this particular thing to instance whether or not we rip the score
	#print "$temp \n";
	#if(index($temp,$gametype) ne -1 && index($temp,$notesea) == -1){
	if(1){
	
		print "YAH IT'S JOE & NOT ESEA MatchId: $curr_match \n";
		@teams = "";
		@players = "";
		$outstrA = "";
		$outstrB = "";
		$out_csv = "";


		if(index($temp,$win_string) ne -1){
			$team_a_win = 1;
		}
		else{
			$team_a_win = 0;
		}
		my $teamBrounds = 0, my $teamArounds = 0;

		if($team_a_win == 1){
			($winner) = $temp =~ m/span style=\"color\:green\;\">(.*?)\<\/span\>/;
			($loser) = $temp =~ m/<span style=\"color\:red\">(.*?)\<\/span\>/;
			$teamArounds = $winner;
			$teamBrounds = $loser;
		}
		if($team_a_win == 0){
			($winner) = $temp =~ m/span style=\"color\:green\">(.*?)\<\/span\>/;
			($loser) = $temp =~ m/<span style=\"color\:red\;">(.*?)\<\/span\>/;
			$teamBrounds = $winner;
			$teamArounds = $loser;
		}
		
		$out_csv = "$team_a_win, $teamArounds, $teamBrounds";
		#need to test that the $winner value is >= 16 to ensure completed matches only!!
		#For some curious reason, teams[1] is team A and teams[0] is teamB
		(@map) = $temp =~ /Map<\/div><div class=\"covSmallHeadline\" style=\"font-weight\:normal\;width:180px\;float\:left\;text-align\:right\;\">(.*?)<\/div/g;
		(@teams) = $temp =~ m/<a href="\/\?pageid\=179.*>(.*?)<\/a>/g;
		$sizeOf = @teams;
		for(my $iii = 0; $iii<$sizeOf; $iii++){
			$teams[$iii] =~ s/^\s+|\s+$//g;
		}
		my @assists;
        (@assists) = $temp =~ m/title="headshots" style="cursor:help">(.*?)<\/span><\/div><div class="covSmallHeadline" style="font-weight:normal;width:5%;float:left;text-align:center">(.*?)<\/div>/g;
		(@players)= $temp =~ m/<a href="\/\?pageid\=179.*>(.*?)<\/a><\/div><div .*center">(.*?)<span title="headshots".*<\/div.*;text-align:center">(.*?)<\/div.*text-align:center">(.*?)<\/div.*text-align:center">(.*?)<\/div.*text-align:center">(.*?)<\/div.*text-align:center">(.*?)<\/div/g;
		my $lenlen = @players;
		my $quai;
		my $player_num = 1;
		#these dereferences are gonna make runtime SUCK
		#order data now lel
	if($lenlen == 70 && $winner>=16){	
		for($quai = 0; $quai<$lenlen; $quai++){
			if(index($players[$quai],$teams[1]) ne -1 || index($players[$quai],$teams[0]) ne -1){
				if($players[$quai] eq $teams[1]){
                    $outstrA = $outstrA .",". $players[$quai+1] . ",". $assists[$player_num] . "," . $players[$quai+2];
                }
                elsif($players[$quai] eq $teams[0]){
                    $outstrB = $outstrB .",".$players[$quai+1] . ",". $assists[$player_num] . "," . $players[$quai+2];
                }
                $player_num += 2;
			}
		}
			$out_csv = $curr_match.",".$map[0].",".$out_csv . $outstrA . $outstrB . "\n";
			if($winner == 16){
				print OUTFILE $out_csv;
				print "Recording match\n";
			}
	}
}
else{
	print "CONTINUING THE STRUGGLE: $curr_match \n";
}
	$curr_match = $curr_match + 1;
	$url = $leading_url . "$curr_match" . $closing_url;

}


close OUTFILE;
if($append_mode){
	print "Updating hltv_parser.pl\n";
	my @args = ("edit.py","hltv",$ARGV[1]);
	system(@args);
}