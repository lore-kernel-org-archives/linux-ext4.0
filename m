From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] ext4: Implementation of a new ioctl called
 "EXT4_IOC_SWAP_BOOT":
Date: Wed, 17 Sep 2014 16:12:53 -0700
Message-ID: <20140917231253.GG10150@birch.djwong.org>
References: <1361599212-2381-1-git-send-email-t.bubeck@reinform.de>
 <79CDA797-602B-4632-8986-2CEC6F0FEEE4@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Dr. Tilmann Bubeck" <t.bubeck@reinform.de>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40290 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbaIQXNN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Sep 2014 19:13:13 -0400
Content-Disposition: inline
In-Reply-To: <79CDA797-602B-4632-8986-2CEC6F0FEEE4@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Feb 23, 2013 at 08:59:03PM +0800, Andreas Dilger wrote:
> On 2013-02-23, at 14:00, "Dr. Tilmann Bubeck" <t.bubeck@reinform.de> wrote:
> 
> > From: "Dr. Tilmann Bubeck" <t.bubeck@reinform.de>
> > 
> >  "Swap i_blocks and associated attributes (like i_blocks, i_size,
> >   i_flags, ...) from the associated inode with inode
> >   EXT4_BOOT_LOADER_INO (#5). This is typically used to store a boot
> >   loader in a secure part of the filesystem, where it can't be
> >   changed by the user on accident.  The data blocks of the previous
> >   boot loader will be associated with the given inode."
> > 
> > This update includes all improvements suggested by Andreas Dilger in
> > his email from Wed, 20 Feb 2013 10:20:11 -0700 and also from
> > Sat, 23 Feb 2013 06:04:23 +0800:
> > 
> > * allow data=journal
> > * require filp to be opened O_WR
> > * removed __ before static function names
> > * fixed some typos
> > * swap i_data back if errors occurred
> > 
> > Please let me know, is there are more things to change for this patch.
> > 
> > Next step would be (after acceptance of this patch) to
> > extend e2fsprogs (tune2fs, e2fsck, mkfs.ext4). However, this is not a
> > prerequisite for using the functionality of this patch.
> > 
> > The implementation uses existing (static) functions from move_extent.c
> > which therefore had to be changed in name and linkage.
> > 
> > Also "ext4_iget()" was extended, so that it is able to return inode
> > EXT4_BOOT_LOADER_INO, which has no valid i_mode and i_nlink.
> > 
> > This usercode program is a simple example of the usage:
> > 
> > int main(int argc, char *argv[])
> > {
> >  int fd;
> >  int err;
> > 
> >  if ( argc != 2 ) {
> >    printf("usage: ext4-swap-boot-inode FILE-TO-SWAP\n");
> >    exit(1);
> >  }
> > 
> >  fd = open(argv[1], O_WRONLY);
> >  if ( fd < 0 ) {
> >    perror("open");
> >    exit(1);
> >  }
> > 
> >  err = ioctl(fd, EXT4_IOC_SWAP_BOOT);
> >  if ( err < 0 ) {
> >    perror("ioctl");
> >    exit(1);
> >  }
> > 
> >  close(fd);
> >  exit(0);
> > }
> > 
> > Signed-off-by: Dr. Tilmann Bubeck <t.bubeck@reinform.de>
> 
> Looks good to me. You can add my/
> 
> Reviewed-by: Andreas Dilger <adilger@dilger.ca>
> 
> > ---
> > Documentation/filesystems/ext4.txt |  10 ++
> > fs/ext4/ext4.h                     |  10 +-
> > fs/ext4/inode.c                    |  11 ++-
> > fs/ext4/ioctl.c                    | 191 +++++++++++++++++++++++++++++++++++++
> > fs/ext4/move_extent.c              |  47 ++++-----
> > 5 files changed, 241 insertions(+), 28 deletions(-)
> > 
> > diff --git a/Documentation/filesystems/ext4.txt b/Documentation/filesystems/ext4.txt
> > index 34ea4f1..47f130e 100644
> > --- a/Documentation/filesystems/ext4.txt
> > +++ b/Documentation/filesystems/ext4.txt
> > @@ -587,6 +587,16 @@ Table of Ext4 specific ioctls
> >                  bitmaps and inode table, the userspace tool thus
> >                  just passes the new number of blocks.
> > 
> > + EXT4_IOC_SWAP_BOOT          Swap i_blocks and associated attributes
> > +                  (like i_blocks, i_size, i_flags, ...) from
> > +                  the associated inode with inode 
> > +                  EXT4_BOOT_LOADER_INO (#5). This is typically
> > +                  used to store a boot loader in a secure part of
> > +                  the filesystem, where it can't be changed by the
> > +                  user on accident.
> > +                  The data blocks of the previous boot loader
> > +                  will be associated with the given inode.
> > +
> > ..............................................................................
> > 
> > References
> > diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> > index d93393e..e4c02b9 100644
> > --- a/fs/ext4/ext4.h
> > +++ b/fs/ext4/ext4.h
> > @@ -614,6 +614,7 @@ enum {
> > #define EXT4_IOC_ALLOC_DA_BLKS        _IO('f', 12)
> > #define EXT4_IOC_MOVE_EXT        _IOWR('f', 15, struct move_extent)
> > #define EXT4_IOC_RESIZE_FS        _IOW('f', 16, __u64)
> > +#define EXT4_IOC_SWAP_BOOT        _IO('f', 17)
> > 
> > #if defined(__KERNEL__) && defined(CONFIG_COMPAT)
> > /*
> > @@ -1335,6 +1336,7 @@ static inline int ext4_valid_inum(struct super_block *sb, unsigned long ino)
> >    return ino == EXT4_ROOT_INO ||
> >        ino == EXT4_USR_QUOTA_INO ||
> >        ino == EXT4_GRP_QUOTA_INO ||
> > +        ino == EXT4_BOOT_LOADER_INO ||
> >        ino == EXT4_JOURNAL_INO ||
> >        ino == EXT4_RESIZE_INO ||
> >        (ino >= EXT4_FIRST_INO(sb) &&
> > @@ -2523,9 +2525,13 @@ extern int ext4_ext_check_inode(struct inode *inode);
> > extern int ext4_find_delalloc_cluster(struct inode *inode, ext4_lblk_t lblk);
> > extern int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
> >            __u64 start, __u64 len);
> > -
> > -
> > /* move_extent.c */
> > +extern void ext4_double_down_write_data_sem(struct inode *first, 
> > +                                       struct inode *second);
> > +extern void ext4_double_up_write_data_sem(struct inode *orig_inode,
> > +                                     struct inode *donor_inode);
> > +void ext4_inode_double_lock(struct inode *inode1, struct inode *inode2);
> > +void ext4_inode_double_unlock(struct inode *inode1, struct inode *inode2);
> > extern int ext4_move_extents(struct file *o_filp, struct file *d_filp,
> >                 __u64 start_orig, __u64 start_donor,
> >                 __u64 len, __u64 *moved_len);
> > diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> > index 07d9def..3731ce8 100644
> > --- a/fs/ext4/inode.c
> > +++ b/fs/ext4/inode.c
> > @@ -3746,8 +3746,9 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
> >     * NeilBrown 1999oct15
> >     */
> >    if (inode->i_nlink == 0) {
> > -        if (inode->i_mode == 0 ||
> > -            !(EXT4_SB(inode->i_sb)->s_mount_state & EXT4_ORPHAN_FS)) {
> > +        if ((inode->i_mode == 0 ||
> > +             !(EXT4_SB(inode->i_sb)->s_mount_state & EXT4_ORPHAN_FS)) &&
> > +            ino != EXT4_BOOT_LOADER_INO) {
> >            /* this inode is deleted */
> >            ret = -ESTALE;
> >            goto bad_inode;
> > @@ -3755,7 +3756,9 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
> >        /* The only unlinked inodes we let through here have
> >         * valid i_mode and are being read by the orphan
> >         * recovery code: that's fine, we're about to complete
> > -         * the process of deleting those. */
> > +         * the process of deleting those.
> > +         * OR it is the EXT4_BOOT_LOADER_INO which is
> > +         * not initialized on a new filesystem. */
> >    }
> >    ei->i_flags = le32_to_cpu(raw_inode->i_flags);
> >    inode->i_blocks = ext4_inode_blocks(raw_inode, ei);
> > @@ -3875,6 +3878,8 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
> >        else
> >            init_special_inode(inode, inode->i_mode,
> >               new_decode_dev(le32_to_cpu(raw_inode->i_block[1])));
> > +    } else if (ino == EXT4_BOOT_LOADER_INO) {
> > +        make_bad_inode(inode);
> >    } else {
> >        ret = -EIO;
> >        EXT4_ERROR_INODE(inode, "bogus i_mode (%o)", inode->i_mode);
> > diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
> > index 4784ac2..0f5845f 100644
> > --- a/fs/ext4/ioctl.c
> > +++ b/fs/ext4/ioctl.c
> > @@ -17,9 +17,195 @@
> > #include <asm/uaccess.h>
> > #include "ext4_jbd2.h"
> > #include "ext4.h"
> > +#include "ext4_extents.h"
> > 
> > #define MAX_32_NUM ((((unsigned long long) 1) << 32) - 1)
> > 
> > +/**
> > + * Swap memory between @a and @b for @len bytes.
> > + *
> > + * @a:          pointer to first memory area
> > + * @b:          pointer to second memory area
> > + * @len:        number of bytes to swap
> > + *
> > + */
> > +static void memswap(void *a, void *b, size_t len)
> > +{
> > +    unsigned char *ap, *bp;
> > +    unsigned char tmp;
> > +
> > +    ap = (unsigned char *)a;
> > +    bp = (unsigned char *)b;
> > +    while (len-- > 0) {
> > +        tmp = *ap;
> > +        *ap = *bp;
> > +        *bp = tmp;
> > +        ap++;
> > +        bp++;
> > +    }
> > +}
> > +
> > +/**
> > + * Swap i_data and associated attributes between inode1 and inode2.
> > + * This function is used for the primary swap between inode1 and inode2
> > + * and also to revert this primary swap in case of errors.
> > + *
> > + * Therefore you have to make sure, that calling this method twice
> > + * will revert all changes.
> > + * 
> > + * @inode1:     pointer to first inode
> > + * @inode2:     pointer to second inode
> > + */
> > +static void swap_inode_data(struct inode *inode1, struct inode *inode2)
> > +{
> > +    loff_t isize;
> > +    struct ext4_inode_info *ei1;
> > +    struct ext4_inode_info *ei2;
> > +
> > +    ei1 = EXT4_I(inode1);
> > +    ei2 = EXT4_I(inode2);
> > +
> > +    memswap(&inode1->i_flags, &inode2->i_flags, sizeof(inode1->i_flags));
> > +    memswap(&inode1->i_version, &inode2->i_version,
> > +          sizeof(inode1->i_version));
> > +    memswap(&inode1->i_blocks, &inode2->i_blocks,
> > +          sizeof(inode1->i_blocks));
> > +    memswap(&inode1->i_bytes, &inode2->i_bytes, sizeof(inode1->i_bytes));
> > +    memswap(&inode1->i_atime, &inode2->i_atime, sizeof(inode1->i_atime));
> > +    memswap(&inode1->i_mtime, &inode2->i_mtime, sizeof(inode1->i_mtime));
> > +
> > +    memswap(ei1->i_data, ei2->i_data, sizeof(ei1->i_data));

I hate to be the guy who's 7mo late to the party, but ...

Swapping the extent tree root isn't enough on a metadata_csum FS; the extent
tree blocks also need to have their checksums recalculated.

--D

> > +    memswap(&ei1->i_flags, &ei2->i_flags, sizeof(ei1->i_flags));
> > +    memswap(&ei1->i_disksize, &ei2->i_disksize, sizeof(ei1->i_disksize));
> > +    memswap(&ei1->i_cached_extent, &ei2->i_cached_extent,
> > +          sizeof(ei1->i_cached_extent));
> > +
> > +    isize = i_size_read(inode1);
> > +    i_size_write(inode1, i_size_read(inode2));
> > +    i_size_write(inode2, isize);
> > +}
> > +
> > +/**
> > + * Swap the information from the given @inode and the inode
> > + * EXT4_BOOT_LOADER_INO. It will basically swap i_data and all other
> > + * important fields of the inodes.
> > + *
> > + * @sb:         the super block of the filesystem
> > + * @inode:      the inode to swap with EXT4_BOOT_LOADER_INO
> > + *
> > + */
> > +static long swap_inode_boot_loader(struct super_block *sb,
> > +                struct inode *inode)
> > +{
> > +    handle_t *handle;
> > +    int err;
> > +    struct inode *inode_bl;
> > +    struct ext4_inode_info *ei;
> > +    struct ext4_inode_info *ei_bl;
> > +    struct ext4_sb_info *sbi;
> > +    
> > +    if (inode->i_nlink != 1 || !S_ISREG(inode->i_mode)) {
> > +        err = -EINVAL;
> > +        goto swap_boot_out;
> > +    }
> > +    
> > +    sbi = EXT4_SB(sb);
> > +    ei = EXT4_I(inode);
> > +    
> > +    inode_bl = ext4_iget(sb, EXT4_BOOT_LOADER_INO);
> > +    if (IS_ERR(inode_bl)) {
> > +        err = PTR_ERR(inode_bl);
> > +        goto swap_boot_out;
> > +    }
> > +    ei_bl = EXT4_I(inode_bl);
> > +
> > +    /* Protect orig inodes against a truncate and make sure,
> > +     * that only 1 swap_inode_boot_loader is running. */
> > +    ext4_inode_double_lock(inode, inode_bl);
> > +
> > +    /* Wait for all existing dio workers */
> > +    ext4_inode_block_unlocked_dio(inode);
> > +    ext4_inode_block_unlocked_dio(inode_bl);
> > +    inode_dio_wait(inode);
> > +    inode_dio_wait(inode_bl);
> > +
> > +    /* Protect extent tree against block allocations via delalloc */
> > +    ext4_double_down_write_data_sem(inode, inode_bl);
> > +
> > +    handle = ext4_journal_start(inode_bl, 2);
> > +    if (IS_ERR(handle)) {
> > +        err = -EINVAL;
> > +        goto swap_boot_out;
> > +    }
> > +
> > +    if (inode_bl->i_nlink == 0) {
> > +        /* this inode has never been used as a BOOT_LOADER */
> > +        set_nlink(inode_bl, 1);
> > +        inode_bl->i_uid = 0;
> > +        inode_bl->i_gid = 0;
> > +        inode_bl->i_flags = 0;
> > +        ei_bl->i_flags = 0;
> > +        inode_bl->i_version = 1;
> > +        i_size_write(inode_bl, 0);
> > +        inode_bl->i_mode = S_IFREG;
> > +        ext4_ext_tree_init(handle, inode_bl);
> > +    }
> > +
> > +    if (!inode_owner_or_capable(inode_bl)) {
> > +        err = -EPERM;
> > +        goto swap_boot_out_with_journal;
> > +    }
> > +
> > +    swap_inode_data(inode, inode_bl);
> > +
> > +    inode->i_ctime = inode_bl->i_ctime = ext4_current_time(inode);
> > +
> > +    spin_lock(&sbi->s_next_gen_lock);
> > +    inode_bl->i_generation = sbi->s_next_generation++;
> > +    spin_unlock(&sbi->s_next_gen_lock);
> > +
> > +    ext4_ext_invalidate_cache(inode);
> > +    ext4_discard_preallocations(inode);
> > +
> > +    err = ext4_mark_inode_dirty(handle, inode);
> > +    if (err < 0) {
> > +        ext4_warning(inode->i_sb,
> > +            "couldn't mark inode #%lu dirty (err %d)", 
> > +            inode->i_ino, err);
> > +        /* Revert all changes: */
> > +        swap_inode_data(inode, inode_bl);
> > +    } else {
> > +        err = ext4_mark_inode_dirty(handle, inode_bl);
> > +        if (err < 0) {
> > +            ext4_warning(inode_bl->i_sb,
> > +                "couldn't mark inode #%lu dirty (err %d)", 
> > +                inode_bl->i_ino, err);
> > +            /* Revert all changes: */
> > +            swap_inode_data(inode, inode_bl);
> > +        }
> > +    }
> > +
> > +swap_boot_out_with_journal:
> > +    ext4_journal_stop(handle);
> > +    
> > +    ext4_double_up_write_data_sem(inode, inode_bl);
> > +
> > +    ext4_inode_resume_unlocked_dio(inode);
> > +    ext4_inode_resume_unlocked_dio(inode_bl);
> > +
> > +    ext4_inode_double_unlock(inode, inode_bl);
> > +
> > +    truncate_inode_pages(&inode->i_data, 0);
> > +    truncate_inode_pages(&inode_bl->i_data, 0);
> > +    filemap_flush(inode->i_mapping);
> > +    filemap_flush(inode_bl->i_mapping);
> > +
> > +    iput(inode_bl);
> > +
> > +swap_boot_out:
> > +    return err;
> > +}
> > +
> > long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
> > {
> >    struct inode *inode = filp->f_dentry->d_inode;
> > @@ -357,6 +543,11 @@ group_add_out:
> >        return err;
> >    }
> > 
> > +    case EXT4_IOC_SWAP_BOOT:
> > +        if (!(filp->f_mode & FMODE_WRITE))
> > +            return -EBADF;
> > +        return swap_inode_boot_loader(sb, inode);
> > +
> >    case EXT4_IOC_RESIZE_FS: {
> >        ext4_fsblk_t n_blocks_count;
> >        struct super_block *sb = inode->i_sb;
> > diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
> > index d9cc5ee..ee7da4e 100644
> > --- a/fs/ext4/move_extent.c
> > +++ b/fs/ext4/move_extent.c
> > @@ -142,12 +142,13 @@ mext_next_extent(struct inode *inode, struct ext4_ext_path *path,
> > }
> > 
> > /**
> > - * double_down_write_data_sem - Acquire two inodes' write lock of i_data_sem
> > + * ext4_double_down_write_data_sem - Acquire two inodes' write lock 
> > + *                                   of i_data_sem
> >  *
> >  * Acquire write lock of i_data_sem of the two inodes
> >  */
> > -static void
> > -double_down_write_data_sem(struct inode *first, struct inode *second)
> > +void
> > +ext4_double_down_write_data_sem(struct inode *first, struct inode *second)
> > {
> >    if (first < second) {
> >        down_write(&EXT4_I(first)->i_data_sem);
> > @@ -160,14 +161,14 @@ double_down_write_data_sem(struct inode *first, struct inode *second)
> > }
> > 
> > /**
> > - * double_up_write_data_sem - Release two inodes' write lock of i_data_sem
> > + * ext4_double_up_write_data_sem - Release two inodes' write lock of i_data_sem
> >  *
> >  * @orig_inode:        original inode structure to be released its lock first
> >  * @donor_inode:    donor inode structure to be released its lock second
> >  * Release write lock of i_data_sem of two inodes (orig and donor).
> >  */
> > -static void
> > -double_up_write_data_sem(struct inode *orig_inode, struct inode *donor_inode)
> > +void
> > +ext4_double_up_write_data_sem(struct inode *orig_inode, struct inode *donor_inode)
> > {
> >    up_write(&EXT4_I(orig_inode)->i_data_sem);
> >    up_write(&EXT4_I(donor_inode)->i_data_sem);
> > @@ -965,7 +966,7 @@ again:
> >     * necessary, just swap data blocks between orig and donor.
> >     */
> >    if (uninit) {
> > -        double_down_write_data_sem(orig_inode, donor_inode);
> > +        ext4_double_down_write_data_sem(orig_inode, donor_inode);
> >        /* If any of extents in range became initialized we have to
> >         * fallback to data copying */
> >        uninit = mext_check_coverage(orig_inode, orig_blk_offset,
> > @@ -979,7 +980,7 @@ again:
> >            goto drop_data_sem;
> > 
> >        if (!uninit) {
> > -            double_up_write_data_sem(orig_inode, donor_inode);
> > +            ext4_double_up_write_data_sem(orig_inode, donor_inode);
> >            goto data_copy;
> >        }
> >        if ((page_has_private(pagep[0]) &&
> > @@ -993,7 +994,7 @@ again:
> >                        donor_inode, orig_blk_offset,
> >                        block_len_in_page, err);
> >    drop_data_sem:
> > -        double_up_write_data_sem(orig_inode, donor_inode);
> > +        ext4_double_up_write_data_sem(orig_inode, donor_inode);
> >        goto unlock_pages;
> >    }
> > data_copy:
> > @@ -1054,11 +1055,11 @@ repair_branches:
> >     * Extents are swapped already, but we are not able to copy data.
> >     * Try to swap extents to it's original places
> >     */
> > -    double_down_write_data_sem(orig_inode, donor_inode);
> > +    ext4_double_down_write_data_sem(orig_inode, donor_inode);
> >    replaced_count = mext_replace_branches(handle, donor_inode, orig_inode,
> >                           orig_blk_offset,
> >                           block_len_in_page, &err2);
> > -    double_up_write_data_sem(orig_inode, donor_inode);
> > +    ext4_double_up_write_data_sem(orig_inode, donor_inode);
> >    if (replaced_count != block_len_in_page) {
> >        EXT4_ERROR_INODE_BLOCK(orig_inode, (sector_t)(orig_blk_offset),
> >                       "Unable to copy data block,"
> > @@ -1198,15 +1199,15 @@ mext_check_arguments(struct inode *orig_inode,
> > }
> > 
> > /**
> > - * mext_inode_double_lock - Lock i_mutex on both @inode1 and @inode2
> > + * ext4_inode_double_lock - Lock i_mutex on both @inode1 and @inode2
> >  *
> >  * @inode1:    the inode structure
> >  * @inode2:    the inode structure
> >  *
> >  * Lock two inodes' i_mutex
> >  */
> > -static void
> > -mext_inode_double_lock(struct inode *inode1, struct inode *inode2)
> > +void
> > +ext4_inode_double_lock(struct inode *inode1, struct inode *inode2)
> > {
> >    BUG_ON(inode1 == inode2);
> >    if (inode1 < inode2) {
> > @@ -1219,15 +1220,15 @@ mext_inode_double_lock(struct inode *inode1, struct inode *inode2)
> > }
> > 
> > /**
> > - * mext_inode_double_unlock - Release i_mutex on both @inode1 and @inode2
> > + * ext4_inode_double_unlock - Release i_mutex on both @inode1 and @inode2
> >  *
> >  * @inode1:     the inode that is released first
> >  * @inode2:     the inode that is released second
> >  *
> >  */
> > 
> > -static void
> > -mext_inode_double_unlock(struct inode *inode1, struct inode *inode2)
> > +void
> > +ext4_inode_double_unlock(struct inode *inode1, struct inode *inode2)
> > {
> >    mutex_unlock(&inode1->i_mutex);
> >    mutex_unlock(&inode2->i_mutex);
> > @@ -1322,7 +1323,7 @@ ext4_move_extents(struct file *o_filp, struct file *d_filp,
> >        return -EINVAL;
> >    }
> >    /* Protect orig and donor inodes against a truncate */
> > -    mext_inode_double_lock(orig_inode, donor_inode);
> > +    ext4_inode_double_lock(orig_inode, donor_inode);
> > 
> >    /* Wait for all existing dio workers */
> >    ext4_inode_block_unlocked_dio(orig_inode);
> > @@ -1331,7 +1332,7 @@ ext4_move_extents(struct file *o_filp, struct file *d_filp,
> >    inode_dio_wait(donor_inode);
> > 
> >    /* Protect extent tree against block allocations via delalloc */
> > -    double_down_write_data_sem(orig_inode, donor_inode);
> > +    ext4_double_down_write_data_sem(orig_inode, donor_inode);
> >    /* Check the filesystem environment whether move_extent can be done */
> >    ret = mext_check_arguments(orig_inode, donor_inode, orig_start,
> >                    donor_start, &len);
> > @@ -1455,7 +1456,7 @@ ext4_move_extents(struct file *o_filp, struct file *d_filp,
> >         * b. racing with ->readpage, ->write_begin, and ext4_get_block
> >         *    in move_extent_per_page
> >         */
> > -        double_up_write_data_sem(orig_inode, donor_inode);
> > +        ext4_double_up_write_data_sem(orig_inode, donor_inode);
> > 
> >        while (orig_page_offset <= seq_end_page) {
> > 
> > @@ -1489,7 +1490,7 @@ ext4_move_extents(struct file *o_filp, struct file *d_filp,
> >                block_len_in_page = rest_blocks;
> >        }
> > 
> > -        double_down_write_data_sem(orig_inode, donor_inode);
> > +        ext4_double_down_write_data_sem(orig_inode, donor_inode);
> >        if (ret < 0)
> >            break;
> > 
> > @@ -1527,10 +1528,10 @@ out:
> >        ext4_ext_drop_refs(holecheck_path);
> >        kfree(holecheck_path);
> >    }
> > -    double_up_write_data_sem(orig_inode, donor_inode);
> > +    ext4_double_up_write_data_sem(orig_inode, donor_inode);
> >    ext4_inode_resume_unlocked_dio(orig_inode);
> >    ext4_inode_resume_unlocked_dio(donor_inode);
> > -    mext_inode_double_unlock(orig_inode, donor_inode);
> > +    ext4_inode_double_unlock(orig_inode, donor_inode);
> > 
> >    return ret;
> > }
> > -- 
> > 1.8.1.2
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
