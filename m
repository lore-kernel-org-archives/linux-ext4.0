From: Theodore Tso <tytso@mit.edu>
Subject: Re: file allocation problem
Date: Fri, 17 Jul 2009 10:26:28 -0400
Message-ID: <20090717142628.GL8508@mit.edu>
References: <200907161331.17623.coolo@suse.de> <200907161943.21575.coolo@suse.de> <20090717011219.GE8508@mit.edu> <200907170717.12225.coolo@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Stephan Kulow <coolo@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:45719 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019AbZGQO0d (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 17 Jul 2009 10:26:33 -0400
Content-Disposition: inline
In-Reply-To: <200907170717.12225.coolo@suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 17, 2009 at 07:17:12AM +0200, Stephan Kulow wrote:
> Well, is there a tool to check the overall state of the file system? I can't 
> really believe it's 1010101010, but it's hard to say without a picture :)

Well, you can check the fragmentation of the free space by using
dumpe2fs and looking at the free blocks in each block group.

> > The other problem is that an ext3 filesystem that has been converted
> > to ext4 does not have the flex_bg feature.  This is a feature that,
> > when set at when the file system is formatted, creates a higher order
> > flex_bg which combines several block groups into a bigger allocation
> > group, a flex_bg.  This helps avoid fragmentation, especially for
> > directories like /usr/bin which typically have more than 128 megs (a
> > single block group) worth of files in it.
> 
> Oh, I enabled flex_bg after you asked, rebooted to get a e2fsck -
> and I still get 34 extents for my gimp-2.6.defrag. From what I
> understand, this doesn't help in the after fact, but then again how
> am I supposed to fix my file system if even new files are created
> fragmented.

Well, it's actually not enough to enable flex_bg filesystem feature;
you need to also set the flex_bg size, like this:

debugfs -w /dev/XXX
debugfs: ssv log_groups_per_flex 4
debugfs: quit

(And no, this isn't something which we've done a lot of testing on.)

And this isn't necessarily going to help; if 16 block groups around
(2**4) for the flex_bg for the /usr/bin directory are all badly
fragmented, then when you create new files in /usr/bin, it will still
be fragmented.

> > In any case, I don't anything went _wrong_ per se, just that both
> > e4defrag and our block allocator are insufficiently smart to help
> > improve things for you given your current filesystem.  A backup,
> > reformat, and restore will result in a filesystem that works far
> > better.
>
> I believe that, but my hope for online defrag was not having to rely on this 
> 80ties defrag method :)

Yeah, sorry, online defrag is a very new feature.  It will hopefully
get better, but it's matter of resources.  Ultimately, though, the
problem is that the ext3 allocation algorithms are very different (and
far more primitive) than the ext4 allocation algorithms.  So undoing
the ext3 allocation algorithm decisions is going to be non-trivial,
and even if we can eventually get e4defrag to the point where it can
do this on the whole filesystem, I suspect backup/reformat/restore
will almost always be faster.

> > Out of curiosity, what sort of workload had the file system received?
> > It looks like the filesystem hadn't been created that long ago, so
> > it's bit surprising it was so fragmented.  Were you perhaps updating
> > your system (by doing a yum update or apt-get update) very frequently,
> > perhaps?
>
> Yes, that's what I'm doing. I'm updating about every file in this
> file system every second day by means of rpm packages (openSUSE
> calls it factory, you will now it as rawhide).

Unfortunately, constantly updating every single file on a daily basis
is a very effective way of seriously aging a filesystem.  The ext4
allocator tries to keep files aligned on power of two boundaries,
which tends to help this a lot (although this means that dumpe2fs -h
will show a bunch of holes that makes the free space look more
fragmented than it really is), but the ext3 allocator doesn't have any
such smarts on it.

						- Ted
