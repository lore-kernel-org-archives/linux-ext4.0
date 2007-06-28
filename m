From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: patch to support ext4 online resizing with meta block groups
Date: Thu, 28 Jun 2007 02:12:26 -0400
Message-ID: <20070628061226.GA5670@schatzie.adilger.int>
References: <f4ca31560706271157p2a25546fmf8fad29dfcf8f056@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: zuogui xie <zuogui.xie@googlemail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:56246 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbXF1GM3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Jun 2007 02:12:29 -0400
Content-Disposition: inline
In-Reply-To: <f4ca31560706271157p2a25546fmf8fad29dfcf8f056@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jun 27, 2007  19:57 +0100, zuogui xie wrote:
> To keep compatibility, we begin to use meta block groups after the
> reserved block groups run out. superblock and single block group descriptor
> block are placed at the beginning of the first, second, and last block
> groups in a meta-block group. The block group in the meta block groups
> no longer reserves the blocks for group descriptor table.  To let it work,
> we need mkfs.ext3 to set superblock's s_first_meta_bg field and it is easy
> to implement.

Do we really need mkfs.ext3 to do that?  It can easily be done by the
kernel when resizing the filesystem beyond the last group descriptor
block.  It would also set the INCOMPAT_META_BG feature flag, which has
been in kernels for a long time now (at least back to 2.4.29 or so), so
only a small danger of incompatibility.  There should probably be support
in resize2fs or similar to be able to remove the META_BG feature to return
the filesystem to "normal" if this is needed.

> --- linux-2.6.21.5/fs/ext4/resize.c    2007-06-11 19:37:06.000000000 +0100
> +++ resize.c    2007-06-27 10:55:14.000000000 +0100
> @@ -21,6 +21,25 @@
> #define outside(b, first, last)    ((b) < (first) || (b) >= (last))
> #define inside(b, first, last)    ((b) >= (first) && (b) < (last))
> 
> +/**
> + *    ext4_bg_in_metabg - whether this block group is in meta block group
> + *    @sb: superblock for filesystem
> + *    @group: group number to check
> + *
> + *    Return value will be only 0 or 1.
> + */
> +int ext4_bg_in_metabg(struct super_block *sb, int group)
> +{
> +    unsigned long first_meta_bg =
> +            le32_to_cpu(EXT4_SB(sb)->s_es->s_first_meta_bg);
> +    unsigned long metagroup = group / EXT4_DESC_PER_BLOCK(sb);

Your mailer seems to have broken all of the whitespace in this patch.

> @@ -171,8 +190,11 @@ static int setup_new_group_blocks(struct
> +    /*The group in meta block group no longer reserves blocks */

Space before "The".

> @@ -203,8 +225,9 @@ static int setup_new_group_blocks(struct
> +    for (i = 0, bit = 1, block = start +
> +         ext4_bg_has_super(sb, input->group);i < gdblocks;

Space before "i".

> @@ -219,7 +242,23 @@ static int setup_new_group_blocks(struct
> +        if(bg_in_metabg) {

Space after "if".

> +            unsigned long last = first + EXT4_DESC_PER_BLOCK(sb) -
> +                         1;

Can probably fit "1;" on previous line by removing space around '-'.

> +static int add_new_gdb_meta(handle_t *handle, struct inode *inode,
> +               struct ext4_new_group_data *input,
> +               struct buffer_head **primary)
> +{
> +    n_group_desc[gdb_num] = *primary;
> +    EXT4_SB(sb)->s_group_desc = n_group_desc;
> +    EXT4_SB(sb)->s_gdb_count++;
> +    kfree(o_group_desc);

This should save the s_first_metabg and set INCOMPAT_META_BG if it is
the first such group.

> +static void update_backups_metabg(struct super_block *sb,
> +               int gdb_num, char *data, int size)
> +{
> +    struct ext4_sb_info *sbi = EXT4_SB(sb);
> +

Remove empty line here.

> +    unsigned second_bg_no = gdb_num * EXT4_DESC_PER_BLOCK(sb) + 1;
> +    unsigned last_bg_no = second_bg_no + EXT4_DESC_PER_BLOCK(sb) -2;
> +    unsigned list_bg_no[2]={second_bg_no,last_bg_no};

Please don't use these extra variables, just initialize list_bg_no[]
directly.

> +    int i=0;

Spaces around '='.

> +

Remove empty line here.

> +    int rest = sb->s_blocksize - size;
> +    handle_t *handle;
> +    int err = 0, err2;
> +    unsigned group=0;

Spaces around '='

> +        struct buffer_head *bh;
> +        group=list_bg_no[i];

Space around '='.

> @@ -813,8 +1012,13 @@ int ext4_group_add(struct super_block *s
>         if (reserved_gdb && ext4_bg_num_gdb(sb, input->group) &&
>             (err = reserve_backup_gdb(handle, inode, input)))
>             goto exit_journal;
> -    } else if ((err = add_new_gdb(handle, inode, input, &primary)))
> +    } else if (!ext4_bg_in_metabg(sb, input->group) &&
> +           (err = add_new_gdb(handle, inode, input, &primary))) {
> +        goto exit_journal;
> +    } else if (ext4_bg_in_metabg(sb, input->group) &&

Use "bg_in_metabg" here.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
