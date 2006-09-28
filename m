From: Alexandre Ratchov <alexandre.ratchov@bull.net>
Subject: Re: ext4 compat flag assignments
Date: Thu, 28 Sep 2006 10:55:15 +0200
Message-ID: <20060928085515.GC27104@openx1.frec.bull.fr>
References: <20060922091520.GC6335@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:12425 "EHLO
	ecfrec.frec.bull.fr") by vger.kernel.org with ESMTP
	id S1751674AbWI1IzZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 Sep 2006 04:55:25 -0400
To: Andreas Dilger <adilger@clusterfs.com>
In-Reply-To: <20060922091520.GC6335@schatzie.adilger.int>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Sep 22, 2006 at 02:15:20AM -0700, Andreas Dilger wrote:
> Ted,
> there are several COMPAT flag assignments that have been proposed in
> the past:

as Ted suggested, i post here a list of all fields we plan to use, perhaps
others could complete it?

> 
> - EXT4_FEATURE_INCOMPAT_64BIT (0x0080!) - support for 64-bit block count
>   fields in the superblock (s_blocks_count_hi, s_free_blocks_count_hi),
>   large group descriptors (s_desc_size), extents with high 16 bits
>   (ee_start_hi, ei_leaf_hi), inode ACL (i_file_acl_hi).  May also grow
>   to encompass the previously proposed BIG_BG.
>


here is a list of fields we plan to use for the 64bit support, they must be
zero on file systems without the EXT4_FEATURE_INCOMPAT_64BIT.

struct ext4_super_block
{
	/* at offset 0xfe */
	__le32	s_desc_size;		/* Group descriptor size */
	/* at offset 0x150 */
	__le32	s_blocks_count_hi;	/* Blocks count */
	__le32	s_r_blocks_count_hi;	/* Reserved blocks count */
	__le32	s_free_blocks_count_hi;	/* Free blocks count */
	__le32	s_jnl_blocks_hi[17];	/* Backup of the journal inode */
};

struct ext4_group_desc
{
	/* at offset 0x20 */
	__le32	bg_block_bitmap;	/* Blocks bitmap block hi bits */
	__le32	bg_inode_bitmap;	/* Inodes bitmap block hi bits */
	__le32	bg_inode_table;		/* Inodes table block hi bits */
	__le16	bg_free_blocks_count;	/* Free blocks count hi bits */
	__le16	bg_free_inodes_count;	/* Free inodes count hi bits */
	__le16	bg_used_dirs_count;	/* Directories count hi bits */
};

basically, we make 64bit all block numbers and we double the size of all
xxx_count in the block group descriptor.

> - EXT4_FEATURE_RO_COMPAT_HUGE_FILE (0x0008) - change i_blocks to be
>   in units of s_blocksize units instead of 512-byte sectors, use
>   l_i_frag and l_i_fsize as i_blocks_hi (could also be part of 64BIT).
>   Also uses EXT4_HUGE_FILE_FL 0x40000 for i_flags.
> 
> - EXT4_FEATURE_RO_COMPAT_GDT_CSUM (0x0010?) - store a crc16 checksum in
>   the group descriptor (s_uuid[16] | __u32 group | ext3_group_desc
>   (excluding gd_checksum itself)).  This allows the kernel to more safely
>   manage UNINIT groups.  Incomplete patch, e2fsck support mostly done.
> 
> - EXT4_FEATURE_RO_COMPAT_DIR_NLINK (0x0020?) - allow directories to have >
>   65000 subdirectories (i_nlinks) by setting i_nlinks = 1 for such
>   directories.  RO_COMPAT protects old filesystems from unlinking such
>   directories incorrectly and losing all files therein.  Needs RO_COMPAT
>   flag handling, needs e2fsck support, but very heavily tested.
> 
> - EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE (0x0040?) - add s_min_extra_isize and
>   s_want_extra_isize fields to superblock, which allow specifying
>   the minimum and desired i_extra_isize fields in large inodes
>   (for nsec+epoch timestamps, potential other uses).  Needs RO_COMPAT
>   flag handling, needs e2fsck support, patch complete, little testing.
> 
> 
> I'm not sure about the state of HUGE_FILE (it might be useful for ext[23]
> to allow larger sparse files, but also fits quite well with INCOMPAT_64BIT),
> but the others are definitely useful independent from INCOMPAT_64BIT.
> There are patches in various states of completion for all of the features.
> 

i agree, this should go with INCOMPAT_64BIT.

There's also the change attribute patch; it currently uses the l_i_reserved2
field of the inode:

-                       __u32   l_i_reserved2;
+                       __le32  l_i_change_attribute;

-#define i_reserved2    osd2.linux2.l_i_reserved2
+#define i_chattr       osd2.linux2.l_i_change_attribute

It doesn't need RO_COMPAT/INCOMPAT flag because there are no incompatibility
issues with kernels that do not support the change attribute but that mount
file systems that have used it. Also it doesn't really need changes in fsck.

cheers,

-- Alexandre
