From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 1/2 v3] EXT4: Secure Delete: Zero out file data
Date: Thu, 30 Jun 2011 16:15:58 -0600
Message-ID: <0B56FD8D-DCE5-4FB1-A97D-25EC1CD3CA14@dilger.ca>
References: <1309468923-5677-1-git-send-email-achender@linux.vnet.ibm.com> <1309468923-5677-2-git-send-email-achender@linux.vnet.ibm.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:47803 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775Ab1F3WQB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 30 Jun 2011 18:16:01 -0400
In-Reply-To: <1309468923-5677-2-git-send-email-achender@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-06-30, at 3:22 PM, Allison Henderson wrote:
> The first patch adds a new flag, EXT4_FREE_BLOCKS_ZERO,
> to ext4_free_blocks. This flag causes causes blocks to be
> zerod before they are freed.  Files that have the EXT4_SECRM_FL
> attribute flag on will have their blocks zerod when
> they are released.  The EXT4_SECRM_FL attribute flag can
> be enabled useing chattr +s
> 
> Signed-off-by: Allison Henderson <achender@linux.vnet.ibm.com>
> ---
> v1->v2
> Removed check for discard mount option and replaced with
> check for secure discard and discard_zeroes_data
> 
> Added BLKDEV_DISCARD_SECURE to the sb_issue_discard call
> 
> v2->v3
> Removed code for discard.  A seperate patch will
> be done to add that code in the block layer
> 
> :100644 100644 1921392... 38a4d75... M	fs/ext4/ext4.h
> :100644 100644 f815cc8... cf178f3... M	fs/ext4/extents.c
> :100644 100644 62f86e7... 8fdae7d... M	fs/ext4/inode.c
> :100644 100644 6ed859d... 94872b2... M	fs/ext4/mballoc.c
> :100644 100644 c757adc... 1ff7532... M	fs/ext4/xattr.c
> fs/ext4/ext4.h    |    1 +
> fs/ext4/extents.c |    3 +++
> fs/ext4/inode.c   |    3 +++
> fs/ext4/mballoc.c |    8 ++++++++
> fs/ext4/xattr.c   |   12 ++++++++----
> 5 files changed, 23 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 1921392..38a4d75 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -526,6 +526,7 @@ struct ext4_new_group_data {
> #define EXT4_FREE_BLOCKS_METADATA	0x0001
> #define EXT4_FREE_BLOCKS_FORGET		0x0002
> #define EXT4_FREE_BLOCKS_VALIDATED	0x0004
> +#define EXT4_FREE_BLOCKS_ZERO		0x0008
> 
> /*
> * ioctl commands
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index f815cc8..cf178f3 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -2231,6 +2231,9 @@ static int ext4_remove_blocks(handle_t *handle, struct inode *inode,
> 
> 	if (S_ISDIR(inode->i_mode) || S_ISLNK(inode->i_mode))
> 		flags |= EXT4_FREE_BLOCKS_METADATA;
> +
> +	if (EXT4_I(inode)->i_flags & EXT4_SECRM_FL)
> +		flags |= EXT4_FREE_BLOCKS_ZERO;
> #ifdef EXTENTS_STATS
> 	{
> 		struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 62f86e7..8fdae7d 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4182,6 +4182,9 @@ static int ext4_clear_blocks(handle_t *handle, struct inode *inode,
> 	for (p = first; p < last; p++)
> 		*p = 0;
> 
> +	if (EXT4_I(inode)->i_flags & EXT4_SECRM_FL)
> +		flags |= EXT4_FREE_BLOCKS_ZERO;
> +
> 	ext4_free_blocks(handle, inode, NULL, block_to_free, count, flags);
> 	return 0;
> out_err:
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 6ed859d..94872b2 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -4485,6 +4485,14 @@ void ext4_free_blocks(handle_t *handle, struct inode *inode,
> 	ext4_debug("freeing block %llu\n", block);
> 	trace_ext4_free_blocks(inode, block, count, flags);
> 
> +	if (flags & EXT4_FREE_BLOCKS_ZERO) {
> +		err = sb_issue_zeroout(inode->i_sb, block, count, GFP_NOFS);

Does sb_issue_zeroout() use the SCSI "write same" feature in the
background?  That would avoid busying the CPU/controller/bus with
writing out zeroes, which might be expensive for a large file.

> +		if (err < 0)
> +			goto error_return;
> +		else
> +			err = 0;
> +	}
> +
> 	if (flags & EXT4_FREE_BLOCKS_FORGET) {
> 		struct buffer_head *tbh = bh;
> 		int i;
> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index c757adc..1ff7532 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -471,7 +471,7 @@ ext4_xattr_release_block(handle_t *handle, struct inode *inode,
> 			 struct buffer_head *bh)
> {
> 	struct mb_cache_entry *ce = NULL;
> -	int error = 0;
> +	int free_blocks_flags, error = 0;
> 
> 	ce = mb_cache_entry_get(ext4_xattr_cache, bh->b_bdev, bh->b_blocknr);
> 	error = ext4_journal_get_write_access(handle, bh);
> @@ -484,9 +484,13 @@ ext4_xattr_release_block(handle_t *handle, struct inode *inode,
> 		if (ce)
> 			mb_cache_entry_free(ce);
> 		get_bh(bh);
> -		ext4_free_blocks(handle, inode, bh, 0, 1,
> -				 EXT4_FREE_BLOCKS_METADATA |
> -				 EXT4_FREE_BLOCKS_FORGET);
> +		free_blocks_flags = EXT4_FREE_BLOCKS_METADATA |
> +					EXT4_FREE_BLOCKS_FORGET;
> +
> +		if (EXT4_I(inode)->i_flags & EXT4_SECRM_FL)
> +			free_blocks_flags |= EXT4_FREE_BLOCKS_ZERO;
> +
> +		ext4_free_blocks(handle, inode, bh, 0, 1, free_blocks_flags);
> 	} else {
> 		le32_add_cpu(&BHDR(bh)->h_refcount, -1);
> 		error = ext4_handle_dirty_metadata(handle, inode, bh);
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





