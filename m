From: Jiaying Zhang <jiayingz@google.com>
Subject: [RFC PATCH 2/4] ext4: use ext4_get_block_write in buffer write
Date: Tue, 15 Dec 2009 17:39:08 -0800
Message-ID: <5df78e1d0912151739j1f9f8a36j830ee175291d21a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Michael Rubin <mrubin@google.com>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:43370 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934426AbZLPBjL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Dec 2009 20:39:11 -0500
Received: from wpaz33.hot.corp.google.com (wpaz33.hot.corp.google.com [172.24.198.97])
	by smtp-out.google.com with ESMTP id nBG1dB3l025168
	for <linux-ext4@vger.kernel.org>; Tue, 15 Dec 2009 17:39:11 -0800
Received: from pxi17 (pxi17.prod.google.com [10.243.27.17])
	by wpaz33.hot.corp.google.com with ESMTP id nBG1d2Bi001220
	for <linux-ext4@vger.kernel.org>; Tue, 15 Dec 2009 17:39:08 -0800
Received: by pxi17 with SMTP id 17so832058pxi.30
        for <linux-ext4@vger.kernel.org>; Tue, 15 Dec 2009 17:39:08 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4: use ext4_get_block_write in buffer write

Allocate uninitialized extent before ext4 buffer write and
convert the extent to initialized after io completes.
The purpose is to make sure an extent can only be marked
initialized after it has been written with new data so
we can safely drop the i_mutex lock in ext4 DIO read without
exposing stale data. This helps to improve multi-thread DIO
read performance on high-speed disks.

Skip the nobh and data=journal mount cases to make things simple for now.

Signed-off-by: Jiaying Zhang <jiayingz@google.com>
---
 fs/ext4/ext4.h    |    5 +++
 fs/ext4/extents.c |   10 +++---
 fs/ext4/fsync.c   |    3 ++
 fs/ext4/inode.c   |   81 ++++++++++++++++++++++++++++++++++++++++++++++--------
 fs/ext4/super.c   |   30 +++++++++++++++++---
 5 files changed, 108 insertions(+), 21 deletions(-)

Index: git-ext4/fs/ext4/extents.c
===================================================================
--- git-ext4.orig/fs/ext4/extents.c     2009-12-15 16:03:05.000000000 -0800
+++ git-ext4/fs/ext4/extents.c  2009-12-15 16:03:15.000000000 -0800
@@ -3052,6 +3052,7 @@ ext4_ext_handle_uninitialized_extents(ha
                       io->flag = EXT4_IO_UNWRITTEN;
               else
                       EXT4_I(inode)->i_state |= EXT4_STATE_DIO_UNWRITTEN;
+               set_buffer_uninit(bh_result);
               goto out;
       }
       /* IO end_io complete, convert the filled extent to written */
