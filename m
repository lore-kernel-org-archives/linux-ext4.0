From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 12/12] mke2fs: allow metadata blocks to be at the
 beginning of the file system
Date: Tue, 21 Jan 2014 01:23:51 -0500
Message-ID: <20140121062351.GA23185@thunk.org>
References: <1390197254-14583-1-git-send-email-tytso@mit.edu>
 <1390197254-14583-13-git-send-email-tytso@mit.edu>
 <ACF77779-7A44-4ED7-BC49-7658A8DF8514@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50279 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803AbaAUGXx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 21 Jan 2014 01:23:53 -0500
Content-Disposition: inline
In-Reply-To: <ACF77779-7A44-4ED7-BC49-7658A8DF8514@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 20, 2014 at 04:25:23PM -0700, Andreas Dilger wrote:
> The "packed_meta_blocks" appears to be equivalent to setting flex_bg
> to some large enough factor that all the block and inode bitmaps are
> at the start of the filesystem?

It's not the same thing, unfortunately, because of how we make room
for the file system to grow and so require extra room for potential
new block groups.  Try running "mke2fs -t ext4 -G 262144 /tmp/foo.img
1T" and look at the gaps between the allocation bitmaps and the inode
table using dumpe2fs.

> It would probably be better to align
> the inode and block bitmaps and inode table on a multiple of
> s_raid_stride (will this be used to align on SMR erase blocks?) so
> that rewrites are at least somewhat efficient and aligned?  That would
> also allow reserving some room in the flex_bg packing to allow for
> filesystem resizing.

Given these blocks are written using random 4k writes, I don't think
any kind of alignment is going to be worth it.

> It would also be useful to allow setting the journal goal block
> directly, instead of journal_location_front only allowing to specify
> goal == 0 (i.e. add "-E journal_start_goal=N" instead of adding
> "-E journal_location_front", which implied by packed_meta_blocks).
> I've wanted to be able to do this for a long time, but the stumbling
> block is that write_journal_inode() doesn't have any parameter to
> specify the goal journal block without storing it in the superblock.
> I suppose it would be possible to pass the journal goal block in
> s_jnl_blocks[0..1] or something?

Hmm, yes, adding a flag which indicates that the starting block should
be passed in s_jnl_blocks[0] is a good idea.

					- Ted
