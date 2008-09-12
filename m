From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Update for patches in patch queue
Date: Fri, 12 Sep 2008 14:32:27 +0530
Message-ID: <1221210148-26329-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1221210148-26329-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:53686 "EHLO
	e28esmtp06.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750901AbYILJDe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 12 Sep 2008 05:03:34 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28esmtp06.in.ibm.com (8.13.1/8.13.1) with ESMTP id m8C93Us7014799
	for <linux-ext4@vger.kernel.org>; Fri, 12 Sep 2008 14:33:30 +0530
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m8C93306778290
	for <linux-ext4@vger.kernel.org>; Fri, 12 Sep 2008 14:33:30 +0530
Received: from d28av03.in.ibm.com (loopback [127.0.0.1])
	by d28av03.in.ibm.com (8.13.1/8.13.3) with ESMTP id m8C932h3002309
	for <linux-ext4@vger.kernel.org>; Fri, 12 Sep 2008 19:03:03 +1000
In-Reply-To: <1221210148-26329-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

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
 fs/ext4/ext4.h    |   11 +++++++++++
 fs/ext4/extents.c |    9 +++++----
 fs/ext4/inode.c   |   54 +++++++++++++++++++++++++++++------------------------
 3 files changed, 46 insertions(+), 28 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 79bdcd8..9fb7796 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1219,6 +1219,17 @@ do {								\
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
index b24d3c5..cbf388a 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2877,10 +2877,11 @@ static void ext4_falloc_update_inode(struct inode *inode,
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
index e7c84e4..a06a4a8 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1434,16 +1434,18 @@ static int ext4_ordered_write_end(struct file *file,
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
@@ -1468,8 +1470,14 @@ static int ext4_writeback_write_end(struct file *file,
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
@@ -1494,6 +1502,7 @@ static int ext4_journalled_write_end(struct file *file,
 	int ret = 0, ret2;
 	int partial = 0;
 	unsigned from, to;
+	loff_t new_i_size;
 
 	from = pos & (PAGE_CACHE_SIZE - 1);
 	to = from + len;
@@ -1508,11 +1517,12 @@ static int ext4_journalled_write_end(struct file *file,
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
