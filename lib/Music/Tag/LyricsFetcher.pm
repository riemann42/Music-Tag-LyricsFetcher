package Music::Tag::LyricsFetcher;
our $VERSION = 0.03;

# Copyright (c) 2008 Edward Allen III. Some rights reserved.
#
## This program is free software; you can redistribute it and/or
## modify it under the terms of the Artistic License, distributed
## with Perl.
#

=pod

=head1 NAME

Music::Tag::LyricsFetcher - Music::Tag plugin to use Lyrics::Fetcher

=head1 SYNOPSIS

	use Music::Tag;

	my $info = Music::Tag->new($filename, { quiet => 1 });
	$info->add_plugin("Lyrics");
	$info->get_tag();
   
	print "Lyrics are ", $info->lyrics;

=head1 DESCRIPTION

Music::Tag::LyricsFetcher is an interface to David Precious' L<Lyrics::Fetcher> module.   

=head1 REQUIRED VALUES

Artist and Title are required to be set before using this plugin.

=head1 SET VALUES

=over 4

=item lyrics

=cut

use strict;
use warnings;

use Lyrics::Fetcher;
our @ISA = qw(Music::Tag::Generic);

sub default_options {{
	'lyricsoverwrite' => 0,
	'lyricsfetchers' => undef,
}}

sub get_tag {
    my $self = shift;
    unless ( $self->info->artist && $self->info->title ) {
        $self->status("Lyrics lookup requires ARTIST and TITLE already set!");
        return;
    }
    if ( $self->info->lyrics && not $self->options->{lyricsoverwrite} ) {
        $self->status("Lyrics already in tag");
    }
    else {
        my $lyrics = Lyrics::Fetcher->fetch($self->info->artist, $self->info->title, $self->options->{lyricsfetchers});
		if (($Lyrics::Fetcher::Error eq "OK") && ($lyrics)) {
            my $lyricsl = $lyrics;
            $lyricsl =~ s/[\r\n]+/ \/ /g;
            $self->tagchange( "Lyrics", substr( "$lyricsl", 0, 50 ) . "..." );
            $self->info->lyrics($lyrics);
            $self->info->changed(1);
        }
        else {
            $self->status("Lyrics not found: ", $Lyrics::Fetcher::Error);
        }
    }
    return $self;
}

=pod

=back

=head1 OPTIONS

=over 4

=item lyricsfetchers

Optional array reference containing list of Lyrics::Fetcher plugins.

=item lyricsoverwrite

OVerwrite lyrics, even if they exists.

=back

=head1 METHODS

=over 4

=item default_options

Returns the default options for the plugin.  

=item set_tag

Not used by this plugin.

=item get_tag

Uses Lyrics::Fetcher to fetch lyrics and add to object.

=back

=head1 BUGS

Let me know.

=head1 SEE ALSO INCLUDED

L<Music::Tag>, L<Music::Tag::Amazon>, L<Music::Tag::File>, L<Music::Tag::FLAC>, 
L<Music::Tag::M4A>, L<Music::Tag::MP3>, L<Music::Tag::MusicBrainz>, L<Music::Tag::OGG>, L<Music::Tag::Option>

=head1 AUTHOR 

Edward Allen III <ealleniii _at_ cpan _dot_ org>

=head1 COPYRIGHT

Copyright (c) 2007 Edward Allen III. Some rights reserved.

This program is free software; you can redistribute it and/or
modify it under the terms of the Artistic License, distributed
with Perl.


=cut



1;

