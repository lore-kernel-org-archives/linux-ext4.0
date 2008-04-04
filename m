From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: #blocks per group too big: 37265
Date: Fri, 4 Apr 2008 08:08:09 -0400
Message-ID: <20080404120808.GA29297@mit.edu>
References: <20080403161904.GA31670@msgid.wurtel.net> <20080404092120.GA28403@msgid.wurtel.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:59677 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752682AbYDDMIN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Apr 2008 08:08:13 -0400
Content-Disposition: inline
In-Reply-To: <20080404092120.GA28403@msgid.wurtel.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 04, 2008 at 11:21:20AM +0200, Paul Slootman wrote:
> I still end up with a "blocks per group" of 37265, and when mounted I'm
> greeted with the message "EXT4-fs: #blocks per group too big: 37265".
> Is the ext4 code in the 2.6.25-rc8 kernel too old? According to the
> source the number of block per group must be <= 8 * blocksize; with 4k
> blocks that would mean 32768, not 37265.
> 
> Even passing the -g option to explicitly set the blocks per group gets
> ignored.

I didn't notice it initially, but it looks like you're using a 1.38
mke2fs program and 1.39-tyt3 libraries.  I'm guessing that was
responsible for the wierd results, since mke2fs and e2fsck are much
more sensitive to library versions than most other libext2fs library
programs.

So that's probably the real proximate cause of your problems.

> > BTW, we will be making a new snapshot for people who want to test ext4
> > soon....
> 
> Kernel code and userspace utils? Or just kernel code?
> Where can I find the most recent version of both? 

I was referring to e2fsprogs.  The latest version is available in the
git repository, at:

    git://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git
    http://git.kernel.org/?p=fs/ext2/e2fsprogs.git;a=summary

The 'master' branch is pretty stable, the 'next' branch is a bit more
exciting, and the 'pu' (proposed update) branch is constantly getting
rebased and mainly for ext4 developers.

The mainline linux kernel has the fairly latest kernel code.  There is
also more recent kernel patches in the ext4 patch queue, which is
available here:

	  git://repo.or.cz/ext4-patch-queue.git
	  http://repo.or.cz/w/ext4-patch-queue.git

The patch queue is really intended mostly for ext4 developers, though.

So if you want to use the latest bleeding-edge development code,
that's where to find it.  (Please think very carefully before doing
anything with production data, though!  We try to be very careful, but
it's your data on the line at the end of the day.  :-)

The main issue is that e2fsprogs-1.39-tyt3 is quite about 5-6 months
old, and so it's a bit out of synch with the latest kernel code if you
are using the latest kernel release.  That will be remedied once we
can get e2fsprogs 1.41-rc0 out the door.  I had been hoping to get it
out this week, but I'm guessing it will probably slip until next week.

At that point we can update Documentation/filesystems/ext4.txt, and
things much easier to set up.

					- Ted
