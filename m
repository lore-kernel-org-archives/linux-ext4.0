From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 2/4] ext4: use ext4_get_block_write in buffer write
Date: Fri, 18 Dec 2009 15:24:44 +0530
Message-ID: <20091218095444.GA9437@skywalker.linux.vnet.ibm.com>
References: <5df78e1d0912151739j1f9f8a36j830ee175291d21a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Michael Rubin <mrubin@google.com>
To: Jiaying Zhang <jiayingz@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:33858 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905AbZLRJyw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Dec 2009 04:54:52 -0500
Received: from d28relay01.in.ibm.com (d28relay01.in.ibm.com [9.184.220.58])
	by e28smtp04.in.ibm.com (8.14.3/8.13.1) with ESMTP id nBI9skTw024914
	for <linux-ext4@vger.kernel.org>; Fri, 18 Dec 2009 15:24:46 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay01.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id nBI9skEo1167588
	for <linux-ext4@vger.kernel.org>; Fri, 18 Dec 2009 15:24:46 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id nBI9skNS011804
	for <linux-ext4@vger.kernel.org>; Fri, 18 Dec 2009 15:24:46 +0530
Content-Disposition: inline
In-Reply-To: <5df78e1d0912151739j1f9f8a36j830ee175291d21a@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 15, 2009 at 05:39:08PM -0800, Jiaying Zhang wrote:
> ext4: use ext4_get_block_write in buffer write
> 
> Allocate uninitialized extent before ext4 buffer write and
> convert the extent to initialized after io completes.
> The purpose is to make sure an extent can only be marked
> initialized after it has been written with new data so
> we can safely drop the i_mutex lock in ext4 DIO read without
> exposing stale data. This helps to improve multi-thread DIO
> read performance on high-speed disks.
> 
> Skip the nobh and data=journal mount cases to make things simple for now.
> 
> Signed-off-by: Jiaying Zhang <jiayingz@google.com>
> ---
>  fs/ext4/ext4.h    |    5 +++
>  fs/ext4/extents.c |   10 +++---
>  fs/ext4/fsync.c   |    3 ++
>  fs/ext4/inode.c   |   81 ++++++++++++++++++++++++++++++++++++++++++++++--------
>  fs/ext4/super.c   |   30 +++++++++++++++++---
>  5 files changed, 108 insertions(+), 21 deletions(-)
> 
> Index: git-ext4/fs/ext4/extents.c
> ===================================================================
> --- git-ext4.orig/fs/ext4/extents.c     2009-12-15 16:03:05.000000000 -0800
> +++ git-ext4/fs/ext4/extents.c  2009-12-15 16:03:15.000000000 -0800
> @@ -3052,6 +3052,7 @@ ext4_ext_handle_uninitialized_extents(ha
>                        io->flag = EXT4_IO_UNWRITTEN;
>                else
>                        EXT4_I(inode)->i_state |= EXT4_STATE_DIO_UNWRITTEN;
> +               set_buffer_uninit(bh_result);
>                goto out;
>        }
>        /* IO end_io complete, convert the filled extent to written */
> @@ -3291,11 +3292,9 @@ int ext4_ext_get_blocks(handle_t *handle
>        if (flags & EXT4_GET_BLOCKS_UNINIT_EXT){
>                ext4_ext_mark_uninitialized(&newex);
>                /*
> -                * io_end structure was created for every async
> -                * direct IO write to the middle of the file.
> -                * To avoid unecessary convertion for every aio dio rewrite
> -                * to the mid of file, here we flag the IO that is really
> -                * need the convertion.
> +                * io_end structure was created for every IO write to an
> +                * uninitialized extent. To avoid unecessary convertion,
> +                * here we flag the IO that really needs the convertion.
>                 * For non asycn direct IO case, flag the inode state
>                 * that we need to perform convertion when IO is done.
>                 */
> @@ -3306,6 +3305,7 @@ int ext4_ext_get_blocks(handle_t *handle
>                                EXT4_I(inode)->i_state |=
>                                        EXT4_STATE_DIO_UNWRITTEN;;
>                }
> +               set_buffer_uninit(bh_result);
>        }
>        err = ext4_ext_insert_extent(handle, inode, path, &newex, flags);
>        if (err) {
> Index: git-ext4/fs/ext4/ext4.h
> ===================================================================
> --- git-ext4.orig/fs/ext4/ext4.h        2009-12-15 16:03:05.000000000 -0800
> +++ git-ext4/fs/ext4/ext4.h     2009-12-15 16:03:15.000000000 -0800
> @@ -134,6 +134,7 @@ struct mpage_da_data {
>        int retval;
>  };
>  #define        EXT4_IO_UNWRITTEN       0x1
> +#define        EXT4_IO_WRITTEN         0x2
>  typedef struct ext4_io_end {
>        struct list_head        list;           /* per-file finished AIO list */
>        struct inode            *inode;         /* file being written to */
> @@ -752,6 +753,7 @@ struct ext4_inode_info {
>  #define EXT4_MOUNT_QUOTA               0x80000 /* Some quota option set */
>  #define EXT4_MOUNT_USRQUOTA            0x100000 /* "old" user quota */
>  #define EXT4_MOUNT_GRPQUOTA            0x200000 /* "old" group quota */
> +#define EXT4_MOUNT_DIOREAD_NOLOCK      0x400000 /* Enable support for
> dio read nolocking */
>  #define EXT4_MOUNT_JOURNAL_CHECKSUM    0x800000 /* Journal checksums */
>  #define EXT4_MOUNT_JOURNAL_ASYNC_COMMIT        0x1000000 /* Journal
> Async Commit */
>  #define EXT4_MOUNT_I_VERSION            0x2000000 /* i_version support */
> @@ -1764,6 +1766,9 @@ static inline void set_bitmap_uptodate(s
>        set_bit(BH_BITMAP_UPTODATE, &(bh)->b_state);
>  }
> 
> +/* BH_Uninit flag: blocks are allocated but uninitialized on disk */
> +#define BH_Uninit (BH_JBDPrivateStart + 1)
> +BUFFER_FNS(Uninit, uninit)


Why do we need to add a new buffer_head flag. Why is unwritten flag not sufficient
for this ?


>  #endif /* __KERNEL__ */
> 
>  #endif /* _EXT4_H */
> Index: git-ext4/fs/ext4/super.c
> ===================================================================
> --- git-ext4.orig/fs/ext4/super.c       2009-12-15 16:03:05.000000000 -0800
> +++ git-ext4/fs/ext4/super.c    2009-12-15 16:03:15.000000000 -0800
> @@ -921,6 +921,9 @@ static int ext4_show_options(struct seq_
>        if (test_opt(sb, NOLOAD))
>                seq_puts(seq, ",norecovery");
> 
> +       if (test_opt(sb, DIOREAD_NOLOCK))
> +               seq_puts(seq, ",dioread_nolock");
> +
>        ext4_show_quota_options(seq, sb);
> 
>        return 0;
> @@ -1103,6 +1106,7 @@ enum {
>        Opt_stripe, Opt_delalloc, Opt_nodelalloc,
>        Opt_block_validity, Opt_noblock_validity,
>        Opt_inode_readahead_blks, Opt_journal_ioprio,
> +       Opt_dioread_nolock, Opt_dioread_lock,
>        Opt_discard, Opt_nodiscard, Opt_akpm_lock_hack
>  };
> 
> @@ -1171,6 +1175,8 @@ static const match_table_t tokens = {
>        {Opt_auto_da_alloc, "auto_da_alloc=%u"},
>        {Opt_auto_da_alloc, "auto_da_alloc"},
>        {Opt_noauto_da_alloc, "noauto_da_alloc"},
> +       {Opt_dioread_nolock, "dioread_nolock"},
> +       {Opt_dioread_lock, "dioread_lock"},



I guess this mount option will go away when we are ready to merge this
upstream ? If we want to merge i guess we should make this the default
behaviour.

Why version of the kernel are the patches against. I would like to take
a look at the changes after applying the patches.

-aneesh



