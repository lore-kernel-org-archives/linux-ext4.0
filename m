From: Theodore Tso <tytso@mit.edu>
Subject: Re: Porting Zfs features to ext2/3
Date: Sun, 27 Jul 2008 19:37:07 -0400
Message-ID: <20080727233707.GA9378@mit.edu>
References: <18674437.post@talk.nabble.com> <20080727224958.GB7922@mit.edu> <488CFB6E.3020602@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: postrishi <postrishi@gmail.com>, linux-ext4@vger.kernel.org
To: Shehjar Tikoo <shehjart@cse.unsw.edu.au>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:56004 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750843AbYG0Xh3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 27 Jul 2008 19:37:29 -0400
Content-Disposition: inline
In-Reply-To: <488CFB6E.3020602@cse.unsw.edu.au>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 28, 2008 at 08:49:18AM +1000, Shehjar Tikoo wrote:
> Hi Ted
>
> Theodore Tso wrote:
>> The btrfs filesystem effort is an attempt to create a filesystem that 
>> will leapfrog the ZFS feature set, but it will probably take longer to 
>> reach production ready status than ext4.
>
> Since you mention btrfs here and since I've read this earlier too, do
> you know if btrfs will be the default Linux file system in the future,
> like extX has been?

The nature of Linux is such that these sorts of decisions are not made
by anyone other than each individual system administrator, and by the
distributions who choose which filesystem they which to use as the
"default".  There is no such thing as an "official" default
filesystem.  For example, the Maemo distribution, which Nokia
distributes for use on the N800/N810 devices, uses jffs2 as its
default filesystem, since those devices use a flash storage device.
DragonLinux, which is designed to be installed on top of DOS/Windows
uses UMSDOS as its default distribution.

What happens in the future, who can say?  At some point the ext2/3/4
filesystem, which is based fundamentally on a BSD Fast Filesystem
design base, may get displaced by a filesystem which uses some very
different design as a starting point, when the advantages of starting
with that different design outweighs the advantages of backwards
compatibility and broad base of support which is enjoyed by ext2/3/4.

To give one example from the past, filesystems like JFS were
theoretically better than ext3 at the time, but unfortunately all of
the expertise was concentrated in one company (IBM), and so
distributions were slow to accept it.  In the meantime, ext3 was able
to add enough features (htree directories, better SMP scalability) to
eventually meet and then surpass JFS's technical advantages.

XFS has a number of technical advantages over ext3, but the number of
people who understand it are small, and people seem to like the tools
built for ext3 --- and now ext4 has a number of features that were
previously exclusive to XFS.  XFS is still the best filesystem for
very large, SGI-class machines, however.  But for general purpose
computing, most people are more comfortable with ext3.  

Yet the fact that we are retaining backwards compatibility with ext3
does constraint our ability to add radical new features.  So
eventually some filesystem will probably overtake ext2/3/4.  Will that
btrfs?  I don't think anyone can answer that question.  I *have* been
helping out the btrfs design team, though, giving them advice such as
making sure that they try to gather contributors from a wide variety
of distributions and other Linux companies.  So I hope they do become
successful.  In the meantime, though, ext4 is a great extension to the
ext2/3 filesystem family.  But in the long run, it may very well be
that btrfs will be more successful than some future attempt to create
an ext5; and that's fine.

Regards,

						- Ted
