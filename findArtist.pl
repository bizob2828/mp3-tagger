use Carp;
use File::Copy;
use Image::ExifTool qw(:Public);
use Data::Dumper;
use File::Find;

sub loadFiles(); #udf
sub mySub(); #udf

my @files = ();
my $dir = shift || die "Argument missing: directory name\n";
#my $expArtist = shift || die "Argument missing: artistname\n";

loadFiles(); #call
map { print "$_\n"; } @files;
sub loadFiles()
{
  find(\&mySub,"$dir"); #custom subroutine find, parse $dir
}

# following gets called recursively for each file in $dir, check $_ to see if you want the file!
sub mySub()
{
push @files, $File::Find::name if(/\.mp3|flac$/i); # modify the regex as per your needs or pass it as another arg
}
my @goodFiles;
my @badfiles;
my %hash;
foreach(@files){
	my $artist;
	my $mp3 = ImageInfo($_);
	if(defined $mp3->{Band}){
		$artist = $mp3->{Band};
	}elsif(defined $mp3->{Composer}){
		$artist = $mp3->{Composer};
	}elsif(defined $mp3->{Artist}){
		$artist = $mp3->{Artist};
	}else{
		push(@badfiles, $mp3);#carp "Could not find a tag";
	}
	push(@{$hash{$artist}}, $_);
	#if( exists($hash{$artist})){
	#	"artist found moving on\n";
	#}else{
#
#	  $hash{$artist} = 1;
#	}
	
}
foreach my $key (keys %hash){
	print "Key: $key\n";
	`mkdir "$key"`;
	foreach my $song (@{$hash{$key}}){
		move("$song","$key/");
		print "Song: $song\n";
	}
		
}
# 	`mkdir "$key"`;
#}
#`mkdir "$expArtist"`;
#foreach my $newfile (@goodFiles){
#	print "Moving: $newfile\n";
#	move("$newfile", "$expArtist/");
#}

