From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: block groups with no inode tables
Date: Tue, 10 Jul 2007 22:31:18 -0600
Message-ID: <20070711043118.GJ6417@schatzie.adilger.int>
References: <20070710121221.5478a1e3@rx8> <20070710203050.GH27033@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Jose R. Santos" <jrs@us.ibm.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 74-0-229-162.T1.lbdsl.net ([74.0.229.162]:46160 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159AbXGKEbU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 Jul 2007 00:31:20 -0400
Content-Disposition: inline
In-Reply-To: <20070710203050.GH27033@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jul 10, 2007  16:30 -0400, Theodore Tso wrote:
> On Tue, Jul 10, 2007 at 12:12:21PM -0500, Jose R. Santos wrote:
> > As I play with the allocation of the metadata for the FLEX_BG feature,
> > it seems that we could benefit from having block groups with no inode
> > tables.  Right now we allocate one inode table per bg base on the
> > inode_blocks_per_group.  For FLEX_BG though, it would make more sense
> > to have a larger inode tables that fully use the inode bitmap allocated
> > on the first few block groups.  Once we reach the number of inode per
> > FLEX_BG, then the remaining block groups could then have no inode
> > tables defined.
> > 
> > The idea here is that we better utilize the inode bitmaps and reduce the
> > number of inode tables to improve mkfs/fsck times. We could also
> > support expansion of inode since we have block groups that have empty
> > entries in the block group descriptors and as long as we can find
> > enough empty blocks for the inode table expanding the number of inodes
> > should be relatively easy.
> > 
> > Don't know if ext4 currently supports this.  Any thoughts?
> 
> Plans to support are there; Andreas sent a patch back in April to
> implement this, using bg_itable_unused, which is already reserved in
> the block group data structure.  The idea here is to speed up fsck by
> specifying how many inodes are actually in use in the block group, so
> we don't have to initialize them until they are to be used.  This is
> tied with the checksum patches, since doing this means we need to
> really worry about the accuracy of the block group descriptors or we
> could lose a lot of data if the block group descriptors are corrupted.

I think Jose means something slightly different, but in the end the
uninit_groups feature (patches in the patch queue, but disabled for
some reason) essentially implements this.  We don't need to read inode
bitmaps from disk if the INODE_UNINIT flag is in the group.

I think all that is needed to get the semantics Jose wants is to tune
the inode allocation in ext4_new_inode() to avoid inode bitmaps that
are not yet initialized.  I suppose the other incremental feature would
be to allow the blocks in the inode table become used for file allocation,
but this exposes us to potential malicious corruption in some cases if
users create "inode looking" data files (e.g. suid root inodes) on a full
filesystem and e2fsck is convinced to treat them as inodes.

We might instead limit this space to directories and indirect/index
blocks, which wouldn't be a bad idea but when we get to changing the
inode structures too much I'd like to combine several of the other
changes.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
