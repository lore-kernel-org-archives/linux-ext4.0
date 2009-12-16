From: Jiaying Zhang <jiayingz@google.com>
Subject: [RFC PATCH 1/4] ext4: DIO get_block code cleanup
Date: Tue, 15 Dec 2009 17:37:53 -0800
Message-ID: <5df78e1d0912151737v3be07575k638edf744e59ee2f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Michael Rubin <mrubin@google.com>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:43041 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934381AbZLPBh6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Dec 2009 20:37:58 -0500
Received: from wpaz13.hot.corp.google.com (wpaz13.hot.corp.google.com [172.24.198.77])
	by smtp-out.google.com with ESMTP id nBG1bvTx016373
	for <linux-ext4@vger.kernel.org>; Tue, 15 Dec 2009 17:37:57 -0800
Received: from pwi20 (pwi20.prod.google.com [10.241.219.20])
	by wpaz13.hot.corp.google.com with ESMTP id nBG1bsJF008809
	for <linux-ext4@vger.kernel.org>; Tue, 15 Dec 2009 17:37:55 -0800
Received: by pwi20 with SMTP id 20so317090pwi.9
        for <linux-ext4@vger.kernel.org>; Tue, 15 Dec 2009 17:37:54 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4: dio get_block code cleanup in prepare for it to be used by buffer write

Renaming the dio block allocation flags, variables and functions
introduced in Mingming's "Direct IO for holes and fallocate"
patches so that they can be used by ext4 buffer write as well.

Signed-off-by: Jiaying Zhang <jiayingz@google.com>
---
 fs/ext4/ext4.h    |   18 ++++----
 fs/ext4/extents.c |   24 +++++------
 fs/ext4/fsync.c   |    2
 fs/ext4/inode.c   |  112 ++++++++++++++++++++++++++----------------------------
 fs/ext4/super.c   |    2
 5 files changed, 78 insertions(+), 80 deletions(-)

