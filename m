From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] ext4: Remove automatic enabling of the HUGE_FILE	feature
 flag
Date: Fri, 17 Oct 2008 14:24:24 -0600
Message-ID: <20081017202424.GE3184@webber.adilger.int>
References: <1224250047-31403-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:38041 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbYJQUYh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 17 Oct 2008 16:24:37 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m9HKObx2019108
	for <linux-ext4@vger.kernel.org>; Fri, 17 Oct 2008 13:24:37 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K8W00K01GLEVX00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Fri, 17 Oct 2008 13:24:36 -0700 (PDT)
In-reply-to: <1224250047-31403-1-git-send-email-tytso@mit.edu>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Oct 17, 2008  09:27 -0400, Theodore Ts'o wrote:
> If the HUGE_FILE feature flag is not set, don't allow the creation of
> large files, instead of automatically enabling the feature flag.
> Recent versions of mke2fs will set the HUGE_FILE flag automatically
> anyway for ext4 filesystems.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

Took a second to grok the change, but it looks OK.

Acked-by: Andreas Dilger <adilger@sun.com>

> ---
>  fs/ext4/inode.c |   24 ++++-----------
>  fs/ext4/super.c |   85 +++++++++----------------------------------------------
>  2 files changed, 21 insertions(+), 88 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 27fc6b9..8dbf695 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4194,7 +4194,6 @@ static int ext4_inode_blocks_set(handle_t *handle,
>  	struct inode *inode = &(ei->vfs_inode);
>  	u64 i_blocks = inode->i_blocks;
>  	struct super_block *sb = inode->i_sb;
> -	int err = 0;
>  
>  	if (i_blocks <= ~0U) {
>  		/*
> @@ -4204,36 +4203,27 @@ static int ext4_inode_blocks_set(handle_t *handle,
>  		raw_inode->i_blocks_lo   = cpu_to_le32(i_blocks);
>  		raw_inode->i_blocks_high = 0;
>  		ei->i_flags &= ~EXT4_HUGE_FILE_FL;
> -	} else if (i_blocks <= 0xffffffffffffULL) {
> +		return 0;
> +	}
> +	if (!EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_HUGE_FILE))
> +		return -EFBIG;
> +
> +	if (i_blocks <= 0xffffffffffffULL) {
>  		/*
>  		 * i_blocks can be represented in a 48 bit variable
>  		 * as multiple of 512 bytes
>  		 */
> -		err = ext4_update_rocompat_feature(handle, sb,
> -					    EXT4_FEATURE_RO_COMPAT_HUGE_FILE);
> -		if (err)
> -			goto  err_out;
> -		/* i_block is stored in the split  48 bit fields */
>  		raw_inode->i_blocks_lo   = cpu_to_le32(i_blocks);
>  		raw_inode->i_blocks_high = cpu_to_le16(i_blocks >> 32);
>  		ei->i_flags &= ~EXT4_HUGE_FILE_FL;
>  	} else {
> -		/*
> -		 * i_blocks should be represented in a 48 bit variable
> -		 * as multiple of  file system block size
> -		 */
> -		err = ext4_update_rocompat_feature(handle, sb,
> -					    EXT4_FEATURE_RO_COMPAT_HUGE_FILE);
> -		if (err)
> -			goto  err_out;
>  		ei->i_flags |= EXT4_HUGE_FILE_FL;
>  		/* i_block is stored in file system block size */
>  		i_blocks = i_blocks >> (inode->i_blkbits - 9);
>  		raw_inode->i_blocks_lo   = cpu_to_le32(i_blocks);
>  		raw_inode->i_blocks_high = cpu_to_le16(i_blocks >> 32);
>  	}
> -err_out:
> -	return err;
> +	return 0;
>  }
>  
>  /*
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 95127f0..9b2b2bc 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -374,66 +374,6 @@ void ext4_update_dynamic_rev(struct super_block *sb)
>  	 */
>  }
>  
> -int ext4_update_compat_feature(handle_t *handle,
> -					struct super_block *sb, __u32 compat)
> -{
> -	int err = 0;
> -	if (!EXT4_HAS_COMPAT_FEATURE(sb, compat)) {
> -		err = ext4_journal_get_write_access(handle,
> -				EXT4_SB(sb)->s_sbh);
> -		if (err)
> -			return err;
> -		EXT4_SET_COMPAT_FEATURE(sb, compat);
> -		sb->s_dirt = 1;
> -		handle->h_sync = 1;
> -		BUFFER_TRACE(EXT4_SB(sb)->s_sbh,
> -					"call ext4_journal_dirty_met adata");
> -		err = ext4_journal_dirty_metadata(handle,
> -				EXT4_SB(sb)->s_sbh);
> -	}
> -	return err;
> -}
> -
> -int ext4_update_rocompat_feature(handle_t *handle,
> -					struct super_block *sb, __u32 rocompat)
> -{
> -	int err = 0;
> -	if (!EXT4_HAS_RO_COMPAT_FEATURE(sb, rocompat)) {
> -		err = ext4_journal_get_write_access(handle,
> -				EXT4_SB(sb)->s_sbh);
> -		if (err)
> -			return err;
> -		EXT4_SET_RO_COMPAT_FEATURE(sb, rocompat);
> -		sb->s_dirt = 1;
> -		handle->h_sync = 1;
> -		BUFFER_TRACE(EXT4_SB(sb)->s_sbh,
> -					"call ext4_journal_dirty_met adata");
> -		err = ext4_journal_dirty_metadata(handle,
> -				EXT4_SB(sb)->s_sbh);
> -	}
> -	return err;
> -}
> -
> -int ext4_update_incompat_feature(handle_t *handle,
> -					struct super_block *sb, __u32 incompat)
> -{
> -	int err = 0;
> -	if (!EXT4_HAS_INCOMPAT_FEATURE(sb, incompat)) {
> -		err = ext4_journal_get_write_access(handle,
> -				EXT4_SB(sb)->s_sbh);
> -		if (err)
> -			return err;
> -		EXT4_SET_INCOMPAT_FEATURE(sb, incompat);
> -		sb->s_dirt = 1;
> -		handle->h_sync = 1;
> -		BUFFER_TRACE(EXT4_SB(sb)->s_sbh,
> -					"call ext4_journal_dirty_met adata");
> -		err = ext4_journal_dirty_metadata(handle,
> -				EXT4_SB(sb)->s_sbh);
> -	}
> -	return err;
> -}
> -
>  /*
>   * Open the external journal device
>   */
> @@ -1771,13 +1711,13 @@ static void ext4_orphan_cleanup(struct super_block *sb,
>   *
>   * Note, this does *not* consider any metadata overhead for vfs i_blocks.
>   */
> -static loff_t ext4_max_size(int blkbits)
> +static loff_t ext4_max_size(int blkbits, int has_huge_files)
>  {
>  	loff_t res;
>  	loff_t upper_limit = MAX_LFS_FILESIZE;
>  
>  	/* small i_blocks in vfs inode? */
> -	if (sizeof(blkcnt_t) < sizeof(u64)) {
> +	if (!has_huge_files || sizeof(blkcnt_t) < sizeof(u64)) {
>  		/*
>  		 * CONFIG_LSF is not enabled implies the inode
>  		 * i_block represent total blocks in 512 bytes
> @@ -1807,7 +1747,7 @@ static loff_t ext4_max_size(int blkbits)
>   * block limit, and also a limit of (2^48 - 1) 512-byte sectors in i_blocks.
>   * We need to be 1 filesystem block less than the 2^48 sector limit.
>   */
> -static loff_t ext4_max_bitmap_size(int bits)
> +static loff_t ext4_max_bitmap_size(int bits, int has_huge_files)
>  {
>  	loff_t res = EXT4_NDIR_BLOCKS;
>  	int meta_blocks;
> @@ -1820,11 +1760,11 @@ static loff_t ext4_max_bitmap_size(int bits)
>  	 * total number of  512 bytes blocks of the file
>  	 */
>  
> -	if (sizeof(blkcnt_t) < sizeof(u64)) {
> +	if (!has_huge_files || sizeof(blkcnt_t) < sizeof(u64)) {
>  		/*
> -		 * CONFIG_LSF is not enabled implies the inode
> -		 * i_block represent total blocks in 512 bytes
> -		 * 32 == size of vfs inode i_blocks * 8
> +		 * !has_huge_files or CONFIG_LSF is not enabled
> +		 * implies the inode i_block represent total blocks in
> +		 * 512 bytes 32 == size of vfs inode i_blocks * 8
>  		 */
>  		upper_limit = (1LL << 32) - 1;
>  
> @@ -1933,7 +1873,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>  	int blocksize;
>  	int db_count;
>  	int i;
> -	int needs_recovery;
> +	int needs_recovery, has_huge_files;
>  	__le32 features;
>  	__u64 blocks_count;
>  	int err;
> @@ -2074,7 +2014,9 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>  		       sb->s_id, le32_to_cpu(features));
>  		goto failed_mount;
>  	}
> -	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_HUGE_FILE)) {
> +	has_huge_files = EXT4_HAS_RO_COMPAT_FEATURE(sb,
> +				    EXT4_FEATURE_RO_COMPAT_HUGE_FILE);
> +	if (has_huge_files) {
>  		/*
>  		 * Large file size enabled file system can only be
>  		 * mount if kernel is build with CONFIG_LSF
> @@ -2124,8 +2066,9 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>  		}
>  	}
>  
> -	sbi->s_bitmap_maxbytes = ext4_max_bitmap_size(sb->s_blocksize_bits);
> -	sb->s_maxbytes = ext4_max_size(sb->s_blocksize_bits);
> +	sbi->s_bitmap_maxbytes = ext4_max_bitmap_size(sb->s_blocksize_bits,
> +						      has_huge_files);
> +	sb->s_maxbytes = ext4_max_size(sb->s_blocksize_bits, has_huge_files);
>  
>  	if (le32_to_cpu(es->s_rev_level) == EXT4_GOOD_OLD_REV) {
>  		sbi->s_inode_size = EXT4_GOOD_OLD_INODE_SIZE;
> -- 
> 1.5.6.1.205.ge2c7.dirty
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

