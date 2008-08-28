From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Properly update i_disksize.
Date: Thu, 28 Aug 2008 22:57:53 +0530
Message-ID: <1219944473-8770-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1219944473-8770-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1219944473-8770-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:43224 "EHLO
	e28esmtp03.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753788AbYH1R2D (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Aug 2008 13:28:03 -0400
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28esmtp03.in.ibm.com (8.13.1/8.13.1) with ESMTP id m7SHS1ic020289
	for <linux-ext4@vger.kernel.org>; Thu, 28 Aug 2008 22:58:01 +0530
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7SHS1I61413146
	for <linux-ext4@vger.kernel.org>; Thu, 28 Aug 2008 22:58:01 +0530
Received: from d28av04.in.ibm.com (loopback [127.0.0.1])
	by d28av04.in.ibm.com (8.13.1/8.13.3) with ESMTP id m7SHS0W5010847
	for <linux-ext4@vger.kernel.org>; Thu, 28 Aug 2008 22:58:00 +0530
In-Reply-To: <1219944473-8770-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

With delayed allocation we use i_data_sem to update
i_disksize. We need to update i_disksize only
if the new size specified is greater than the
current value and we need to make sure we don't
race with other i_disksize update. With delayed
allocation we will switch to nondelalloc write_begin
if we are low on free blocks. That means nondelalloc
write_begin also need to use the same locking.

We also need to check and update i_disksize even
if the new size is less that inode.i_size because
of delayed allocation.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/ext4.h    |   11 +++++++++
 fs/ext4/extents.c |    9 ++++---
 fs/ext4/inode.c   |   61 ++++++++++++++++++++++++++++++++--------------------
 3 files changed, 53 insertions(+), 28 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 13c69ed..bc856e3 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1307,6 +1307,17 @@ do {								\
 #define EXT4_FREEBLOCKS_WATERMARK 0
 #endif
 
+static inline void ext4_update_i_disksize(struct inode *inode, loff_t newsize)
+{
+	/*
+	 * XXX: replace with spinlock if seen contended -bzzz
+	 */
+	down_write(&EXT4_I(inode)->i_data_sem);
+	if (newsize > EXT4_I(inode)->i_disksize)
+		EXT4_I(inode)->i_disksize = newsize;
+	up_write(&EXT4_I(inode)->i_data_sem);
+	return ;
+}
 
 /*
  * Inodes and files operations
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 268e96d..7def792 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3018,10 +3018,11 @@ static void ext4_falloc_update_inode(struct inode *inode,
 	 * Update only when preallocation was requested beyond
 	 * the file size.
 	 */
-	if (!(mode & FALLOC_FL_KEEP_SIZE) &&
-				new_size > i_size_read(inode)) {
-		i_size_write(inode, new_size);
-		EXT4_I(inode)->i_disksize = new_size;
+	if (!(mode & FALLOC_FL_KEEP_SIZE)) {
+		if (new_size > i_size_read(inode))
+			i_size_write(inode, new_size);
+		if (new_size > EXT4_I(inode)->i_disksize)
+			ext4_update_i_disksize(inode, new_size);
 	}
 
 }
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index a8c6bc8..605ae24 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1437,16 +1437,18 @@ static int ext4_ordered_write_end(struct file *file,
 	ret = ext4_jbd2_file_inode(handle, inode);
 
 	if (ret == 0) {
-		/*
-		 * generic_write_end() will run mark_inode_dirty() if i_size
-		 * changes.  So let's piggyback the i_disksize mark_inode_dirty
-		 * into that.
-		 */
 		loff_t new_i_size;
 
 		new_i_size = pos + copied;
-		if (new_i_size > EXT4_I(inode)->i_disksize)
-			EXT4_I(inode)->i_disksize = new_i_size;
+		if (new_i_size > EXT4_I(inode)->i_disksize) {
+			ext4_update_i_disksize(inode, new_i_size);
+			/* We need to mark inode dirty even if
+			 * new_i_size is less that inode->i_size
+			 * bu greater than i_disksize.(hint delalloc)
+			 */
+			ext4_mark_inode_dirty(handle, inode);
+		}
+
 		ret2 = generic_write_end(file, mapping, pos, len, copied,
 							page, fsdata);
 		copied = ret2;
@@ -1471,8 +1473,14 @@ static int ext4_writeback_write_end(struct file *file,
 	loff_t new_i_size;
 
 	new_i_size = pos + copied;
-	if (new_i_size > EXT4_I(inode)->i_disksize)
-		EXT4_I(inode)->i_disksize = new_i_size;
+	if (new_i_size > EXT4_I(inode)->i_disksize) {
+		ext4_update_i_disksize(inode, new_i_size);
+		/* We need to mark inode dirty even if
+		 * new_i_size is less that inode->i_size
+		 * bu greater than i_disksize.(hint delalloc)
+		 */
+		ext4_mark_inode_dirty(handle, inode);
+	}
 
 	ret2 = generic_write_end(file, mapping, pos, len, copied,
 							page, fsdata);
@@ -1497,6 +1505,7 @@ static int ext4_journalled_write_end(struct file *file,
 	int ret = 0, ret2;
 	int partial = 0;
 	unsigned from, to;
+	loff_t new_i_size;
 
 	from = pos & (PAGE_CACHE_SIZE - 1);
 	to = from + len;
@@ -1511,11 +1520,12 @@ static int ext4_journalled_write_end(struct file *file,
 				to, &partial, write_end_fn);
 	if (!partial)
 		SetPageUptodate(page);
-	if (pos+copied > inode->i_size)
+	new_i_size = pos + copied;
+	if (new_i_size > inode->i_size)
 		i_size_write(inode, pos+copied);
 	EXT4_I(inode)->i_state |= EXT4_STATE_JDATA;
-	if (inode->i_size > EXT4_I(inode)->i_disksize) {
-		EXT4_I(inode)->i_disksize = inode->i_size;
+	if (new_i_size > EXT4_I(inode)->i_disksize) {
+		ext4_update_i_disksize(inode, new_i_size);
 		ret2 = ext4_mark_inode_dirty(handle, inode);
 		if (!ret)
 			ret = ret2;
@@ -2227,18 +2237,9 @@ static int ext4_da_get_block_write(struct inode *inode, sector_t iblock,
 		if (disksize > i_size_read(inode))
 			disksize = i_size_read(inode);
 		if (disksize > EXT4_I(inode)->i_disksize) {
-			/*
-			 * XXX: replace with spinlock if seen contended -bzzz
-			 */
-			down_write(&EXT4_I(inode)->i_data_sem);
-			if (disksize > EXT4_I(inode)->i_disksize)
-				EXT4_I(inode)->i_disksize = disksize;
-			up_write(&EXT4_I(inode)->i_data_sem);
-
-			if (EXT4_I(inode)->i_disksize == disksize) {
-				ret = ext4_mark_inode_dirty(handle, inode);
-				return ret;
-			}
+			ext4_update_i_disksize(inode, disksize);
+			ret = ext4_mark_inode_dirty(handle, inode);
+			return ret;
 		}
 		ret = 0;
 	}
@@ -2567,6 +2568,13 @@ static int ext4_da_write_begin(struct file *file, struct address_space *mapping,
 		unlock_page(page);
 		ext4_journal_stop(handle);
 		page_cache_release(page);
+		/*
+		 * block_write_begin may have instantiated a few blocks
+		 * outside i_size.  Trim these off again. Don't need
+		 * i_size_read because we hold i_mutex.
+		 */
+		if (pos + len > inode->i_size)
+			vmtruncate(inode, inode->i_size);
 	}
 
 	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
@@ -2647,6 +2655,11 @@ static int ext4_da_write_end(struct file *file,
 				EXT4_I(inode)->i_disksize = new_i_size;
 			}
 			up_write(&EXT4_I(inode)->i_data_sem);
+			/* We need to mark inode dirty even if
+			 * new_i_size is less that inode->i_size
+			 * bu greater than i_disksize.(hint delalloc)
+			 */
+			ext4_mark_inode_dirty(handle, inode);
 		}
 	}
 	ret2 = generic_write_end(file, mapping, pos, len, copied,
-- 
1.6.0.1.90.g27a6e

