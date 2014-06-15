From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Recovery after mkfs.ext4 on a ext4
Date: Sun, 15 Jun 2014 17:44:03 -0400
Message-ID: <20140615214403.GA1420@thunk.org>
References: <539D555E.3050707@scarlet.be>
 <20140615132026.GC2180@thunk.org>
 <539E019C.6060600@scarlet.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Killian De Volder <killian.de.volder@scarlet.be>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39954 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752146AbaFOVoJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 15 Jun 2014 17:44:09 -0400
Content-Disposition: inline
In-Reply-To: <539E019C.6060600@scarlet.be>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jun 15, 2014 at 10:27:08PM +0200, Killian De Volder wrote:
> >> Can e2fsck recover the directory structure and/or files in this scenario?
> > Well, maybe.  The problem is what got destroyed....  given some of the
> > errors you have described, it looks like more than the inode table got
> > wiped.  It's quite possible that version of mke2fs used to create the
> > original file system is older than the one used in the guest OS.  For
> > example, we changed where we placed the journal at one point.  That
> > would explain some of the file system errors.
> I assume this includes changing the journal size manually? (For the wiki.)

Yes, indeed.  Or any of the other mke2fs parameters.  This includes if
the file system was originally formated for ext3, and then was
upgraded to ext4, for example.  The size of the inode table, certain
file system features, etc., all can change the layout of where the
file system metadata gets placed.

All of these caveats apply for mke2fs -S as well, by the way.  The
mke2fs -S command basically reconstructs the superblock and block
group descriptors, and then exits afterwards, before celaring the
inode table.  It's unknown exactly how many of the disk blocks written
by your mke2fs running the guest OS actually made it to the disk, but
mercifully, the block group descriptors generally don't get written
out until after the inode table is cleared.  But that's one of the
reasons why I suggested that running mke2fs -S probably isn't going to
help.

> Sometimes I think it's certain inodes causing the excessive memory usage cause.
> 20GiB sounds a lot when the normal -f fschk took less then 3GiB. (It's a 16TiB file system).
> But suppose it needs more binary maps when the filesystem is this corrupt ?

E2fsck needs a lot more memory when dealing with a file systems where
some blocks are claimed by multiple inodes.  This is when pass
1b/1c/1d are invoked.  The e2fsck program also caches where the
directory blocks are located, but I doubt that's a particular concern
here.

> I've also been pondering about taking a lvm snapshot and running an
> actual repair.  (Instead of a testrun.) But I have no idea howbig
> the snapshot should be. Any indicators ?  > Good luck, Thank you for
> the info and luck, I'll need it :) > - Ted

Sorry, no clue.  It really depends on how badly damaged the file
system might be.

Something that could in theory be done is a modified version of e2fsck
that does not try to repair all file system corruption, but just
enough so that orphaned directories are mapped into lost+found, and
inodes that are so badly corrupted that it would cause the kernel
really complain are made inaccessible.  This would just be enough so
that the file system could be mounted read-only, or accessed via
debugfs's rdump, for data recovery purposes.

Unfortunately, I don't have time to implement such a best, but maybe
it's mode that could be added at some point in the future.

Regards,

						- Ted
