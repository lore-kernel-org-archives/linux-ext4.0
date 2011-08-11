From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 03/13] ext4: add a function which sets up a new group desc
Date: Thu, 11 Aug 2011 00:42:25 -0600
Message-ID: <B9FE530C-A531-4C2E-824B-178F31CA1E0E@dilger.ca>
References: <1313033308-882-1-git-send-email-xiaoqiangnk@gmail.com> <1313033308-882-4-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4 List <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:15931 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468Ab1HKGm0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Aug 2011 02:42:26 -0400
In-Reply-To: <1313033308-882-4-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-08-10, at 9:28 PM, Yongqiang Yang wrote:
> This patch adds a function named ext4_setup_new_desc() which sets
> up a new group descriptor and whose code is sopied from ext4_group_add().
> 
> The function will be used by new resize implementation.

Again, duplicating a big hunk of ext4_group_add().  Similar comments apply.

Another question is whether this new resize code is safe from crashes?
One of the original design goals of the resize code is that it would never
leave a filesystem inconsistent if it crashed in the middle.

The way that these patches are looking, it seems that they may not be safe
in this regard, and possibly leave the filesystem in an inconsistent state
if they crash in the middle.  Maybe I'm missing something?

> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
> ---
> fs/ext4/resize.c |   54 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
> 1 files changed, 54 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
> index 4fcd515..6320baa 100644
> --- a/fs/ext4/resize.c
> +++ b/fs/ext4/resize.c
> @@ -777,6 +777,60 @@ out:
> 	return err;
> }
> 
> +/*
> + * ext4_setup_new_desc() sets up group descriptors specified by @input.
> + *
> + * @handle: journal handle
> + * @sb: super block
> + */
> +static int ext4_setup_new_desc(handle_t *handle, struct super_block *sb,
> +			       struct ext4_new_group_data *input)
> +{
> +	struct ext4_sb_info *sbi = EXT4_SB(sb);
> +	ext4_group_t group;
> +	struct ext4_group_desc *gdp;
> +	struct buffer_head *gdb_bh;
> +	int gdb_off, gdb_num, err = 0;
> +
> +	group = input->group;
> +
> +	gdb_off = group % EXT4_DESC_PER_BLOCK(sb);
> +	gdb_num = group / EXT4_DESC_PER_BLOCK(sb);
> +
> +	/*
> +	 * get_write_access() has been called on gdb_bh by ext4_add_new_desc().
> +	 */
> +	gdb_bh = sbi->s_group_desc[gdb_num];
> +	/* Update group descriptor block for new group */
> +	gdp = (struct ext4_group_desc *)((char *)gdb_bh->b_data +
> +				 gdb_off * EXT4_DESC_SIZE(sb));
> +
> +	memset(gdp, 0, EXT4_DESC_SIZE(sb));
> +	 /* LV FIXME */
> +	memset(gdp, 0, EXT4_DESC_SIZE(sb));
> +	ext4_block_bitmap_set(sb, gdp, input->block_bitmap); /* LV FIXME */
> +	ext4_inode_bitmap_set(sb, gdp, input->inode_bitmap); /* LV FIXME */
> +	ext4_inode_table_set(sb, gdp, input->inode_table); /* LV FIXME */
> +	ext4_free_blks_set(sb, gdp, input->free_blocks_count);
> +	ext4_free_inodes_set(sb, gdp, EXT4_INODES_PER_GROUP(sb));
> +	gdp->bg_flags = cpu_to_le16(EXT4_BG_INODE_ZEROED);
> +	gdp->bg_checksum = ext4_group_desc_csum(sbi, input->group, gdp);
> +
> +	err = ext4_handle_dirty_metadata(handle, NULL, gdb_bh);
> +	if (unlikely(err)) {
> +		ext4_std_error(sb, err);
> +		return err;
> +	}
> +
> +	/*
> +	 * We can allocate memory for mb_alloc based on the new group
> +	 * descriptor
> +	 */
> +	err = ext4_mb_add_groupinfo(sb, group, gdp);
> +
> +	return err;
> +}
> +
> /* Add group descriptor data to an existing or new group descriptor block.
>  * Ensure we handle all possible error conditions _before_ we start modifying
>  * the filesystem, because we cannot abort the transaction and not have it
> -- 
> 1.7.5.1
> 


Cheers, Andreas





