From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 1/2] Add stack I/O manager.
Date: Mon, 21 May 2007 11:12:21 -0400
Message-ID: <20070521151221.GA14888@thunk.org>
References: <11786983382211-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <d286e4520f717821cf2363ff3c71a9fff5ecad2f.1178698029.git.aneesh.kumar@linux.vnet.ibm.com> <20070519033100.GB8654@thunk.org> <4651740E.6090704@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:59188 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764141AbXEUPMi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 May 2007 11:12:38 -0400
Content-Disposition: inline
In-Reply-To: <4651740E.6090704@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, May 21, 2007 at 03:57:26PM +0530, Aneesh Kumar K.V wrote:
> Can't we address the FIXME by calling the respective close routine in 
> the failure case.

You can but it doesn't address the biggest problem, which is if you're
going to add all of this extra complexity, we might as well deal with
the name parsing issue.  In your stacking I/O layer, you pass the same
name to all of the stacked modules.  That's not necessarily the right
thing to do.  It works for test_io because it doesn't need a name
parameter (it just passes the name straight down to the its
lower-layer module).  It mostly works for the undo_io layer because
while the tdb pathname could be the passed in open argument, it's
ext2fs_openfs() is openfs, and you don't have to give it its tdb name
until after the ext2fs_openfs() succeeds, and you can pass it down as
an option.

In general, though, you need to worry about what sub-parts of the name
you need to pass down to each of the stacked modules.  So the stack_io
layer adds a lot of complexity, but it's not a fully general solution.
So if it's not fully general, maybe something that's simpler is
sufficient, since in truth we probably don't need unlimited levels of
stacking.

> One thing i was confused about was the usage of read_blk, write_blk etc 
> pointers in test_private_data. With respect to undo I/O manager do i 
> need to provide them ?. If we really need them, then i was thinking a 
> generic stacking layer as i send in the patches would be better. That 
> means any pluggable functionality that we achieve right now by setting
> test_io_cb_read_blk etc will be implemented as a I/O manager that does 
> the particular task. Later we stack all these I/O manager to get the 
> full functionality.

The read_blk, write_blk, etc. pointers in test_private_data() are
specific to the test_io layer.  That's part of the value-add which the
test_io module provides, and no, the undo I/O manager doesn't need
them.  It's just there as part of what the user of the test i/o
manager might want to use, by allowing some arbitrary callback
function to be called for each test i/o.  The main place I've used it
is when I want to set effectively a watchpoint on e2fsck, because I'm
trying to figure out which part of e2fsck is reading or writing a
particular block, and I want to dump out the contents of that block
when it reads/writes it.  The fastest way to do that is to add a
callback function that tests for the block number, and when it is
triggered, I can have the debugging function print out some or all of
the contents the block.  So that's strictly a test i/o manager thing;
the undo i/o manager wouldn't need this at all!

Regards,

						- Ted
