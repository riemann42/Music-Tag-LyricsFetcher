package Music::Tag::LyricsFetcher;
our $VERSION = 0.04;

# Copyright (c) 2008 Edward Allen III. Some rights reserved.

#
# You may distribute under the terms of either the GNU General Public
# License or the Artistic License, as specified in the README file.
#


=pod

=for changes stop

=head1 NAME

Music::Tag::LyricsFetcher - Plugin module for Music::Tag to fetch lyrics use Lyrics::Fetcher

=for readme stop

=head1 SYNOPSIS

	use Music::Tag;

	my $info = Music::Tag->new($filename, { quiet => 1 });
	$info->add_plugin("Lyrics");
	$info->get_tag();
   
	print "Lyrics are ", $info->lyrics;

=for readme continue

=begin readme

=head1 INSTALLATION

To install this module type the following:

   perl Makefile.PL
   make
   make test
   make install

=head1 DEPENDENCIES

This module requires these other modules and libraries:

   Music::Tag
   Lyrics::Fetcher
   Lyrics::Fetcher::LeosLyrics

You can also install these other plugins

    Lyrics::Fetcher::LyricWiki
    Lyrics::Fetcher::AZLyrics
    Lyrics::Fetcher::AstraWeb

=end readme

=for readme stop

=head1 DESCRIPTION

Music::Tag::LyricsFetcher is an interface to David Precious' L<Lyrics::Fetcher> module.   

=head1 REQUIRED DATA VALUES

Artist and Title are required to be set before using this plugin.

=head1 SET DATA VALUES

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

Overwrite lyrics, even if they exists.

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

L<Music::Tag>, L<Music::Tag::Lyrics>

=head1 CHANGES

=for changes continue

=over 4

=item Release Name: 0.4

=over 4

=item * 

Changed license to explicitly include GPL

=item *

Started using Pod::Readme

=back

=begin changes

=item Release Name: 0.3  2008/02/22

=over 4

=item * 

Improved test

=item * 

Now requires Lyrics::Fetcher::LeosLyrics

=item * 

Fixed type-o in Synopsis

=back

=item Release Name: 0.2  2008/02/21

=over 4

=item * 

Fixed default_options method

=item * 

Kwalitee changes

=back

=item Release Name: 0.1  2008/02/10

=over 4

=item * 

Initial Public Release

=back

=end changes

=back

=for changes stop

=for readme continue

=head1 AUTHOR 

Edward Allen III <ealleniii _at_ cpan _dot_ org>

=head1 COPYRIGHT

Copyright (c) 2007,2008 Edward Allen III. Some rights reserved.

=head1 LICENSE

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either:

a) the GNU General Public License as published by the Free
Software Foundation; either version 1, or (at your option) any
later version, or

b) the "Artistic License" which comes with Perl.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See either
the GNU General Public License or the Artistic License for more details.

You should have received a copy of the Artistic License with this
Kit, in the file named "Artistic".  If not, I'll be glad to provide one.

You should also have received a copy of the GNU General Public License
along with this program in the file named "Copying". If not, write to the
Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
Boston, MA 02110-1301, USA or visit their web page on the Internet at
http://www.gnu.org/copyleft/gpl.html.

=cut

1;

