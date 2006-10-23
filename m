From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC] Ext3 online defrag
Date: Mon, 23 Oct 2006 16:45:15 +0200
Message-ID: <20061023144515.GC19623@atrey.karlin.mff.cuni.cz>
References: <20061023122710.GA12034@atrey.karlin.mff.cuni.cz> <20061023141641.GA29649@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:62877 "EHLO
	atrey.karlin.mff.cuni.cz") by vger.kernel.org with ESMTP
	id S964896AbWJWOo0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Oct 2006 10:44:26 -0400
To: Theodore Tso <tytso@mit.edu>
Content-Disposition: inline
In-Reply-To: <20061023141641.GA29649@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  Hello,

> >   I've written a simple patch implementing ext3 ioctl for file
> > relocation. Basically you call ioctl on a file, give it list of blocks
> > and it relocates the file into given blocks (provided they are still
> > free). The idea is to use it as a kernel part of ext3 online
> > defragmenter (or generally disk access optimizer). Now I don't have the
> > user space part that finds larger runs of free blocks and so on so that
> > it can really be used as a defragmenter. I just send this as a kind of
> > proof-of-concept to hear some comments. Attached is also a simple
> > program that demonstrates the use of the ioctl.
> 
> As a suggestion, I would pass the inode number and inode generation
> number into the ext3_file_mode_data array:
> 
> struct ext3_file_move_data {
> 	int extents;
> 	struct ext3_reloc_extent __user *ext_array;
> };
> 
> This will be much more efficient for the userspace relocator, since it
> won't need to translate from an inode number to a pathname, and then
> try to open the file before relocating it.
  Hmm, I was also thinking about it. Probably you're right. It just
seemed elegant to call ioctl on a file and *plop* it's relocated ;).

> I'd also use an explicit 64-bit block numbers type so that we don't
> have to worry about the ABI changing when we support 64-bit block
> numbers.
  Right, will fix.

> The other problem I see with this patch is that there will be cache
> coherency problems between the buffer cache and the page cache.  I
> think you will want to pull the data blocks of the file into the page
> cache, and then write them out from the page cache, and only *then*
> update the indirect blocks and commit the transaction.
  Hmm, I thought I got this right. We build a new tree, copy all data to
it (no writes happen so trees remain consistent), we switch block
pointers from inode. So from now on, any get_block() will correctly
return new block number and block will be read from disk (hmm, probably
I'm missing sync after writing out all the data). Now we call
invalidate_inode_pages2() so all buffers mapped to old blocks are freed
from memory. So there should not be problems with this... OTOH doing the
data copy via page-cache (of the temporarily set-up inode) should not be
a big problem either and we can avoid one sync which should be a win.

> So what needs to happen is the following:
> 
> 1) Validate that inode and generation number.  Make sure the new
> (destination) blocks passed in are valid and not in use.  Allocate
> them to prevent anyone else from using those blocks.
> 
> 2) Pull the blocks into the page cache (if they are not already
> there), and the write them out to the new location on disk.  If any of
> the I/O's fail, abort.
> 
> 3) Update the indirect blocks or extent tree to point at the newly
> allocated and copied data blocks.
> 
> In the current patch, it looks like you add the inode being relocated
> to the orphan list, and then update the direct/indirect blocks first
  No, I create temporary inode that holds allocated blocks and that is
added to the orphan list. Hence if we crash in the middle of relocation,
all blocks are correctly freed.

> --- and if you fail the inode gets truncated.  That's bad since we
> don't want to lose any data if we crash in the middle of the defrag
> operation....
> 
> Great to see that you're working on this problem!  I'd love to see
> this functionality into ext4.
  Thanks for comments.

> P.S.  There is also the question of whether we'll be able to get this
> interface past the ioctl() police, but the atomicity requirements of
> such an interface are a poster child for why we really, REALLY, can't
> do this via a sysfs interface.  We might be forced to create a new
> filesystem, or create a pseudo inode which we open via a magic
> pathname, though.  That in my opinion is uglier than an ioctl, but the
> ioctl police really don't like the problem of needing to maintain
> 32/64 bit translation functions, and this interface would surely cause
> problems for the x86_64 and PPC platforms, since they have to support
> 32-bit and 64-bit system ABI's.
  Umm, yes. I'm open to suggestions with respect to which interface to
choose. ioctl() was just the easiest to code ;).

							Bye
								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
