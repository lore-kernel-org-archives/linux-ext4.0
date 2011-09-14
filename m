From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 11/37] libext2fs: Create the inode bitmap checksum
Date: Wed, 14 Sep 2011 18:14:47 -0400
Message-ID: <20110914221447.GA15782@thunk.org>
References: <20110901003509.1176.51159.stgit@elm3c44.beaverton.ibm.com>
 <20110901003622.1176.1504.stgit@elm3c44.beaverton.ibm.com>
 <20110914170259.GG3429@dhcp-172-31-195-159.cam.corp.google.com>
 <1240A2E8-5AA6-4F97-BB36-944A2F51B2E5@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Darrick J. Wong" <djwong@us.ibm.com>,
	Sunil Mushran <sunil.mushran@oracle.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>, linux-ext4@vger.kernel.org,
	Coly Li <colyli@gmail.com>
To: Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:56794 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750698Ab1INWOy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 14 Sep 2011 18:14:54 -0400
Content-Disposition: inline
In-Reply-To: <1240A2E8-5AA6-4F97-BB36-944A2F51B2E5@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 14, 2011 at 01:59:06PM -0600, Andreas Dilger wrote:
> 
> There is the field that you told Amir he could use for the exception
> bitmap for snapshots, which is using one of the two reserved fields in
> ext2_group_desc, and also one of the 3 reserved fields in ext4_group_desc
> for 64-bit block numbers.  That leaves one __u32 in ext2_group_desc, and
> two __u32 in ext4_group_desc for checksums.

Right, that's what I was forgetting.  Thanks for reminding me!

> My proposal was as follows.  It adds the split checksums for block and
> inode bitmaps, and renames bg_checksum to bg_group_desc_csum to avoid
> confusion with these new checksums.  Truncate after bg_group_desc_csum
> for smaller ext2_group_desc version.
> 
> struct ext4_group_desc
> {
>         __le32  bg_block_bitmap_lo;     /* Blocks bitmap block */
>         __le32  bg_inode_bitmap_lo;     /* Inodes bitmap block */
>         __le32  bg_inode_table_lo;      /* Inodes table block */
>         __le16  bg_free_blocks_count_lo;/* Free blocks count */
>         __le16  bg_free_inodes_count_lo;/* Free inodes count */
>         __le16  bg_used_dirs_count_lo;  /* Directories count */
>         __le16  bg_flags;               /* EXT4_BG_flags (INODE_UNINIT, etc) */
>         __le32  bg_exclude_bitmap_lo;   /* Snapshot exclude bitmap block LSB */
>         __le16  bg_block_bitmap_csum_lo;/* crc32c(s_uuid+grp_num+bitmap) LSB */
>         __le16  bg_inode_bitmap_csum_lo;/* crc32c(s_uuid+grp_num+bitmap) LSB */
>         __le16  bg_itable_unused_lo;    /* Unused inodes count */
>         __le16  bg_group_desc_csum;     /* crc16(sb_uuid+group+desc) */
>         __le32  bg_block_bitmap_hi;     /* Blocks bitmap block MSB */
>         __le32  bg_inode_bitmap_hi;     /* Inodes bitmap block MSB */
>         __le32  bg_inode_table_hi;      /* Inodes table block MSB */
>         __le16  bg_free_blocks_count_hi;/* Free blocks count MSB */
>         __le16  bg_free_inodes_count_hi;/* Free inodes count MSB */
>         __le16  bg_used_dirs_count_hi;  /* Directories count MSB */
>         __le16  bg_itable_unused_hi;    /* Unused inodes count MSB */
> 	__le32	bg_exclude_bitmap_hi;	/* Exclude bitmap block MSB */
>         __le16  bg_block_bitmap_csum_hi;/* crc32c(s_uuid+grp_num+bitmap) MSB */
>         __le16  bg_inode_bitmap_csum_hi;/* crc32c(s_uuid+grp_num+bitmap) MSB */
>         __le32  bg_reserved2;
> };

That looks reasonable to me.

> Whether crc32c & 0xffff is as strong as crc16 is open for debate, but it
> isn't completely worthless (it provides some protection, and crc32c is
> much faster at least for larger block sizes), and is only for filesystems
> upgraded in-place from ext3 so it isn't critical in the long run.  I'd
> rather have less complex and faster code than having to conditionally
> compute crc16 vs crc32c depending on the ext4_group_desc size.

That seems reasonable for me.  Note that most ext4 file systems are
still being created using the 32 byte bg descriptor, mainly for
compatibility for older 1.41.x e2fsprogs.  But yes, long term that's
fair.

> There is also the question if we want to extend bg_group_desc_csum and/or
> the bg_flags values to be 32-bit fields?  If we do, then that uses up all
> of the space in the 64-byte group descriptor and we would need to bump it
> to 128 bytes to add any new fields.  We can deal with that when we run
> out of flags.

I don't think either is likely; we've used very few flags in bg_flags
so far, and the bg_group_desc_csum is only covering 64 bytes.  A
16-bit checksum should be more than good enough for that.

The thing which did occur to me was whether it would make sence to
change the use of crc16(x) to crc32(x) & 0xffff if the METADATA_CSUM
feature is enabled for the existing bg_checksum field.  But the speed
benefits for checksuming such a small number of bytes is minimal, and
probably not worth the extra code complexity.

Regards,

						- Ted
