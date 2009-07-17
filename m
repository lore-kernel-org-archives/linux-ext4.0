From: Stephan Kulow <coolo@suse.de>
Subject: Re: file allocation problem
Date: Fri, 17 Jul 2009 20:02:18 +0200
Message-ID: <200907172002.19286.coolo@suse.de>
References: <200907161331.17623.coolo@suse.de> <200907170717.12225.coolo@suse.de> <20090717142628.GL8508@mit.edu>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from charybdis-ext.suse.de ([195.135.221.2]:50557 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753143AbZGQSC3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 17 Jul 2009 14:02:29 -0400
In-Reply-To: <20090717142628.GL8508@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Friday 17 July 2009 16:26:28 Theodore Tso wrote:
> And this isn't necessarily going to help; if 16 block groups around
> (2**4) for the flex_bg for the /usr/bin directory are all badly
> fragmented, then when you create new files in /usr/bin, it will still
> be fragmented.
Yeah, but even the file in /tmp/nd got 3 extents. my file is 1142 blocks
and my mb_groups says 2**9 is the highest possible value. So I guess I will
indeed try to create the file system from scratch to test the allocator for 
real.
>
> > > In any case, I don't anything went _wrong_ per se, just that both
> > > e4defrag and our block allocator are insufficiently smart to help
> > > improve things for you given your current filesystem.  A backup,
> > > reformat, and restore will result in a filesystem that works far
> > > better.
> >
> > I believe that, but my hope for online defrag was not having to rely on
> > this 80ties defrag method :)
>
> Yeah, sorry, online defrag is a very new feature.  It will hopefully
> get better, but it's matter of resources.  Ultimately, though, the
> problem is that the ext3 allocation algorithms are very different (and
> far more primitive) than the ext4 allocation algorithms.  So undoing
> the ext3 allocation algorithm decisions is going to be non-trivial,
> and even if we can eventually get e4defrag to the point where it can
> do this on the whole filesystem, I suspect backup/reformat/restore
> will almost always be faster.
I don't have any kind of experience in that field, but would it possible
to allocate a big file that would get all all the free blocks and then move
the extents of one group into it, basically freeing all blocks of one group
so it can be used purely by ext4 allocation? Or even go as far and pack the 
blocks of every group. As far as I see there is no way with the current ioctl 
interface to achieve that once your file system is fragmented enough because 
the allocator will always create new files as fragemented and the ioctl can 
only move extents from one fragemented to another fragemented.

And yes, backup/restore might be faster, but it's also the far more 
interruptive action than leaving defrag running over night.
 
>
> > > Out of curiosity, what sort of workload had the file system received?
> > > It looks like the filesystem hadn't been created that long ago, so
> > > it's bit surprising it was so fragmented.  Were you perhaps updating
> > > your system (by doing a yum update or apt-get update) very frequently,
> > > perhaps?
> >
> > Yes, that's what I'm doing. I'm updating about every file in this
> > file system every second day by means of rpm packages (openSUSE
> > calls it factory, you will now it as rawhide).
>
> Unfortunately, constantly updating every single file on a daily basis
> is a very effective way of seriously aging a filesystem.  The ext4
Of course it is, guess why I'm so interested in having it :)

> allocator tries to keep files aligned on power of two boundaries,
> which tends to help this a lot (although this means that dumpe2fs -h
> will show a bunch of holes that makes the free space look more
> fragmented than it really is), but the ext3 allocator doesn't have any
> such smarts on it.
But there is nothing packing the blocks if the groups get full, so these
holes will always cause fragmentation once the file system gets full, right?

So I guess online defragmentation first needs to pretend doing an online 
resize so it can use the gained free size. Now I have something to test.. :)

Greetings, Stephan
