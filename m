From: Alexandre Ratchov <alexandre.ratchov@bull.net>
Subject: Re: rfc: [patch] change attribute for ext3
Date: Fri, 15 Sep 2006 12:19:33 +0200
Message-ID: <20060915101933.GA7254@openx1.frec.bull.fr>
References: <20060913164202.GA14838@openx1.frec.bull.fr> <20060913193130.GJ6441@schatzie.adilger.int> <20060914132154.GB28663@openx1.frec.bull.fr> <20060914210147.GY6441@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, nfsv4@linux-nfs.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:62635 "EHLO
	ecfrec.frec.bull.fr") by vger.kernel.org with ESMTP
	id S1750865AbWIOKTk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 15 Sep 2006 06:19:40 -0400
To: Andreas Dilger <adilger@clusterfs.com>
In-Reply-To: <20060914210147.GY6441@schatzie.adilger.int>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Sep 14, 2006 at 03:01:48PM -0600, Andreas Dilger wrote:
> On Sep 14, 2006  15:21 +0200, Alexandre Ratchov wrote:
> > IMHO, the natural place to do this stuff is the VFS, because it can be
> > common to all file-systems supporting this feature. Currently it's the same
> > with ctime, mtime and atime. These are in the VFS even if there are
> > file-systems that don't support all of them.
> 
> Well, that is only partly true.  I see lots of places in ext3 that are
> setting i_ctime and i_mtime...
>

i fully agree here; personnally in the long term, i'd like to see all this
stuff common to all file systems. IMHO, the file-system specific code should
only handle the on-disk storage part of the problem.

> > > Ugh, this would definitely hurt performance, because ext3_dirty_inode()
> > > packs-for-disk the whole inode each time.  I believe Stephen had patches
> > > at one time to do the inode packing at transaction commit time instead
> > > of when it is changed, so we only do the packing once.  Having a generic
> > > mechanism to do pre-commit callbacks from jbd (i.e. to pack a dirty
> > > inode to the buffer) would also be useful for other things like doing
> > > the inode or group descriptor checksum only once per transaction...
> > 
> > afaik, for an open file, there is always a copy of the inode in memory,
> > because there is a reference to it in the file structure. So, in principle,
> > we shouldn't need to make dirty the inode. I don't know if this is feasable
> > perhaps am i missing something here.
> 
> The in-memory inode needs to be copied into the buffer so that it is
> part of the transaction being committed to disk, or updates are lost.
> This was a common bug with early ext3 - marking the inode dirty and
> then changing a field in the in-core inode - which would not be saved
> to disk.  In other filesystems this is only a few-cycle race, but in
> ext3 the in-core inode is not written to disk unless the inode is
> again marked dirty.
> 
> The potential benefit of making this a callback from the JBD layer is
> it avoids copying the inode for EVERY dirty, and only doing it once
> per transaction.  Add a list of callbacks hooked onto the transaction
> to be called before it is committed, and the callback data is the
> inode pointer which does a single ext3_do_update_inode() call if the
> inode is still marked dirty.
> 

yes, that would be a real solution. Do you have any reference to Stephen
patches?

BTW, note that when we'll add support for nanosecond time-stamps, we still
have the same problem, because with a very high clock and time-stamp
resolutions, we'll have to update the inode on every change.

> > it's not strictly necessary; it's not more necessary that the interface to
> > ctime or other attributes. It's here for completness, in my opinion the
> > change attribute is the same as the ctime time-stamp
> 
> Then makes sense to just improve the ctime mechanism instead of adding
> new code and interfaces...
> 

that's also my opinion, and i really see the change attribute as part of the
ctime mechanism. It adds very few lines code (most of them are trivial) and
it uses the same interface as ctime.

The problem we want to solve is how to track relaiably file changes; there
are several solutions. The solution that Celine and me have considered is
the change attribute. It uses the 'ctime' semantics so we used the ctime
interface.

It's available for kernel threads, but I don't see any reason not to make it
available for user-land programs. In order to use it, user-land will just
need some trivial modifications.

Note that the change attribute is not incompatible with nanosecond
time-stamps. Its just a complement to the ctime, regardless of the time
resolution.

-- Alexandre

