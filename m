From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: Update for patches in patch queue
Date: Fri, 12 Sep 2008 14:37:23 +0530
Message-ID: <20080912090723.GB8405@skywalker>
References: <1221210148-26329-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1221210148-26329-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="hHWLQfXTYDoKhP50"
Cc: linux-ext4@vger.kernel.org
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:35067 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598AbYILJH7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 12 Sep 2008 05:07:59 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp05.au.ibm.com (8.13.1/8.13.1) with ESMTP id m8C96uOw010875
	for <linux-ext4@vger.kernel.org>; Fri, 12 Sep 2008 19:06:56 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m8C97qFc169782
	for <linux-ext4@vger.kernel.org>; Fri, 12 Sep 2008 19:07:52 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m8C97bLE011696
	for <linux-ext4@vger.kernel.org>; Fri, 12 Sep 2008 19:07:38 +1000
Content-Disposition: inline
In-Reply-To: <1221210148-26329-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--hHWLQfXTYDoKhP50
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

I guess git send-email did something wrong. I had these two patches as 
followup for the compose mail with this subject. Any how i am attaching
the patches below. The patches update
ext4_truncate_block_allocated_on_a_failed_ext4_write_begin.patch and 
ext4_i_disksize_lock_race_fix.patch by moving some changes from 
ext4_i_disksize_lock_race_fix.patch to the other.

-aneesh

--hHWLQfXTYDoKhP50
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="003-ext4_truncate_block_allocated_on_a_failed_ext4_write_begin.patch"

ext4: truncate block allocated on a failed ext4_write_begin

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

For blocksize < pagesize we need to remove blocks that
got allocte in block_wirte_begin if we fail with ENOSPC
for later blocks. block_write_begin internally does
this if it allocated page locally. This make sure
we don't have blocks outisde inode.i_size during
ENOSPC

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/inode.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 48534be..e7c84e4 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1391,6 +1391,13 @@ static int ext4_write_begin(struct file *file, struct address_space *mapping,
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
@@ -2560,6 +2567,13 @@ static int ext4_da_write_begin(struct file *file, struct address_space *mapping,
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

--hHWLQfXTYDoKhP50
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="002ext4_i_disksize_lock_race_fix.patch"

ext4: Properly update i_disksize.

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
--hHWLQfXTYDoKhP50--
