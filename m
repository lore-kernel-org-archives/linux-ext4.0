From: Andreas Dilger <aedilger@gmail.com>
Subject: Re: [PATCH 2/2] ext4: remove ext4_free_blocks_after_init()
Date: Wed, 20 Jul 2011 09:41:24 -0600
Message-ID: <B18ADA2A-CB14-4D30-A091-E4ACB1C9E280@gmail.com>
References: <1311168774-26378-1-git-send-email-xiaoqiangnk@gmail.com> <1311168774-26378-3-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0 (iPhone Mail 8J2)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"tytso@mit.edu" <tytso@mit.edu>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:60214 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752Ab1GTPlk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Jul 2011 11:41:40 -0400
Received: by pvg12 with SMTP id 12so277908pvg.19
        for <linux-ext4@vger.kernel.org>; Wed, 20 Jul 2011 08:41:40 -0700 (PDT)
In-Reply-To: <1311168774-26378-3-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-07-20, at 7:32 AM, Yongqiang Yang <xiaoqiangnk@gmail.com> wrote:
> This patch removes ext4_free_blocks_after_init() and simplifies
> ext4_init_block_bitmap() a lot.

Why not use the ext4_set_bits() function, exported in another patch, to set multiple bits?

> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
> ---
> fs/ext4/balloc.c |  122 ++++++++++++++++++-----------------------------------
> fs/ext4/ext4.h   |    4 +-
> 2 files changed, 43 insertions(+), 83 deletions(-)
> 
> diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
> index f8224ad..2dd9820 100644
> --- a/fs/ext4/balloc.c
> +++ b/fs/ext4/balloc.c
> @@ -55,60 +55,31 @@ static int ext4_block_in_group(struct super_block *sb, ext4_fsblk_t block,
>    return 0;
> }
> 
> -static int ext4_group_used_meta_blocks(struct super_block *sb,
> -                       ext4_group_t block_group,
> -                       struct ext4_group_desc *gdp)
> -{
> -    ext4_fsblk_t tmp;
> -    struct ext4_sb_info *sbi = EXT4_SB(sb);
> -    /* block bitmap, inode bitmap, and inode table blocks */
> -    int used_blocks = sbi->s_itb_per_group + 2;
> -
> -    if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FLEX_BG)) {
> -        if (!ext4_block_in_group(sb, ext4_block_bitmap(sb, gdp),
> -                    block_group))
> -            used_blocks--;
> -
> -        if (!ext4_block_in_group(sb, ext4_inode_bitmap(sb, gdp),
> -                    block_group))
> -            used_blocks--;
> -
> -        tmp = ext4_inode_table(sb, gdp);
> -        for (; tmp < ext4_inode_table(sb, gdp) +
> -                sbi->s_itb_per_group; tmp++) {
> -            if (!ext4_block_in_group(sb, tmp, block_group))
> -                used_blocks -= 1;
> -        }
> -    }
> -    return used_blocks;
> -}
> -
> -/* Initializes an uninitialized block bitmap if given, and returns the
> - * number of blocks free in the group. */
> -unsigned ext4_init_block_bitmap(struct super_block *sb, struct buffer_head *bh,
> +/* Initializes an uninitialized block bitmap */
> +void ext4_init_block_bitmap(struct super_block *sb, struct buffer_head *bh,
>         ext4_group_t block_group, struct ext4_group_desc *gdp)
> {
> +    ext4_fsblk_t start, tmp;
>    int bit, bit_max;
>    ext4_group_t ngroups = ext4_get_groups_count(sb);
> -    unsigned free_blocks, group_blocks;
> +    unsigned group_blocks;
>    struct ext4_sb_info *sbi = EXT4_SB(sb);
> -
> -    if (bh) {
> -        J_ASSERT_BH(bh, buffer_locked(bh));
> -
> -        /* If checksum is bad mark all blocks used to prevent allocation
> -         * essentially implementing a per-group read-only flag. */
> -        if (!ext4_group_desc_csum_verify(sbi, block_group, gdp)) {
> -            ext4_error(sb, "Checksum bad for group %u",
> -                    block_group);
> -            ext4_free_blks_set(sb, gdp, 0);
> -            ext4_free_inodes_set(sb, gdp, 0);
> -            ext4_itable_unused_set(sb, gdp, 0);
> -            memset(bh->b_data, 0xff, sb->s_blocksize);
> -            return 0;
> -        }
> -        memset(bh->b_data, 0, sb->s_blocksize);
> +    int flex_bg = 0;
> +
> +    J_ASSERT_BH(bh, bh && buffer_locked(bh));
> +
> +    /* If checksum is bad mark all blocks used to prevent allocation
> +     * essentially implementing a per-group read-only flag. */
> +    if (!ext4_group_desc_csum_verify(sbi, block_group, gdp)) {
> +        ext4_error(sb, "Checksum bad for group %u",
> +                block_group);
> +        ext4_free_blks_set(sb, gdp, 0);
> +        ext4_free_inodes_set(sb, gdp, 0);
> +        ext4_itable_unused_set(sb, gdp, 0);
> +        memset(bh->b_data, 0xff, sb->s_blocksize);
> +        return; 
>    }
> +    memset(bh->b_data, 0, sb->s_blocksize);
> 
>    /* Check for superblock and gdt backups in this group */
>    bit_max = ext4_bg_has_super(sb, block_group);
> @@ -137,46 +108,37 @@ unsigned ext4_init_block_bitmap(struct super_block *sb, struct buffer_head *bh,
>        group_blocks = EXT4_BLOCKS_PER_GROUP(sb);
>    }
> 
> -    free_blocks = group_blocks - bit_max;
> 
> -    if (bh) {
> -        ext4_fsblk_t start, tmp;
> -        int flex_bg = 0;
> +    for (bit = 0; bit < bit_max; bit++)
> +        ext4_set_bit(bit, bh->b_data);
> 
> -        for (bit = 0; bit < bit_max; bit++)
> -            ext4_set_bit(bit, bh->b_data);
> +    start = ext4_group_first_block_no(sb, block_group);
> 
> -        start = ext4_group_first_block_no(sb, block_group);
> +    flex_bg = EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FLEX_BG);
> 
> -        if (EXT4_HAS_INCOMPAT_FEATURE(sb,
> -                          EXT4_FEATURE_INCOMPAT_FLEX_BG))
> -            flex_bg = 1;
> +    /* Set bits for block and inode bitmaps, and inode table */
> +    tmp = ext4_block_bitmap(sb, gdp);
> +    if (!flex_bg || ext4_block_in_group(sb, tmp, block_group))
> +        ext4_set_bit(tmp - start, bh->b_data);
> 
> -        /* Set bits for block and inode bitmaps, and inode table */
> -        tmp = ext4_block_bitmap(sb, gdp);
> -        if (!flex_bg || ext4_block_in_group(sb, tmp, block_group))
> -            ext4_set_bit(tmp - start, bh->b_data);
> +    tmp = ext4_inode_bitmap(sb, gdp);
> +    if (!flex_bg || ext4_block_in_group(sb, tmp, block_group))
> +        ext4_set_bit(tmp - start, bh->b_data);
> 
> -        tmp = ext4_inode_bitmap(sb, gdp);
> -        if (!flex_bg || ext4_block_in_group(sb, tmp, block_group))
> +    tmp = ext4_inode_table(sb, gdp);
> +    for (; tmp < ext4_inode_table(sb, gdp) +
> +            sbi->s_itb_per_group; tmp++) {
> +        if (!flex_bg ||
> +            ext4_block_in_group(sb, tmp, block_group))
>            ext4_set_bit(tmp - start, bh->b_data);
> -
> -        tmp = ext4_inode_table(sb, gdp);
> -        for (; tmp < ext4_inode_table(sb, gdp) +
> -                sbi->s_itb_per_group; tmp++) {
> -            if (!flex_bg ||
> -                ext4_block_in_group(sb, tmp, block_group))
> -                ext4_set_bit(tmp - start, bh->b_data);
> -        }
> -        /*
> -         * Also if the number of blocks within the group is
> -         * less than the blocksize * 8 ( which is the size
> -         * of bitmap ), set rest of the block bitmap to 1
> -         */
> -        ext4_mark_bitmap_end(group_blocks, sb->s_blocksize * 8,
> -                     bh->b_data);
>    }
> -    return free_blocks - ext4_group_used_meta_blocks(sb, block_group, gdp);
> +    /*
> +     * Also if the number of blocks within the group is
> +     * less than the blocksize * 8 ( which is the size
> +     * of bitmap ), set rest of the block bitmap to 1
> +     */
> +    ext4_mark_bitmap_end(group_blocks, sb->s_blocksize * 8,
> +                 bh->b_data);
> }
> 
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 62cee2b..eacaad2 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1741,12 +1741,10 @@ extern struct ext4_group_desc * ext4_get_group_desc(struct super_block * sb,
> extern int ext4_should_retry_alloc(struct super_block *sb, int *retries);
> struct buffer_head *ext4_read_block_bitmap(struct super_block *sb,
>                      ext4_group_t block_group);
> -extern unsigned ext4_init_block_bitmap(struct super_block *sb,
> +extern void ext4_init_block_bitmap(struct super_block *sb,
>                       struct buffer_head *bh,
>                       ext4_group_t group,
>                       struct ext4_group_desc *desc);
> -#define ext4_free_blocks_after_init(sb, group, desc)            \
> -        ext4_init_block_bitmap(sb, NULL, group, desc)
> ext4_fsblk_t ext4_inode_to_goal_block(struct inode *);
> 
> /* dir.c */
> -- 
> 1.7.5.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