@@ -3291,11 +3292,9 @@ int ext4_ext_get_blocks(handle_t *handle
       if (flags & EXT4_GET_BLOCKS_UNINIT_EXT){
               ext4_ext_mark_uninitialized(&newex);
               /*
-                * io_end structure was created for every async
-                * direct IO write to the middle of the file.
-                * To avoid unecessary convertion for every aio dio rewrite
-                * to the mid of file, here we flag the IO that is really
-                * need the convertion.
+                * io_end structure was created for every IO write to an
+                * uninitialized extent. To avoid unecessary convertion,
+                * here we flag the IO that really needs the convertion.
                * For non asycn direct IO case, flag the inode state
                * that we need to perform convertion when IO is done.
                */
@@ -3306,6 +3305,7 @@ int ext4_ext_get_blocks(handle_t *handle
                               EXT4_I(inode)->i_state |=
                                       EXT4_STATE_DIO_UNWRITTEN;;
               }
+               set_buffer_uninit(bh_result);
       }
       err = ext4_ext_insert_extent(handle, inode, path, &newex, flags);
       if (err) {
Index: git-ext4/fs/ext4/ext4.h
===================================================================
--- git-ext4.orig/fs/ext4/ext4.h        2009-12-15 16:03:05.000000000 -0800
+++ git-ext4/fs/ext4/ext4.h     2009-12-15 16:03:15.000000000 -0800
@@ -134,6 +134,7 @@ struct mpage_da_data {
       int retval;
 };
 #define        EXT4_IO_UNWRITTEN       0x1
+#define        EXT4_IO_WRITTEN         0x2
 typedef struct ext4_io_end {
       struct list_head        list;           /* per-file finished AIO list */
       struct inode            *inode;         /* file being written to */
@@ -752,6 +753,7 @@ struct ext4_inode_info {
 #define EXT4_MOUNT_QUOTA               0x80000 /* Some quota option set */
 #define EXT4_MOUNT_USRQUOTA            0x100000 /* "old" user quota */
 #define EXT4_MOUNT_GRPQUOTA            0x200000 /* "old" group quota */
+#define EXT4_MOUNT_DIOREAD_NOLOCK      0x400000 /* Enable support for
dio read nolocking */
 #define EXT4_MOUNT_JOURNAL_CHECKSUM    0x800000 /* Journal checksums */
 #define EXT4_MOUNT_JOURNAL_ASYNC_COMMIT        0x1000000 /* Journal
Async Commit */
 #define EXT4_MOUNT_I_VERSION            0x2000000 /* i_version support */
@@ -1764,6 +1766,9 @@ static inline void set_bitmap_uptodate(s
       set_bit(BH_BITMAP_UPTODATE, &(bh)->b_state);
 }

+/* BH_Uninit flag: blocks are allocated but uninitialized on disk */
+#define BH_Uninit (BH_JBDPrivateStart + 1)
+BUFFER_FNS(Uninit, uninit)
 #endif /* __KERNEL__ */

 #endif /* _EXT4_H */
Index: git-ext4/fs/ext4/super.c
===================================================================
--- git-ext4.orig/fs/ext4/super.c       2009-12-15 16:03:05.000000000 -0800
+++ git-ext4/fs/ext4/super.c    2009-12-15 16:03:15.000000000 -0800
@@ -921,6 +921,9 @@ static int ext4_show_options(struct seq_
       if (test_opt(sb, NOLOAD))
               seq_puts(seq, ",norecovery");

+       if (test_opt(sb, DIOREAD_NOLOCK))
+               seq_puts(seq, ",dioread_nolock");
+
       ext4_show_quota_options(seq, sb);

       return 0;
@@ -1103,6 +1106,7 @@ enum {
       Opt_stripe, Opt_delalloc, Opt_nodelalloc,
       Opt_block_validity, Opt_noblock_validity,
       Opt_inode_readahead_blks, Opt_journal_ioprio,
+       Opt_dioread_nolock, Opt_dioread_lock,
       Opt_discard, Opt_nodiscard, Opt_akpm_lock_hack
 };

@@ -1171,6 +1175,8 @@ static const match_table_t tokens = {
       {Opt_auto_da_alloc, "auto_da_alloc=%u"},
       {Opt_auto_da_alloc, "auto_da_alloc"},
       {Opt_noauto_da_alloc, "noauto_da_alloc"},
+       {Opt_dioread_nolock, "dioread_nolock"},
+       {Opt_dioread_lock, "dioread_lock"},
       {Opt_discard, "discard"},
       {Opt_nodiscard, "nodiscard"},
       {Opt_err, NULL},
@@ -1603,6 +1609,12 @@ set_qf_format:
               case Opt_nodiscard:
                       clear_opt(sbi->s_mount_opt, DISCARD);
                       break;
+               case Opt_dioread_nolock:
+                       set_opt(sbi->s_mount_opt, DIOREAD_NOLOCK);
+                       break;
+               case Opt_dioread_lock:
+                       clear_opt(sbi->s_mount_opt, DIOREAD_NOLOCK);
+                       break;
               case Opt_akpm_lock_hack:
                       set_opt(sbi->s_mount_opt, AKPM_LOCK_HACK);
                       break;
@@ -2769,7 +2781,7 @@ static int ext4_fill_super(struct super_
             EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER)) {
               ext4_msg(sb, KERN_ERR, "required journal recovery "
                      "suppressed and not mounted read-only");
-               goto failed_mount4;
+               goto failed_mount_wq;
       } else {
               clear_opt(sbi->s_mount_opt, DATA_FLAGS);
               set_opt(sbi->s_mount_opt, WRITEBACK_DATA);
@@ -2782,7 +2794,7 @@ static int ext4_fill_super(struct super_
           !jbd2_journal_set_features(EXT4_SB(sb)->s_journal, 0, 0,
                                      JBD2_FEATURE_INCOMPAT_64BIT)) {
               ext4_msg(sb, KERN_ERR, "Failed to set 64-bit journal feature");
-               goto failed_mount4;
+               goto failed_mount_wq;
       }

       if (test_opt(sb, JOURNAL_ASYNC_COMMIT)) {
@@ -2821,7 +2833,7 @@ static int ext4_fill_super(struct super_
                   (sbi->s_journal, 0, 0, JBD2_FEATURE_INCOMPAT_REVOKE)) {
                       ext4_msg(sb, KERN_ERR, "Journal does not support "
                              "requested data journaling mode");
-                       goto failed_mount4;
+                       goto failed_mount_wq;
               }
       default:
               break;
@@ -2829,13 +2841,17 @@ static int ext4_fill_super(struct super_
       set_task_ioprio(sbi->s_journal->j_task, journal_ioprio);

 no_journal:
-
       if (test_opt(sb, NOBH)) {
               if (!(test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_WRITEBACK_DATA)) {
                       ext4_msg(sb, KERN_WARNING, "Ignoring nobh option - "
                               "its supported only with writeback mode");
                       clear_opt(sbi->s_mount_opt, NOBH);
               }
+               if (test_opt(sb, DIOREAD_NOLOCK)) {
+                       ext4_msg(sb, KERN_WARNING, "dioread_nolock option is "
+                               "not supported with nobh mode");
+                       goto failed_mount_wq;
+               }
       }
       EXT4_SB(sb)->dio_unwritten_wq = create_workqueue("ext4-dio-unwritten");
       if (!EXT4_SB(sb)->dio_unwritten_wq) {
@@ -2900,6 +2916,12 @@ no_journal:
                        "requested data journaling mode");
               clear_opt(sbi->s_mount_opt, DELALLOC);
       }
+       if (test_opt(sb, DIOREAD_NOLOCK) &&
+           (test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_JOURNAL_DATA)) {
+               ext4_msg(sb, KERN_WARNING, "Ignoring dioread_nolock option - "
+                        "requested data journaling mode");
+               clear_opt(sbi->s_mount_opt, DIOREAD_NOLOCK);
+       }

       err = ext4_setup_system_zone(sb);
       if (err) {
Index: git-ext4/fs/ext4/inode.c
===================================================================
--- git-ext4.orig/fs/ext4/inode.c       2009-12-15 16:03:05.000000000 -0800
+++ git-ext4/fs/ext4/inode.c    2009-12-15 16:03:15.000000000 -0800
@@ -1492,6 +1492,8 @@ static int do_journal_get_write_access(h
       return ext4_journal_get_write_access(handle, bh);
 }

+static int ext4_get_block_write(struct inode *inode, sector_t iblock,
+                  struct buffer_head *bh_result, int create);
 static int ext4_write_begin(struct file *file, struct address_space *mapping,
                           loff_t pos, unsigned len, unsigned flags,
                           struct page **pagep, void **fsdata)
@@ -1533,8 +1535,12 @@ retry:
       }
       *pagep = page;

-       ret = block_write_begin(file, mapping, pos, len, flags, pagep, fsdata,
-                               ext4_get_block);
+       if (test_opt(inode->i_sb, DIOREAD_NOLOCK))
+               ret = block_write_begin(file, mapping, pos, len, flags, pagep,
+                               fsdata, ext4_get_block_write);
+       else
+               ret = block_write_begin(file, mapping, pos, len, flags, pagep,
+                               fsdata, ext4_get_block);

       if (!ret && ext4_should_journal_data(inode)) {
               ret = walk_page_buffers(handle, page_buffers(page),
@@ -2053,6 +2059,8 @@ static void mpage_put_bnr_to_bhs(struct
                               } else if (buffer_mapped(bh))
                                       BUG_ON(bh->b_blocknr != pblock);

+                               if (buffer_uninit(exbh))
+                                       set_buffer_uninit(bh);
                               cur_logical++;
                               pblock++;
                       } while ((bh = bh->b_this_page) != head);
@@ -2183,6 +2191,8 @@ static int mpage_da_map_blocks(struct mp
       new.b_state = 0;
       get_blocks_flags = (EXT4_GET_BLOCKS_CREATE |
                           EXT4_GET_BLOCKS_DELALLOC_RESERVE);
+       if (test_opt(mpd->inode->i_sb, DIOREAD_NOLOCK))
+               get_blocks_flags |= EXT4_GET_BLOCKS_IO_CREATE_EXT;
       if (mpd->b_state & (1 << BH_Delay))
               get_blocks_flags |= EXT4_GET_BLOCKS_UPDATE_RESERVE_SPACE;
       blks = ext4_get_blocks(handle, mpd->inode, next, max_blocks,
@@ -2597,6 +2607,9 @@ out:
       return ret;
 }

+static int ext4_set_bh_endio(struct buffer_head *bh, struct inode *inode);
+static void ext4_end_io_buffer_write(struct buffer_head *bh, int uptodate);
+
 /*
 * Note that we don't need to start a transaction unless we're journaling data
 * because we should have holes filled from ext4_page_mkwrite(). We even don't
@@ -2644,7 +2657,7 @@ static int ext4_writepage(struct page *p
       int ret = 0;
       loff_t size;
       unsigned int len;
-       struct buffer_head *page_bufs;
+       struct buffer_head *page_bufs = NULL;
       struct inode *inode = page->mapping->host;

       trace_ext4_writepage(inode, page);
@@ -2720,7 +2733,11 @@ static int ext4_writepage(struct page *p

       if (test_opt(inode->i_sb, NOBH) && ext4_should_writeback_data(inode))
               ret = nobh_writepage(page, noalloc_get_block_write, wbc);
-       else
+       else if (page_bufs && buffer_uninit(page_bufs)) {
+               ext4_set_bh_endio(page_bufs, inode);
+               ret = block_write_full_page_endio(page, noalloc_get_block_write,
+                                           wbc, ext4_end_io_buffer_write);
+       } else
               ret = block_write_full_page(page, noalloc_get_block_write,
                                           wbc);

@@ -3697,12 +3714,10 @@ static int ext4_end_io_nolock(ext4_io_en
       if (list_empty(&io->list))
               return ret;

-       if (io->flag != EXT4_IO_UNWRITTEN)
+       if (io->flag != EXT4_IO_WRITTEN)
               return ret;

-       if (offset + size <= i_size_read(inode))
-               ret = ext4_convert_unwritten_extents(inode, offset, size);
-
+       ret = ext4_convert_unwritten_extents(inode, offset, size);
       if (ret < 0) {
               printk(KERN_EMERG "%s: failed to convert unwritten"
                       "extents to written extents, error is %d"
@@ -3750,7 +3765,7 @@ static void ext4_end_io_work(struct work
 */
 int flush_completed_IO(struct inode *inode)
 {
-       ext4_io_end_t *io;
+       ext4_io_end_t *io, *tmp;
       int ret = 0;
       int ret2 = 0;

@@ -3758,9 +3773,10 @@ int flush_completed_IO(struct inode *ino
               return ret;

       dump_completed_IO(inode);
-       while (!list_empty(&EXT4_I(inode)->i_completed_io_list)){
-               io = list_entry(EXT4_I(inode)->i_completed_io_list.next,
-                               ext4_io_end_t, list);
+       list_for_each_entry_safe(io, tmp,
+                       &EXT4_I(inode)->i_completed_io_list, list) {
+               if (io->flag == EXT4_IO_UNWRITTEN)
+                       continue;
               /*
                * Calling ext4_end_io_nolock() to convert completed
                * IO to written.
@@ -3828,6 +3844,7 @@ static void ext4_end_io_dio(struct kiocb

       io_end->offset = offset;
       io_end->size = size;
+       io_end->flag = EXT4_IO_WRITTEN;
       wq = EXT4_SB(io_end->inode->i_sb)->dio_unwritten_wq;

       /* queue the work to convert unwritten extents to written */
@@ -3839,6 +3856,46 @@ static void ext4_end_io_dio(struct kiocb
       iocb->private = NULL;
 }

+static void ext4_end_io_buffer_write(struct buffer_head *bh, int uptodate)
+{
+       ext4_io_end_t *io_end = bh->b_private;
+       struct workqueue_struct *wq;
+
+       if (!io_end)
+               goto out;
+       io_end->flag = EXT4_IO_WRITTEN;
+       wq = EXT4_SB(io_end->inode->i_sb)->dio_unwritten_wq;
+       /* queue the work to convert unwritten extents to written */
+       queue_work(wq, &io_end->work);
+out:
+       bh->b_private = NULL;
+       bh->b_end_io = NULL;
+       clear_buffer_uninit(bh);
+       end_buffer_async_write(bh, uptodate);
+}
+
+static int ext4_set_bh_endio(struct buffer_head *bh, struct inode *inode)
+{
+       ext4_io_end_t *io_end;
+       struct page *page = bh->b_page;
+       loff_t offset = (sector_t)page->index << PAGE_CACHE_SHIFT;
+       size_t size = bh->b_size;
+
+       io_end = ext4_init_io_end(inode);
+       if (!io_end)
+               return -ENOMEM;
+       io_end->offset = offset;
+       io_end->size = size;
+       io_end->flag = EXT4_IO_UNWRITTEN;
+       /* Add the io_end to per-inode completed io list*/
+       list_add_tail(&io_end->list,
+                &EXT4_I(io_end->inode)->i_completed_io_list);
+
+       bh->b_private = io_end;
+       bh->b_end_io = ext4_end_io_buffer_write;
+       return 0;
+}
+
 /*
 * For ext4 extent files, ext4 will do direct-io write to holes,
 * preallocated extents, and those write extend the file, no need to
Index: git-ext4/fs/ext4/fsync.c
===================================================================
--- git-ext4.orig/fs/ext4/fsync.c       2009-12-15 16:03:05.000000000 -0800
+++ git-ext4/fs/ext4/fsync.c    2009-12-15 16:03:15.000000000 -0800
@@ -101,6 +101,9 @@ int ext4_sync_file(struct file *file, st
               if (ret == 0)
                       ret = err;
       }
+       if (ret == 0)
+               flush_completed_IO(inode);
+       BUG_ON(!list_empty(&EXT4_I(inode)->i_completed_io_list));
 out:
       if (journal && (journal->j_flags & JBD2_BARRIER))
               blkdev_issue_flush(inode->i_sb->s_bdev, NULL);
