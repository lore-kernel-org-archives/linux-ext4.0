From: "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH] ext4: fix fio regression
Date: Sun, 28 Apr 2013 13:45:34 +0800
Message-ID: <1367127934-4321-1-git-send-email-zheng.z.yan@intel.com>
Cc: wenqing.lz@taobao.com, tytso@mit.edu, lkp@linux.intel.com,
	lkp@01.org, "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:54077 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750969Ab3D1Fpi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 28 Apr 2013 01:45:38 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

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
---
 fs/ext4/extents.c        | 6 +++---
 fs/ext4/extents_status.c | 8 +++++++-
 fs/ext4/extents_status.h | 3 ++-
 fs/ext4/file.c           | 4 ++--
 4 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 9c6d06d..466f78b 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3537,7 +3537,7 @@ int ext4_find_delalloc_range(struct inode *inode,
 {
 	struct extent_status es;
 
-	ext4_es_find_delayed_extent(inode, lblk_start, &es);
+	ext4_es_find_delayed_extent(inode, lblk_start, lblk_end, &es);
 	if (es.es_len == 0)
 		return 0; /* there is no delay extent in this tree */
 	else if (es.es_lblk <= lblk_start &&
@@ -4555,7 +4555,7 @@ static int ext4_find_delayed_extent(struct inode *inode,
 	struct extent_status es;
 	ext4_lblk_t block, next_del;
 
-	ext4_es_find_delayed_extent(inode, newes->es_lblk, &es);
+	ext4_es_find_delayed_extent(inode, newes->es_lblk, EXT_MAX_BLOCKS, &es);
 
 	if (newes->es_pblk == 0) {
 		/*
@@ -4577,7 +4577,7 @@ static int ext4_find_delayed_extent(struct inode *inode,
 	}
 
 	block = newes->es_lblk + newes->es_len;
-	ext4_es_find_delayed_extent(inode, block, &es);
+	ext4_es_find_delayed_extent(inode, block, EXT_MAX_BLOCKS, &es);
 	if (es.es_len == 0)
 		next_del = EXT_MAX_BLOCKS;
 	else
diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
index fe3337a..2c2f3b8 100644
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -237,9 +237,11 @@ static struct extent_status *__es_tree_search(struct rb_root *root,
  *
  * @inode: the inode which owns delayed extents
  * @lblk: the offset where we start to search
+ * @end: the offset where we stop to search
  * @es: delayed extent that we found
  */
-void ext4_es_find_delayed_extent(struct inode *inode, ext4_lblk_t lblk,
+void ext4_es_find_delayed_extent(struct inode *inode,
+				 ext4_lblk_t lblk, ext4_lblk_t end,
 				 struct extent_status *es)
 {
 	struct ext4_es_tree *tree = NULL;
@@ -270,6 +272,10 @@ out:
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
diff --git a/fs/ext4/extents_status.h b/fs/ext4/extents_status.h
index d8e2d4d..7d41c4a 100644
--- a/fs/ext4/extents_status.h
+++ b/fs/ext4/extents_status.h
@@ -62,7 +62,8 @@ extern int ext4_es_insert_extent(struct inode *inode, ext4_lblk_t lblk,
 				 unsigned long long status);
 extern int ext4_es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
 				 ext4_lblk_t len);
-extern void ext4_es_find_delayed_extent(struct inode *inode, ext4_lblk_t lblk,
+extern void ext4_es_find_delayed_extent(struct inode *inode,
+					ext4_lblk_t lblk, ext4_lblk_t end,
 					struct extent_status *es);
 extern int ext4_es_lookup_extent(struct inode *inode, ext4_lblk_t lblk,
 				 struct extent_status *es);
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 64848b5..52574ce6 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -464,7 +464,7 @@ static loff_t ext4_seek_data(struct file *file, loff_t offset, loff_t maxsize)
 		 * If there is a delay extent at this offset,
 		 * it will be as a data.
 		 */
-		ext4_es_find_delayed_extent(inode, last, &es);
+		ext4_es_find_delayed_extent(inode, last, last, &es);
 		if (es.es_len != 0 && in_range(last, es.es_lblk, es.es_len)) {
 			if (last != start)
 				dataoff = last << blkbits;
@@ -547,7 +547,7 @@ static loff_t ext4_seek_hole(struct file *file, loff_t offset, loff_t maxsize)
 		 * If there is a delay extent at this offset,
 		 * we will skip this extent.
 		 */
-		ext4_es_find_delayed_extent(inode, last, &es);
+		ext4_es_find_delayed_extent(inode, last, last, &es);
 		if (es.es_len != 0 && in_range(last, es.es_lblk, es.es_len)) {
 			last = es.es_lblk + es.es_len;
 			holeoff = last << blkbits;
-- 
1.8.1.4

