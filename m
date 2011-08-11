From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 02/13] ext4: add a function which adds a new desc to a fs
Date: Wed, 10 Aug 2011 23:49:29 -0600
Message-ID: <883C890C-4FAB-4517-BB5C-47FB96AB4811@dilger.ca>
References: <1313033308-882-1-git-send-email-xiaoqiangnk@gmail.com> <1313033308-882-3-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4 List <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:59322 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210Ab1HKFta convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Aug 2011 01:49:30 -0400
In-Reply-To: <1313033308-882-3-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-08-10, at 9:28 PM, Yongqiang Yang wrote:
> This patch adds a function named ext4_add_new_desc() which adds
> a new desc to a fs and whose code is copied from ext4_group_add().
> 
> The function will be used by new resize implementation.

Similarly, this is duplicating a hunk of code from the middle of
ext4_group_add(), and instead of just adding a second copy of that
code, ext4_group_add() should be changed to call this new function
to avoid the code duplication.

> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
> ---
> fs/ext4/resize.c |   42 ++++++++++++++++++++++++++++++++++++++++++
> 1 files changed, 42 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
> index 6ffbdb6..4fcd515 100644
> --- a/fs/ext4/resize.c
> +++ b/fs/ext4/resize.c
> @@ -735,6 +735,48 @@ exit_err:
> 	}
> }
> 
> +/*
> + * ext4_add_new_desc() adds group descriptor of group @group
> + *
> + * @handle: journal handle
> + * @sb; super block
> + * @group: the group no. of the first group desc to be added
> + * @resize_inode: the resize inode
> + */
> +static int ext4_add_new_desc(handle_t *handle, struct super_block *sb,
> +			     ext4_group_t group, struct inode *resize_inode)
> +{
> +	struct ext4_sb_info *sbi = EXT4_SB(sb);
> +	struct ext4_super_block *es = sbi->s_es;
> +	struct buffer_head *gdb_bh;
> +	int gdb_off, gdb_num, err = 0;
> +	int reserved_gdb = ext4_bg_has_super(sb, group) ?
> +		le16_to_cpu(es->s_reserved_gdt_blocks) : 0;
> +
> +	gdb_off = group % EXT4_DESC_PER_BLOCK(sb);
> +	gdb_num = group / EXT4_DESC_PER_BLOCK(sb);
> +
> +	/*
> +	 * We will only either add reserved group blocks to a backup group
> +	 * or remove reserved blocks for the first group in a new group block.
> +	 * Doing both would be mean more complex code, and sane people don't
> +	 * use non-sparse filesystems anymore.  This is already checked above.
> +	 */
> +	if (gdb_off) {
> +		gdb_bh = sbi->s_group_desc[gdb_num];
> +		err = ext4_journal_get_write_access(handle, gdb_bh);
> +		if (err)
> +			goto out;
> +
> +		if (reserved_gdb && ext4_bg_num_gdb(sb, group))
> +			err = reserve_backup_gdb(handle, resize_inode, group);
> +	} else
> +		err = add_new_gdb(handle, resize_inode, group);
> +
> +out:
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





