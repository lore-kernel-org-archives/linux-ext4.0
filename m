From: Theodore Tso <tytso@mit.edu>
Subject: Re: Enable asynchronous commits by default patch revoked?
Date: Mon, 24 Aug 2009 19:52:40 -0400
Message-ID: <20090824235240.GL17684@mit.edu>
References: <200908241033.10527.Christian.Fischer@easterngraphics.com> <20090824133447.GH23677@mit.edu> <20090824183119.GI5931@webber.adilger.int> <20090824201027.GC17684@mit.edu> <4A92F7E0.9010001@redhat.com> <20090824220738.GG17684@mit.edu> <20090824224616.GR5931@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ric Wheeler <rwheeler@redhat.com>,
	Christian Fischer <Christian.Fischer@easterngraphics.com>,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:39058 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753858AbZHXXw7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 24 Aug 2009 19:52:59 -0400
Content-Disposition: inline
In-Reply-To: <20090824224616.GR5931@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 24, 2009 at 04:46:16PM -0600, Andreas Dilger wrote:
> On Aug 24, 2009  18:07 -0400, Theodore Ts'o wrote:
> > What ext3 and ext4 does by default is this:
> > 
> > 1)  Write data blocks required by data=ordered mode (if any)
> > 
> > 2)  Write the journal blocks
> > 
> > 3)  Wait for the journal blocks to be sent to disk.  (We don't actually
> >     do a barrier operation), so this just means the blocks have been
> >     sent to the disk, not necessarily that they are forced to a platter.
> 
> Hmm, I think you are missing a step here.  In both jbd and jbd2 there is
> a wait for these buffers to hit the disk.  In the jbd case it is at
> "commit phase 2", and in jbd2 it is at "wait_for_iobuf".

That's what I meant by step 3.  We wait for the blocks to be *sent* to
disk, but since there is no barrier operation, the disks have not
necessarily been committed to iron oxide (or whatever alloy is used on
HDD platters these days  :-).

Without a barrier, Chris Mason has demonstrated that with a very heavy
workload, while the system is under memory pressure, and with lots of
fsync()'s thrown in for good measure, simply waiting for the block
device to signal completion is **not** enough.  He has demonstrated
filesystem corruption bad enough that fsck -p was not able to recover
the filesystem; it required manual intervention to clear the
filesystem corruption.  The bottom line is that modern disks *do* do
significant reordering in their 8-32MB internal buffer, and they
*don't* have sufficient power storage to guarantee that everything
accepted and stored in the cache will actually be written out in the
event of a power failure.

So waiting for the block device layer to say, "OK the write is done",
is not sufficient.

> > 5)  Wait for the commit block (since a barrier is requested, this is
> > just when it was sent to the disk, not when it is actually committed
> > to stable store).
> 
> Similarly, in the async case, all of the data blocks and the commit
> block are waited on, AFAICS.  It's just that with async_commit the
> commit block is submitted with the data blocks, and in case of a
> crash the transaction checksum is needed to determine if the commit
> block is valid or not.

The key here is what is meant by "waited on".  We don't have a way for
the HDD to tell us, "this block has hit stable store"; all we know
that the DMA operation has completed, and the data has been posted to
the device.

The real problem is that the cache flush operation is the only thing
which modern disks give us to guarantee that blocks sent to the disk
are on stable storage.  Some SCSI disks have FUA, but its semantics
are incredibly sucky (force just this specific sector to disk,
ignoring all hard drive optimizations or elevator optimizations), and
very few hard drives have FUA in any case.

What we *really* want is something where we can say, "please write
these disk blocks tagged with tag <Foo>, in whatever order you like
that is most optimal, and let the OS know when all blocks tagged with
<Foo> are safely written to stable store".  Unfortunately, that's not
a facility that HDD manufacturers are willing to give us....

  	   	    		      	      	 - Ted
