From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Recovery after mkfs.ext4 on a ext4
Date: Sun, 22 Mar 2015 16:19:13 -0400
Message-ID: <20150322201913.GA28505@thunk.org>
References: <539D555E.3050707@scarlet.be>
 <20140615132026.GC2180@thunk.org>
 <539E019C.6060600@scarlet.be>
 <20140615214403.GA1420@thunk.org>
 <53A7C4A1.4000603@scarlet.be>
 <20140623123758.GA14887@thunk.org>
 <53A857C0.3060401@scarlet.be>
 <20140623173151.GD14887@thunk.org>
 <550E7B05.7020703@scarlet.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Killian De Volder <killian.de.volder@scarlet.be>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54257 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751822AbbCVUTO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 22 Mar 2015 16:19:14 -0400
Content-Disposition: inline
In-Reply-To: <550E7B05.7020703@scarlet.be>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Mar 22, 2015 at 09:19:17AM +0100, Killian De Volder wrote:
> On 23-06-14 19:31, Theodore Ts'o wrote:
> >
> > ...
> > We do actually keep a linked list of these inode numbers so we can try
> > to report a directory name so you know which file has been trashed.
> > This happens in pass #2, so the inodes which are invalid are stored in
> > pass #1 and only removed in pass #2.  
> >
> > So if you are seeing gazillions of bad inodes, that could very easily
> > be what's going on.  If so, I can imagine having some mode that we
> > enter after a hundred inodes where we just ask permission to blow away
> > all of the corrupted inodes in pass #1, without waiting until we can
> > give you a proper pathname.
> > ...
> >
> >
> > 						 - Ted
> >
> Been thinking, maybe I should rewrite this code to used linked-arrays ?
> Linked lists are painfully slow on swap. (and cpu too because of all the cache misses)
> Or are we doing a lot of inserts ?

I'm not sure why I said linked lists last June, but that's actually
not correct.  In old versions of e2fsck, we used a bitmap to mark
which inodes were bad.  In newer versions of e2fscks, we have an
alternative representation for bitmaps where we can used red/black
trees for extents (contiguous regions of blocks or inodes that are
"set" in the bitmap).

In any case, I don't think trying to further optimize how we store bad
inodes is really worth it.  It happens extremely rarely, and it's
probably more useful to consider how we can avoid these sorts of
things from happening in the future.

For example, e2fsck and mke2fs will try to open the file system using
the O_EXCL flag.  The kernel will not allow the file system to opened
if either (a) the file system is mounted, or (b) some other file
system has the block device opened using O_EXCL.  From looking at the
e-mail thread history, the problem was that you accidentally ran
mke2fs on a file system that was mounted via qemu.  So if qemu opens
its block devices with O_EXCL, that would avoid a lot of problems.

In addition, newer versions of mke2fs will now warn you when you try
running mke2fs on an existing file system:

mke2fs 1.42.12 (29-Aug-2014)
/dev/sda3 contains a ext4 file system labelled 'test-filesystem'
	created on Sun Mar 22 16:18:03 2015
Proceed anyway? (y,n)

Cheers,

					- Ted
