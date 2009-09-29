From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Question on fallocate/ftruncate sequence
Date: Tue, 29 Sep 2009 14:15:23 -0500
Message-ID: <4AC25CCB.8050805@redhat.com>
References: <1248389165.17459.3.camel@bobble.smo.corp.google.com>	 <5df78e1d0908281444x556a7c2ey763dc6233820abc6@mail.gmail.com>	 <20090828221432.GS4197@webber.adilger.int>	 <5df78e1d0908281740w7bc0f283x5004ca5b231b3af5@mail.gmail.com>	 <20090830025250.GA25768@mit.edu>	 <5df78e1d0908311240s3205b4bcrb65b2552b4ed579c@mail.gmail.com>	 <20090831215612.GG4197@webber.adilger.int>	 <5df78e1d0908311633k1f16a096t701e0cdab54b174c@mail.gmail.com>	 <20090902084134.GO4197@webber.adilger.int>	 <5df78e1d0909022220m1152b313o92f6cb7cc8858298@mail.gmail.com> <5df78e1d0909232227y2cb52abew827d7732a3bc9040@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@sun.com>, Theodore Tso <tytso@mit.edu>,
	Frank Mayhar <fmayhar@google.com>,
	Curt Wohlgemuth <curtw@google.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Jiaying Zhang <jiayingz@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9893 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752855AbZI2TP0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 Sep 2009 15:15:26 -0400
In-Reply-To: <5df78e1d0909232227y2cb52abew827d7732a3bc9040@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jiaying Zhang wrote:
> Sorry for taking so long to finish this. Here is the new patch based on
> Andreas's suggestions. Now the patch clears the EXT4_EOFBLOCKS_FL
> flag when we allocate beyond the maximum allocated block. I also
> made the EOFBLOCKS flag user visible and added the handling
> in ext4_ioctl as Andrea suggested.

I was testing this a bit in xfstests, with test 083 (recently I sent a
patch to the xfs list to let that test run on generic filesystems) which
runs fsstress on a small-ish 100M fs, and that fsstress does space
preallocation (on newer kernels, where the older xfs ioctls are hooked
up to do_fallocate in a generic fashion).

I'm actually seeing more corruption w/ this patch than without it,
though I don't yet see why.  I'll double check that it applied properly,
since this was against 2.6.30.5....

Also it strikes me as a little odd to allow clearing of the EOF Flag
from userspace, and the subsequent discarding of the blocks past EOF.

Doesn't truncating to i_size do exactly the same thing, in a more
portable way?  Why make a new interface unique to ext4?

-Eric

