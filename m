From: Jiaying Zhang <jiayingz@google.com>
Subject: [RFC PATCH 4/4] ext4: ext4_get_block_write and io_end code cleanup
Date: Tue, 15 Dec 2009 17:41:38 -0800
Message-ID: <5df78e1d0912151741x34700b18sa9f3fc8f66d69181@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Michael Rubin <mrubin@google.com>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:44789 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333AbZLPBlt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Dec 2009 20:41:49 -0500
Received: from wpaz33.hot.corp.google.com (wpaz33.hot.corp.google.com [172.24.198.97])
	by smtp-out.google.com with ESMTP id nBG1fgen012574
	for <linux-ext4@vger.kernel.org>; Wed, 16 Dec 2009 01:41:46 GMT
Received: from pzk38 (pzk38.prod.google.com [10.243.19.166])
	by wpaz33.hot.corp.google.com with ESMTP id nBG1fdYR004044
	for <linux-ext4@vger.kernel.org>; Tue, 15 Dec 2009 17:41:39 -0800
Received: by pzk38 with SMTP id 38so347484pzk.9
        for <linux-ext4@vger.kernel.org>; Tue, 15 Dec 2009 17:41:38 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4: ext4_get_block_write and io_end code cleanup

Move ext4_get_block_write and io_end related code forward to get rid
of function declearation.

Signed-off-by: Jiaying Zhang <jiayingz@google.com>
---
 fs/ext4/inode.c | 2179 +++++++++++++++++++++++++++-----------------------------
 1 file changed, 1087 insertions(+), 1092 deletions(-)

