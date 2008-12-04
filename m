From: Theodore Tso <tytso@mit.edu>
Subject: Re: Problems with checking corrupted large ext3 file system
Date: Thu, 4 Dec 2008 14:51:38 -0500
Message-ID: <20081204195138.GA1323@mit.edu>
References: <20081203101100.GO17966@skl-net.de> <20081204000936.GE3186@webber.adilger.int> <20081204163759.GR17966@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:53936 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750763AbYLDTvn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 4 Dec 2008 14:51:43 -0500
Content-Disposition: inline
In-Reply-To: <20081204163759.GR17966@skl-net.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 04, 2008 at 05:37:59PM +0100, Andre Noll wrote:
> OK, so I guess I would like to run e2fsck again without cloning those
> blocks.

Actually, what you should probably do is to take a look at the inodes
which were listed in the pass1b, and if they don't make sense, to
clear them out.  An individual inode can be cleared by using the
debugfs clri command.  i.e., to zero out inode 12345, you do this:

debugfs -w /dev/mapper/thunk-closure
debugfs: clri <12345>
debugfs: quit

This doesn't work very easily if there is a large number of inodes
that contain garbage, though.  I don't have tools that deal well with
wholeslae corruption of large portions of the inode table, mostly
because those tools, if misused, could actually cause a lot more harm
than good, and so designing the proper safety mechanism so they are
safe to use in the hands of system administrators that are not
filesystem experts and tend to use commands like "fsck -y" is very
difficult to get right.  It's also a failure mode which happens
rarely, so it's never been a high priority to figure out how create
tools that can safely handle this problem in the general case.

If you're convinced that all of the inode tables greater than 4TB have
been corrupted, or blocks from a particular physical volume are *all*
toast, onesolution is to zero out all of the damaged blocks, on the
theory that there's nothing to save anyway, and e2fsck is trying hard
to save all possible data --- and if you know there's nothing to save
there, clearing the parts of the inode table that ar eknown to be bad,
will make e2fsck run more cleanly.

In the long run, I can imagine enhancements to ext4 where we reserve 4
bytes in each inode which are used to collectively to store
information to assure ourselves an inode table block really contains
valid data and not random garbage.  The first inode in an inode table
block would use the 4 byte field to store the first inode number in
the itable block.  The second inode in the inode table block would
store the block number for the current itable block.  Each subsequent
inode, for up to 32 inodes, would use the 4 byte field to store
successive 4 bytes of the filesystem UUID.  This would allow e2fsck to
validate whether a particular inode table block read in from disk
really was valid or not.  (I'm deliberately not including an actual
checksum since that would complicate matters, and if we are going to
store a checksum, we should have one set of fields which indicates
that this block belongs to filesystem XYZ's inode table starting at
position A, and another set of fields that indicates whether a one or
more bits in the itable block have gotten flipped.  The two are
different concepts and how we react may differ depending on what know
is incorrect.)

> > One option is to use the Lustre e2fsprogs which has a patch that tries
> > to detect such "garbage" inodes and wipe them clean, instead of trying
> > to continue using them.
> > 
> > 	http://downloads.lustre.org/public/tools/e2fsprogs/latest/
> > 
> > That said, it may be too late to help because the previous e2fsck run
> > will have done a lot of work to "clean up" the garbage inodes and they
> > may no longer be above the "bad inode threshold".
> 
> I would love to give it a try if it gets me an intact file system
> within hours rather than days or even weeks because it avoids the
> lengthy algorithm that clones the multiply-claimed blocks.

Well, it's still worth a shot.


> As the box is running a Ubuntu, I could not install the rpm directly.
> So I compiled the source from e2fsprogs-1.40.11.sun1.tar.gz which is
> contained in e2fsprogs-1.40.11.sun1-0redhat.src.rpm. gcc complained
> about unsafe format strings but produced the e2fsck executable.
> 
> Do I need to use any command line option to the patched e2fsck? And
> is there anything else I should consider before killing the currently
> running e2fsck?

Nope, try it and let us know whether it seems to work.  It might be
possible to augment the hueristics to detect the bad inodes (i.e.,
check to see if the modtimes/ctimes are totally looks reflect times
that are totally outside of what might be considered "normal" times as
an indication of itable block's sanity.

But long-term (although it probably won't help you), we should
seriously think about adding some inode sanity-check fields whose
primary purpose is to tell us whether a itable block is likely to be
valid or garbage.

						- Ted
