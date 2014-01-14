From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH v2] Add support for new compat feature "super_sparse"
Date: Tue, 14 Jan 2014 04:21:52 -0700
Message-ID: <6C608D9A-AAAC-402D-BC7B-FC23EF9956BD@dilger.ca>
References: <1389497029-10488-1-git-send-email-tytso@mit.edu> <20140113132707.GA22358@orion.maiolino.org> <20140113140645.GC18029@thunk.org> <20140113161949.GB22541@thunk.org> <20140114055426.GB27083@thunk.org>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:39262 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbaANLV6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Jan 2014 06:21:58 -0500
Received: by mail-pd0-f181.google.com with SMTP id p10so8622746pdj.40
        for <linux-ext4@vger.kernel.org>; Tue, 14 Jan 2014 03:21:58 -0800 (PST)
In-Reply-To: <20140114055426.GB27083@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

A few comments on this new patch:
- I think the name will be confusing to users, especially non-native English
  speakers. Is it "sparse_super" or "super_sparse" they want?
- I would suspect that group #1 is not the best place to put the backup.
  For very large filesystems, there is a conflict with the backup group
  descriptors in group #0 and #1. It would be better to out the one
  backup in group #3 or something.  I don't think this will be a problem
  for SMR drives, since they will be so large that this will easily fit inside
  (or close to) the flex_bg layout of the inode table.
- To simplify matters, it makes sense that super_sparse supersedes
  the sparse_super and meta_bg features. It doesn't make sense
  to have both. Should it also require flex_bg?  Without it, it is mostly
  useless. 

Cheers, Andreas

