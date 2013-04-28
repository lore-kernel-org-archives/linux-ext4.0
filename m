From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH] ext4: fix fio regression
Date: Sun, 28 Apr 2013 17:07:38 +0800
Message-ID: <20130428090738.GA3273@gmail.com>
References: <1367127934-4321-1-git-send-email-zheng.z.yan@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, wenqing.lz@taobao.com, tytso@mit.edu,
	lkp@linux.intel.com, lkp@01.org
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f44.google.com ([209.85.210.44]:48613 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866Ab3D1IuK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 28 Apr 2013 04:50:10 -0400
Received: by mail-da0-f44.google.com with SMTP id z20so1082409dae.31
        for <linux-ext4@vger.kernel.org>; Sun, 28 Apr 2013 01:50:10 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1367127934-4321-1-git-send-email-zheng.z.yan@intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Apr 28, 2013 at 01:45:34PM +0800, Yan, Zheng wrote:
> From: "Yan, Zheng" <zheng.z.yan@intel.com>
> 
> We (Linux Kernel Performance project) found a regression introduced
> by commit:
> 
>   f7fec032aa ext4: track all extent status in extent status tree
> 
> The commit causes about 20% performance decrease in fio random write
> test. Profiler shows that rb_next() uses a lot of CPU time. The call
> stack is:
> 
>   rb_next
>   ext4_es_find_delayed_extent
>   ext4_map_blocks
>   _ext4_get_block
>   ext4_get_block_write
>   __blockdev_direct_IO
>   ext4_direct_IO
>   generic_file_direct_write
>   __generic_file_aio_write
>   ext4_file_write
>   aio_rw_vect_retry
>   aio_run_iocb
>   do_io_submit
>   sys_io_submit
>   system_call_fastpath
>   io_submit
>   td_io_getevents
>   io_u_queued_complete
>   thread_main
>   main
>   __libc_start_main
> 
> The cause is that ext4_es_find_delayed_extent() doesn't have an
> upper bound, it keeps searching until a delayed extent is found.
> When there are a lots of non-delayed entries in the extent state
> tree, ext4_es_find_delayed_extent() may uses a lot of CPU time.
> 
> Reported-by: LKP project <lkp@linux.intel.com>
> Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>

Hi Zheng,

Thanks for fixing this regression.  The patch looks good to me.
Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>

Otherwise, I improve your patch.  Could you plese give it a try?

Thanks,
                                                - Zheng

Subject: [PATCH] ext4: fix fio regression

From: "Yan, Zheng" <zheng.z.yan@intel.com>

We (Linux Kernel Performance project) found a regression introduced
by commit:

  f7fec032aa ext4: track all extent status in extent status tree

The commit causes about 20% performance decrease in fio random write
test. Profiler shows that rb_next() uses a lot of CPU time. The call
stack is:

  rb_next
  ext4_es_find_delayed_extent
  ext4_map_blocks
  _ext4_get_block
  ext4_get_block_write
  __blockdev_direct_IO
  ext4_direct_IO
  generic_file_direct_write
  __generic_file_aio_write
  ext4_file_write
  aio_rw_vect_retry
  aio_run_iocb
  do_io_submit
  sys_io_submit
  system_call_fastpath
  io_submit
  td_io_getevents
  io_u_queued_complete
  thread_main
  main
  __libc_start_main

The cause is that ext4_es_find_delayed_extent() doesn't have an
upper bound, it keeps searching until a delayed extent is found.
When there are a lots of non-delayed entries in the extent state
tree, ext4_es_find_delayed_extent() may uses a lot of CPU time.

Reported-by: LKP project <lkp@linux.intel.com>
Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
changelog:
 * rename ext4_es_find_delayed_extent with ext4_es_find_delayed_extent_range
 * add a BUG_ON in ext4_es_find_delayed_extent_range
 * don't find a delayed extent in ext4_find_delayed_extent when es_pblk != 0
 * search a delayed extent in a given range

 fs/ext4/extents.c           | 10 ++++++----
 fs/ext4/extents_status.c    | 17 ++++++++++++-----
 fs/ext4/extents_status.h    |  3 ++-
 fs/ext4/file.c              |  4 ++--
 include/trace/events/ext4.h |  4 ++--
 5 files changed, 24 insertions(+), 14 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 107936d..1da3c0c 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3642,7 +3642,7 @@ int ext4_find_delalloc_range(struct inode *inode,
 {
 	struct extent_status es;
 
-	ext4_es_find_delayed_extent(inode, lblk_start, &es);
+	ext4_es_find_delayed_extent_range(inode, lblk_start, lblk_end, &es);
 	if (es.es_len == 0)
 		return 0; /* there is no delay extent in this tree */
 	else if (es.es_lblk <= lblk_start &&
@@ -4608,9 +4608,11 @@ static int ext4_find_delayed_extent(struct inode *inode,
 	struct extent_status es;
 	ext4_lblk_t block, next_del;
 
-	ext4_es_find_delayed_extent(inode, newes->es_lblk, &es);
-
 	if (newes->es_pblk == 0) {
+		ext4_es_find_delayed_extent_range(inode, newes->es_lblk,
+						  newes->es_lblk + newes->es_len,
+						  &es);
+
 		/*
 		 * No extent in extent-tree contains block @newes->es_pblk,
 		 * then the block may stay in 1)a hole or 2)delayed-extent.
@@ -4630,7 +4632,7 @@ static int ext4_find_delayed_extent(struct inode *inode,
 	}
 
 	block = newes->es_lblk + newes->es_len;
-	ext4_es_find_delayed_extent(inode, block, &es);
+	ext4_es_find_delayed_extent_range(inode, block, EXT_MAX_BLOCKS, &es);
 	if (es.es_len == 0)
 		next_del = EXT_MAX_BLOCKS;
 	else
diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
index fe3337a..e6941e6 100644
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -232,14 +232,16 @@ static struct extent_status *__es_tree_search(struct rb_root *root,
 }
 
 /*
- * ext4_es_find_delayed_extent: find the 1st delayed extent covering @es->lblk
- * if it exists, otherwise, the next extent after @es->lblk.
+ * ext4_es_find_delayed_extent_range: find the 1st delayed extent covering
+ * @es->lblk if it exists, otherwise, the next extent after @es->lblk.
  *
  * @inode: the inode which owns delayed extents
  * @lblk: the offset where we start to search
+ * @end: the offset where we stop to search
  * @es: delayed extent that we found
  */
-void ext4_es_find_delayed_extent(struct inode *inode, ext4_lblk_t lblk,
+void ext4_es_find_delayed_extent_range(struct inode *inode,
+				 ext4_lblk_t lblk, ext4_lblk_t end,
 				 struct extent_status *es)
 {
 	struct ext4_es_tree *tree = NULL;
@@ -247,7 +249,8 @@ void ext4_es_find_delayed_extent(struct inode *inode, ext4_lblk_t lblk,
 	struct rb_node *node;
 
 	BUG_ON(es == NULL);
-	trace_ext4_es_find_delayed_extent_enter(inode, lblk);
+	BUG_ON(end < lblk);
+	trace_ext4_es_find_delayed_extent_range_enter(inode, lblk);
 
 	read_lock(&EXT4_I(inode)->i_es_lock);
 	tree = &EXT4_I(inode)->i_es_tree;
@@ -270,6 +273,10 @@ out:
 	if (es1 && !ext4_es_is_delayed(es1)) {
 		while ((node = rb_next(&es1->rb_node)) != NULL) {
 			es1 = rb_entry(node, struct extent_status, rb_node);
+			if (es1->es_lblk > end) {
+				es1 = NULL;
+				break;
+			}
 			if (ext4_es_is_delayed(es1))
 				break;
 		}
@@ -285,7 +292,7 @@ out:
 	read_unlock(&EXT4_I(inode)->i_es_lock);
 
 	ext4_es_lru_add(inode);
-	trace_ext4_es_find_delayed_extent_exit(inode, es);
+	trace_ext4_es_find_delayed_extent_range_exit(inode, es);
 }
 
 static struct extent_status *
diff --git a/fs/ext4/extents_status.h b/fs/ext4/extents_status.h
index d8e2d4d..f740eb03 100644
--- a/fs/ext4/extents_status.h
+++ b/fs/ext4/extents_status.h
@@ -62,7 +62,8 @@ extern int ext4_es_insert_extent(struct inode *inode, ext4_lblk_t lblk,
 				 unsigned long long status);
 extern int ext4_es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
 				 ext4_lblk_t len);
-extern void ext4_es_find_delayed_extent(struct inode *inode, ext4_lblk_t lblk,
+extern void ext4_es_find_delayed_extent_range(struct inode *inode,
+					ext4_lblk_t lblk, ext4_lblk_t end,
 					struct extent_status *es);
 extern int ext4_es_lookup_extent(struct inode *inode, ext4_lblk_t lblk,
 				 struct extent_status *es);
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 64848b5..1bc4523 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -464,7 +464,7 @@ static loff_t ext4_seek_data(struct file *file, loff_t offset, loff_t maxsize)
 		 * If there is a delay extent at this offset,
 		 * it will be as a data.
 		 */
-		ext4_es_find_delayed_extent(inode, last, &es);
+		ext4_es_find_delayed_extent_range(inode, last, last, &es);
 		if (es.es_len != 0 && in_range(last, es.es_lblk, es.es_len)) {
 			if (last != start)
 				dataoff = last << blkbits;
@@ -547,7 +547,7 @@ static loff_t ext4_seek_hole(struct file *file, loff_t offset, loff_t maxsize)
 		 * If there is a delay extent at this offset,
 		 * we will skip this extent.
 		 */
-		ext4_es_find_delayed_extent(inode, last, &es);
+		ext4_es_find_delayed_extent_range(inode, last, last, &es);
 		if (es.es_len != 0 && in_range(last, es.es_lblk, es.es_len)) {
 			last = es.es_lblk + es.es_len;
 			holeoff = last << blkbits;
diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
index d0e6864..8ee15b9 100644
--- a/include/trace/events/ext4.h
+++ b/include/trace/events/ext4.h
@@ -2139,7 +2139,7 @@ TRACE_EVENT(ext4_es_remove_extent,
 		  __entry->lblk, __entry->len)
 );
 
-TRACE_EVENT(ext4_es_find_delayed_extent_enter,
+TRACE_EVENT(ext4_es_find_delayed_extent_range_enter,
 	TP_PROTO(struct inode *inode, ext4_lblk_t lblk),
 
 	TP_ARGS(inode, lblk),
@@ -2161,7 +2161,7 @@ TRACE_EVENT(ext4_es_find_delayed_extent_enter,
 		  (unsigned long) __entry->ino, __entry->lblk)
 );
 
-TRACE_EVENT(ext4_es_find_delayed_extent_exit,
+TRACE_EVENT(ext4_es_find_delayed_extent_range_exit,
 	TP_PROTO(struct inode *inode, struct extent_status *es),
 
 	TP_ARGS(inode, es),
-- 
1.7.12.rc2.18.g61b472e

