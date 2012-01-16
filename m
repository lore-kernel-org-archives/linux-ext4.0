From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/3] ext4: remove block bitmap initialization in
 ext4_new_inode()
Date: Mon, 16 Jan 2012 10:52:06 -0500
Message-ID: <20120116155206.GB4667@thunk.org>
References: <1326490249-1685-1-git-send-email-tytso@mit.edu>
 <1326490249-1685-2-git-send-email-tytso@mit.edu>
 <00C2AC6D-7D45-4FFF-B509-77BFD21BC093@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:35103 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750785Ab2APPwK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 Jan 2012 10:52:10 -0500
Content-Disposition: inline
In-Reply-To: <00C2AC6D-7D45-4FFF-B509-77BFD21BC093@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 13, 2012 at 10:02:46PM -0700, Andreas Dilger wrote:
> On 2012-01-13, at 2:30 PM, Theodore Ts'o wrote:
> > This is old code from the very early days that is just
> > confusing things, and also has the problem of modifying the block
> > group descriptor without obeying the ext4_journal_get_write_access() /
> > ext4_handle_dirty_metadata() modification protocols.
> 
> The group descriptor was already modified earlier on when the inode was
> being allocated from the group, so the group descriptor block was already
> accounted for in the transaction credits after "repeat_in_this_group:"

That's true, but we also have to modify the block bitmap block itself;
and that's a journal credit which is currently not accounted for.
Fortunately we're over conservative enough in how we calculate the
number of journal credits necessary that in practice we don't BUG_ON
due to running out ouf journal credits.

> I'm not wholly against removing this code, but we have to do it with the
> clear understanding that we will have inodes in use for which the block
> bitmap is showing that the in-use blocks are free.  This doesn't seem like
> a great situation to me.

We have backup block groups descriptors and (in the case of meta_bg,
which is needed for 64-bit resize) primary block group descriptors
which are also only accounted for by the fields in the block group
descriptors.

We can't allocate blocks in that block group without initializing the
block bitmap, and ext4_init_block_bitmap() will reserve the
appropriate fields; furthermore, if the block group checksum is
incorrect, it will lock out the block group by marking all blocks as
used and setting the number of free inodes and blocks to zero.

So it should be a safe thing to do.

						- Ted