> On Jan 13, 2014, at 22:54, Theodore Ts'o <tytso@mit.edu> wrote:
> 
> And here's the version of this patch which adds a block group in the
> last block group.  Note the huge complexity required to support
> shrinking such a file system.  I still haven't tested that bit of code
> yet, since it's also painful to create all of the various file systems
> to test all of reserve_super_sparse_last_group().
> 
> But I'll send it out so people have an idea of what's needed/involved.
> 
>                        - Ted
> 
> From af0f4ad05d1bbce4ae6b817e2638a3700e8a5a6e Mon Sep 17 00:00:00 2001
> From: Theodore Ts'o <tytso@mit.edu>
> Date: Sat, 11 Jan 2014 22:11:42 -0500
> Subject: [PATCH] Add support for new compat feature "super_sparse"
> 
> In practice, it is **extremely** rare for users to try to use more
> than the first backup superblock located at the beginning of block
> group #1.  (i.e., at block number 32768 for file systems with a 4k
> block size).  This new compat feature restricts the backup superblock
> to block group #1 and the last block group in the file system.
> 
> Aside from reducing the overhead of the file system by a small number
> of blocks, by eliminating the rest of the backup superblocks, it
> allows us to have a much more flexible metadata layout.  For example,
> we can force all of the allocation bitmaps and inode table blocks to
> the beginning of the disk, which allows most of the disk to be
> exclusively used for contiguous data blocks.
> 
> This simplifies taking advantage of certain HDD specific features,
> such as Shingled Magnetic Recording (aka Shingled Drives), and the
> TCG's OPAL Storage Specification where having a simple mapping between
> LBA block ranges and the data blocks used by the file system can make
> life much simpler.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
> lib/e2p/feature.c    |   2 +
> lib/ext2fs/closefs.c |  10 +++-
> lib/ext2fs/ext2_fs.h |   1 +
> lib/ext2fs/ext2fs.h  |   3 +-
> lib/ext2fs/res_gdt.c |  14 +++++-
> misc/ext4.5.in       |   7 +++
> misc/mke2fs.c        |   3 +-
> resize/online.c      |   8 ++++
> resize/resize2fs.c   | 127 +++++++++++++++++++++++++++++++++++++++++++++++++++
> 9 files changed, 169 insertions(+), 6 deletions(-)
> 
> diff --git a/lib/e2p/feature.c b/lib/e2p/feature.c
> index 9691263..c06b833 100644
> --- a/lib/e2p/feature.c
> +++ b/lib/e2p/feature.c
> @@ -43,6 +43,8 @@ static struct feature feature_list[] = {
>            "lazy_bg" },
>    {    E2P_FEATURE_COMPAT, EXT2_FEATURE_COMPAT_EXCLUDE_BITMAP,
>            "snapshot_bitmap" },
> +    {    E2P_FEATURE_COMPAT, EXT4_FEATURE_COMPAT_SUPER_SPARSE,
> +            "super_sparse" },
> 
>    {    E2P_FEATURE_RO_INCOMPAT, EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER,
>            "sparse_super" },
> diff --git a/lib/ext2fs/closefs.c b/lib/ext2fs/closefs.c
> index 3e4af7f..caf5b46 100644
> --- a/lib/ext2fs/closefs.c
> +++ b/lib/ext2fs/closefs.c
> @@ -35,9 +35,15 @@ static int test_root(unsigned int a, unsigned int b)
> 
> int ext2fs_bg_has_super(ext2_filsys fs, dgrp_t group)
> {
> -    if (!(fs->super->s_feature_ro_compat &
> -          EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER) || group <= 1)
> +    if ((group <= 1) || !(fs->super->s_feature_ro_compat &
> +                  EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER))
>        return 1;
> +    if (fs->super->s_feature_compat & EXT4_FEATURE_COMPAT_SUPER_SPARSE) {
> +        /* Implied by the above test */
> +        if (/* group == 1 || */ group == fs->group_desc_count - 1)
> +            return 1;
> +        return 0;
> +    }
>    if (!(group & 1))
>        return 0;
>    if (test_root(group, 3) || (test_root(group, 5)) ||
> diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
> index 930c2a3..eb040e5 100644
> --- a/lib/ext2fs/ext2_fs.h
> +++ b/lib/ext2fs/ext2_fs.h
> @@ -696,6 +696,7 @@ struct ext2_super_block {
> #define EXT2_FEATURE_COMPAT_LAZY_BG        0x0040
> /* #define EXT2_FEATURE_COMPAT_EXCLUDE_INODE    0x0080 not used, legacy */
> #define EXT2_FEATURE_COMPAT_EXCLUDE_BITMAP    0x0100
> +#define EXT4_FEATURE_COMPAT_SUPER_SPARSE    0x0200
> 
> 
> #define EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER    0x0001
> diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
> index 1e07f88..efec97f 100644
> --- a/lib/ext2fs/ext2fs.h
> +++ b/lib/ext2fs/ext2fs.h
> @@ -550,7 +550,8 @@ typedef struct ext2_icount *ext2_icount_t;
>                     EXT3_FEATURE_COMPAT_HAS_JOURNAL|\
>                     EXT2_FEATURE_COMPAT_RESIZE_INODE|\
>                     EXT2_FEATURE_COMPAT_DIR_INDEX|\
> -                     EXT2_FEATURE_COMPAT_EXT_ATTR)
> +                     EXT2_FEATURE_COMPAT_EXT_ATTR|\
> +                     EXT4_FEATURE_COMPAT_SUPER_SPARSE)
> 
> /* This #ifdef is temporary until compression is fully supported */
> #ifdef ENABLE_COMPRESSION
> diff --git a/lib/ext2fs/res_gdt.c b/lib/ext2fs/res_gdt.c
> index 6449228..1ce6f68 100644
> --- a/lib/ext2fs/res_gdt.c
> +++ b/lib/ext2fs/res_gdt.c
> @@ -31,13 +31,23 @@ static unsigned int list_backups(ext2_filsys fs, unsigned int *three,
>    int mult = 3;
>    unsigned int ret;
> 
> +    if (fs->super->s_feature_compat & EXT4_FEATURE_COMPAT_SUPER_SPARSE) {
> +        if (*min == 1) {
> +            *min = fs->group_desc_count - 1;
> +            if (*min <= 1)
> +                *min = 2;
> +            return 1;
> +        }
> +        ret = *min;
> +        *min += 1;
> +        return ret;
> +    }
>    if (!(fs->super->s_feature_ro_compat &
>          EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER)) {
>        ret = *min;
> -        *min += 1;
> +        *min +=1 ;
>        return ret;
>    }
> -
>    if (*five < *min) {
>        min = five;
>        mult = 5;
> diff --git a/misc/ext4.5.in b/misc/ext4.5.in
> index fab1139..d6f71e7 100644
> --- a/misc/ext4.5.in
> +++ b/misc/ext4.5.in
> @@ -171,6 +171,13 @@ kernels from mounting file systems that they could not understand.
> .\" .br
> .\" .B Future feature, available in e2fsprogs 1.43-WIP
> .TP
> +.B super_sparse
> +.br
> +This feature indicates that there will only be only two backup
> +superblock and block group descriptors; one located at the beginning of
> +block group #1, and one in the last block group in the file system.
> +This is an more extreme version of sparse_super.
> +.TP
> .B meta_bg
> .br
> This ext4 feature allows file systems to be resized on-line without explicitly
> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> index c45b42f..825165f 100644
> --- a/misc/mke2fs.c
> +++ b/misc/mke2fs.c
> @@ -924,7 +924,8 @@ static __u32 ok_features[3] = {
>    EXT3_FEATURE_COMPAT_HAS_JOURNAL |
>        EXT2_FEATURE_COMPAT_RESIZE_INODE |
>        EXT2_FEATURE_COMPAT_DIR_INDEX |
> -        EXT2_FEATURE_COMPAT_EXT_ATTR,
> +        EXT2_FEATURE_COMPAT_EXT_ATTR |
> +        EXT4_FEATURE_COMPAT_SUPER_SPARSE,
>    /* Incompat */
>    EXT2_FEATURE_INCOMPAT_FILETYPE|
>        EXT3_FEATURE_INCOMPAT_EXTENTS|
> diff --git a/resize/online.c b/resize/online.c
> index defcac1..af640c3 100644
> --- a/resize/online.c
> +++ b/resize/online.c
> @@ -76,6 +76,14 @@ errcode_t online_resize_fs(ext2_filsys fs, const char *mtpt,
>            no_resize_ioctl = 1;
>    }
> 
> +    if (EXT2_HAS_COMPAT_FEATURE(fs->super,
> +                    EXT4_FEATURE_COMPAT_SUPER_SPARSE) &&
> +        (access("/sys/fs/ext4/features/super_sparse", R_OK) != 0)) {
> +        com_err(program_name, 0, _("kernel does not support online "
> +                       "resize with super_sparse"));
> +        exit(1);
> +    }
> +
>    printf(_("Filesystem at %s is mounted on %s; "
>         "on-line resizing required\n"), fs->device_name, mtpt);
> 
> diff --git a/resize/resize2fs.c b/resize/resize2fs.c
> index c4c2517..a6cbe57 100644
> --- a/resize/resize2fs.c
> +++ b/resize/resize2fs.c
> @@ -53,6 +53,9 @@ static errcode_t ext2fs_calculate_summary_stats(ext2_filsys fs);
> static errcode_t fix_sb_journal_backup(ext2_filsys fs);
> static errcode_t mark_table_blocks(ext2_filsys fs,
>                   ext2fs_block_bitmap bmap);
> +static errcode_t clear_super_sparse_last_group(ext2_resize_t rfs);
> +static errcode_t reserve_super_sparse_last_group(ext2_resize_t rfs,
> +                         ext2fs_block_bitmap meta_bmap);
> 
> /*
>  * Some helper CPP macros
> @@ -191,6 +194,10 @@ errcode_t resize_fs(ext2_filsys fs, blk64_t *new_size, int flags,
>        goto errout;
>    print_resource_track(rfs, &rtrack, fs->io);
> 
> +    retval = clear_super_sparse_last_group(rfs);
> +    if (retval)
> +        goto errout;
> +
>    rfs->new_fs->super->s_state &= ~EXT2_ERROR_FS;
>    rfs->new_fs->flags &= ~EXT2_FLAG_MASTER_SB_ONLY;
> 
> @@ -952,6 +959,10 @@ static errcode_t blocks_to_move(ext2_resize_t rfs)
>        new_blocks = fs->desc_blocks + fs->super->s_reserved_gdt_blocks;
>    }
> 
> +    retval = reserve_super_sparse_last_group(rfs, meta_bmap);
> +    if (retval)
> +        goto errout;
> +
>    if (old_blocks == new_blocks) {
>        retval = 0;
>        goto errout;
> @@ -1840,6 +1851,122 @@ errout:
> }
> 
> /*
> + * This function is used when expanding a file system.  It frees the
> + * superblock and block group descriptor blocks from the block group
> + * which is no longer the last block group.
> + */
> +static errcode_t clear_super_sparse_last_group(ext2_resize_t rfs)
> +{
> +    ext2_filsys    fs = rfs->new_fs;
> +    errcode_t    retval;
> +    dgrp_t        old_groups = rfs->old_fs->group_desc_count;
> +    dgrp_t        new_groups = fs->group_desc_count;
> +    blk64_t        sb, old_desc;
> +    blk_t        num;
> +
> +    if (!(fs->super->s_feature_compat & EXT4_FEATURE_COMPAT_SUPER_SPARSE))
> +        return 0;
> +
> +    if (new_groups <= old_groups || old_groups <= 2)
> +        return 0;
> +
> +    retval = ext2fs_super_and_bgd_loc2(rfs->old_fs, old_groups - 1,
> +                       &sb, &old_desc, NULL, &num);
> +    if (retval)
> +        return retval;
> +
> +    if (sb)
> +        ext2fs_unmark_block_bitmap2(fs->block_map, sb);
> +    if (old_desc)
> +        ext2fs_unmark_block_bitmap_range2(fs->block_map, old_desc, num);
> +    return 0;
> +}
> +
> +/*
> + * This function is used when shrinking a file system.  We need to
> + * utilize blocks from what will be the new last block group for the
> + * backup superblock and block group descriptor blocks.
> + * Unfortunately, those blocks may be used by other files or fs
> + * metadata blocks.  We need to mark them as being in use.
> + */
> +static errcode_t reserve_super_sparse_last_group(ext2_resize_t rfs,
> +                         ext2fs_block_bitmap meta_bmap)
> +{
> +    ext2_filsys    fs = rfs->new_fs;
> +    ext2_filsys    old_fs = rfs->old_fs;
> +    errcode_t    retval;
> +    dgrp_t        old_groups = old_fs->group_desc_count;
> +    dgrp_t        new_groups = fs->group_desc_count;
> +    dgrp_t        g;
> +    blk64_t        blk, sb, old_desc;
> +    blk_t        i, num;
> +    int        realloc = 0;
> +
> +    if (!(fs->super->s_feature_compat & EXT4_FEATURE_COMPAT_SUPER_SPARSE))
> +        return 0;
> +
> +    if (new_groups >= old_groups || new_groups <= 2)
> +        return 0;
> +
> +    retval = ext2fs_super_and_bgd_loc2(rfs->new_fs, new_groups - 1,
> +                       &sb, &old_desc, NULL, &num);
> +    if (retval)
> +        return retval;
> +
> +    if (!sb) {
> +        fputs(_("Should never happen!  No sb in last super_sparse bg?\n"),
> +              stderr);
> +        exit(1);
> +    }
> +    if (old_desc != sb+1) {
> +        fputs(_("Should never happen!  Unexpected old_desc in "
> +            "super_sparse bg?\n"),
> +              stderr);
> +        exit(1);
> +    }
> +    num = (old_desc) ? num + 1 : 1;
> +
> +    /* Reserve the backup blocks */
> +    ext2fs_mark_block_bitmap_range2(fs->block_map, sb, num);
> +
> +    for (g = 0; g < fs->group_desc_count; g++) {
> +        blk64_t mb;
> +
> +        mb = ext2fs_block_bitmap_loc(fs, g);
> +        if ((mb >= sb) && (mb < sb + num)) {
> +            ext2fs_block_bitmap_loc_set(fs, g, 0);
> +            realloc = 1;
> +        }
> +        mb = ext2fs_inode_bitmap_loc(fs, g);
> +        if ((mb >= sb) && (mb < sb + num)) {
> +            ext2fs_inode_bitmap_loc_set(fs, g, 0);
> +            realloc = 1;
> +        }
> +        mb = ext2fs_inode_table_loc(fs, g);
> +        if ((mb < sb + num) &&
> +            (sb < mb + fs->inode_blocks_per_group)) {
> +            ext2fs_inode_table_loc_set(fs, g, 0);
> +            realloc = 1;
> +        }
> +        if (realloc) {
> +            retval = ext2fs_allocate_group_table(fs, g, 0);
> +            if (retval)
> +                return retval;
> +        }
> +    }
> +
> +    for (blk = sb, i = 0; i < num; i++) {
> +        if (ext2fs_test_block_bitmap2(old_fs->block_map, blk) &&
> +            !ext2fs_test_block_bitmap2(meta_bmap, blk)) {
> +            ext2fs_mark_block_bitmap2(rfs->move_blocks, blk);
> +            rfs->needed_blocks++;
> +        }
> +        ext2fs_mark_block_bitmap2(rfs->reserve_blocks, blk);
> +    }
> +    return 0;
> +}
> +
> +/*
>  * Fix the resize inode
>  */
> static errcode_t fix_resize_inode(ext2_filsys fs)
> -- 
> 1.8.5.rc3.362.gdf10213
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
