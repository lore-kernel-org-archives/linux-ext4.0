From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Remarks regarding sparse_super2 feature
Date: Tue, 10 May 2016 19:28:45 -0400
Message-ID: <20160510232845.GC30312@thunk.org>
References: <5724CE0E.6030407@partition-saving.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Damien Guibouret <damien.guibouret@partition-saving.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40368 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752437AbcEJX2s (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 May 2016 19:28:48 -0400
Content-Disposition: inline
In-Reply-To: <5724CE0E.6030407@partition-saving.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Apr 30, 2016 at 05:23:58PM +0200, Damien Guibouret wrote:
> Hello,
> 
> I was looking to sparse_super2 feature and there is some points I do not
> understand in the way it is handled on fs initialisation and resize.
> 
> In ext2fs_initialize (initialize.c), the backup superblocks field is
> initialised at line 437, but they were used previously when checking for
> overhead (at line 407) when the second value is still ~0. Could not this
> lead to wrong overhead computation in some cases?
> This is certainly very unlikely because of the 50 margin taken on this
> overhead. As this is some chicken/egg problem, solution is not obvious. A
> way is perhaps to have ext2fs_bg_has_super accepting ~0 as a group always
> having a backup superblock (unless extending the number of groups to 64
> bits, if such a number of groups is reached, it will obviously be the latest
> so be the candidate for the backup bg).

Good point.  You're right that in most cases the margin should hide
the problem, but to be correct, I've changed this to be:

	has_bg = 0;
	if (ext2fs_has_feature_sparse_super2(super)) {
		/*
		 * We have to do this manually since
		 * super->s_backup_bgs hasn't been set up yet.
		 */
		if (fs->group_desc_count == 2)
			has_bg = param->s_backup_bgs[0] != 0;
		else
			has_bg = param->s_backup_bgs[1] != 0;
	} else
		has_bg = ext2fs_bg_has_super(fs, fs->group_desc_count - 1);
	if (has_bg)
		overhead += 1 + fs->desc_blocks + super->s_reserved_gdt_blocks;


> In case there is some other solution, there is same kind of problem in
> adjust_fs_info of resize2fs.c (line 724 check for backup super block and
> line 839 updates the value).
>
> Concerning adjust_fs_info I do not understand the logic of some tests
> concerning update of these values....

You're right, the resize2fs handling for sparse_super2 was pretty
badly broken.

Thanks for asking these questions.  I found some rotten code when I
started looking.  I'll make sure these get fixed before e2fsprogs 1.43
is released.  (It looks like the worst of the bugs only lead to the
summary block group statistics being screwed up, and in some cases,
backup block group descriptors not getting established when growing
the file system, so the while the code was buggy, the impact of the
bugs was relatively small.)

> For the other case (shrinking the fs) at line 856:
> 			if (last_bg > 1 &&
> 			    old_fs->super->s_backup_bgs[1] == old_last_bg)
> 				fs->super->s_backup_bgs[1] = last_bg;
> what ensures the location where the new super block backup will be set is a
> free block?

This is handled by reserve_sparse2_last_group().  We have to deal this
sort of thing whenever we need to do things like grow the group
descriptors, and we will relocate data blocks as necessary to make
room for blocks that have to be at specific locations.  (This means we
have allocate new blocks for the blocks we are moving, copy the data
blocks, and then update the inode(s) to point the new block
locations.)

Cheers,

						- Ted
