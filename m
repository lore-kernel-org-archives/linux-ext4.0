From: Theodore Tso <tytso@mit.edu>
Subject: Re: block groups with no inode tables
Date: Tue, 10 Jul 2007 16:30:50 -0400
Message-ID: <20070710203050.GH27033@thunk.org>
References: <20070710121221.5478a1e3@rx8>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:39850 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753047AbXGJUax (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Jul 2007 16:30:53 -0400
Content-Disposition: inline
In-Reply-To: <20070710121221.5478a1e3@rx8>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jul 10, 2007 at 12:12:21PM -0500, Jose R. Santos wrote:
> Hi folks,
> 
> As I play with the allocation of the metadata for the FLEX_BG feature,
> it seems that we could benefit from having block groups with no inode
> tables.  Right now we allocate one inode table per bg base on the
> inode_blocks_per_group.  For FLEX_BG though, it would make more sense
> to have a larger inode tables that fully use the inode bitmap allocated
> on the first few block groups.  Once we reach the number of inode per
> FLEX_BG, then the remaining block groups could then have no inode
> tables defined.
> 
> The idea here is that we better utilize the inode bitmaps and reduce the
> number of inode tables to improve mkfs/fsck times. We could also
> support expansion of inode since we have block groups that have empty
> entries in the block group descriptors and as long as we can find
> enough empty blocks for the inode table expanding the number of inodes
> should be relatively easy.
> 
> Don't know if ext4 currently supports this.  Any thoughts?

Plans to support are there; Andreas sent a patch back in April to
implement this, using bg_itable_unused, which is already reserved in
the block group data structure.  The idea here is to speed up fsck by
specifying how many inodes are actually in use in the block group, so
we don't have to initialize them until they are to be used.  This is
tied with the checksum patches, since doing this means we need to
really worry about the accuracy of the block group descriptors or we
could lose a lot of data if the block group descriptors are corrupted.

We also have something already implemented which does this on a
per-blockgroup basis.  That's the LAZY_BG feature, which was intended
for testing really big filesystems without needing to initialize all
of the inode tables.  In fact mke2fs -O lazy_bg it only initializes
the first and last blockgroups, in order to make sure we can force the
use of blocks at the very end of the filesystem, so we can find any
2**32 bit cleanliness problems, or other problems with really big
block numbers.

Regards,

						- Ted
