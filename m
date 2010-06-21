From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 1/8] e2fsprogs: Next3 on-disk format changes
Date: Mon, 21 Jun 2010 12:32:37 -0600
Message-ID: <DEF06E15-64B4-4661-9091-2F5E2BD308CC@dilger.ca>
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org development" <linux-ext4@vger.kernel.org>
To: Amir Goldstein <amir73il@users.sf.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:49614 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268Ab0FUSci convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Jun 2010 14:32:38 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Amir Goldstein <amir73il@users.sf.net> wrote on 2010-05-05 18:28:49:
> @@ -113,6 +113,11 @@ static struct field_set_info super_fields[] = {
>  	{ "journal_inum", &set_sb.s_journal_inum, 4, parse_uint },
>  	{ "journal_dev", &set_sb.s_journal_dev, 4, parse_uint },
>  	{ "last_orphan", &set_sb.s_last_orphan, 4, parse_uint },
> +	{ "snapshot_inum", &set_sb.s_snapshot_inum, 4, parse_uint },
> +	{ "snapshot_id", &set_sb.s_snapshot_id, 4, parse_uint },
> +	{ "snapshot_r_blocks_count", &set_sb.s_snapshot_r_blocks_count,
> +		4, parse_uint },
> +	{ "snapshot_list", &set_sb.s_snapshot_list, 4, parse_uint },
>  	{ "hash_seed", &set_sb.s_hash_seed, 16, parse_uuid },
>  	{ "def_hash_version", &set_sb.s_def_hash_version, 1, parse_hashalg },
>  	{ "jnl_backup_type", &set_sb.s_jnl_backup_type, 1, parse_uint },


These should be added into the array in superblock offset order, rather than into the middle of the array.

> @@ -29,6 +29,8 @@ static struct feature feature_list[] = {
>  			"dir_prealloc" },
>  	{	E2P_FEATURE_COMPAT, EXT3_FEATURE_COMPAT_HAS_JOURNAL,
>  			"has_journal" },
> +	{	E2P_FEATURE_COMPAT, NEXT3_FEATURE_COMPAT_BIG_JOURNAL,
> +			"big_journal" },
>  	{	E2P_FEATURE_COMPAT, EXT2_FEATURE_COMPAT_IMAGIC_INODES,
>  			"imagic_inodes" },
>  	{	E2P_FEATURE_COMPAT, EXT2_FEATURE_COMPAT_EXT_ATTR,

These should be added into the array in feature number order, rather than into the middle of the array.

> @@ -37,6 +39,8 @@ static struct feature feature_list[] = {
>  			"dir_index" },
>  	{	E2P_FEATURE_COMPAT, EXT2_FEATURE_COMPAT_RESIZE_INODE,
>  			"resize_inode" },
> +	{	E2P_FEATURE_COMPAT, NEXT3_FEATURE_COMPAT_EXCLUDE_INODE,
> +			"exclude_inode" },
>  	{	E2P_FEATURE_COMPAT, EXT2_FEATURE_COMPAT_LAZY_BG,
>  			"lazy_bg" },

Same.
 
> @@ -44,6 +48,14 @@ static struct feature feature_list[] = {
>  			"sparse_super" },
>  	{	E2P_FEATURE_RO_INCOMPAT, EXT2_FEATURE_RO_COMPAT_LARGE_FILE,
>  			"large_file" },
> +	{	E2P_FEATURE_RO_INCOMPAT, NEXT3_FEATURE_RO_COMPAT_HAS_SNAPSHOT,
> +			"has_snapshot" },
> +	{	E2P_FEATURE_RO_INCOMPAT, NEXT3_FEATURE_RO_COMPAT_IS_SNAPSHOT,
> +			"is_snapshot" },
> +	{	E2P_FEATURE_RO_INCOMPAT, NEXT3_FEATURE_RO_COMPAT_FIX_SNAPSHOT,
> +			"fix_snapshot" },
> +	{	E2P_FEATURE_RO_INCOMPAT, NEXT3_FEATURE_RO_COMPAT_FIX_EXCLUDE,
> +			"fix_exclude" },
>  	{	E2P_FEATURE_RO_INCOMPAT, EXT4_FEATURE_RO_COMPAT_HUGE_FILE,
>  			"huge_file" },
>  	{	E2P_FEATURE_RO_INCOMPAT, EXT4_FEATURE_RO_COMPAT_GDT_CSUM,

Same


> @@ -144,7 +144,8 @@ struct ext2_group_desc
>  	__u16	bg_free_inodes_count;	/* Free inodes count */
>  	__u16	bg_used_dirs_count;	/* Directories count */
>  	__u16	bg_flags;
> -	__u32	bg_reserved
> [2]
> ;
> +	__u32	bg_exclude_bitmap;	/* Exclude bitmap block */
> +	__u32	bg_cow_bitmap;		/* COW bitmap block of last snapshot */

These two fields were intended to hold the 32-bit checksum of the inode and block bitmaps for this group.  Also, a 32-bit block number is not sufficient for a filesystem larger than 2^32 blocks, and there is no way to extend this in the future to hold the full block number.

> @@ -426,14 +427,14 @@ struct ext2_inode_large {
> -#define i_reserved1	osd1.linux1.l_i_reserved1
> +#define i_next_snapshot	osd1.linux1.l_i_version

This field is already in use by NFS and Lustre, I don't think it is correct to re-use it.

> @@ -638,6 +648,10 @@ struct ext2_super_block {
>  #define EXT4_FEATURE_RO_COMPAT_GDT_CSUM		0x0010
>  #define EXT4_FEATURE_RO_COMPAT_DIR_NLINK	0x0020
>  #define EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE	0x0040
> +#define NEXT3_FEATURE_RO_COMPAT_HAS_SNAPSHOT	0x1000 /* Next3 has snapshots */
> +#define NEXT3_FEATURE_RO_COMPAT_IS_SNAPSHOT	0x2000 /* Is a snapshot image */
> +#define NEXT3_FEATURE_RO_COMPAT_FIX_SNAPSHOT	0x4000 /* Corrupted snapshot */
> +#define NEXT3_FEATURE_RO_COMPAT_FIX_EXCLUDE	0x8000 /* Bad exclude bitmap */

Are all of these states mutually exclusive?  Can they legally all be set at the same time?


Cheers, Andreas

