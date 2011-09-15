From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 1/2] libext2fs: add metadata checksum and snapshot feature flags
Date: Thu, 15 Sep 2011 17:09:13 -0600
Message-ID: <F041558F-1F4B-4ADE-9DC2-53708C9124B8@dilger.ca>
References: <1316127052-1890-1-git-send-email-tytso@mit.edu> <1316127052-1890-2-git-send-email-tytso@mit.edu>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"Darrick J. Wong" <djwong@us.ibm.com>,
	Amir Goldstein <amir73il@gmail.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:63511 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935277Ab1IOXJQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 15 Sep 2011 19:09:16 -0400
In-Reply-To: <1316127052-1890-2-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-09-15, at 4:50 PM, Theodore Ts'o wrote:
> Reserve EXT4_FEATURE_RO_COMPAT_METADATA_CSUM and
> EXT2_FEATURE_COMPAT_EXCLUDE_BITMAP.  Also reserve fields in the
> superblock and the inode for the checksums.  In the block group
> descriptor, reserve the exclude bitmap field for the snapshot feature,
> and checksums for the inode and block allocation bitmaps.
> 
> With this commit, the metadata checksum and exclude bitmap features
> should have reserved all of the fields they need in ext4's on-disk
> format.
> 
> #define EXT2_BG_INODE_UNINIT	0x0001 /* Inode table/bitmap not initialized */
> @@ -363,7 +370,8 @@ struct ext2_inode {
> 			__u16	l_i_file_acl_high;
> 			__u16	l_i_uid_high;	/* these 2 fields    */
> 			__u16	l_i_gid_high;	/* were reserved2[0] */
> -			__u32	l_i_reserved2;
> +			__u16	l_i_checksum_lo;/* crc32c(uuid+inum+inode) */
> +			__u16	l_i_reserved;	/* crc32c(uuid+inum+inode) */
> 		} linux2;

The comment for l_i_reserved is incorrect, and the comment should include "LSB"? 
Also, if the order of these two fields was swapped it would avoid an extra
call to the CRC function to checksum the last 2 bytes:

			__u16	l_i_uid_high;	/* these 2 fields    */
			__u16	l_i_gid_high;	/* were reserved2[0] */
-			__u32	l_i_reserved2;
+			__u16	l_i_reserved;
+			__u16	l_i_checksum_lo;/* crc32c(uuid+inum+inode) LSB*/
		} linux2;

> @@ -422,7 +431,7 @@ struct ext2_inode_large {
> 		} hurd2;
> 	} osd2;				/* OS dependent 2 */
> 	__u16	i_extra_isize;
> -	__u16	i_pad1;
> +	__u16	i_checksum_hi;	/* crc32c(uuid+inum+inode) */

This comment should include "MSB".

> @@ -623,7 +632,8 @@ struct ext2_super_block {
> 	__u32	s_usr_quota_inum;	/* inode number of user quota file */
> 	__u32	s_grp_quota_inum;	/* inode number of group quota file */
> 	__u32	s_overhead_blocks;	/* overhead blocks/clusters in fs */
> -	__u32   s_reserved[109];        /* Padding to the end of the block */
> +	__u32	s_checksum;		/* crc32c(superblock) */
> +	__u32   s_reserved[108];        /* Padding to the end of the block */
> };


I thought it would be better to move s_checksum to be the last field in the
superblock to avoid multiple calls to the CRC function?  So:

	__u32	s_grp_quota_inum;	/* inode number of group quota file */
	__u32	s_overhead_blocks;	/* overhead blocks/clusters in fs */
-	__u32   s_reserved[109];        /* Padding to the end of the block */
+	__u32   s_reserved[108];        /* Padding to the end of the block */
+	__u32	s_checksum;		/* crc32c(superblock) */
};


> diff --git a/lib/ext2fs/tst_inode_size.c b/lib/ext2fs/tst_inode_size.c
> index 962f1cd..a4f6247 100644
> --- a/lib/ext2fs/tst_inode_size.c
> +++ b/lib/ext2fs/tst_inode_size.c
> @@ -61,7 +61,8 @@ void check_structure_fields()
> 	check_field(osd2.linux2.l_i_file_acl_high);
> 	check_field(osd2.linux2.l_i_uid_high);
> 	check_field(osd2.linux2.l_i_gid_high);
> -	check_field(osd2.linux2.l_i_reserved2);
> +	check_field(osd2.linux2.l_i_checksum_lo);
> +	check_field(osd2.linux2.l_i_reserved);
> 	printf("Ending offset is %d\n\n", cur_offset);
> #endif
> }
> diff --git a/lib/ext2fs/tst_super_size.c b/lib/ext2fs/tst_super_size.c
> index 1e5a524..75659ae 100644
> --- a/lib/ext2fs/tst_super_size.c
> +++ b/lib/ext2fs/tst_super_size.c
> @@ -126,6 +126,7 @@ void check_superblock_fields()
> 	check_field(s_usr_quota_inum);
> 	check_field(s_grp_quota_inum);
> 	check_field(s_overhead_blocks);
> +	check_field(s_checksum);
> 	check_field(s_reserved);
> 	printf("Ending offset is %d\n\n", cur_offset);
> #endif

These two checks would need to be reversed to match the above changes.

Cheers, Andreas





