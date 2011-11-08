From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH V3 01/15] ext4: add a function which extends a group without checking parameters
Date: Tue, 8 Nov 2011 00:12:48 -0700
Message-ID: <E849D75B-FA54-4426-9B01-9672931221B1@dilger.ca>
References: <1320707608-14246-1-git-send-email-xiaoqiangnk@gmail.com> <1320707608-14246-2-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0 (iPhone Mail 8L1)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "tytso@mit.edu" <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from shawmail.shawcable.com ([64.59.128.220]:14809 "EHLO
	mail.shawcable.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314Ab1KHHLp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Nov 2011 02:11:45 -0500
In-Reply-To: <1320707608-14246-2-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-11-07, at 4:13 PM, Yongqiang Yang <xiaoqiangnk@gmail.com> wrote:
> This patch added a function named __ext4_group_extend() whose code
> is copied from ext4_group_extend().  __ext4_group_extend() assumes
> the parameter is valid and has been checked by caller.

To be honest, I don't like the use of underscores to rename such functions, since they convey no meaning to the reader, or perhaps only "these functions are similar but not the same, in some unspecified way".

I'd much prefer something like ext4_group_extend_nocheck() or similar that indicates how it is different from ext4_group_extend().

> __ext4_group_extend() will be used by new resize implementation. It
> can also be used by ext4_group_extend(), but this patch series does
> not do this.

If this is intended to replace the old resize functionality, it makes sense to remove the code duplication as part of this series, or in fact as part of this patch. 

> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
> fs/ext4/resize.c |   53 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> 1 files changed, 53 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
> index 996780a..ff77512 100644
> --- a/fs/ext4/resize.c
> +++ b/fs/ext4/resize.c
> @@ -969,6 +969,59 @@ exit_put:
> } /* ext4_group_add */
> 
> /*
> + * extend a group without checking assuming that checking has been done.
> + */
> +static int __ext4_group_extend(struct super_block *sb,
> +                   ext4_fsblk_t o_blocks_count, ext4_grpblk_t add)
> +{
> +    struct ext4_super_block *es = EXT4_SB(sb)->s_es;
> +    handle_t *handle;
> +    int err = 0, err2;
> +
> +    /* We will update the superblock, one block bitmap, and
> +     * one group descriptor via ext4_group_add_blocks().
> +     */
> +    handle = ext4_journal_start_sb(sb, 3);
> +    if (IS_ERR(handle)) {
> +        err = PTR_ERR(handle);
> +        ext4_warning(sb, "error %d on journal start", err);
> +        goto out;
> +    }
> +
> +    err = ext4_journal_get_write_access(handle, EXT4_SB(sb)->s_sbh);
> +    if (err) {
> +        ext4_warning(sb, "error %d on journal write access", err);
> +        ext4_journal_stop(handle);
> +        goto out;
> +    }
> +
> +    ext4_blocks_count_set(es, o_blocks_count + add);
> +    ext4_debug("freeing blocks %llu through %llu\n", o_blocks_count,
> +           o_blocks_count + add);
> +    /* We add the blocks to the bitmap and set the group need init bit */
> +    err = ext4_group_add_blocks(handle, sb, o_blocks_count, add);
> +    if (err)
> +        goto exit_journal;
> +    ext4_handle_dirty_super(handle, sb);
> +    ext4_debug("freed blocks %llu through %llu\n", o_blocks_count,
> +           o_blocks_count + add);
> +exit_journal:
> +    err2 = ext4_journal_stop(handle);
> +    if (err2 && !err)
> +        err = err2;
> +
> +    if (!err) {
> +        if (test_opt(sb, DEBUG))
> +            printk(KERN_DEBUG "EXT4-fs: extended group to %llu "
> +                   "blocks\n", ext4_blocks_count(es));
> +        update_backups(sb, EXT4_SB(sb)->s_sbh->b_blocknr, (char *)es,
> +                   sizeof(struct ext4_super_block));
> +    }
> +out:
> +    return err;
> +}
> +
> +/*
>  * Extend the filesystem to the new number of blocks specified.  This entry
>  * point is only used to extend the current filesystem to the end of the last
>  * existing group.  It can be accessed via ioctl, or by "remount,resize=<size>"
> -- 
> 1.7.5.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
