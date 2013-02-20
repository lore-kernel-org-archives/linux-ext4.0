From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] New ioctl "EXT4_IOC_SWAP_BOOT" to secure boot loader code.
Date: Wed, 20 Feb 2013 10:20:11 -0700
Message-ID: <D1134183-EA96-4419-8EC6-12CFF70DFC6C@dilger.ca>
References: <1361308255-7991-1-git-send-email-t.bubeck@reinform.de>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"Dr. Tilmann Bubeck" <t.bubeck@reinform.de>
To: "Dr. Tilmann Bubeck" <t.bubeck@reinform.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:50334 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758998Ab3BTRUM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Feb 2013 12:20:12 -0500
Received: by mail-pa0-f54.google.com with SMTP id fa10so4163508pad.27
        for <linux-ext4@vger.kernel.org>; Wed, 20 Feb 2013 09:20:12 -0800 (PST)
In-Reply-To: <1361308255-7991-1-git-send-email-t.bubeck@reinform.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2013-02-19, at 14:10, "Dr. Tilmann Bubeck" <t.bubeck@reinform.de> wrote:
> 
>  "Swap i_blocks and associated attributes (like i_blocks, i_size,
>   i_flags, ...) from the associated inode with inode
>   EXT4_BOOT_LOADER_INO (#5). This is typically used to store a boot
>   loader in a secure part of the filesystem, where it can't be
>   changed by the user on accident.  The data blocks of the previous
>   boot loader will be associated with the given inode."
> 
> The implementation uses existing (static) functions from move_extent.c
> which therefore had to be changed in name and linkage.

Patch looks mostly good, but some comments inline. 

> Also "ext4_iget()" was extended, so that it is able to return inode
> EXT4_BOOT_LOADER_INO, which has no valid i_mode and i_nlink.

It would be good to also have mke2fs and e2fsck itialize the mode of the
EXT4_BOOT_LOADER_INO inode, so that it can be treated like a normal
inode at some point in the future. 

> This usercode program is a simple example of the usage:
> 
> int main(int argc, char *argv[])
> {
>  int fd;
>  int err;
> 
>  if ( argc != 2 ) {
>    printf("usage: ext4-swap-boot-inode FILE-TO-SWAP\n");
>    exit(1);
>  }
> 
>  fd = open(argv[1], O_RDONLY);

It should be required to be able to open the target inode in write mode, to check
permissions, since this inode will essentially be deleted from the user's
point of view. 

>  if ( fd < 0 ) {
>    perror("open");
>    exit(1);
>  }
> 
>  err = ioctl(fd, EXT4_IOC_SWAP_BOOT);
>  if ( err < 0 ) {
>    perror("ioctl");
>    exit(1);
>  }
> 
>  close(fd);
>  exit(0);
> }
> 
> Signed-off-by: Dr. Tilmann Bubeck <t.bubeck@reinform.de>
> ---
> 
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index d93393e..e4c02b9 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -614,6 +614,7 @@ enum {
> #define EXT4_IOC_ALLOC_DA_BLKS        _IO('f', 12)
> #define EXT4_IOC_MOVE_EXT        _IOWR('f', 15, struct move_extent)
> #define EXT4_IOC_RESIZE_FS        _IOW('f', 16, __u64)
> +#define EXT4_IOC_SWAP_BOOT        _IO('f', 17)


> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 07d9def..767d2da 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -3748,14 +3748,18 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
>    if (inode->i_nlink == 0) {
>        if (inode->i_mode == 0 ||
>            !(EXT4_SB(inode->i_sb)->s_mount_state & EXT4_ORPHAN_FS)) {
> -            /* this inode is deleted */
> -            ret = -ESTALE;
> -            goto bad_inode;
> +            if (ino != EXT4_BOOT_LOADER_INO) {
> +                /* this inode is deleted */
> +                ret = -ESTALE;
> +                goto bad_inode;
> +            }

(style) Instead of multiple nested "if" blocks, this should just use "&&" to
avoid indenting the code so much.

      if ((inode->i_mode == 0 ||
          !(EXT4_SB(inode->i_sb)->s_mount_state) & EXT4_ORPHAN_FS) &&
         ino != EXT4_BOOT_LOADER_INO) {
            /* this inode is deleted */
            ret = -ESTALE;
            goto bad_inode;
      }

> +            /* The only unlinked inodes we let through here have
> +             * valid i_mode and are being read by the orphan
> +             * recovery code: that's fine, we're about to complete
> +             * the process of deleting those.
> +             * OR it is the EXT4_BOOT_LOADER_INO which is
> +             * not initialized on a prune filesystem. */

(typo) "prune filesystem"? Maybe "new filesystem" is better?

> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
> index 4784ac2..b17a1c2 100644
> --- a/fs/ext4/ioctl.c
> +++ b/fs/ext4/ioctl.c
> @@ -17,9 +17,166 @@
> +/**
> + * Swap the information from the given @inode and the inode
> + * EXT4_BOOT_LOADER_INO. It will basically swap i_data and all other
> + * important fields of the inodes.
> + *
> + * @sb:         the super block of the filesystem
> + * @inode:      the inode to swap with EXT4_BOOT_LOADER_INO
> + *
> + */
> +static long __swap_inode_boot_loader(struct super_block *sb,

(style) no need for a double underscore prefix for this function. 

> +                     struct inode *inode)
> +{
> +    handle_t *handle;
> +    int err, err2;
> +    struct inode *inode_bl;
> +    struct ext4_inode_info *ei;
> +    struct ext4_inode_info *ei_bl;
> +    long long isize;

This is typically loff_t. 

> +    struct ext4_sb_info *sbi;
> +
> +    sbi = EXT4_SB(sb);
> +    ei = EXT4_I(inode);


> +    inode_bl = ext4_iget(sb, EXT4_BOOT_LOADER_INO);
> +    if (IS_ERR(inode_bl)) {
> +        err = PTR_ERR(inode_bl);
> +        goto swap_boot_out;
> +    }
> +    ei_bl = EXT4_I(inode_bl);
> +
> +    if (!inode_owner_or_capable(inode_bl)) {
> +        err = -EPERM;
> +        goto swap_boot_out;
> +    }

This check should be moved to after i_uid and i_gid are initialized, if
inode_bl is a new inode. 

> +    /* This is non obvious task to swap blocks for inodes with full
> +     * jornaling enabled */

(typo) s/jornaling/journaling/

Could you please explain why data journal is a problem?  The data blocks
themselves are not being moved, so it should be enough to fdatasync() and
fdatawait() for the source inode to ensure it has no dirty blocks before swapping. 

> +    if (ext4_should_journal_data(inode) ||
> +        ext4_should_journal_data(inode_bl)) {
> +        err = -EINVAL;
> +        goto swap_boot_out;
> +    }
> +    /* Protect orig and boot loader inodes against a truncate */
> +    ext4_inode_double_lock(inode, inode_bl);

Since the bootloader inode is inaccessible to userspace, there is no
danger of truncating it. However, there should only be one EXT4_IOC_SWAP_BOOT
operation in progress at a time, so this locking is definitely still needed. It just
needs a more accurate comment. 

> +    /* Wait for all existing dio workers */
> +    ext4_inode_block_unlocked_dio(inode);
> +    ext4_inode_block_unlocked_dio(inode_bl);
> +    inode_dio_wait(inode);
> +    inode_dio_wait(inode_bl);
> +
> +    /* Protect extent tree against block allocations via delalloc */
> +    ext4_double_down_write_data_sem(inode, inode_bl);
> +
> +    handle = ext4_journal_start(inode_bl, 2);
> +    if (IS_ERR(handle)) {
> +        err = -EINVAL;
> +        goto swap_boot_out;
> +    }
> +
> +    if (inode_bl->i_nlink == 0) {
> +        /* this inode has never been used as a BOOT_LOADER */
> +        set_nlink(inode_bl, 1);
> +        inode_bl->i_uid = 0;
> +        inode_bl->i_gid = 0;
> +        inode_bl->i_flags = inode->i_flags;
> +        ei_bl->i_flags = ei->i_flags;

Better to just initialize the flags to zero. Otherwise it might inherit some strange
flags that don't make sense for the empty inode. 

> +        inode_bl->i_version = 1;

Just to be paranoid, this should also set i_size_write(inode_bl, 0)) in case
it was corrupted. Also need to set inode->i_mode = S_IFREG. 

> +        ext4_ext_tree_init(handle, inode_bl);
> +    }

Should this also prevent installing an inode with multiple hard links, or is
there some reason that would be desirable? Similarly, is it desirable if
the BOOT_LOADER inode could be
a directory, or should it refuse to work on anything but S_IFREG inodes?

> +    __memswap(&inode->i_flags, &inode_bl->i_flags, sizeof(inode->i_flags));
> +    __memswap(&inode->i_version, &inode_bl->i_version,
> +          sizeof(inode->i_version));
> +    __memswap(&inode->i_blocks, &inode_bl->i_blocks,
> +          sizeof(inode->i_blocks));
> +    __memswap(&inode->i_bytes, &inode_bl->i_bytes, sizeof(inode->i_bytes));
> +    __memswap(&inode->i_atime, &inode_bl->i_atime, sizeof(inode->i_atime));
> +    __memswap(&inode->i_mtime, &inode_bl->i_mtime, sizeof(inode->i_mtime));


> +    __memswap(ei->i_data, ei_bl->i_data, sizeof(ei->i_data));
> +    __memswap(&ei->i_flags, &ei_bl->i_flags, sizeof(ei->i_flags));
> +    __memswap(&ei->i_disksize, &ei_bl->i_disksize, sizeof(ei->i_disksize));
> +    __memswap(&ei->i_cached_extent, &ei_bl->i_cached_extent,
> +          sizeof(ei->i_cached_extent));
> +
> +    isize = i_size_read(inode);
> +    i_size_write(inode, i_size_read(inode_bl));
> +    i_size_write(inode_bl, isize);
> +
> +    inode->i_ctime = inode_bl->i_ctime = ext4_current_time(inode);
> +
> +    spin_lock(&sbi->s_next_gen_lock);
> +    inode_bl->i_generation = sbi->s_next_generation++;
> +    spin_unlock(&sbi->s_next_gen_lock);
> +
> +    ext4_ext_invalidate_cache(inode);
> +    ext4_ext_invalidate_cache(inode_bl);
> +    ext4_discard_preallocations(inode);
> +    ext4_discard_preallocations(inode_bl);

It shouldn't be possible to have any cache or preallocations on inode_bl,
unless it can have multiple hard links. 

> +    err = ext4_mark_inode_dirty(handle, inode);
> +    if (err < 0) {
> +        ext4_warning(inode->i_sb,
> +                 "couldn't mark inode dirty (err %d)", err);
> +    }
> +    err2 = ext4_mark_inode_dirty(handle, inode_bl);
> +    if (err2 < 0) {
> +        ext4_warning(inode->i_sb,
> +                 "couldn't mark inode dirty (err %d)", err2);
> +        err = err2;
> +    }

If either of these operations fail, the blocks should be swapped back,
or the kernel and filesystem will be in an inconsistent state and operations
on the files could cause corruption of the on-disk state. 

> +    ext4_journal_stop(handle);
> +    ext4_double_up_write_data_sem(inode, inode_bl);
> +
> +    ext4_inode_resume_unlocked_dio(inode);
> +    ext4_inode_resume_unlocked_dio(inode_bl);
> +
> +    ext4_inode_double_unlock(inode, inode_bl);
> +
> +    truncate_inode_pages(&inode->i_data, 0);
> +    truncate_inode_pages(&inode_bl->i_data, 0);
> +    filemap_flush(inode->i_mapping);
> +    filemap_flush(inode_bl->i_mapping);
> +
> +    iput(inode_bl);
> +
> +swap_boot_out:
> +    return err;
> +}
> +
> long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
> {
>    struct inode *inode = filp->f_dentry->d_inode;
> @@ -357,6 +514,12 @@ group_add_out:
>        return err;
>    }
> 
> +    case EXT4_IOC_SWAP_BOOT:
> +    {

(style) no need for {} here, since no variables are declared local to this ioctl. 

> +        ext4_msg(sb, KERN_ERR, "%s/%d", __func__, __LINE__);
> +        return __swap_inode_boot_loader(sb, inode);
> +    }
> +
>    case EXT4_IOC_RESIZE_FS: {
>        ext4_fsblk_t n_blocks_count;
>        struct super_block *sb = inode->i_sb;

Cheers, Andreas