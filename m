From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: ext4 compat flag assignments
Date: Thu, 28 Sep 2006 16:41:33 -0600
Message-ID: <20060928224133.GM22010@schatzie.adilger.int>
References: <20060922091520.GC6335@schatzie.adilger.int> <20060928085515.GC27104@openx1.frec.bull.fr> <p73u02rivk8.fsf@verdi.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alexandre Ratchov <alexandre.ratchov@bull.net>,
	Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:23722 "EHLO
	mail.clusterfs.com") by vger.kernel.org with ESMTP id S1751027AbWI1Wlg
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 Sep 2006 18:41:36 -0400
To: Andi Kleen <ak@suse.de>
Content-Disposition: inline
In-Reply-To: <p73u02rivk8.fsf@verdi.suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sep 28, 2006  22:29 +0200, Andi Kleen wrote:
> Alexandre Ratchov <alexandre.ratchov@bull.net> writes:
> > struct ext4_group_desc
> > {
> > 	/* at offset 0x20 */
> > 	__le32	bg_block_bitmap;	/* Blocks bitmap block hi bits */
> > 	__le32	bg_inode_bitmap;	/* Inodes bitmap block hi bits */
> > 	__le32	bg_inode_table;		/* Inodes table block hi bits */
> > 	__le16	bg_free_blocks_count;	/* Free blocks count hi bits */
> > 	__le16	bg_free_inodes_count;	/* Free inodes count hi bits */
> > 	__le16	bg_used_dirs_count;	/* Directories count hi bits */
> > };
> > 
> > basically, we make 64bit all block numbers and we double the size of all
> > xxx_count in the block group descriptor.
> 
> When you do this have you considered at least reserving fields in the 
> new 64bit indirect blocks for checksums for each block? 
>
> IMHO it would be a great advantage to checksum all metadata 
> (as demonstrated by ZFS) and CPU cycles are cheap enough now that it is 
> basically free.

Actually, there are several plans afoot in that direction already.
Some of them need at least some help in the "finish up and get it
into the kernel" department, some of them are just ideas previously
discussed..

One of the reason for Alexandre pushing the 64-bit inode/block counters
into the "large" descriptor is because the 64-bit filesystem is already
incompatible with a 32-bit filesystem so there is no extra harm, and this
leaves space in the "original" group descriptor for checksums of the block
and inode bitmaps.  The bitmap checksums are a critical single-point-of-
failure, and having checksums allows the kernel to avoid cascading
filesystem corruption even if it can't (yet) do anything about it.
Having the checksums in the "original" group descriptor allows this
feature to be used on both 32-bit and 64-bit filesystems.

No work has been done on this yet.  Getting checksums to be efficient
depends on having a generic callback mechanism from the journal code
to avoid repeated checksums on a block while it is being modified.
The journal callback would do the checksum exactly once for each block
(or sub-structure therein) at checkpoint time.

A second change is to add checksums to the ext3 journal commit blocks
(per U. Wisconsin) to avoid need for 2-phase commit for transactions,
and to provide redundancy.  Patches for the kernel and e2fsck are
available for that already (not 100% sure if I posted them here).

Checksums for the group descriptors themselves, to allow mke2fs
and the kernel to handle "uninitialized groups".  This means that mke2fs
doesn't need to zero the block/inode bitmaps and inode table, and the
kernel can selectively initialize the inode tables to avoid the need to
read all of them during e2fsck time.  The checksum is a safety check on
the group descriptor flags, as well as providing normal corruption detection.
Patches for the kernel and e2fsck are in early prototype and were posted
about a week ago.

Finally, the extents format has the capability (though no code is implemented
for this yet) to store a checksum in each index and extent block.  This
would be done by reducing the count of allowed entries in the block and
storing an ext3_extent_tail (checksum, inode+generation backpointer) as
the last entry in the block.  No work has been done on this, but I've
described the ext3_extent_tail a few times previously on this list.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