Index: git-ext4/fs/ext4/extents.c
===================================================================
--- git-ext4.orig/fs/ext4/extents.c     2009-12-15 15:14:34.000000000 -0800
+++ git-ext4/fs/ext4/extents.c  2009-12-15 16:03:05.000000000 -0800
@@ -1603,7 +1603,7 @@ int ext4_ext_insert_extent(handle_t *han
       BUG_ON(path[depth].p_hdr == NULL);

       /* try to insert block into found extent and return */
-       if (ex && (flag != EXT4_GET_BLOCKS_DIO_CREATE_EXT)
+       if (ex && !(flag & EXT4_GET_BLOCKS_PRE_IO)
               && ext4_can_extents_be_merged(inode, ex, newext)) {
               ext_debug("append [%d]%d block to %d:[%d]%d (from %llu)\n",
                               ext4_ext_is_uninitialized(newext),
@@ -1724,7 +1724,7 @@ has_space:

 merge:
       /* try to merge extents to the right */
-       if (flag != EXT4_GET_BLOCKS_DIO_CREATE_EXT)
+       if (!(flag & EXT4_GET_BLOCKS_PRE_IO))
               ext4_ext_try_to_merge(inode, path, nearex);

       /* try to merge extents to the left */
@@ -2966,7 +2966,7 @@ fix_extent_len:
       ext4_ext_dirty(handle, inode, path + depth);
       return err;
 }
-static int ext4_convert_unwritten_extents_dio(handle_t *handle,
+static int ext4_convert_unwritten_extents_endio(handle_t *handle,
                                             struct inode *inode,
                                             struct ext4_ext_path *path)
 {
@@ -3038,8 +3038,8 @@ ext4_ext_handle_uninitialized_extents(ha
                 flags, allocated);
       ext4_ext_show_leaf(inode, path);

-       /* DIO get_block() before submit the IO, split the extent */
-       if (flags == EXT4_GET_BLOCKS_DIO_CREATE_EXT) {
+       /* get_block() before submit the IO, split the extent */
+       if ((flags & EXT4_GET_BLOCKS_PRE_IO)) {
               ret = ext4_split_unwritten_extents(handle,
                                               inode, path, iblock,
                                               max_blocks, flags);
@@ -3049,14 +3049,14 @@ ext4_ext_handle_uninitialized_extents(ha
                * completed
                */
               if (io)
-                       io->flag = DIO_AIO_UNWRITTEN;
+                       io->flag = EXT4_IO_UNWRITTEN;
               else
                       EXT4_I(inode)->i_state |= EXT4_STATE_DIO_UNWRITTEN;
               goto out;
       }
-       /* async DIO end_io complete, convert the filled extent to written */
-       if (flags == EXT4_GET_BLOCKS_DIO_CONVERT_EXT) {
-               ret = ext4_convert_unwritten_extents_dio(handle, inode,
+       /* IO end_io complete, convert the filled extent to written */
+       if ((flags & EXT4_GET_BLOCKS_CONVERT)) {
+               ret = ext4_convert_unwritten_extents_endio(handle, inode,
                                                       path);
               goto out2;
       }
@@ -3299,9 +3299,9 @@ int ext4_ext_get_blocks(handle_t *handle
                * For non asycn direct IO case, flag the inode state
                * that we need to perform convertion when IO is done.
                */
-               if (flags == EXT4_GET_BLOCKS_DIO_CREATE_EXT) {
+               if ((flags & EXT4_GET_BLOCKS_PRE_IO)) {
                       if (io)
-                               io->flag = DIO_AIO_UNWRITTEN;
+                               io->flag = EXT4_IO_UNWRITTEN;
                       else
                               EXT4_I(inode)->i_state |=
                                       EXT4_STATE_DIO_UNWRITTEN;;
@@ -3561,7 +3561,7 @@ int ext4_convert_unwritten_extents(struc
               map_bh.b_state = 0;
               ret = ext4_get_blocks(handle, inode, block,
                                     max_blocks, &map_bh,
-                                     EXT4_GET_BLOCKS_DIO_CONVERT_EXT);
+                                     EXT4_GET_BLOCKS_IO_CONVERT_EXT);
               if (ret <= 0) {
                       WARN_ON(ret <= 0);
                       printk(KERN_ERR "%s: ext4_ext_get_blocks "
Index: git-ext4/fs/ext4/ext4.h
===================================================================
--- git-ext4.orig/fs/ext4/ext4.h        2009-12-15 15:14:34.000000000 -0800
+++ git-ext4/fs/ext4/ext4.h     2009-12-15 16:03:05.000000000 -0800
@@ -133,7 +133,7 @@ struct mpage_da_data {
       int pages_written;
       int retval;
 };
-#define        DIO_AIO_UNWRITTEN       0x1
+#define        EXT4_IO_UNWRITTEN       0x1
 typedef struct ext4_io_end {
       struct list_head        list;           /* per-file finished AIO list */
       struct inode            *inode;         /* file being written to */
@@ -367,13 +367,13 @@ struct ext4_new_group_data {
       /* caller is from the direct IO path, request to creation of an
       unitialized extents if not allocated, split the uninitialized
       extent if blocks has been preallocated already*/
-#define EXT4_GET_BLOCKS_DIO                    0x0010
+#define EXT4_GET_BLOCKS_PRE_IO                 0x0010
 #define EXT4_GET_BLOCKS_CONVERT                        0x0020
-#define EXT4_GET_BLOCKS_DIO_CREATE_EXT         (EXT4_GET_BLOCKS_DIO|\
+#define EXT4_GET_BLOCKS_IO_CREATE_EXT          (EXT4_GET_BLOCKS_PRE_IO|\
+                                        EXT4_GET_BLOCKS_CREATE_UNINIT_EXT)
+       /* Convert extent to initialized after IO complete */
+#define EXT4_GET_BLOCKS_IO_CONVERT_EXT         (EXT4_GET_BLOCKS_CONVERT|\
                                        EXT4_GET_BLOCKS_CREATE_UNINIT_EXT)
-       /* Convert extent to initialized after direct IO complete */
-#define EXT4_GET_BLOCKS_DIO_CONVERT_EXT
(EXT4_GET_BLOCKS_CONVERT|\
-                                        EXT4_GET_BLOCKS_DIO_CREATE_EXT)

 /*
 * Flags used by ext4_free_blocks
@@ -707,8 +707,8 @@ struct ext4_inode_info {

       spinlock_t i_block_reservation_lock;

-       /* completed async DIOs that might need unwritten extents handling */
-       struct list_head i_aio_dio_complete_list;
+       /* completed IOs that might need unwritten extents handling */
+       struct list_head i_completed_io_list;
       /* current io_end structure for async DIO write*/
       ext4_io_end_t *cur_aio_dio;
 };
@@ -1432,7 +1432,7 @@ extern int ext4_block_truncate_page(hand
               struct address_space *mapping, loff_t from);
 extern int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf);
 extern qsize_t ext4_get_reserved_space(struct inode *inode);
-extern int flush_aio_dio_completed_IO(struct inode *inode);
+extern int flush_completed_IO(struct inode *inode);
 /* ioctl.c */
 extern long ext4_ioctl(struct file *, unsigned int, unsigned long);
 extern long ext4_compat_ioctl(struct file *, unsigned int, unsigned long);
Index: git-ext4/fs/ext4/super.c
===================================================================
--- git-ext4.orig/fs/ext4/super.c       2009-12-15 15:14:34.000000000 -0800
+++ git-ext4/fs/ext4/super.c    2009-12-15 16:03:05.000000000 -0800
@@ -711,7 +711,7 @@ static struct inode *ext4_alloc_inode(st
       ei->i_allocated_meta_blocks = 0;
       ei->i_delalloc_reserved_flag = 0;
       spin_lock_init(&(ei->i_block_reservation_lock));
-       INIT_LIST_HEAD(&ei->i_aio_dio_complete_list);
+       INIT_LIST_HEAD(&ei->i_completed_io_list);
       ei->cur_aio_dio = NULL;

       return &ei->vfs_inode;
Index: git-ext4/fs/ext4/fsync.c
===================================================================
--- git-ext4.orig/fs/ext4/fsync.c       2009-12-15 15:14:34.000000000 -0800
+++ git-ext4/fs/ext4/fsync.c    2009-12-15 16:03:05.000000000 -0800
@@ -58,7 +58,7 @@ int ext4_sync_file(struct file *file, st

       trace_ext4_sync_file(file, dentry, datasync);

-       ret = flush_aio_dio_completed_IO(inode);
+       ret = flush_completed_IO(inode);
       if (ret < 0)
               return ret;
       /*
Index: git-ext4/fs/ext4/inode.c
===================================================================
--- git-ext4.orig/fs/ext4/inode.c       2009-12-15 15:14:34.000000000 -0800
+++ git-ext4/fs/ext4/inode.c    2009-12-15 16:03:05.000000000 -0800
@@ -3606,52 +3606,44 @@ out:
       return ret;
 }

-static int ext4_get_block_dio_write(struct inode *inode, sector_t iblock,
+static int ext4_get_block_write(struct inode *inode, sector_t iblock,
                  struct buffer_head *bh_result, int create)
 {
-       handle_t *handle = NULL;
+       handle_t *handle = ext4_journal_current_handle();
       int ret = 0;
       unsigned max_blocks = bh_result->b_size >> inode->i_blkbits;
       int dio_credits;
+       int started = 0;

-       ext4_debug("ext4_get_block_dio_write: inode %lu, create flag %d\n",
+       ext4_debug("ext4_get_block_write: inode %lu, create flag %d\n",
                  inode->i_ino, create);
       /*
-        * DIO VFS code passes create = 0 flag for write to
-        * the middle of file. It does this to avoid block
-        * allocation for holes, to prevent expose stale data
-        * out when there is parallel buffered read (which does
-        * not hold the i_mutex lock) while direct IO write has
-        * not completed. DIO request on holes finally falls back
-        * to buffered IO for this reason.
-        *
-        * For ext4 extent based file, since we support fallocate,
-        * new allocated extent as uninitialized, for holes, we
-        * could fallocate blocks for holes, thus parallel
-        * buffered IO read will zero out the page when read on
-        * a hole while parallel DIO write to the hole has not completed.
-        *
-        * when we come here, we know it's a direct IO write to
-        * to the middle of file (<i_size)
-        * so it's safe to override the create flag from VFS.
-        */
-       create = EXT4_GET_BLOCKS_DIO_CREATE_EXT;
-
-       if (max_blocks > DIO_MAX_BLOCKS)
-               max_blocks = DIO_MAX_BLOCKS;
-       dio_credits = ext4_chunk_trans_blocks(inode, max_blocks);
-       handle = ext4_journal_start(inode, dio_credits);
-       if (IS_ERR(handle)) {
-               ret = PTR_ERR(handle);
-               goto out;
+        * ext4_get_block in prepare for a DIO write or buffer write.
+        * We allocate an uinitialized extent if blocks haven't been allocated.
+        * The extent will be converted to initialized after IO complete.
+        */
+       create = EXT4_GET_BLOCKS_IO_CREATE_EXT;
+
+       if (!handle) {
+               if (max_blocks > DIO_MAX_BLOCKS)
+                       max_blocks = DIO_MAX_BLOCKS;
+               dio_credits = ext4_chunk_trans_blocks(inode, max_blocks);
+               handle = ext4_journal_start(inode, dio_credits);
+               if (IS_ERR(handle)) {
+                       ret = PTR_ERR(handle);
+                       goto out;
+               }
+               started = 1;
       }
+
       ret = ext4_get_blocks(handle, inode, iblock, max_blocks, bh_result,
                             create);
       if (ret > 0) {
               bh_result->b_size = (ret << inode->i_blkbits);
               ret = 0;
       }
-       ext4_journal_stop(handle);
+       if (started)
+               ext4_journal_stop(handle);
 out:
       return ret;
 }
@@ -3662,19 +3654,20 @@ static void ext4_free_io_end(ext4_io_end
       iput(io->inode);
       kfree(io);
 }
-static void dump_aio_dio_list(struct inode * inode)
+
+static void dump_completed_IO(struct inode * inode)
 {
 #ifdef EXT4_DEBUG
       struct list_head *cur, *before, *after;
       ext4_io_end_t *io, *io0, *io1;

-       if (list_empty(&EXT4_I(inode)->i_aio_dio_complete_list)){
-               ext4_debug("inode %lu aio dio list is empty\n", inode->i_ino);
+       if (list_empty(&EXT4_I(inode)->i_completed_io_list)){
+               ext4_debug("inode %lu completed_io list is empty\n",
inode->i_ino);
               return;
       }

-       ext4_debug("Dump inode %lu aio_dio_completed_IO list \n", inode->i_ino);
-       list_for_each_entry(io, &EXT4_I(inode)->i_aio_dio_complete_list, list){
+       ext4_debug("Dump inode %lu completed_io list \n", inode->i_ino);
+       list_for_each_entry(io, &EXT4_I(inode)->i_completed_io_list, list){
               cur = &io->list;
               before = cur->prev;
               io0 = container_of(before, ext4_io_end_t, list);
@@ -3690,21 +3683,21 @@ static void dump_aio_dio_list(struct ino
 /*
 * check a range of space and convert unwritten extents to written.
 */
-static int ext4_end_aio_dio_nolock(ext4_io_end_t *io)
+static int ext4_end_io_nolock(ext4_io_end_t *io)
 {
       struct inode *inode = io->inode;
       loff_t offset = io->offset;
       size_t size = io->size;
       int ret = 0;

-       ext4_debug("end_aio_dio_onlock: io 0x%p from inode %lu,list->next 0x%p,"
+       ext4_debug("ext4_end_io_nolock: io 0x%p from inode %lu,list->next 0x%p,"
                  "list->prev 0x%p\n",
                  io, inode->i_ino, io->list.next, io->list.prev);

       if (list_empty(&io->list))
               return ret;

-       if (io->flag != DIO_AIO_UNWRITTEN)
+       if (io->flag != EXT4_IO_UNWRITTEN)
               return ret;

       if (offset + size <= i_size_read(inode))
@@ -3722,17 +3715,18 @@ static int ext4_end_aio_dio_nolock(ext4_
       io->flag = 0;
       return ret;
 }
+
 /*
 * work on completed aio dio IO, to convert unwritten extents to extents
 */
-static void ext4_end_aio_dio_work(struct work_struct *work)
+static void ext4_end_io_work(struct work_struct *work)
 {
       ext4_io_end_t *io  = container_of(work, ext4_io_end_t, work);
       struct inode *inode = io->inode;
       int ret = 0;

       mutex_lock(&inode->i_mutex);
-       ret = ext4_end_aio_dio_nolock(io);
+       ret = ext4_end_io_nolock(io);
       if (ret >= 0) {
               if (!list_empty(&io->list))
                       list_del_init(&io->list);
@@ -3740,32 +3734,35 @@ static void ext4_end_aio_dio_work(struct
       }
       mutex_unlock(&inode->i_mutex);
 }
+
 /*
 * This function is called from ext4_sync_file().
 *
- * When AIO DIO IO is completed, the work to convert unwritten
- * extents to written is queued on workqueue but may not get immediately
+ * When IO is completed, the work to convert unwritten extents to
+ * written is queued on workqueue but may not get immediately
 * scheduled. When fsync is called, we need to ensure the
 * conversion is complete before fsync returns.
- * The inode keeps track of a list of completed AIO from DIO path
- * that might needs to do the conversion. This function walks through
- * the list and convert the related unwritten extents to written.
+ * The inode keeps track of a list of pending/completed IO that
+ * might needs to do the conversion. This function walks through
+ * the list and convert the related unwritten extents for completed IO
+ * to written.
+ * The function return the number of pending IOs on success.
 */
-int flush_aio_dio_completed_IO(struct inode *inode)
+int flush_completed_IO(struct inode *inode)
 {
       ext4_io_end_t *io;
       int ret = 0;
       int ret2 = 0;

-       if (list_empty(&EXT4_I(inode)->i_aio_dio_complete_list))
+       if (list_empty(&EXT4_I(inode)->i_completed_io_list))
               return ret;

-       dump_aio_dio_list(inode);
-       while (!list_empty(&EXT4_I(inode)->i_aio_dio_complete_list)){
-               io = list_entry(EXT4_I(inode)->i_aio_dio_complete_list.next,
+       dump_completed_IO(inode);
+       while (!list_empty(&EXT4_I(inode)->i_completed_io_list)){
+               io = list_entry(EXT4_I(inode)->i_completed_io_list.next,
                               ext4_io_end_t, list);
               /*
-                * Calling ext4_end_aio_dio_nolock() to convert completed
+                * Calling ext4_end_io_nolock() to convert completed
                * IO to written.
                *
                * When ext4_sync_file() is called, run_queue() may already
@@ -3778,7 +3775,7 @@ int flush_aio_dio_completed_IO(struct in
                * avoid double converting from both fsync and background work
                * queue work.
                */
-               ret = ext4_end_aio_dio_nolock(io);
+               ret = ext4_end_io_nolock(io);
               if (ret < 0)
                       ret2 = ret;
               else
@@ -3800,7 +3797,7 @@ static ext4_io_end_t *ext4_init_io_end (
               io->offset = 0;
               io->size = 0;
               io->error = 0;
-               INIT_WORK(&io->work, ext4_end_aio_dio_work);
+               INIT_WORK(&io->work, ext4_end_io_work);
               INIT_LIST_HEAD(&io->list);
       }

@@ -3823,7 +3820,7 @@ static void ext4_end_io_dio(struct kiocb
                 size);

       /* if not aio dio with unwritten extents, just free io and return */
-       if (io_end->flag != DIO_AIO_UNWRITTEN){
+       if (io_end->flag != EXT4_IO_UNWRITTEN){
               ext4_free_io_end(io_end);
               iocb->private = NULL;
               return;
@@ -3838,9 +3835,10 @@ static void ext4_end_io_dio(struct kiocb

       /* Add the io_end to per-inode completed aio dio list*/
       list_add_tail(&io_end->list,
-                &EXT4_I(io_end->inode)->i_aio_dio_complete_list);
+                &EXT4_I(io_end->inode)->i_completed_io_list);
       iocb->private = NULL;
 }
+
 /*
 * For ext4 extent files, ext4 will do direct-io write to holes,
 * preallocated extents, and those write extend the file, no need to
@@ -3910,7 +3908,7 @@ static ssize_t ext4_ext_direct_IO(int rw
               ret = blockdev_direct_IO(rw, iocb, inode,
                                        inode->i_sb->s_bdev, iov,
                                        offset, nr_segs,
-                                        ext4_get_block_dio_write,
+                                        ext4_get_block_write,
                                        ext4_end_io_dio);
               if (iocb->private)
                       EXT4_I(inode)->cur_aio_dio = NULL;
