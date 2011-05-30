From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 1/2] ext4: use little-endian bitops directly
Date: Mon, 30 May 2011 08:49:43 -0600
Message-ID: <09010AAD-7443-4966-BF20-8580FBE8F389@dilger.ca>
References: <1306763382-13817-1-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0 (iPhone Mail 8J2)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Akinobu Mita <akinobu.mita@gmail.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from shawmail.shawcable.com ([64.59.128.220]:48101 "EHLO
	mail.shawcable.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391Ab1E3Ote convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 May 2011 10:49:34 -0400
In-Reply-To: <1306763382-13817-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-05-30, at 7:49 AM, Akinobu Mita <akinobu.mita@gmail.com> wrote:
> s/ext4_set_bit/__test_and_set_bit_le/
> s/ext4_clear_bit/__test_and_clear_bit_le/
> s/ext4_test_bit/test_bit_le/
> s/ext4_find_first_zero_bit/find_first_zero_bit_le/
> s/ext4_find_next_zero_bit/find_next_zero_bit_le/
> s/ext4_find_next_bit/find_next_bit_le/

I'm not souch in favor of making this change. One reason is the need for inconsistent test_bit_le() vs __test_and_set_bit_le() functions. I think this will make it more difficult to get the correct bit operations (I for one do not know the difference between the normal and __ versions without looking each time). 

Since the ext4_*() versions are macros there os no runtime overhead from using them, but it does make it easier for the developer to use the correct and consistent form of bitops. I don't see any clear benefit to removing the macros. 

> This change reveals that there are some __test_and_{set,clear}_bit_le()
> calls which ignore the return value. These can be replaced with
> __{set,clear}_bit_le().

This means that there should be a new  ext4_set_bit_only() macro, or similar, for those few parts of the code that need it. I'd prefer to keep the simple ext4_set_bit() form for the common usage.

My recollection is that in the old days of the kernel there was only a test_and_set_bit() version of that operation.  The only place that uses the non-test version is in the online resize code, which doesn't care what the old bit value was, since that part of the filesystem is not yet in use. 

> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Andreas Dilger <adilger.kernel@dilger.ca>
> Cc: linux-ext4@vger.kernel.org
> ---
> fs/ext4/balloc.c  |   14 +++++++-------
> fs/ext4/ext4.h    |    6 ------
> fs/ext4/ialloc.c  |   15 +++++++--------
> fs/ext4/inode.c   |    2 +-
> fs/ext4/mballoc.c |   12 ++++++------
> fs/ext4/resize.c  |   12 ++++++------
> 6 files changed, 27 insertions(+), 34 deletions(-)
> 
> diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
> index 264f694..6230bf0 100644
> --- a/fs/ext4/balloc.c
> +++ b/fs/ext4/balloc.c
> @@ -144,7 +144,7 @@ unsigned ext4_init_block_bitmap(struct super_block *sb, struct buffer_head *bh,
>        int flex_bg = 0;
> 
>        for (bit = 0; bit < bit_max; bit++)
> -            ext4_set_bit(bit, bh->b_data);
> +            __test_and_set_bit_le(bit, bh->b_data);
> 
>        start = ext4_group_first_block_no(sb, block_group);
> 
> @@ -155,18 +155,18 @@ unsigned ext4_init_block_bitmap(struct super_block *sb, struct buffer_head *bh,
>        /* Set bits for block and inode bitmaps, and inode table */
>        tmp = ext4_block_bitmap(sb, gdp);
>        if (!flex_bg || ext4_block_in_group(sb, tmp, block_group))
> -            ext4_set_bit(tmp - start, bh->b_data);
> +            __test_and_set_bit_le(tmp - start, bh->b_data);
> 
>        tmp = ext4_inode_bitmap(sb, gdp);
>        if (!flex_bg || ext4_block_in_group(sb, tmp, block_group))
> -            ext4_set_bit(tmp - start, bh->b_data);
> +            __test_and_set_bit_le(tmp - start, bh->b_data);
> 
>        tmp = ext4_inode_table(sb, gdp);
>        for (; tmp < ext4_inode_table(sb, gdp) +
>                sbi->s_itb_per_group; tmp++) {
>            if (!flex_bg ||
>                ext4_block_in_group(sb, tmp, block_group))
> -                ext4_set_bit(tmp - start, bh->b_data);
> +                __test_and_set_bit_le(tmp - start, bh->b_data);
>        }
>        /*
>         * Also if the number of blocks within the group is
> @@ -256,21 +256,21 @@ static int ext4_valid_block_bitmap(struct super_block *sb,
>    /* check whether block bitmap block number is set */
>    bitmap_blk = ext4_block_bitmap(sb, desc);
>    offset = bitmap_blk - group_first_block;
> -    if (!ext4_test_bit(offset, bh->b_data))
> +    if (!test_bit_le(offset, bh->b_data))
>        /* bad block bitmap */
>        goto err_out;
> 
>    /* check whether the inode bitmap block number is set */
>    bitmap_blk = ext4_inode_bitmap(sb, desc);
>    offset = bitmap_blk - group_first_block;
> -    if (!ext4_test_bit(offset, bh->b_data))
> +    if (!test_bit_le(offset, bh->b_data))
>        /* bad block bitmap */
>        goto err_out;
> 
>    /* check whether the inode table block number is set */
>    bitmap_blk = ext4_inode_table(sb, desc);
>    offset = bitmap_blk - group_first_block;
> -    next_zero_bit = ext4_find_next_zero_bit(bh->b_data,
> +    next_zero_bit = find_next_zero_bit_le(bh->b_data,
>                offset + EXT4_SB(sb)->s_itb_per_group,
>                offset);
>    if (next_zero_bit >= offset + EXT4_SB(sb)->s_itb_per_group)
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 1921392..058e6df 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -930,14 +930,8 @@ struct ext4_inode_info {
> #define test_opt2(sb, opt)        (EXT4_SB(sb)->s_mount_opt2 & \
>                     EXT4_MOUNT2_##opt)
> 
> -#define ext4_set_bit            __test_and_set_bit_le
> #define ext4_set_bit_atomic        ext2_set_bit_atomic
> -#define ext4_clear_bit            __test_and_clear_bit_le
> #define ext4_clear_bit_atomic        ext2_clear_bit_atomic
> -#define ext4_test_bit            test_bit_le
> -#define ext4_find_first_zero_bit    find_first_zero_bit_le
> -#define ext4_find_next_zero_bit        find_next_zero_bit_le
> -#define ext4_find_next_bit        find_next_bit_le
> 
> /*
>  * Maximal mount counts between two filesystem checks
> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> index 21bb2f6..450d149 100644
> --- a/fs/ext4/ialloc.c
> +++ b/fs/ext4/ialloc.c
> @@ -59,7 +59,7 @@ void ext4_mark_bitmap_end(int start_bit, int end_bit, char *bitmap)
> 
>    ext4_debug("mark end bits +%d through +%d used\n", start_bit, end_bit);
>    for (i = start_bit; i < ((start_bit + 7) & ~7UL); i++)
> -        ext4_set_bit(i, bitmap);
> +        __test_and_set_bit_le(i, bitmap);
>    if (i < end_bit)
>        memset(bitmap + (i >> 3), 0xff, (end_bit - i) >> 3);
> }
> @@ -252,7 +252,7 @@ void ext4_free_inode(handle_t *handle, struct inode *inode)
>        fatal = ext4_journal_get_write_access(handle, bh2);
>    }
>    ext4_lock_group(sb, block_group);
> -    cleared = ext4_clear_bit(bit, bitmap_bh->b_data);
> +    cleared = __test_and_clear_bit_le(bit, bitmap_bh->b_data);
>    if (fatal || !cleared) {
>        ext4_unlock_group(sb, block_group);
>        goto out;
> @@ -729,7 +729,7 @@ static int ext4_claim_inode(struct super_block *sb,
>     */
>    down_read(&grp->alloc_sem);
>    ext4_lock_group(sb, group);
> -    if (ext4_set_bit(ino, inode_bitmap_bh->b_data)) {
> +    if (__test_and_set_bit_le(ino, inode_bitmap_bh->b_data)) {
>        /* not a free inode */
>        retval = 1;
>        goto err_ret;
> @@ -884,8 +884,7 @@ got_group:
>            goto fail;
> 
> repeat_in_this_group:
> -        ino = ext4_find_next_zero_bit((unsigned long *)
> -                          inode_bitmap_bh->b_data,
> +        ino = find_next_zero_bit_le(inode_bitmap_bh->b_data,
>                          EXT4_INODES_PER_GROUP(sb), ino);
> 
>        if (ino < EXT4_INODES_PER_GROUP(sb)) {
> @@ -1119,7 +1118,7 @@ struct inode *ext4_orphan_get(struct super_block *sb, unsigned long ino)
>     * is a valid orphan (no e2fsck run on fs).  Orphans also include
>     * inodes that were being truncated, so we can't check i_nlink==0.
>     */
> -    if (!ext4_test_bit(bit, bitmap_bh->b_data))
> +    if (!test_bit_le(bit, bitmap_bh->b_data))
>        goto bad_orphan;
> 
>    inode = ext4_iget(sb, ino);
> @@ -1144,9 +1143,9 @@ iget_failed:
>    inode = NULL;
> bad_orphan:
>    ext4_warning(sb, "bad orphan inode %lu!  e2fsck was run?", ino);
> -    printk(KERN_NOTICE "ext4_test_bit(bit=%d, block=%llu) = %d\n",
> +    printk(KERN_NOTICE "test_bit_le(bit=%d, block=%llu) = %d\n",
>           bit, (unsigned long long)bitmap_bh->b_blocknr,
> -           ext4_test_bit(bit, bitmap_bh->b_data));
> +           test_bit_le(bit, bitmap_bh->b_data));
>    printk(KERN_NOTICE "inode=%p\n", inode);
>    if (inode) {
>        printk(KERN_NOTICE "is_bad_inode(inode)=%d\n",
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index a5763e3..db54359 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4725,7 +4725,7 @@ static int __ext4_get_inode_loc(struct inode *inode,
>            for (i = start; i < start + inodes_per_block; i++) {
>                if (i == inode_offset)
>                    continue;
> -                if (ext4_test_bit(i, bitmap_bh->b_data))
> +                if (test_bit_le(i, bitmap_bh->b_data))
>                    break;
>            }
>            brelse(bitmap_bh);
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 859f2ae..15b1716 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -374,23 +374,23 @@ static inline void *mb_correct_addr_and_bit(int *bit, void *addr)
> static inline int mb_test_bit(int bit, void *addr)
> {
>    /*
> -     * ext4_test_bit on architecture like powerpc
> +     * test_bit_le on architecture like powerpc
>     * needs unsigned long aligned address
>     */
>    addr = mb_correct_addr_and_bit(&bit, addr);
> -    return ext4_test_bit(bit, addr);
> +    return test_bit_le(bit, addr);
> }
> 
> static inline void mb_set_bit(int bit, void *addr)
> {
>    addr = mb_correct_addr_and_bit(&bit, addr);
> -    ext4_set_bit(bit, addr);
> +    __test_and_set_bit_le(bit, addr);
> }
> 
> static inline void mb_clear_bit(int bit, void *addr)
> {
>    addr = mb_correct_addr_and_bit(&bit, addr);
> -    ext4_clear_bit(bit, addr);
> +    __test_and_clear_bit_le(bit, addr);
> }
> 
> static inline int mb_find_next_zero_bit(void *addr, int max, int start)
> @@ -400,7 +400,7 @@ static inline int mb_find_next_zero_bit(void *addr, int max, int start)
>    tmpmax = max + fix;
>    start += fix;
> 
> -    ret = ext4_find_next_zero_bit(addr, tmpmax, start) - fix;
> +    ret = find_next_zero_bit_le(addr, tmpmax, start) - fix;
>    if (ret > max)
>        return max;
>    return ret;
> @@ -413,7 +413,7 @@ static inline int mb_find_next_bit(void *addr, int max, int start)
>    tmpmax = max + fix;
>    start += fix;
> 
> -    ret = ext4_find_next_bit(addr, tmpmax, start) - fix;
> +    ret = find_next_bit_le(addr, tmpmax, start) - fix;
>    if (ret > max)
>        return max;
>    return ret;
> diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
> index 80bbc9c..09e7f54 100644
> --- a/fs/ext4/resize.c
> +++ b/fs/ext4/resize.c
> @@ -194,7 +194,7 @@ static int setup_new_group_blocks(struct super_block *sb,
> 
>    if (ext4_bg_has_super(sb, input->group)) {
>        ext4_debug("mark backup superblock %#04llx (+0)\n", start);
> -        ext4_set_bit(0, bh->b_data);
> +        __test_and_set_bit_le(0, bh->b_data);
>    }
> 
>    /* Copy all of the GDT blocks into the backup in this group */
> @@ -225,7 +225,7 @@ static int setup_new_group_blocks(struct super_block *sb,
>            brelse(gdb);
>            goto exit_bh;
>        }
> -        ext4_set_bit(bit, bh->b_data);
> +        __test_and_set_bit_le(bit, bh->b_data);
>        brelse(gdb);
>    }
> 
> @@ -237,14 +237,14 @@ static int setup_new_group_blocks(struct super_block *sb,
>    if (err)
>        goto exit_bh;
>    for (i = 0, bit = gdblocks + 1; i < reserved_gdb; i++, bit++)
> -        ext4_set_bit(bit, bh->b_data);
> +        __test_and_set_bit_le(bit, bh->b_data);
> 
>    ext4_debug("mark block bitmap %#04llx (+%llu)\n", input->block_bitmap,
>           input->block_bitmap - start);
> -    ext4_set_bit(input->block_bitmap - start, bh->b_data);
> +    __test_and_set_bit_le(input->block_bitmap - start, bh->b_data);
>    ext4_debug("mark inode bitmap %#04llx (+%llu)\n", input->inode_bitmap,
>           input->inode_bitmap - start);
> -    ext4_set_bit(input->inode_bitmap - start, bh->b_data);
> +    __test_and_set_bit_le(input->inode_bitmap - start, bh->b_data);
> 
>    /* Zero out all of the inode table blocks */
>    block = input->inode_table;
> @@ -255,7 +255,7 @@ static int setup_new_group_blocks(struct super_block *sb,
>        goto exit_bh;
>    for (i = 0, bit = input->inode_table - start;
>         i < sbi->s_itb_per_group; i++, bit++)
> -        ext4_set_bit(bit, bh->b_data);
> +        __test_and_set_bit_le(bit, bh->b_data);
> 
>    if ((err = extend_or_restart_transaction(handle, 2, bh)))
>        goto exit_bh;
> -- 
> 1.7.4.4
> 
