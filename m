From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/3] lib/ext2fs: Add ext2fs_symlink
Date: Sat, 5 Jan 2013 17:40:59 -0500
Message-ID: <20130105224059.GA29789@thunk.org>
References: <1357329660-28639-1-git-send-email-dvhart@infradead.org>
 <3fd850c4bf72f868b0d93bb0a5acced51fd25caa.1357329054.git.dvhart@infradead.org>
 <20130105200716.GM20106@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Darren Hart <dvhart@infradead.org>, linux-ext4@vger.kernel.org,
	adilger@dilger.ca, sgw@linux.intel.com
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:41883 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755865Ab3AEWlK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 5 Jan 2013 17:41:10 -0500
Content-Disposition: inline
In-Reply-To: <20130105200716.GM20106@blackbox.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jan 05, 2013 at 12:07:16PM -0800, Darrick J. Wong wrote:
> Given that you can have at most one data block anyway, does it matter to set
> EXTENTS_FL?

It doesn't matter either way.

> Also, what happens to the inode + data block if the ext2fs_link fails?  I don't
> see any code that explicitly rolls back those allocations, but maybe I missed
> something?

It's fine.  We don't actually update the block bitmap, nor update the
block group statistics, until the very end, when the proposed code does this:

	 */
	if (!fastlink)
		ext2fs_block_alloc_stats2(fs, blk, +1);
	ext2fs_inode_alloc_stats2(fs, ino, +1, 1);

This is one of the reasons why ext2fs_new_block and ext2fs_new_inode
don't actually mark the block and inode as in use.  You could argue
they are misnamed; something like ext2fs_find_unused_{block,inode}()
would have been better names, but what I can say?  I didn't think of
that back in 1996....

					- Ted