> Index: linux-2.6.30.5/fs/ext4/inode.c
> ===================================================================
> --- linux-2.6.30.5.orig/fs/ext4/inode.c    2009-08-31 12:08:10.000000000 -0700
> +++ linux-2.6.30.5/fs/ext4/inode.c    2009-09-23 21:42:33.000000000 -0700
> @@ -3973,6 +3973,8 @@ void ext4_truncate(struct inode *inode)
>      if (!ext4_can_truncate(inode))
>          return;
> 
> +    inode->i_flags &= ~EXT4_EOFBLOCKS_FL;
> +
>      if (inode->i_size == 0 && !test_opt(inode->i_sb, NO_AUTO_DA_ALLOC))
>          ei->i_state |= EXT4_STATE_DA_ALLOC_CLOSE;
> 
> @@ -4285,8 +4287,8 @@ void ext4_get_inode_flags(struct ext4_in
>  {
>      unsigned int flags = ei->vfs_inode.i_flags;
> 
> -    ei->i_flags &= ~(EXT4_SYNC_FL|EXT4_APPEND_FL|
> -            EXT4_IMMUTABLE_FL|EXT4_NOATIME_FL|EXT4_DIRSYNC_FL);
> +    ei->i_flags &= ~(EXT4_SYNC_FL|EXT4_APPEND_FL|EXT4_IMMUTABLE_FL|
> +            EXT4_NOATIME_FL|EXT4_DIRSYNC_FL|EXT4_EOFBLOCKS_FL);
>      if (flags & S_SYNC)
>          ei->i_flags |= EXT4_SYNC_FL;
>      if (flags & S_APPEND)
> @@ -4297,6 +4299,8 @@ void ext4_get_inode_flags(struct ext4_in
>          ei->i_flags |= EXT4_NOATIME_FL;
>      if (flags & S_DIRSYNC)
>          ei->i_flags |= EXT4_DIRSYNC_FL;
> +    if (flags & FS_EOFBLOCKS_FL)
> +        ei->i_flags |= EXT4_EOFBLOCKS_FL;
>  }
>  static blkcnt_t ext4_inode_blocks(struct ext4_inode *raw_inode,
>                      struct ext4_inode_info *ei)
> @@ -4807,7 +4811,9 @@ int ext4_setattr(struct dentry *dentry,
>      }
> 
>      if (S_ISREG(inode->i_mode) &&
> -        attr->ia_valid & ATTR_SIZE && attr->ia_size < inode->i_size) {
> +        attr->ia_valid & ATTR_SIZE &&
> +        (attr->ia_size < inode->i_size ||
> +         (inode->i_flags & EXT4_EOFBLOCKS_FL))) {
>          handle_t *handle;
> 
>          handle = ext4_journal_start(inode, 3);
> @@ -4838,6 +4844,11 @@ int ext4_setattr(struct dentry *dentry,
>                  goto err_out;
>              }
>          }
> +        if ((inode->i_flags & EXT4_EOFBLOCKS_FL)) {
> +            rc = vmtruncate(inode, attr->ia_size);
> +            if (rc)
> +                goto err_out;
> +        }
>      }
> 
>      rc = inode_setattr(inode, attr);
> Index: linux-2.6.30.5/include/linux/fs.h
> ===================================================================
> --- linux-2.6.30.5.orig/include/linux/fs.h    2009-08-31
> 12:08:10.000000000 -0700
> +++ linux-2.6.30.5/include/linux/fs.h    2009-09-10 21:27:30.000000000 -0700
> @@ -343,9 +343,10 @@ struct inodes_stat_t {
>  #define FS_TOPDIR_FL            0x00020000 /* Top of directory hierarchies*/
>  #define FS_EXTENT_FL            0x00080000 /* Extents */
>  #define FS_DIRECTIO_FL            0x00100000 /* Use direct i/o */
> +#define FS_EOFBLOCKS_FL            0x00200000 /* Blocks allocated beyond EOF */
>  #define FS_RESERVED_FL            0x80000000 /* reserved for ext2 lib */
> 
> -#define FS_FL_USER_VISIBLE        0x0003DFFF /* User visible flags */
> +#define FS_FL_USER_VISIBLE        0x0023DFFF /* User visible flags */
>  #define FS_FL_USER_MODIFIABLE        0x000380FF /* User modifiable flags */
> 
> 
> Index: linux-2.6.30.5/fs/ext4/ext4.h
> ===================================================================
> --- linux-2.6.30.5.orig/fs/ext4/ext4.h    2009-08-31 12:08:10.000000000 -0700
> +++ linux-2.6.30.5/fs/ext4/ext4.h    2009-09-10 21:28:14.000000000 -0700
> @@ -235,9 +235,10 @@ struct flex_groups {
>  #define EXT4_HUGE_FILE_FL               0x00040000 /* Set to each huge file */
>  #define EXT4_EXTENTS_FL            0x00080000 /* Inode uses extents */
>  #define EXT4_EXT_MIGRATE        0x00100000 /* Inode is migrating */
> +#define EXT4_EOFBLOCKS_FL        0x00200000 /* Blocks allocated
> beyond EOF (bit reserved in fs.h) */
>  #define EXT4_RESERVED_FL        0x80000000 /* reserved for ext4 lib */
> 
> -#define EXT4_FL_USER_VISIBLE        0x000BDFFF /* User visible flags */
> +#define EXT4_FL_USER_VISIBLE        0x002BDFFF /* User visible flags */
>  #define EXT4_FL_USER_MODIFIABLE        0x000B80FF /* User modifiable flags */
> 
>  /* Flags that should be inherited by new inodes from their parent. */
> Index: linux-2.6.30.5/fs/ext4/extents.c
> ===================================================================
> --- linux-2.6.30.5.orig/fs/ext4/extents.c    2009-09-01 18:14:58.000000000 -0700
> +++ linux-2.6.30.5/fs/ext4/extents.c    2009-09-23 22:12:22.000000000 -0700
> @@ -2788,7 +2788,7 @@ int ext4_ext_get_blocks(handle_t *handle
>  {
>      struct ext4_ext_path *path = NULL;
>      struct ext4_extent_header *eh;
> -    struct ext4_extent newex, *ex;
> +    struct ext4_extent newex, *ex, *last_ex;
>      ext4_fsblk_t newblock;
>      int err = 0, depth, ret, cache_type;
>      unsigned int allocated = 0;
> @@ -2968,6 +2968,14 @@ int ext4_ext_get_blocks(handle_t *handle
>      newex.ee_len = cpu_to_le16(ar.len);
>      if (create == EXT4_CREATE_UNINITIALIZED_EXT)  /* Mark uninitialized */
>          ext4_ext_mark_uninitialized(&newex);
> +
> +    if (unlikely(inode->i_flags & EXT4_EOFBLOCKS_FL)) {
> +        BUG_ON(!eh->eh_entries);
> +        last_ex = EXT_LAST_EXTENT(eh);
> +        if (iblock + ar.len > le32_to_cpu(last_ex->ee_block)
> +                    + ext4_ext_get_actual_len(last_ex))
> +            inode->i_flags &= ~EXT4_EOFBLOCKS_FL;
> +    }
>      err = ext4_ext_insert_extent(handle, inode, path, &newex);
>      if (err) {
>          /* free data blocks we just allocated */
> @@ -3095,6 +3103,13 @@ static void ext4_falloc_update_inode(str
>              i_size_write(inode, new_size);
>          if (new_size > EXT4_I(inode)->i_disksize)
>              ext4_update_i_disksize(inode, new_size);
> +    } else {
> +        /*
> +         * Mark that we allocate beyond EOF so the subsequent truncate
> +         * can proceed even if the new size is the same as i_size.
> +         */
> +        if (new_size > i_size_read(inode))
> +            inode->i_flags |= EXT4_EOFBLOCKS_FL;
>      }
>  }
> 
> Index: linux-2.6.30.5/fs/ext4/ioctl.c
> ===================================================================
> --- linux-2.6.30.5.orig/fs/ext4/ioctl.c    2009-08-16 14:19:38.000000000 -0700
> +++ linux-2.6.30.5/fs/ext4/ioctl.c    2009-09-23 22:04:47.000000000 -0700
> @@ -92,6 +92,16 @@ long ext4_ioctl(struct file *filp, unsig
>              flags &= ~EXT4_EXTENTS_FL;
>          }
> 
> +        if (flags & EXT4_EOFBLOCKS_FL) {
> +            /* we don't support adding EOFBLOCKS flag */
> +            if (!(oldflags & EXT4_EOFBLOCKS_FL)) {
> +                err = -EOPNOTSUPP;
> +                goto flags_out;
> +            }
> +        } else if (oldflags & EXT4_EOFBLOCKS_FL)
> +            /* free the space reserved with fallocate KEEPSIZE */
> +            vmtruncate(inode, inode->i_size);
> +
>          handle = ext4_journal_start(inode, 1);
>          if (IS_ERR(handle)) {
>              err = PTR_ERR(handle);
> 
> 