Index: git-ext4/fs/ext4/inode.c
===================================================================
--- git-ext4.orig/fs/ext4/inode.c       2009-12-15 16:59:06.000000000 -0800
+++ git-ext4/fs/ext4/inode.c    2009-12-15 17:02:13.000000000 -0800
@@ -1493,7 +1493,47 @@ static int do_journal_get_write_access(h
 }

 static int ext4_get_block_write(struct inode *inode, sector_t iblock,
-                  struct buffer_head *bh_result, int create);
+                  struct buffer_head *bh_result, int create)
+{
+       handle_t *handle = ext4_journal_current_handle();
+       int ret = 0;
+       unsigned max_blocks = bh_result->b_size >> inode->i_blkbits;
+       int dio_credits;
+       int started = 0;
+
+       ext4_debug("ext4_get_block_write: inode %lu, create flag %d\n",
+                  inode->i_ino, create);
+       /*
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
+       }
+
+       ret = ext4_get_blocks(handle, inode, iblock, max_blocks, bh_result,
+                             create);
+       if (ret > 0) {
+               bh_result->b_size = (ret << inode->i_blkbits);
+               ret = 0;
+       }
+       if (started)
+               ext4_journal_stop(handle);
+out:
+       return ret;
+}
+
 static int ext4_write_begin(struct file *file, struct address_space *mapping,
                           loff_t pos, unsigned len, unsigned flags,
                           struct page **pagep, void **fsdata)
@@ -2607,746 +2647,497 @@ out:
       return ret;
 }

-static int ext4_set_bh_endio(struct buffer_head *bh, struct inode *inode);
-static void ext4_end_io_buffer_write(struct buffer_head *bh, int uptodate);
+static void ext4_free_io_end(ext4_io_end_t *io)
+{
+       BUG_ON(!io);
+       iput(io->inode);
+       kfree(io);
+}
+
+static void dump_completed_IO(struct inode * inode)
+{
+#ifdef EXT4_DEBUG
+       struct list_head *cur, *before, *after;
+       ext4_io_end_t *io, *io0, *io1;
+
+       if (list_empty(&EXT4_I(inode)->i_completed_io_list)){
+               ext4_debug("inode %lu completed_io list is empty\n",
inode->i_ino);
+               return;
+       }
+
+       ext4_debug("Dump inode %lu completed_io list \n", inode->i_ino);
+       list_for_each_entry(io, &EXT4_I(inode)->i_completed_io_list, list){
+               cur = &io->list;
+               before = cur->prev;
+               io0 = container_of(before, ext4_io_end_t, list);
+               after = cur->next;
+               io1 = container_of(after, ext4_io_end_t, list);
+
+               ext4_debug("io 0x%p from inode %lu,prev 0x%p,next 0x%p\n",
+                           io, inode->i_ino, io0, io1);
+       }
+#endif
+}

 /*
- * Note that we don't need to start a transaction unless we're journaling data
- * because we should have holes filled from ext4_page_mkwrite(). We even don't
- * need to file the inode to the transaction's list in ordered mode because if
- * we are writing back data added by write(), the inode is already there and if
- * we are writing back data modified via mmap(), noone guarantees in which
- * transaction the data will hit the disk. In case we are journaling data, we
- * cannot start transaction directly because transaction start ranks above page
- * lock so we have to do some magic.
- *
- * This function can get called via...
- *   - ext4_da_writepages after taking page lock (have journal handle)
- *   - journal_submit_inode_data_buffers (no journal handle)
- *   - shrink_page_list via pdflush (no journal handle)
- *   - grab_page_cache when doing write_begin (have journal handle)
- *
- * We don't do any block allocation in this function. If we have page with
- * multiple blocks we need to write those buffer_heads that are mapped. This
- * is important for mmaped based write. So if we do with blocksize 1K
- * truncate(f, 1024);
- * a = mmap(f, 0, 4096);
- * a[0] = 'a';
- * truncate(f, 4096);
- * we have in the page first buffer_head mapped via page_mkwrite call back
- * but other bufer_heads would be unmapped but dirty(dirty done via the
- * do_wp_page). So writepage should write the first block. If we modify
- * the mmap area beyond 1024 we will again get a page_fault and the
- * page_mkwrite callback will do the block allocation and mark the
- * buffer_heads mapped.
- *
- * We redirty the page if we have any buffer_heads that is either delay or
- * unwritten in the page.
- *
- * We can get recursively called as show below.
- *
- *     ext4_writepage() -> kmalloc() -> __alloc_pages() -> page_launder() ->
- *             ext4_writepage()
- *
- * But since we don't do any block allocation we should not deadlock.
- * Page also have the dirty flag cleared so we don't get recurive page_lock.
+ * check a range of space and convert unwritten extents to written.
 */
-static int ext4_writepage(struct page *page,
-                         struct writeback_control *wbc)
+static int ext4_end_io_nolock(ext4_io_end_t *io)
 {
+       struct inode *inode = io->inode;
+       loff_t offset = io->offset;
+       size_t size = io->size;
       int ret = 0;
-       loff_t size;
-       unsigned int len;
-       struct buffer_head *page_bufs = NULL;
-       struct inode *inode = page->mapping->host;

-       trace_ext4_writepage(inode, page);
-       size = i_size_read(inode);
-       if (page->index == size >> PAGE_CACHE_SHIFT)
-               len = size & ~PAGE_CACHE_MASK;
-       else
-               len = PAGE_CACHE_SIZE;
+       ext4_debug("ext4_end_io_nolock: io 0x%p from inode %lu,list->next 0x%p,"
+                  "list->prev 0x%p\n",
+                  io, inode->i_ino, io->list.next, io->list.prev);

-       if (page_has_buffers(page)) {
-               page_bufs = page_buffers(page);
-               if (walk_page_buffers(NULL, page_bufs, 0, len, NULL,
-                                       ext4_bh_delay_or_unwritten)) {
-                       /*
-                        * We don't want to do  block allocation
-                        * So redirty the page and return
-                        * We may reach here when we do a journal commit
-                        * via journal_submit_inode_data_buffers.
-                        * If we don't have mapping block we just ignore
-                        * them. We can also reach here via shrink_page_list
-                        */
-                       redirty_page_for_writepage(wbc, page);
-                       unlock_page(page);
-                       return 0;
-               }
-       } else {
-               /*
-                * The test for page_has_buffers() is subtle:
-                * We know the page is dirty but it lost buffers. That means
-                * that at some moment in time after write_begin()/write_end()
-                * has been called all buffers have been clean and thus they
-                * must have been written at least once. So they are all
-                * mapped and we can happily proceed with mapping them
-                * and writing the page.
-                *
-                * Try to initialize the buffer_heads and check whether
-                * all are mapped and non delay. We don't want to
-                * do block allocation here.
-                */
-               ret = block_prepare_write(page, 0, len,
-                                         noalloc_get_block_write);
-               if (!ret) {
-                       page_bufs = page_buffers(page);
-                       /* check whether all are mapped and non delay */
-                       if (walk_page_buffers(NULL, page_bufs, 0, len, NULL,
-                                               ext4_bh_delay_or_unwritten)) {
-                               redirty_page_for_writepage(wbc, page);
-                               unlock_page(page);
-                               return 0;
-                       }
-               } else {
-                       /*
-                        * We can't do block allocation here
-                        * so just redity the page and unlock
-                        * and return
-                        */
-                       redirty_page_for_writepage(wbc, page);
-                       unlock_page(page);
-                       return 0;
-               }
-               /* now mark the buffer_heads as dirty and uptodate */
-               block_commit_write(page, 0, len);
-       }
+       if (list_empty(&io->list))
+               return ret;

-       if (PageChecked(page) && ext4_should_journal_data(inode)) {
-               /*
-                * It's mmapped pagecache.  Add buffers and journal it.  There
-                * doesn't seem much point in redirtying the page here.
-                */
-               ClearPageChecked(page);
-               return __ext4_journalled_writepage(page, len);
-       }
+       if (io->flag != EXT4_IO_WRITTEN)
+               return ret;

-       if (test_opt(inode->i_sb, NOBH) && ext4_should_writeback_data(inode))
-               ret = nobh_writepage(page, noalloc_get_block_write, wbc);
-       else if (page_bufs && buffer_uninit(page_bufs)) {
-               ext4_set_bh_endio(page_bufs, inode);
-               ret = block_write_full_page_endio(page, noalloc_get_block_write,
-                                           wbc, ext4_end_io_buffer_write);
-       } else
-               ret = block_write_full_page(page, noalloc_get_block_write,
-                                           wbc);
+       ret = ext4_convert_unwritten_extents(inode, offset, size);
+       if (ret < 0) {
+               printk(KERN_EMERG "%s: failed to convert unwritten"
+                       "extents to written extents, error is %d"
+                       " io is still on inode %lu aio dio list\n",
+                       __func__, ret, inode->i_ino);
+               return ret;
+       }

+       /* clear the DIO AIO unwritten flag */
+       io->flag = 0;
       return ret;
 }

 /*
- * This is called via ext4_da_writepages() to
- * calulate the total number of credits to reserve to fit
- * a single extent allocation into a single transaction,
- * ext4_da_writpeages() will loop calling this before
- * the block allocation.
+ * work on completed aio dio IO, to convert unwritten extents to extents
 */
-
-static int ext4_da_writepages_trans_blocks(struct inode *inode)
+static void ext4_end_io_work(struct work_struct *work)
 {
-       int max_blocks = EXT4_I(inode)->i_reserved_data_blocks;
-
-       /*
-        * With non-extent format the journal credit needed to
-        * insert nrblocks contiguous block is dependent on
-        * number of contiguous block. So we will limit
-        * number of contiguous block to a sane value
-        */
-       if (!(EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL) &&
-           (max_blocks > EXT4_MAX_TRANS_DATA))
-               max_blocks = EXT4_MAX_TRANS_DATA;
+       ext4_io_end_t *io  = container_of(work, ext4_io_end_t, work);
+       struct inode *inode = io->inode;
+       int ret = 0;

-       return ext4_chunk_trans_blocks(inode, max_blocks);
+       mutex_lock(&inode->i_mutex);
+       ret = ext4_end_io_nolock(io);
+       if (ret >= 0) {
+               if (!list_empty(&io->list))
+                       list_del_init(&io->list);
+               ext4_free_io_end(io);
+       }
+       mutex_unlock(&inode->i_mutex);
 }

-static int ext4_da_writepages(struct address_space *mapping,
-                             struct writeback_control *wbc)
-{
-       pgoff_t index;
-       int range_whole = 0;
-       handle_t *handle = NULL;
-       struct mpage_da_data mpd;
-       struct inode *inode = mapping->host;
-       int no_nrwrite_index_update;
-       int pages_written = 0;
-       long pages_skipped;
-       unsigned int max_pages;
-       int range_cyclic, cycled = 1, io_done = 0;
-       int needed_blocks, ret = 0;
-       long desired_nr_to_write, nr_to_writebump = 0;
-       loff_t range_start = wbc->range_start;
-       struct ext4_sb_info *sbi = EXT4_SB(mapping->host->i_sb);
-
-       trace_ext4_da_writepages(inode, wbc);
-
-       /*
-        * No pages to write? This is mainly a kludge to avoid starting
-        * a transaction for special inodes like journal inode on last iput()
-        * because that could violate lock ordering on umount
-        */
-       if (!mapping->nrpages || !mapping_tagged(mapping, PAGECACHE_TAG_DIRTY))
-               return 0;
-
-       /*
-        * If the filesystem has aborted, it is read-only, so return
-        * right away instead of dumping stack traces later on that
-        * will obscure the real source of the problem.  We test
-        * EXT4_MF_FS_ABORTED instead of sb->s_flag's MS_RDONLY because
-        * the latter could be true if the filesystem is mounted
-        * read-only, and in that case, ext4_da_writepages should
-        * *never* be called, so if that ever happens, we would want
-        * the stack trace.
-        */
-       if (unlikely(sbi->s_mount_flags & EXT4_MF_FS_ABORTED))
-               return -EROFS;
-
-       if (wbc->range_start == 0 && wbc->range_end == LLONG_MAX)
-               range_whole = 1;
-
-       range_cyclic = wbc->range_cyclic;
-       if (wbc->range_cyclic) {
-               index = mapping->writeback_index;
-               if (index)
-                       cycled = 0;
-               wbc->range_start = index << PAGE_CACHE_SHIFT;
-               wbc->range_end  = LLONG_MAX;
-               wbc->range_cyclic = 0;
-       } else
-               index = wbc->range_start >> PAGE_CACHE_SHIFT;
-
-       /*
-        * This works around two forms of stupidity.  The first is in
-        * the writeback code, which caps the maximum number of pages
-        * written to be 1024 pages.  This is wrong on multiple
-        * levels; different architectues have a different page size,
-        * which changes the maximum amount of data which gets
-        * written.  Secondly, 4 megabytes is way too small.  XFS
-        * forces this value to be 16 megabytes by multiplying
-        * nr_to_write parameter by four, and then relies on its
-        * allocator to allocate larger extents to make them
-        * contiguous.  Unfortunately this brings us to the second
-        * stupidity, which is that ext4's mballoc code only allocates
-        * at most 2048 blocks.  So we force contiguous writes up to
-        * the number of dirty blocks in the inode, or
-        * sbi->max_writeback_mb_bump whichever is smaller.
-        */
-       max_pages = sbi->s_max_writeback_mb_bump << (20 - PAGE_CACHE_SHIFT);
-       if (!range_cyclic && range_whole)
-               desired_nr_to_write = wbc->nr_to_write * 8;
-       else
-               desired_nr_to_write = ext4_num_dirty_pages(inode, index,
-                                                          max_pages);
-       if (desired_nr_to_write > max_pages)
-               desired_nr_to_write = max_pages;
-
-       if (wbc->nr_to_write < desired_nr_to_write) {
-               nr_to_writebump = desired_nr_to_write - wbc->nr_to_write;
-               wbc->nr_to_write = desired_nr_to_write;
-       }
-
-       mpd.wbc = wbc;
-       mpd.inode = mapping->host;
-
-       /*
-        * we don't want write_cache_pages to update
-        * nr_to_write and writeback_index
-        */
-       no_nrwrite_index_update = wbc->no_nrwrite_index_update;
-       wbc->no_nrwrite_index_update = 1;
-       pages_skipped = wbc->pages_skipped;
-
-retry:
-       while (!ret && wbc->nr_to_write > 0) {
-
-               /*
-                * we  insert one extent at a time. So we need
-                * credit needed for single extent allocation.
-                * journalled mode is currently not supported
-                * by delalloc
-                */
-               BUG_ON(ext4_should_journal_data(inode));
-               needed_blocks = ext4_da_writepages_trans_blocks(inode);
-
-               /* start a new transaction*/
-               handle = ext4_journal_start(inode, needed_blocks);
-               if (IS_ERR(handle)) {
-                       ret = PTR_ERR(handle);
-                       ext4_msg(inode->i_sb, KERN_CRIT, "%s: jbd2_start: "
-                              "%ld pages, ino %lu; err %d\n", __func__,
-                               wbc->nr_to_write, inode->i_ino, ret);
-                       goto out_writepages;
-               }
-
-               /*
-                * Now call __mpage_da_writepage to find the next
-                * contiguous region of logical blocks that need
-                * blocks to be allocated by ext4.  We don't actually
-                * submit the blocks for I/O here, even though
-                * write_cache_pages thinks it will, and will set the
-                * pages as clean for write before calling
-                * __mpage_da_writepage().
-                */
-               mpd.b_size = 0;
-               mpd.b_state = 0;
-               mpd.b_blocknr = 0;
-               mpd.first_page = 0;
-               mpd.next_page = 0;
-               mpd.io_done = 0;
-               mpd.pages_written = 0;
-               mpd.retval = 0;
-               ret = write_cache_pages(mapping, wbc, __mpage_da_writepage,
-                                       &mpd);
-               /*
-                * If we have a contigous extent of pages and we
-                * haven't done the I/O yet, map the blocks and submit
-                * them for I/O.
-                */
-               if (!mpd.io_done && mpd.next_page != mpd.first_page) {
-                       if (mpage_da_map_blocks(&mpd) == 0)
-                               mpage_da_submit_io(&mpd);
-                       mpd.io_done = 1;
-                       ret = MPAGE_DA_EXTENT_TAIL;
-               }
-               trace_ext4_da_write_pages(inode, &mpd);
-               wbc->nr_to_write -= mpd.pages_written;
-
-               ext4_journal_stop(handle);
-
-               if ((mpd.retval == -ENOSPC) && sbi->s_journal) {
-                       /* commit the transaction which would
-                        * free blocks released in the transaction
-                        * and try again
-                        */
-                       jbd2_journal_force_commit_nested(sbi->s_journal);
-                       wbc->pages_skipped = pages_skipped;
-                       ret = 0;
-               } else if (ret == MPAGE_DA_EXTENT_TAIL) {
-                       /*
-                        * got one extent now try with
-                        * rest of the pages
-                        */
-                       pages_written += mpd.pages_written;
-                       wbc->pages_skipped = pages_skipped;
-                       ret = 0;
-                       io_done = 1;
-               } else if (wbc->nr_to_write)
-                       /*
-                        * There is no more writeout needed
-                        * or we requested for a noblocking writeout
-                        * and we found the device congested
-                        */
-                       break;
-       }
-       if (!io_done && !cycled) {
-               cycled = 1;
-               index = 0;
-               wbc->range_start = index << PAGE_CACHE_SHIFT;
-               wbc->range_end  = mapping->writeback_index - 1;
-               goto retry;
-       }
-       if (pages_skipped != wbc->pages_skipped)
-               ext4_msg(inode->i_sb, KERN_CRIT,
-                        "This should not happen leaving %s "
-                        "with nr_to_write = %ld ret = %d\n",
-                        __func__, wbc->nr_to_write, ret);
-
-       /* Update index */
-       index += pages_written;
-       wbc->range_cyclic = range_cyclic;
-       if (wbc->range_cyclic || (range_whole && wbc->nr_to_write > 0))
-               /*
-                * set the writeback_index so that range_cyclic
-                * mode will write it back later
-                */
-               mapping->writeback_index = index;
-
-out_writepages:
-       if (!no_nrwrite_index_update)
-               wbc->no_nrwrite_index_update = 0;
-       if (wbc->nr_to_write > nr_to_writebump)
-               wbc->nr_to_write -= nr_to_writebump;
-       wbc->range_start = range_start;
-       trace_ext4_da_writepages_result(inode, wbc, ret, pages_written);
-       return ret;
-}
-
-#define FALL_BACK_TO_NONDELALLOC 1
-static int ext4_nonda_switch(struct super_block *sb)
-{
-       s64 free_blocks, dirty_blocks;
-       struct ext4_sb_info *sbi = EXT4_SB(sb);
-
-       /*
-        * switch to non delalloc mode if we are running low
-        * on free block. The free block accounting via percpu
-        * counters can get slightly wrong with percpu_counter_batch getting
-        * accumulated on each CPU without updating global counters
-        * Delalloc need an accurate free block accounting. So switch
-        * to non delalloc when we are near to error range.
-        */
-       free_blocks  = percpu_counter_read_positive(&sbi->s_freeblocks_counter);
-       dirty_blocks =
percpu_counter_read_positive(&sbi->s_dirtyblocks_counter);
-       if (2 * free_blocks < 3 * dirty_blocks ||
-               free_blocks < (dirty_blocks + EXT4_FREEBLOCKS_WATERMARK)) {
-               /*
-                * free block count is less that 150% of dirty blocks
-                * or free blocks is less that watermark
-                */
-               return 1;
-       }
-       return 0;
-}
-
-static int ext4_da_write_begin(struct file *file, struct
address_space *mapping,
-                              loff_t pos, unsigned len, unsigned flags,
-                              struct page **pagep, void **fsdata)
+/*
+ * This function is called from ext4_sync_file().
+ *
+ * When IO is completed, the work to convert unwritten extents to
+ * written is queued on workqueue but may not get immediately
+ * scheduled. When fsync is called, we need to ensure the
+ * conversion is complete before fsync returns.
+ * The inode keeps track of a list of pending/completed IO that
+ * might needs to do the conversion. This function walks through
+ * the list and convert the related unwritten extents for completed IO
+ * to written.
+ * The function return the number of pending IOs on success.
+ */
+int flush_completed_IO(struct inode *inode)
 {
-       int ret, retries = 0;
-       struct page *page;
-       pgoff_t index;
-       unsigned from, to;
-       struct inode *inode = mapping->host;
-       handle_t *handle;
-
-       index = pos >> PAGE_CACHE_SHIFT;
-       from = pos & (PAGE_CACHE_SIZE - 1);
-       to = from + len;
-
-       if (ext4_nonda_switch(inode->i_sb)) {
-               *fsdata = (void *)FALL_BACK_TO_NONDELALLOC;
-               return ext4_write_begin(file, mapping, pos,
-                                       len, flags, pagep, fsdata);
-       }
-       *fsdata = (void *)0;
-       trace_ext4_da_write_begin(inode, pos, len, flags);
-retry:
-       /*
-        * With delayed allocation, we don't log the i_disksize update
-        * if there is delayed block allocation. But we still need
-        * to journalling the i_disksize update if writes to the end
-        * of file which has an already mapped buffer.
-        */
-       handle = ext4_journal_start(inode, 1);
-       if (IS_ERR(handle)) {
-               ret = PTR_ERR(handle);
-               goto out;
-       }
-       /* We cannot recurse into the filesystem as the transaction is already
-        * started */
-       flags |= AOP_FLAG_NOFS;
+       ext4_io_end_t *io, *tmp;
+       int ret = 0;
+       int ret2 = 0;

-       page = grab_cache_page_write_begin(mapping, index, flags);
-       if (!page) {
-               ext4_journal_stop(handle);
-               ret = -ENOMEM;
-               goto out;
-       }
-       *pagep = page;
+       if (list_empty(&EXT4_I(inode)->i_completed_io_list))
+               return ret;

-       ret = block_write_begin(file, mapping, pos, len, flags, pagep, fsdata,
-                               ext4_da_get_block_prep);
-       if (ret < 0) {
-               unlock_page(page);
-               ext4_journal_stop(handle);
-               page_cache_release(page);
+       dump_completed_IO(inode);
+       list_for_each_entry_safe(io, tmp,
+                       &EXT4_I(inode)->i_completed_io_list, list) {
+               if (io->flag == EXT4_IO_UNWRITTEN)
+                       continue;
               /*
-                * block_write_begin may have instantiated a few blocks
-                * outside i_size.  Trim these off again. Don't need
-                * i_size_read because we hold i_mutex.
+                * Calling ext4_end_io_nolock() to convert completed
+                * IO to written.
+                *
+                * When ext4_sync_file() is called, run_queue() may already
+                * about to flush the work corresponding to this io structure.
+                * It will be upset if it founds the io structure related
+                * to the work-to-be schedule is freed.
+                *
+                * Thus we need to keep the io structure still valid here after
+                * convertion finished. The io structure has a flag to
+                * avoid double converting from both fsync and background work
+                * queue work.
                */
-               if (pos + len > inode->i_size)
-                       ext4_truncate(inode);
+               ret = ext4_end_io_nolock(io);
+               if (ret < 0)
+                       ret2 = ret;
+               else
+                       list_del_init(&io->list);
       }
-
-       if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
-               goto retry;
-out:
-       return ret;
+       return (ret2 < 0) ? ret2 : 0;
 }

-/*
- * Check if we should update i_disksize
- * when write to the end of file but not require block allocation
- */
-static int ext4_da_should_update_i_disksize(struct page *page,
-                                           unsigned long offset)
+static ext4_io_end_t *ext4_init_io_end (struct inode *inode)
 {
-       struct buffer_head *bh;
-       struct inode *inode = page->mapping->host;
-       unsigned int idx;
-       int i;
-
-       bh = page_buffers(page);
-       idx = offset >> inode->i_blkbits;
-
-       for (i = 0; i < idx; i++)
-               bh = bh->b_this_page;
-
-       if (!buffer_mapped(bh) || (buffer_delay(bh)) || buffer_unwritten(bh))
-               return 0;
-       return 1;
-}
+       ext4_io_end_t *io = NULL;

-static int ext4_da_write_end(struct file *file,
-                            struct address_space *mapping,
-                            loff_t pos, unsigned len, unsigned copied,
-                            struct page *page, void *fsdata)
-{
-       struct inode *inode = mapping->host;
-       int ret = 0, ret2;
-       handle_t *handle = ext4_journal_current_handle();
-       loff_t new_i_size;
-       unsigned long start, end;
-       int write_mode = (int)(unsigned long)fsdata;
+       io = kmalloc(sizeof(*io), GFP_NOFS);

-       if (write_mode == FALL_BACK_TO_NONDELALLOC) {
-               if (ext4_should_order_data(inode)) {
-                       return ext4_ordered_write_end(file, mapping, pos,
-                                       len, copied, page, fsdata);
-               } else if (ext4_should_writeback_data(inode)) {
-                       return ext4_writeback_write_end(file, mapping, pos,
-                                       len, copied, page, fsdata);
-               } else {
-                       BUG();
-               }
+       if (io) {
+               igrab(inode);
+               io->inode = inode;
+               io->flag = 0;
+               io->offset = 0;
+               io->size = 0;
+               io->error = 0;
+               INIT_WORK(&io->work, ext4_end_io_work);
+               INIT_LIST_HEAD(&io->list);
       }

-       trace_ext4_da_write_end(inode, pos, len, copied);
-       start = pos & (PAGE_CACHE_SIZE - 1);
-       end = start + copied - 1;
+       return io;
+}

-       /*
-        * generic_write_end() will run mark_inode_dirty() if i_size
-        * changes.  So let's piggyback the i_disksize mark_inode_dirty
-        * into that.
-        */
+static void ext4_end_io_dio(struct kiocb *iocb, loff_t offset,
+                           ssize_t size, void *private)
+{
+        ext4_io_end_t *io_end = iocb->private;
+       struct workqueue_struct *wq;

-       new_i_size = pos + copied;
-       if (new_i_size > EXT4_I(inode)->i_disksize) {
-               if (ext4_da_should_update_i_disksize(page, end)) {
-                       down_write(&EXT4_I(inode)->i_data_sem);
-                       if (new_i_size > EXT4_I(inode)->i_disksize) {
-                               /*
-                                * Updating i_disksize when extending file
-                                * without needing block allocation
-                                */
-                               if (ext4_should_order_data(inode))
-                                       ret = ext4_jbd2_file_inode(handle,
-                                                                  inode);
+       /* if not async direct IO or dio with 0 bytes write, just return */
+       if (!io_end || !size)
+               return;

-                               EXT4_I(inode)->i_disksize = new_i_size;
-                       }
-                       up_write(&EXT4_I(inode)->i_data_sem);
-                       /* We need to mark inode dirty even if
-                        * new_i_size is less that inode->i_size
-                        * bu greater than i_disksize.(hint delalloc)
-                        */
-                       ext4_mark_inode_dirty(handle, inode);
-               }
+       ext_debug("ext4_end_io_dio(): io_end 0x%p"
+                 "for inode %lu, iocb 0x%p, offset %llu, size %llu\n",
+                 iocb->private, io_end->inode->i_ino, iocb, offset,
+                 size);
+
+       /* if not aio dio with unwritten extents, just free io and return */
+       if (io_end->flag != EXT4_IO_UNWRITTEN){
+               ext4_free_io_end(io_end);
+               iocb->private = NULL;
+               return;
       }
-       ret2 = generic_write_end(file, mapping, pos, len, copied,
-                                                       page, fsdata);
-       copied = ret2;
-       if (ret2 < 0)
-               ret = ret2;
-       ret2 = ext4_journal_stop(handle);
-       if (!ret)
-               ret = ret2;

-       return ret ? ret : copied;
+       io_end->offset = offset;
+       io_end->size = size;
+       io_end->flag = EXT4_IO_WRITTEN;
+       wq = EXT4_SB(io_end->inode->i_sb)->dio_unwritten_wq;
+
+       /* queue the work to convert unwritten extents to written */
+       queue_work(wq, &io_end->work);
+
+       /* Add the io_end to per-inode completed aio dio list*/
+       list_add_tail(&io_end->list,
+                &EXT4_I(io_end->inode)->i_completed_io_list);
+       iocb->private = NULL;
 }

-static void ext4_da_invalidatepage(struct page *page, unsigned long offset)
+static void ext4_end_io_buffer_write(struct buffer_head *bh, int uptodate)
 {
-       /*
-        * Drop reserved blocks
-        */
-       BUG_ON(!PageLocked(page));
-       if (!page_has_buffers(page))
+       ext4_io_end_t *io_end = bh->b_private;
+       struct workqueue_struct *wq;
+
+       if (!io_end)
               goto out;
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

-       ext4_da_page_release_reservation(page, offset);
+static int ext4_set_bh_endio(struct buffer_head *bh, struct inode *inode)
+{
+       ext4_io_end_t *io_end;
+       struct page *page = bh->b_page;
+       loff_t offset = (sector_t)page->index << PAGE_CACHE_SHIFT;
+       size_t size = bh->b_size;

-out:
-       ext4_invalidatepage(page, offset);
+       io_end = ext4_init_io_end(inode);
+       if (!io_end)
+               return -ENOMEM;
+       io_end->offset = offset;
+       io_end->size = size;
+       io_end->flag = EXT4_IO_UNWRITTEN;
+       /* Add the io_end to per-inode completed io list*/
+       list_add_tail(&io_end->list,
+                &EXT4_I(io_end->inode)->i_completed_io_list);

-       return;
+       bh->b_private = io_end;
+       bh->b_end_io = ext4_end_io_buffer_write;
+       return 0;
 }

 /*
- * Force all delayed allocation blocks to be allocated for a given inode.
+ * Note that we don't need to start a transaction unless we're journaling data
+ * because we should have holes filled from ext4_page_mkwrite(). We even don't
+ * need to file the inode to the transaction's list in ordered mode because if
+ * we are writing back data added by write(), the inode is already there and if
+ * we are writing back data modified via mmap(), noone guarantees in which
+ * transaction the data will hit the disk. In case we are journaling data, we
+ * cannot start transaction directly because transaction start ranks above page
+ * lock so we have to do some magic.
+ *
+ * This function can get called via...
+ *   - ext4_da_writepages after taking page lock (have journal handle)
+ *   - journal_submit_inode_data_buffers (no journal handle)
+ *   - shrink_page_list via pdflush (no journal handle)
+ *   - grab_page_cache when doing write_begin (have journal handle)
+ *
+ * We don't do any block allocation in this function. If we have page with
+ * multiple blocks we need to write those buffer_heads that are mapped. This
+ * is important for mmaped based write. So if we do with blocksize 1K
+ * truncate(f, 1024);
+ * a = mmap(f, 0, 4096);
+ * a[0] = 'a';
+ * truncate(f, 4096);
+ * we have in the page first buffer_head mapped via page_mkwrite call back
+ * but other bufer_heads would be unmapped but dirty(dirty done via the
+ * do_wp_page). So writepage should write the first block. If we modify
+ * the mmap area beyond 1024 we will again get a page_fault and the
+ * page_mkwrite callback will do the block allocation and mark the
+ * buffer_heads mapped.
+ *
+ * We redirty the page if we have any buffer_heads that is either delay or
+ * unwritten in the page.
+ *
+ * We can get recursively called as show below.
+ *
+ *     ext4_writepage() -> kmalloc() -> __alloc_pages() -> page_launder() ->
+ *             ext4_writepage()
+ *
+ * But since we don't do any block allocation we should not deadlock.
+ * Page also have the dirty flag cleared so we don't get recurive page_lock.
 */
-#if 1
-int ext4_alloc_da_blocks(struct inode *inode)
+static int ext4_writepage(struct page *page,
+                         struct writeback_control *wbc)
 {
-       trace_ext4_alloc_da_blocks(inode);
-
-       if (!EXT4_I(inode)->i_reserved_data_blocks &&
-           !EXT4_I(inode)->i_reserved_meta_blocks)
-               return 0;
+       int ret = 0;
+       loff_t size;
+       unsigned int len;
+       struct buffer_head *page_bufs = NULL;
+       struct inode *inode = page->mapping->host;

-       /*
-        * We do something simple for now.  The filemap_flush() will
-        * also start triggering a write of the data blocks, which is
-        * not strictly speaking necessary (and for users of
-        * laptop_mode, not even desirable).  However, to do otherwise
-        * would require replicating code paths in:
-        *
-        * ext4_da_writepages() ->
-        *    write_cache_pages() ---> (via passed in callback function)
-        *        __mpage_da_writepage() -->
-        *           mpage_add_bh_to_extent()
-        *           mpage_da_map_blocks()
-        *
-        * The problem is that write_cache_pages(), located in
-        * mm/page-writeback.c, marks pages clean in preparation for
-        * doing I/O, which is not desirable if we're not planning on
-        * doing I/O at all.
-        *
-        * We could call write_cache_pages(), and then redirty all of
-        * the pages by calling redirty_page_for_writeback() but that
-        * would be ugly in the extreme.  So instead we would need to
-        * replicate parts of the code in the above functions,
-        * simplifying them becuase we wouldn't actually intend to
-        * write out the pages, but rather only collect contiguous
-        * logical block extents, call the multi-block allocator, and
-        * then update the buffer heads with the block allocations.
-        *
-        * For now, though, we'll cheat by calling filemap_flush(),
-        * which will map the blocks, and start the I/O, but not
-        * actually wait for the I/O to complete.
-        */
-       return filemap_flush(inode->i_mapping);
-}
-#else
-static int flush_alloc_da_page(struct page *page, struct mpage_da_data *mpd)
-{
-       struct inode *inode = mpd->inode;
-       struct buffer_head *bh, *head;
-       sector_t logical;
+       trace_ext4_writepage(inode, page);
+       size = i_size_read(inode);
+       if (page->index == size >> PAGE_CACHE_SHIFT)
+               len = size & ~PAGE_CACHE_MASK;
+       else
+               len = PAGE_CACHE_SIZE;

-       /*
-        * Can we merge this page to current extent?
-        */
-       if (mpd->next_page != page->index) {
+       if (page_has_buffers(page)) {
+               page_bufs = page_buffers(page);
+               if (walk_page_buffers(NULL, page_bufs, 0, len, NULL,
+                                       ext4_bh_delay_or_unwritten)) {
+                       /*
+                        * We don't want to do  block allocation
+                        * So redirty the page and return
+                        * We may reach here when we do a journal commit
+                        * via journal_submit_inode_data_buffers.
+                        * If we don't have mapping block we just ignore
+                        * them. We can also reach here via shrink_page_list
+                        */
+                       redirty_page_for_writepage(wbc, page);
+                       unlock_page(page);
+                       return 0;
+               }
+       } else {
               /*
-                * Nope, we can't. So, we map non-allocated blocks
-                * and start IO on them using writepage()
+                * The test for page_has_buffers() is subtle:
+                * We know the page is dirty but it lost buffers. That means
+                * that at some moment in time after write_begin()/write_end()
+                * has been called all buffers have been clean and thus they
+                * must have been written at least once. So they are all
+                * mapped and we can happily proceed with mapping them
+                * and writing the page.
+                *
+                * Try to initialize the buffer_heads and check whether
+                * all are mapped and non delay. We don't want to
+                * do block allocation here.
                */
-               if (mpd->next_page != mpd->first_page) {
-                       printk(KERN_INFO
-                              "flush_alloc_da_page map_blocks: "
-                              "ino %lu blk %llu, size %u\n",
-                              mpd->inode->i_ino, mpd->b_blocknr,
-                              mpd->b_size >> mpd->inode->i_blkbits);
-                       mpage_da_map_blocks(mpd);
+               ret = block_prepare_write(page, 0, len,
+                                         noalloc_get_block_write);
+               if (!ret) {
+                       page_bufs = page_buffers(page);
+                       /* check whether all are mapped and non delay */
+                       if (walk_page_buffers(NULL, page_bufs, 0, len, NULL,
+                                               ext4_bh_delay_or_unwritten)) {
+                               redirty_page_for_writepage(wbc, page);
+                               unlock_page(page);
+                               return 0;
+                       }
+               } else {
                       /*
-                        * skip rest of the page in the page_vec
+                        * We can't do block allocation here
+                        * so just redity the page and unlock
+                        * and return
                        */
+                       redirty_page_for_writepage(wbc, page);
                       unlock_page(page);
-                       return MPAGE_DA_EXTENT_TAIL;
+                       return 0;
               }
+               /* now mark the buffer_heads as dirty and uptodate */
+               block_commit_write(page, 0, len);
+       }

+       if (PageChecked(page) && ext4_should_journal_data(inode)) {
               /*
-                * Start next extent of pages ...
-                */
-               mpd->first_page = page->index;
-
-               /*
-                * ... and blocks
+                * It's mmapped pagecache.  Add buffers and journal it.  There
+                * doesn't seem much point in redirtying the page here.
                */
-               mpd->b_size = 0;
-               mpd->b_state = 0;
-               mpd->b_blocknr = 0;
+               ClearPageChecked(page);
+               return __ext4_journalled_writepage(page, len);
       }

-       mpd->next_page = page->index + 1;
-       logical = (sector_t) page->index <<
-                 (PAGE_CACHE_SHIFT - inode->i_blkbits);
+       if (test_opt(inode->i_sb, NOBH) && ext4_should_writeback_data(inode))
+               ret = nobh_writepage(page, noalloc_get_block_write, wbc);
+       else if (page_bufs && buffer_uninit(page_bufs)) {
+               ext4_set_bh_endio(page_bufs, inode);
+               ret = block_write_full_page_endio(page, noalloc_get_block_write,
+                                           wbc, ext4_end_io_buffer_write);
+       } else
+               ret = block_write_full_page(page, noalloc_get_block_write,
+                                           wbc);

-       if (!page_has_buffers(page)) {
-               mpage_add_bh_to_extent(mpd, logical, PAGE_CACHE_SIZE,
-                                      (1 << BH_Dirty) | (1 << BH_Uptodate));
-       } else {
-               /*
-                * Page with regular buffer heads, just add all dirty ones
-                */
-               head = page_buffers(page);
-               bh = head;
-               do {
-                       BUG_ON(buffer_locked(bh));
-                       /*
-                        * We need to try to allocate
-                        * unmapped blocks in the same page.
-                        * Otherwise we won't make progress
-                        * with the page in ext4_writepage
-                        */
-                       if (ext4_bh_delay_or_unwritten(NULL, bh)) {
-                               mpage_add_bh_to_extent(mpd, logical,
-                                                      bh->b_size,
-                                                      bh->b_state);
-                       } else if (buffer_dirty(bh) && (buffer_mapped(bh))) {
-                               /*
-                                * mapped dirty buffer. We need to update
-                                * the b_state because we look at
-                                * b_state in mpage_da_map_blocks. We don't
-                                * update b_size because if we find an
-                                * unmapped buffer_head later we need to
-                                * use the b_state flag of that buffer_head.
-                                */
-                               if (mpd->b_size == 0)
-                                       mpd->b_state = bh->b_state & BH_FLAGS;
-                       }
-                       logical++;
-               } while ((bh = bh->b_this_page) != head);
-       }
-       return 0;
+       return ret;
 }

-int ext4_alloc_da_blocks(struct inode *inode)
+/*
+ * This is called via ext4_da_writepages() to
+ * calulate the total number of credits to reserve to fit
+ * a single extent allocation into a single transaction,
+ * ext4_da_writpeages() will loop calling this before
+ * the block allocation.
+ */
+
+static int ext4_da_writepages_trans_blocks(struct inode *inode)
 {
-       struct address_space *mapping = inode->i_mapping;
-       struct pagevec pvec;
-       pgoff_t index = 0;
+       int max_blocks = EXT4_I(inode)->i_reserved_data_blocks;
+
+       /*
+        * With non-extent format the journal credit needed to
+        * insert nrblocks contiguous block is dependent on
+        * number of contiguous block. So we will limit
+        * number of contiguous block to a sane value
+        */
+       if (!(EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL) &&
+           (max_blocks > EXT4_MAX_TRANS_DATA))
+               max_blocks = EXT4_MAX_TRANS_DATA;
+
+       return ext4_chunk_trans_blocks(inode, max_blocks);
+}
+
+static int ext4_da_writepages(struct address_space *mapping,
+                             struct writeback_control *wbc)
+{
+       pgoff_t index;
+       int range_whole = 0;
       handle_t *handle = NULL;
       struct mpage_da_data mpd;
-       int i;
-       int nr_pages;
+       struct inode *inode = mapping->host;
+       int no_nrwrite_index_update;
+       int pages_written = 0;
+       long pages_skipped;
+       unsigned int max_pages;
+       int range_cyclic, cycled = 1, io_done = 0;
       int needed_blocks, ret = 0;
+       long desired_nr_to_write, nr_to_writebump = 0;
+       loff_t range_start = wbc->range_start;
       struct ext4_sb_info *sbi = EXT4_SB(mapping->host->i_sb);

-       if (ext4_should_journal_data(inode))
-               return 0;
+       trace_ext4_da_writepages(inode, wbc);

       /*
-        * If no pages to write, return right away.
+        * No pages to write? This is mainly a kludge to avoid starting
+        * a transaction for special inodes like journal inode on last iput()
+        * because that could violate lock ordering on umount
        */
       if (!mapping->nrpages || !mapping_tagged(mapping, PAGECACHE_TAG_DIRTY))
               return 0;

       /*
-        * If the filesystem has aborted, return immediately with an
-        * EROFS error.
+        * If the filesystem has aborted, it is read-only, so return
+        * right away instead of dumping stack traces later on that
+        * will obscure the real source of the problem.  We test
+        * EXT4_MF_FS_ABORTED instead of sb->s_flag's MS_RDONLY because
+        * the latter could be true if the filesystem is mounted
+        * read-only, and in that case, ext4_da_writepages should
+        * *never* be called, so if that ever happens, we would want
+        * the stack trace.
        */
       if (unlikely(sbi->s_mount_flags & EXT4_MF_FS_ABORTED))
               return -EROFS;

-       printk(KERN_INFO "ext4_alloc_da_pages(%lu)\n", inode->i_ino);
+       if (wbc->range_start == 0 && wbc->range_end == LLONG_MAX)
+               range_whole = 1;
+
+       range_cyclic = wbc->range_cyclic;
+       if (wbc->range_cyclic) {
+               index = mapping->writeback_index;
+               if (index)
+                       cycled = 0;
+               wbc->range_start = index << PAGE_CACHE_SHIFT;
+               wbc->range_end  = LLONG_MAX;
+               wbc->range_cyclic = 0;
+       } else
+               index = wbc->range_start >> PAGE_CACHE_SHIFT;
+
+       /*
+        * This works around two forms of stupidity.  The first is in
+        * the writeback code, which caps the maximum number of pages
+        * written to be 1024 pages.  This is wrong on multiple
+        * levels; different architectues have a different page size,
+        * which changes the maximum amount of data which gets
+        * written.  Secondly, 4 megabytes is way too small.  XFS
+        * forces this value to be 16 megabytes by multiplying
+        * nr_to_write parameter by four, and then relies on its
+        * allocator to allocate larger extents to make them
+        * contiguous.  Unfortunately this brings us to the second
+        * stupidity, which is that ext4's mballoc code only allocates
+        * at most 2048 blocks.  So we force contiguous writes up to
+        * the number of dirty blocks in the inode, or
+        * sbi->max_writeback_mb_bump whichever is smaller.
+        */
+       max_pages = sbi->s_max_writeback_mb_bump << (20 - PAGE_CACHE_SHIFT);
+       if (!range_cyclic && range_whole)
+               desired_nr_to_write = wbc->nr_to_write * 8;
+       else
+               desired_nr_to_write = ext4_num_dirty_pages(inode, index,
+                                                          max_pages);
+       if (desired_nr_to_write > max_pages)
+               desired_nr_to_write = max_pages;
+
+       if (wbc->nr_to_write < desired_nr_to_write) {
+               nr_to_writebump = desired_nr_to_write - wbc->nr_to_write;
+               wbc->nr_to_write = desired_nr_to_write;
+       }
+
+       mpd.wbc = wbc;
       mpd.inode = mapping->host;

-       while (1) {
+       /*
+        * we don't want write_cache_pages to update
+        * nr_to_write and writeback_index
+        */
+       no_nrwrite_index_update = wbc->no_nrwrite_index_update;
+       wbc->no_nrwrite_index_update = 1;
+       pages_skipped = wbc->pages_skipped;
+
+retry:
+       while (!ret && wbc->nr_to_write > 0) {
+
               /*
-                * we insert one extent at a time. So we need
+                * we  insert one extent at a time. So we need
                * credit needed for single extent allocation.
                * journalled mode is currently not supported
                * by delalloc
@@ -3354,67 +3145,48 @@ int ext4_alloc_da_blocks(struct inode *i
               BUG_ON(ext4_should_journal_data(inode));
               needed_blocks = ext4_da_writepages_trans_blocks(inode);

-               pagevec_init(&pvec, 0);
-               nr_pages = pagevec_lookup_tag(&pvec, mapping, &index,
-                                             PAGECACHE_TAG_DIRTY,
-                                             (pgoff_t)PAGEVEC_SIZE);
-               if (nr_pages == 0)
-                       break;
-
               /* start a new transaction*/
               handle = ext4_journal_start(inode, needed_blocks);
-               if (IS_ERR(handle))
-                       break;
-
-               mpd.b_size = 0;
-               mpd.b_state = 0;
-               mpd.b_blocknr = 0;
-               mpd.first_page = 0;
-               mpd.next_page = 0;
-               mpd.io_done = 0;
-               mpd.pages_written = 0;
-               mpd.retval = 0;
-
-               do {
-                       for (i = 0; i < nr_pages; i++) {
-                               struct page *page = pvec.pages[i];
-
-                               lock_page(page);
-                               if (unlikely(page->mapping != mapping) ||
-                                   !PageDirty(page) ||
-                                   PageWriteback(page)) {
-                                       unlock_page(page);
-                                       continue;
-                               }
-
-                               ret = flush_alloc_da_page(page, &mpd);
-                               if (ret) {
-                                       pagevec_release(&pvec);
-                                       goto map_extent;
-                               }
-                       }
-                       pagevec_release(&pvec);
-                       cond_resched();
-
-                       nr_pages = pagevec_lookup_tag(&pvec, mapping, &index,
-                                                     PAGECACHE_TAG_DIRTY,
-                                                     (pgoff_t)PAGEVEC_SIZE);
-               } while (nr_pages);
+               if (IS_ERR(handle)) {
+                       ret = PTR_ERR(handle);
+                       ext4_msg(inode->i_sb, KERN_CRIT, "%s: jbd2_start: "
+                              "%ld pages, ino %lu; err %d\n", __func__,
+                               wbc->nr_to_write, inode->i_ino, ret);
+                       goto out_writepages;
+               }

               /*
+                * Now call __mpage_da_writepage to find the next
+                * contiguous region of logical blocks that need
+                * blocks to be allocated by ext4.  We don't actually
+                * submit the blocks for I/O here, even though
+                * write_cache_pages thinks it will, and will set the
+                * pages as clean for write before calling
+                * __mpage_da_writepage().
+                */
+               mpd.b_size = 0;
+               mpd.b_state = 0;
+               mpd.b_blocknr = 0;
+               mpd.first_page = 0;
+               mpd.next_page = 0;
+               mpd.io_done = 0;
+               mpd.pages_written = 0;
+               mpd.retval = 0;
+               ret = write_cache_pages(mapping, wbc, __mpage_da_writepage,
+                                       &mpd);
+               /*
                * If we have a contigous extent of pages and we
                * haven't done the I/O yet, map the blocks and submit
                * them for I/O.
                */
-       map_extent:
               if (!mpd.io_done && mpd.next_page != mpd.first_page) {
-                       printk(KERN_INFO
-                              "ext4_alloc_da_blocks map_blocks: "
-                              "ino %lu blk %llu, size %u\n",
-                              mpd.inode->i_ino, mpd.b_blocknr,
-                              mpd.b_size >> mpd.inode->i_blkbits);
-                       mpage_da_map_blocks(&mpd);
+                       if (mpage_da_map_blocks(&mpd) == 0)
+                               mpage_da_submit_io(&mpd);
+                       mpd.io_done = 1;
+                       ret = MPAGE_DA_EXTENT_TAIL;
               }
+               trace_ext4_da_write_pages(inode, &mpd);
+               wbc->nr_to_write -= mpd.pages_written;

               ext4_journal_stop(handle);

@@ -3424,484 +3196,707 @@ int ext4_alloc_da_blocks(struct inode *i
                        * and try again
                        */
                       jbd2_journal_force_commit_nested(sbi->s_journal);
-               }
+                       wbc->pages_skipped = pages_skipped;
+                       ret = 0;
+               } else if (ret == MPAGE_DA_EXTENT_TAIL) {
+                       /*
+                        * got one extent now try with
+                        * rest of the pages
+                        */
+                       pages_written += mpd.pages_written;
+                       wbc->pages_skipped = pages_skipped;
+                       ret = 0;
+                       io_done = 1;
+               } else if (wbc->nr_to_write)
+                       /*
+                        * There is no more writeout needed
+                        * or we requested for a noblocking writeout
+                        * and we found the device congested
+                        */
+                       break;
       }
-       printk(KERN_INFO "ext4_alloc_da_pages(%lu) exit\n", inode->i_ino);
+       if (!io_done && !cycled) {
+               cycled = 1;
+               index = 0;
+               wbc->range_start = index << PAGE_CACHE_SHIFT;
+               wbc->range_end  = mapping->writeback_index - 1;
+               goto retry;
+       }
+       if (pages_skipped != wbc->pages_skipped)
+               ext4_msg(inode->i_sb, KERN_CRIT,
+                        "This should not happen leaving %s "
+                        "with nr_to_write = %ld ret = %d\n",
+                        __func__, wbc->nr_to_write, ret);
+
+       /* Update index */
+       index += pages_written;
+       wbc->range_cyclic = range_cyclic;
+       if (wbc->range_cyclic || (range_whole && wbc->nr_to_write > 0))
+               /*
+                * set the writeback_index so that range_cyclic
+                * mode will write it back later
+                */
+               mapping->writeback_index = index;
+
+out_writepages:
+       if (!no_nrwrite_index_update)
+               wbc->no_nrwrite_index_update = 0;
+       if (wbc->nr_to_write > nr_to_writebump)
+               wbc->nr_to_write -= nr_to_writebump;
+       wbc->range_start = range_start;
+       trace_ext4_da_writepages_result(inode, wbc, ret, pages_written);
       return ret;
 }
-#endif

-/*
- * bmap() is special.  It gets used by applications such as lilo and by
- * the swapper to find the on-disk block of a specific piece of data.
- *
- * Naturally, this is dangerous if the block concerned is still in the
- * journal.  If somebody makes a swapfile on an ext4 data-journaling
- * filesystem and enables swap, then they may get a nasty shock when the
- * data getting swapped to that swapfile suddenly gets overwritten by
- * the original zero's written out previously to the journal and
- * awaiting writeback in the kernel's buffer cache.
- *
- * So, if we see any bmap calls here on a modified, data-journaled file,
- * take extra steps to flush any blocks which might be in the cache.
- */
-static sector_t ext4_bmap(struct address_space *mapping, sector_t block)
+#define FALL_BACK_TO_NONDELALLOC 1
+static int ext4_nonda_switch(struct super_block *sb)
 {
-       struct inode *inode = mapping->host;
-       journal_t *journal;
-       int err;
+       s64 free_blocks, dirty_blocks;
+       struct ext4_sb_info *sbi = EXT4_SB(sb);

-       if (mapping_tagged(mapping, PAGECACHE_TAG_DIRTY) &&
-                       test_opt(inode->i_sb, DELALLOC)) {
+       /*
+        * switch to non delalloc mode if we are running low
+        * on free block. The free block accounting via percpu
+        * counters can get slightly wrong with percpu_counter_batch getting
+        * accumulated on each CPU without updating global counters
+        * Delalloc need an accurate free block accounting. So switch
+        * to non delalloc when we are near to error range.
+        */
+       free_blocks  = percpu_counter_read_positive(&sbi->s_freeblocks_counter);
+       dirty_blocks =
percpu_counter_read_positive(&sbi->s_dirtyblocks_counter);
+       if (2 * free_blocks < 3 * dirty_blocks ||
+               free_blocks < (dirty_blocks + EXT4_FREEBLOCKS_WATERMARK)) {
               /*
-                * With delalloc we want to sync the file
-                * so that we can make sure we allocate
-                * blocks for file
+                * free block count is less that 150% of dirty blocks
+                * or free blocks is less that watermark
                */
-               filemap_write_and_wait(mapping);
+               return 1;
       }
+       return 0;
+}

-       if (EXT4_JOURNAL(inode) && EXT4_I(inode)->i_state & EXT4_STATE_JDATA) {
+static int ext4_da_write_begin(struct file *file, struct
address_space *mapping,
+                              loff_t pos, unsigned len, unsigned flags,
+                              struct page **pagep, void **fsdata)
+{
+       int ret, retries = 0;
+       struct page *page;
+       pgoff_t index;
+       unsigned from, to;
+       struct inode *inode = mapping->host;
+       handle_t *handle;
+
+       index = pos >> PAGE_CACHE_SHIFT;
+       from = pos & (PAGE_CACHE_SIZE - 1);
+       to = from + len;
+
+       if (ext4_nonda_switch(inode->i_sb)) {
+               *fsdata = (void *)FALL_BACK_TO_NONDELALLOC;
+               return ext4_write_begin(file, mapping, pos,
+                                       len, flags, pagep, fsdata);
+       }
+       *fsdata = (void *)0;
+       trace_ext4_da_write_begin(inode, pos, len, flags);
+retry:
+       /*
+        * With delayed allocation, we don't log the i_disksize update
+        * if there is delayed block allocation. But we still need
+        * to journalling the i_disksize update if writes to the end
+        * of file which has an already mapped buffer.
+        */
+       handle = ext4_journal_start(inode, 1);
+       if (IS_ERR(handle)) {
+               ret = PTR_ERR(handle);
+               goto out;
+       }
+       /* We cannot recurse into the filesystem as the transaction is already
+        * started */
+       flags |= AOP_FLAG_NOFS;
+
+       page = grab_cache_page_write_begin(mapping, index, flags);
+       if (!page) {
+               ext4_journal_stop(handle);
+               ret = -ENOMEM;
+               goto out;
+       }
+       *pagep = page;
+
+       ret = block_write_begin(file, mapping, pos, len, flags, pagep, fsdata,
+                               ext4_da_get_block_prep);
+       if (ret < 0) {
+               unlock_page(page);
+               ext4_journal_stop(handle);
+               page_cache_release(page);
               /*
-                * This is a REALLY heavyweight approach, but the use of
-                * bmap on dirty files is expected to be extremely rare:
-                * only if we run lilo or swapon on a freshly made file
-                * do we expect this to happen.
-                *
-                * (bmap requires CAP_SYS_RAWIO so this does not
-                * represent an unprivileged user DOS attack --- we'd be
-                * in trouble if mortal users could trigger this path at
-                * will.)
-                *
-                * NB. EXT4_STATE_JDATA is not set on files other than
-                * regular files.  If somebody wants to bmap a directory
-                * or symlink and gets confused because the buffer
-                * hasn't yet been flushed to disk, they deserve
-                * everything they get.
+                * block_write_begin may have instantiated a few blocks
+                * outside i_size.  Trim these off again. Don't need
+                * i_size_read because we hold i_mutex.
                */
+               if (pos + len > inode->i_size)
+                       ext4_truncate(inode);
+       }

-               EXT4_I(inode)->i_state &= ~EXT4_STATE_JDATA;
-               journal = EXT4_JOURNAL(inode);
-               jbd2_journal_lock_updates(journal);
-               err = jbd2_journal_flush(journal);
-               jbd2_journal_unlock_updates(journal);
+       if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
+               goto retry;
+out:
+       return ret;
+}

-               if (err)
-                       return 0;
+/*
+ * Check if we should update i_disksize
+ * when write to the end of file but not require block allocation
+ */
+static int ext4_da_should_update_i_disksize(struct page *page,
+                                           unsigned long offset)
+{
+       struct buffer_head *bh;
+       struct inode *inode = page->mapping->host;
+       unsigned int idx;
+       int i;
+
+       bh = page_buffers(page);
+       idx = offset >> inode->i_blkbits;
+
+       for (i = 0; i < idx; i++)
+               bh = bh->b_this_page;
+
+       if (!buffer_mapped(bh) || (buffer_delay(bh)) || buffer_unwritten(bh))
+               return 0;
+       return 1;
+}
+
+static int ext4_da_write_end(struct file *file,
+                            struct address_space *mapping,
+                            loff_t pos, unsigned len, unsigned copied,
+                            struct page *page, void *fsdata)
+{
+       struct inode *inode = mapping->host;
+       int ret = 0, ret2;
+       handle_t *handle = ext4_journal_current_handle();
+       loff_t new_i_size;
+       unsigned long start, end;
+       int write_mode = (int)(unsigned long)fsdata;
+
+       if (write_mode == FALL_BACK_TO_NONDELALLOC) {
+               if (ext4_should_order_data(inode)) {
+                       return ext4_ordered_write_end(file, mapping, pos,
+                                       len, copied, page, fsdata);
+               } else if (ext4_should_writeback_data(inode)) {
+                       return ext4_writeback_write_end(file, mapping, pos,
+                                       len, copied, page, fsdata);
+               } else {
+                       BUG();
+               }
       }

-       return generic_block_bmap(mapping, block, ext4_get_block);
-}
+       trace_ext4_da_write_end(inode, pos, len, copied);
+       start = pos & (PAGE_CACHE_SIZE - 1);
+       end = start + copied - 1;

-static int ext4_readpage(struct file *file, struct page *page)
-{
-       return mpage_readpage(page, ext4_get_block);
-}
+       /*
+        * generic_write_end() will run mark_inode_dirty() if i_size
+        * changes.  So let's piggyback the i_disksize mark_inode_dirty
+        * into that.
+        */

-static int
-ext4_readpages(struct file *file, struct address_space *mapping,
-               struct list_head *pages, unsigned nr_pages)
-{
-       return mpage_readpages(mapping, pages, nr_pages, ext4_get_block);
+       new_i_size = pos + copied;
+       if (new_i_size > EXT4_I(inode)->i_disksize) {
+               if (ext4_da_should_update_i_disksize(page, end)) {
+                       down_write(&EXT4_I(inode)->i_data_sem);
+                       if (new_i_size > EXT4_I(inode)->i_disksize) {
+                               /*
+                                * Updating i_disksize when extending file
+                                * without needing block allocation
+                                */
+                               if (ext4_should_order_data(inode))
+                                       ret = ext4_jbd2_file_inode(handle,
+                                                                  inode);
+
+                               EXT4_I(inode)->i_disksize = new_i_size;
+                       }
+                       up_write(&EXT4_I(inode)->i_data_sem);
+                       /* We need to mark inode dirty even if
+                        * new_i_size is less that inode->i_size
+                        * bu greater than i_disksize.(hint delalloc)
+                        */
+                       ext4_mark_inode_dirty(handle, inode);
+               }
+       }
+       ret2 = generic_write_end(file, mapping, pos, len, copied,
+                                                       page, fsdata);
+       copied = ret2;
+       if (ret2 < 0)
+               ret = ret2;
+       ret2 = ext4_journal_stop(handle);
+       if (!ret)
+               ret = ret2;
+
+       return ret ? ret : copied;
 }

-static void ext4_invalidatepage(struct page *page, unsigned long offset)
+static void ext4_da_invalidatepage(struct page *page, unsigned long offset)
 {
-       journal_t *journal = EXT4_JOURNAL(page->mapping->host);
-
       /*
-        * If it's a full truncate we just forget about the pending dirtying
+        * Drop reserved blocks
        */
-       if (offset == 0)
-               ClearPageChecked(page);
+       BUG_ON(!PageLocked(page));
+       if (!page_has_buffers(page))
+               goto out;

-       if (journal)
-               jbd2_journal_invalidatepage(journal, page, offset);
-       else
-               block_invalidatepage(page, offset);
-}
+       ext4_da_page_release_reservation(page, offset);

-static int ext4_releasepage(struct page *page, gfp_t wait)
-{
-       journal_t *journal = EXT4_JOURNAL(page->mapping->host);
+out:
+       ext4_invalidatepage(page, offset);

-       WARN_ON(PageChecked(page));
-       if (!page_has_buffers(page))
-               return 0;
-       if (journal)
-               return jbd2_journal_try_to_free_buffers(journal, page, wait);
-       else
-               return try_to_free_buffers(page);
+       return;
 }

 /*
- * O_DIRECT for ext3 (or indirect map) based files
- *
- * If the O_DIRECT write will extend the file then add this inode to the
- * orphan list.  So recovery will truncate it back to the original size
- * if the machine crashes during the write.
- *
- * If the O_DIRECT write is intantiating holes inside i_size and the machine
- * crashes then stale disk data _may_ be exposed inside the file. But current
- * VFS code falls back into buffered path in that case so we are safe.
+ * Force all delayed allocation blocks to be allocated for a given inode.
 */
-static ssize_t ext4_ind_direct_IO(int rw, struct kiocb *iocb,
-                             const struct iovec *iov, loff_t offset,
-                             unsigned long nr_segs)
+#if 1
+int ext4_alloc_da_blocks(struct inode *inode)
 {
-       struct file *file = iocb->ki_filp;
-       struct inode *inode = file->f_mapping->host;
-       struct ext4_inode_info *ei = EXT4_I(inode);
-       handle_t *handle;
-       ssize_t ret;
-       int orphan = 0;
-       size_t count = iov_length(iov, nr_segs);
-       int retries = 0;
+       trace_ext4_alloc_da_blocks(inode);

-       if (rw == WRITE) {
-               loff_t final_size = offset + count;
+       if (!EXT4_I(inode)->i_reserved_data_blocks &&
+           !EXT4_I(inode)->i_reserved_meta_blocks)
+               return 0;

-               if (final_size > inode->i_size) {
-                       /* Credits for sb + inode write */
-                       handle = ext4_journal_start(inode, 2);
-                       if (IS_ERR(handle)) {
-                               ret = PTR_ERR(handle);
-                               goto out;
-                       }
-                       ret = ext4_orphan_add(handle, inode);
-                       if (ret) {
-                               ext4_journal_stop(handle);
-                               goto out;
-                       }
-                       orphan = 1;
-                       ei->i_disksize = inode->i_size;
-                       ext4_journal_stop(handle);
+       /*
+        * We do something simple for now.  The filemap_flush() will
+        * also start triggering a write of the data blocks, which is
+        * not strictly speaking necessary (and for users of
+        * laptop_mode, not even desirable).  However, to do otherwise
+        * would require replicating code paths in:
+        *
+        * ext4_da_writepages() ->
+        *    write_cache_pages() ---> (via passed in callback function)
+        *        __mpage_da_writepage() -->
+        *           mpage_add_bh_to_extent()
+        *           mpage_da_map_blocks()
+        *
+        * The problem is that write_cache_pages(), located in
+        * mm/page-writeback.c, marks pages clean in preparation for
+        * doing I/O, which is not desirable if we're not planning on
+        * doing I/O at all.
+        *
+        * We could call write_cache_pages(), and then redirty all of
+        * the pages by calling redirty_page_for_writeback() but that
+        * would be ugly in the extreme.  So instead we would need to
+        * replicate parts of the code in the above functions,
+        * simplifying them becuase we wouldn't actually intend to
+        * write out the pages, but rather only collect contiguous
+        * logical block extents, call the multi-block allocator, and
+        * then update the buffer heads with the block allocations.
+        *
+        * For now, though, we'll cheat by calling filemap_flush(),
+        * which will map the blocks, and start the I/O, but not
+        * actually wait for the I/O to complete.
+        */
+       return filemap_flush(inode->i_mapping);
+}
+#else
+static int flush_alloc_da_page(struct page *page, struct mpage_da_data *mpd)
+{
+       struct inode *inode = mpd->inode;
+       struct buffer_head *bh, *head;
+       sector_t logical;
+
+       /*
+        * Can we merge this page to current extent?
+        */
+       if (mpd->next_page != page->index) {
+               /*
+                * Nope, we can't. So, we map non-allocated blocks
+                * and start IO on them using writepage()
+                */
+               if (mpd->next_page != mpd->first_page) {
+                       printk(KERN_INFO
+                              "flush_alloc_da_page map_blocks: "
+                              "ino %lu blk %llu, size %u\n",
+                              mpd->inode->i_ino, mpd->b_blocknr,
+                              mpd->b_size >> mpd->inode->i_blkbits);
+                       mpage_da_map_blocks(mpd);
+                       /*
+                        * skip rest of the page in the page_vec
+                        */
+                       unlock_page(page);
+                       return MPAGE_DA_EXTENT_TAIL;
               }
-       }

-retry:
-       if (rw == READ && test_opt(inode->i_sb, DIOREAD_NOLOCK)
-                       && (EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL))
-               ret = blockdev_direct_IO_no_locking(rw, iocb, inode,
-                                inode->i_sb->s_bdev, iov,
-                                offset, nr_segs,
-                                ext4_get_block, NULL);
-       else
-               ret = blockdev_direct_IO(rw, iocb, inode,
-                                inode->i_sb->s_bdev, iov,
-                                offset, nr_segs,
-                                ext4_get_block, NULL);
-       if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
-               goto retry;
+               /*
+                * Start next extent of pages ...
+                */
+               mpd->first_page = page->index;

-       if (orphan) {
-               int err;
+               /*
+                * ... and blocks
+                */
+               mpd->b_size = 0;
+               mpd->b_state = 0;
+               mpd->b_blocknr = 0;
+       }

-               /* Credits for sb + inode write */
-               handle = ext4_journal_start(inode, 2);
-               if (IS_ERR(handle)) {
-                       /* This is really bad luck. We've written the data
-                        * but cannot extend i_size. Bail out and pretend
-                        * the write failed... */
-                       ret = PTR_ERR(handle);
-                       goto out;
-               }
-               if (inode->i_nlink)
-                       ext4_orphan_del(handle, inode);
-               if (ret > 0) {
-                       loff_t end = offset + ret;
-                       if (end > inode->i_size) {
-                               ei->i_disksize = end;
-                               i_size_write(inode, end);
+       mpd->next_page = page->index + 1;
+       logical = (sector_t) page->index <<
+                 (PAGE_CACHE_SHIFT - inode->i_blkbits);
+
+       if (!page_has_buffers(page)) {
+               mpage_add_bh_to_extent(mpd, logical, PAGE_CACHE_SIZE,
+                                      (1 << BH_Dirty) | (1 << BH_Uptodate));
+       } else {
+               /*
+                * Page with regular buffer heads, just add all dirty ones
+                */
+               head = page_buffers(page);
+               bh = head;
+               do {
+                       BUG_ON(buffer_locked(bh));
+                       /*
+                        * We need to try to allocate
+                        * unmapped blocks in the same page.
+                        * Otherwise we won't make progress
+                        * with the page in ext4_writepage
+                        */
+                       if (ext4_bh_delay_or_unwritten(NULL, bh)) {
+                               mpage_add_bh_to_extent(mpd, logical,
+                                                      bh->b_size,
+                                                      bh->b_state);
+                       } else if (buffer_dirty(bh) && (buffer_mapped(bh))) {
                               /*
-                                * We're going to return a positive `ret'
-                                * here due to non-zero-length I/O, so there's
-                                * no way of reporting error returns from
-                                * ext4_mark_inode_dirty() to userspace.  So
-                                * ignore it.
+                                * mapped dirty buffer. We need to update
+                                * the b_state because we look at
+                                * b_state in mpage_da_map_blocks. We don't
+                                * update b_size because if we find an
+                                * unmapped buffer_head later we need to
+                                * use the b_state flag of that buffer_head.
                                */
-                               ext4_mark_inode_dirty(handle, inode);
+                               if (mpd->b_size == 0)
+                                       mpd->b_state = bh->b_state & BH_FLAGS;
                       }
-               }
-               err = ext4_journal_stop(handle);
-               if (ret == 0)
-                       ret = err;
+                       logical++;
+               } while ((bh = bh->b_this_page) != head);
       }
-out:
-       return ret;
+       return 0;
 }

-static int ext4_get_block_write(struct inode *inode, sector_t iblock,
-                  struct buffer_head *bh_result, int create)
+int ext4_alloc_da_blocks(struct inode *inode)
 {
-       handle_t *handle = ext4_journal_current_handle();
-       int ret = 0;
-       unsigned max_blocks = bh_result->b_size >> inode->i_blkbits;
-       int dio_credits;
-       int started = 0;
+       struct address_space *mapping = inode->i_mapping;
+       struct pagevec pvec;
+       pgoff_t index = 0;
+       handle_t *handle = NULL;
+       struct mpage_da_data mpd;
+       int i;
+       int nr_pages;
+       int needed_blocks, ret = 0;
+       struct ext4_sb_info *sbi = EXT4_SB(mapping->host->i_sb);
+
+       if (ext4_should_journal_data(inode))
+               return 0;

-       ext4_debug("ext4_get_block_write: inode %lu, create flag %d\n",
-                  inode->i_ino, create);
       /*
-        * ext4_get_block in prepare for a DIO write or buffer write.
-        * We allocate an uinitialized extent if blocks haven't been allocated.
-        * The extent will be converted to initialized after IO complete.
+        * If no pages to write, return right away.
        */
-       create = EXT4_GET_BLOCKS_IO_CREATE_EXT;
-
-       if (!handle) {
-               if (max_blocks > DIO_MAX_BLOCKS)
-                       max_blocks = DIO_MAX_BLOCKS;
-               dio_credits = ext4_chunk_trans_blocks(inode, max_blocks);
-               handle = ext4_journal_start(inode, dio_credits);
-               if (IS_ERR(handle)) {
-                       ret = PTR_ERR(handle);
-                       goto out;
-               }
-               started = 1;
-       }
-
-       ret = ext4_get_blocks(handle, inode, iblock, max_blocks, bh_result,
-                             create);
-       if (ret > 0) {
-               bh_result->b_size = (ret << inode->i_blkbits);
-               ret = 0;
-       }
-       if (started)
-               ext4_journal_stop(handle);
-out:
-       return ret;
-}
+       if (!mapping->nrpages || !mapping_tagged(mapping, PAGECACHE_TAG_DIRTY))
+               return 0;

-static void ext4_free_io_end(ext4_io_end_t *io)
-{
-       BUG_ON(!io);
-       iput(io->inode);
-       kfree(io);
-}
+       /*
+        * If the filesystem has aborted, return immediately with an
+        * EROFS error.
+        */
+       if (unlikely(sbi->s_mount_flags & EXT4_MF_FS_ABORTED))
+               return -EROFS;

-static void dump_completed_IO(struct inode * inode)
-{
-#ifdef EXT4_DEBUG
-       struct list_head *cur, *before, *after;
-       ext4_io_end_t *io, *io0, *io1;
+       printk(KERN_INFO "ext4_alloc_da_pages(%lu)\n", inode->i_ino);
+       mpd.inode = mapping->host;

-       if (list_empty(&EXT4_I(inode)->i_completed_io_list)){
-               ext4_debug("inode %lu completed_io list is empty\n",
inode->i_ino);
-               return;
-       }
+       while (1) {
+               /*
+                * we insert one extent at a time. So we need
+                * credit needed for single extent allocation.
+                * journalled mode is currently not supported
+                * by delalloc
+                */
+               BUG_ON(ext4_should_journal_data(inode));
+               needed_blocks = ext4_da_writepages_trans_blocks(inode);

-       ext4_debug("Dump inode %lu completed_io list \n", inode->i_ino);
-       list_for_each_entry(io, &EXT4_I(inode)->i_completed_io_list, list){
-               cur = &io->list;
-               before = cur->prev;
-               io0 = container_of(before, ext4_io_end_t, list);
-               after = cur->next;
-               io1 = container_of(after, ext4_io_end_t, list);
+               pagevec_init(&pvec, 0);
+               nr_pages = pagevec_lookup_tag(&pvec, mapping, &index,
+                                             PAGECACHE_TAG_DIRTY,
+                                             (pgoff_t)PAGEVEC_SIZE);
+               if (nr_pages == 0)
+                       break;

-               ext4_debug("io 0x%p from inode %lu,prev 0x%p,next 0x%p\n",
-                           io, inode->i_ino, io0, io1);
-       }
-#endif
-}
+               /* start a new transaction*/
+               handle = ext4_journal_start(inode, needed_blocks);
+               if (IS_ERR(handle))
+                       break;

-/*
- * check a range of space and convert unwritten extents to written.
- */
-static int ext4_end_io_nolock(ext4_io_end_t *io)
-{
-       struct inode *inode = io->inode;
-       loff_t offset = io->offset;
-       size_t size = io->size;
-       int ret = 0;
+               mpd.b_size = 0;
+               mpd.b_state = 0;
+               mpd.b_blocknr = 0;
+               mpd.first_page = 0;
+               mpd.next_page = 0;
+               mpd.io_done = 0;
+               mpd.pages_written = 0;
+               mpd.retval = 0;

-       ext4_debug("ext4_end_io_nolock: io 0x%p from inode %lu,list->next 0x%p,"
-                  "list->prev 0x%p\n",
-                  io, inode->i_ino, io->list.next, io->list.prev);
+               do {
+                       for (i = 0; i < nr_pages; i++) {
+                               struct page *page = pvec.pages[i];

-       if (list_empty(&io->list))
-               return ret;
+                               lock_page(page);
+                               if (unlikely(page->mapping != mapping) ||
+                                   !PageDirty(page) ||
+                                   PageWriteback(page)) {
+                                       unlock_page(page);
+                                       continue;
+                               }

-       if (io->flag != EXT4_IO_WRITTEN)
-               return ret;
+                               ret = flush_alloc_da_page(page, &mpd);
+                               if (ret) {
+                                       pagevec_release(&pvec);
+                                       goto map_extent;
+                               }
+                       }
+                       pagevec_release(&pvec);
+                       cond_resched();

-       ret = ext4_convert_unwritten_extents(inode, offset, size);
-       if (ret < 0) {
-               printk(KERN_EMERG "%s: failed to convert unwritten"
-                       "extents to written extents, error is %d"
-                       " io is still on inode %lu aio dio list\n",
-                       __func__, ret, inode->i_ino);
-               return ret;
-       }
+                       nr_pages = pagevec_lookup_tag(&pvec, mapping, &index,
+                                                     PAGECACHE_TAG_DIRTY,
+                                                     (pgoff_t)PAGEVEC_SIZE);
+               } while (nr_pages);

-       /* clear the DIO AIO unwritten flag */
-       io->flag = 0;
-       return ret;
-}
+               /*
+                * If we have a contigous extent of pages and we
+                * haven't done the I/O yet, map the blocks and submit
+                * them for I/O.
+                */
+       map_extent:
+               if (!mpd.io_done && mpd.next_page != mpd.first_page) {
+                       printk(KERN_INFO
+                              "ext4_alloc_da_blocks map_blocks: "
+                              "ino %lu blk %llu, size %u\n",
+                              mpd.inode->i_ino, mpd.b_blocknr,
+                              mpd.b_size >> mpd.inode->i_blkbits);
+                       mpage_da_map_blocks(&mpd);
+               }

-/*
- * work on completed aio dio IO, to convert unwritten extents to extents
- */
-static void ext4_end_io_work(struct work_struct *work)
-{
-       ext4_io_end_t *io  = container_of(work, ext4_io_end_t, work);
-       struct inode *inode = io->inode;
-       int ret = 0;
+               ext4_journal_stop(handle);

-       mutex_lock(&inode->i_mutex);
-       ret = ext4_end_io_nolock(io);
-       if (ret >= 0) {
-               if (!list_empty(&io->list))
-                       list_del_init(&io->list);
-               ext4_free_io_end(io);
+               if ((mpd.retval == -ENOSPC) && sbi->s_journal) {
+                       /* commit the transaction which would
+                        * free blocks released in the transaction
+                        * and try again
+                        */
+                       jbd2_journal_force_commit_nested(sbi->s_journal);
+               }
       }
-       mutex_unlock(&inode->i_mutex);
+       printk(KERN_INFO "ext4_alloc_da_pages(%lu) exit\n", inode->i_ino);
+       return ret;
 }
+#endif

 /*
- * This function is called from ext4_sync_file().
+ * bmap() is special.  It gets used by applications such as lilo and by
+ * the swapper to find the on-disk block of a specific piece of data.
 *
- * When IO is completed, the work to convert unwritten extents to
- * written is queued on workqueue but may not get immediately
- * scheduled. When fsync is called, we need to ensure the
- * conversion is complete before fsync returns.
- * The inode keeps track of a list of pending/completed IO that
- * might needs to do the conversion. This function walks through
- * the list and convert the related unwritten extents for completed IO
- * to written.
- * The function return the number of pending IOs on success.
+ * Naturally, this is dangerous if the block concerned is still in the
+ * journal.  If somebody makes a swapfile on an ext4 data-journaling
+ * filesystem and enables swap, then they may get a nasty shock when the
+ * data getting swapped to that swapfile suddenly gets overwritten by
+ * the original zero's written out previously to the journal and
+ * awaiting writeback in the kernel's buffer cache.
+ *
+ * So, if we see any bmap calls here on a modified, data-journaled file,
+ * take extra steps to flush any blocks which might be in the cache.
 */
-int flush_completed_IO(struct inode *inode)
+static sector_t ext4_bmap(struct address_space *mapping, sector_t block)
 {
-       ext4_io_end_t *io, *tmp;
-       int ret = 0;
-       int ret2 = 0;
+       struct inode *inode = mapping->host;
+       journal_t *journal;
+       int err;

-       if (list_empty(&EXT4_I(inode)->i_completed_io_list))
-               return ret;
+       if (mapping_tagged(mapping, PAGECACHE_TAG_DIRTY) &&
+                       test_opt(inode->i_sb, DELALLOC)) {
+               /*
+                * With delalloc we want to sync the file
+                * so that we can make sure we allocate
+                * blocks for file
+                */
+               filemap_write_and_wait(mapping);
+       }

-       dump_completed_IO(inode);
-       list_for_each_entry_safe(io, tmp,
-                       &EXT4_I(inode)->i_completed_io_list, list) {
-               if (io->flag == EXT4_IO_UNWRITTEN)
-                       continue;
+       if (EXT4_JOURNAL(inode) && EXT4_I(inode)->i_state & EXT4_STATE_JDATA) {
               /*
-                * Calling ext4_end_io_nolock() to convert completed
-                * IO to written.
+                * This is a REALLY heavyweight approach, but the use of
+                * bmap on dirty files is expected to be extremely rare:
+                * only if we run lilo or swapon on a freshly made file
+                * do we expect this to happen.
                *
-                * When ext4_sync_file() is called, run_queue() may already
-                * about to flush the work corresponding to this io structure.
-                * It will be upset if it founds the io structure related
-                * to the work-to-be schedule is freed.
+                * (bmap requires CAP_SYS_RAWIO so this does not
+                * represent an unprivileged user DOS attack --- we'd be
+                * in trouble if mortal users could trigger this path at
+                * will.)
                *
-                * Thus we need to keep the io structure still valid here after
-                * convertion finished. The io structure has a flag to
-                * avoid double converting from both fsync and background work
-                * queue work.
+                * NB. EXT4_STATE_JDATA is not set on files other than
+                * regular files.  If somebody wants to bmap a directory
+                * or symlink and gets confused because the buffer
+                * hasn't yet been flushed to disk, they deserve
+                * everything they get.
                */
-               ret = ext4_end_io_nolock(io);
-               if (ret < 0)
-                       ret2 = ret;
-               else
-                       list_del_init(&io->list);
-       }
-       return (ret2 < 0) ? ret2 : 0;
-}
-
-static ext4_io_end_t *ext4_init_io_end (struct inode *inode)
-{
-       ext4_io_end_t *io = NULL;

-       io = kmalloc(sizeof(*io), GFP_NOFS);
+               EXT4_I(inode)->i_state &= ~EXT4_STATE_JDATA;
+               journal = EXT4_JOURNAL(inode);
+               jbd2_journal_lock_updates(journal);
+               err = jbd2_journal_flush(journal);
+               jbd2_journal_unlock_updates(journal);

-       if (io) {
-               igrab(inode);
-               io->inode = inode;
-               io->flag = 0;
-               io->offset = 0;
-               io->size = 0;
-               io->error = 0;
-               INIT_WORK(&io->work, ext4_end_io_work);
-               INIT_LIST_HEAD(&io->list);
+               if (err)
+                       return 0;
       }

-       return io;
+       return generic_block_bmap(mapping, block, ext4_get_block);
 }

-static void ext4_end_io_dio(struct kiocb *iocb, loff_t offset,
-                           ssize_t size, void *private)
+static int ext4_readpage(struct file *file, struct page *page)
 {
-        ext4_io_end_t *io_end = iocb->private;
-       struct workqueue_struct *wq;
-
-       /* if not async direct IO or dio with 0 bytes write, just return */
-       if (!io_end || !size)
-               return;
-
-       ext_debug("ext4_end_io_dio(): io_end 0x%p"
-                 "for inode %lu, iocb 0x%p, offset %llu, size %llu\n",
-                 iocb->private, io_end->inode->i_ino, iocb, offset,
-                 size);
+       return mpage_readpage(page, ext4_get_block);
+}

-       /* if not aio dio with unwritten extents, just free io and return */
-       if (io_end->flag != EXT4_IO_UNWRITTEN){
-               ext4_free_io_end(io_end);
-               iocb->private = NULL;
-               return;
-       }
+static int
+ext4_readpages(struct file *file, struct address_space *mapping,
+               struct list_head *pages, unsigned nr_pages)
+{
+       return mpage_readpages(mapping, pages, nr_pages, ext4_get_block);
+}

-       io_end->offset = offset;
-       io_end->size = size;
-       io_end->flag = EXT4_IO_WRITTEN;
-       wq = EXT4_SB(io_end->inode->i_sb)->dio_unwritten_wq;
+static void ext4_invalidatepage(struct page *page, unsigned long offset)
+{
+       journal_t *journal = EXT4_JOURNAL(page->mapping->host);

-       /* queue the work to convert unwritten extents to written */
-       queue_work(wq, &io_end->work);
+       /*
+        * If it's a full truncate we just forget about the pending dirtying
+        */
+       if (offset == 0)
+               ClearPageChecked(page);

-       /* Add the io_end to per-inode completed aio dio list*/
-       list_add_tail(&io_end->list,
-                &EXT4_I(io_end->inode)->i_completed_io_list);
-       iocb->private = NULL;
+       if (journal)
+               jbd2_journal_invalidatepage(journal, page, offset);
+       else
+               block_invalidatepage(page, offset);
 }

-static void ext4_end_io_buffer_write(struct buffer_head *bh, int uptodate)
+static int ext4_releasepage(struct page *page, gfp_t wait)
 {
-       ext4_io_end_t *io_end = bh->b_private;
-       struct workqueue_struct *wq;
+       journal_t *journal = EXT4_JOURNAL(page->mapping->host);

-       if (!io_end)
-               goto out;
-       io_end->flag = EXT4_IO_WRITTEN;
-       wq = EXT4_SB(io_end->inode->i_sb)->dio_unwritten_wq;
-       /* queue the work to convert unwritten extents to written */
-       queue_work(wq, &io_end->work);
-out:
-       bh->b_private = NULL;
-       bh->b_end_io = NULL;
-       clear_buffer_uninit(bh);
-       end_buffer_async_write(bh, uptodate);
+       WARN_ON(PageChecked(page));
+       if (!page_has_buffers(page))
+               return 0;
+       if (journal)
+               return jbd2_journal_try_to_free_buffers(journal, page, wait);
+       else
+               return try_to_free_buffers(page);
 }

-static int ext4_set_bh_endio(struct buffer_head *bh, struct inode *inode)
+/*
+ * O_DIRECT for ext3 (or indirect map) based files
+ *
+ * If the O_DIRECT write will extend the file then add this inode to the
+ * orphan list.  So recovery will truncate it back to the original size
+ * if the machine crashes during the write.
+ *
+ * If the O_DIRECT write is intantiating holes inside i_size and the machine
+ * crashes then stale disk data _may_ be exposed inside the file. But current
+ * VFS code falls back into buffered path in that case so we are safe.
+ */
+static ssize_t ext4_ind_direct_IO(int rw, struct kiocb *iocb,
+                             const struct iovec *iov, loff_t offset,
+                             unsigned long nr_segs)
 {
-       ext4_io_end_t *io_end;
-       struct page *page = bh->b_page;
-       loff_t offset = (sector_t)page->index << PAGE_CACHE_SHIFT;
-       size_t size = bh->b_size;
+       struct file *file = iocb->ki_filp;
+       struct inode *inode = file->f_mapping->host;
+       struct ext4_inode_info *ei = EXT4_I(inode);
+       handle_t *handle;
+       ssize_t ret;
+       int orphan = 0;
+       size_t count = iov_length(iov, nr_segs);
+       int retries = 0;

-       io_end = ext4_init_io_end(inode);
-       if (!io_end)
-               return -ENOMEM;
-       io_end->offset = offset;
-       io_end->size = size;
-       io_end->flag = EXT4_IO_UNWRITTEN;
-       /* Add the io_end to per-inode completed io list*/
-       list_add_tail(&io_end->list,
-                &EXT4_I(io_end->inode)->i_completed_io_list);
+       if (rw == WRITE) {
+               loff_t final_size = offset + count;

-       bh->b_private = io_end;
-       bh->b_end_io = ext4_end_io_buffer_write;
-       return 0;
+               if (final_size > inode->i_size) {
+                       /* Credits for sb + inode write */
+                       handle = ext4_journal_start(inode, 2);
+                       if (IS_ERR(handle)) {
+                               ret = PTR_ERR(handle);
+                               goto out;
+                       }
+                       ret = ext4_orphan_add(handle, inode);
+                       if (ret) {
+                               ext4_journal_stop(handle);
+                               goto out;
+                       }
+                       orphan = 1;
+                       ei->i_disksize = inode->i_size;
+                       ext4_journal_stop(handle);
+               }
+       }
+
+retry:
+       if (rw == READ && test_opt(inode->i_sb, DIOREAD_NOLOCK)
+                       && (EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL))
+               ret = blockdev_direct_IO_no_locking(rw, iocb, inode,
+                                inode->i_sb->s_bdev, iov,
+                                offset, nr_segs,
+                                ext4_get_block, NULL);
+       else
+               ret = blockdev_direct_IO(rw, iocb, inode,
+                                inode->i_sb->s_bdev, iov,
+                                offset, nr_segs,
+                                ext4_get_block, NULL);
+       if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
+               goto retry;
+
+       if (orphan) {
+               int err;
+
+               /* Credits for sb + inode write */
+               handle = ext4_journal_start(inode, 2);
+               if (IS_ERR(handle)) {
+                       /* This is really bad luck. We've written the data
+                        * but cannot extend i_size. Bail out and pretend
+                        * the write failed... */
+                       ret = PTR_ERR(handle);
+                       goto out;
+               }
+               if (inode->i_nlink)
+                       ext4_orphan_del(handle, inode);
+               if (ret > 0) {
+                       loff_t end = offset + ret;
+                       if (end > inode->i_size) {
+                               ei->i_disksize = end;
+                               i_size_write(inode, end);
+                               /*
+                                * We're going to return a positive `ret'
+                                * here due to non-zero-length I/O, so there's
+                                * no way of reporting error returns from
+                                * ext4_mark_inode_dirty() to userspace.  So
+                                * ignore it.
+                                */
+                               ext4_mark_inode_dirty(handle, inode);
+                       }
+               }
+               err = ext4_journal_stop(handle);
+               if (ret == 0)
+                       ret = err;
+       }
+out:
+       return ret;
 }

 /*
