From: Andi Kleen <ak@suse.de>
Subject: Re: ext4 compat flag assignments
Date: 28 Sep 2006 22:29:43 +0200
Message-ID: <p73u02rivk8.fsf@verdi.suse.de>
References: <20060922091520.GC6335@schatzie.adilger.int>
	<20060928085515.GC27104@openx1.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.suse.de ([195.135.220.2]:49598 "EHLO mx1.suse.de")
	by vger.kernel.org with ESMTP id S1750721AbWI1U3v (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 Sep 2006 16:29:51 -0400
To: Alexandre Ratchov <alexandre.ratchov@bull.net>
In-Reply-To: <20060928085515.GC27104@openx1.frec.bull.fr>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Alexandre Ratchov <alexandre.ratchov@bull.net> writes:

> here is a list of fields we plan to use for the 64bit support, they must be
> zero on file systems without the EXT4_FEATURE_INCOMPAT_64BIT.
> 
> struct ext4_super_block
> {
> 	/* at offset 0xfe */
> 	__le32	s_desc_size;		/* Group descriptor size */
> 	/* at offset 0x150 */
> 	__le32	s_blocks_count_hi;	/* Blocks count */
> 	__le32	s_r_blocks_count_hi;	/* Reserved blocks count */
> 	__le32	s_free_blocks_count_hi;	/* Free blocks count */
> 	__le32	s_jnl_blocks_hi[17];	/* Backup of the journal inode */
> };
> 
> struct ext4_group_desc
> {
> 	/* at offset 0x20 */
> 	__le32	bg_block_bitmap;	/* Blocks bitmap block hi bits */
> 	__le32	bg_inode_bitmap;	/* Inodes bitmap block hi bits */
> 	__le32	bg_inode_table;		/* Inodes table block hi bits */
> 	__le16	bg_free_blocks_count;	/* Free blocks count hi bits */
> 	__le16	bg_free_inodes_count;	/* Free inodes count hi bits */
> 	__le16	bg_used_dirs_count;	/* Directories count hi bits */
> };
> 
> basically, we make 64bit all block numbers and we double the size of all
> xxx_count in the block group descriptor.

When you do this have you considered at least reserving fields in the 
new 64bit indirect blocks for checksums for each block? 

IMHO it would be a great advantage to checksum all metadata 
(as demonstrated by ZFS) and CPU cycles are cheap enough now that it is 
basically free.

The checksums could be different feature flags, but it would be useful
to reserve space in any new format. 16 byte free on each block should be enough.

-Andi
