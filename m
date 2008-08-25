From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [RFC PATCH -v2] ext4: Switch to non delalloc mode when we are low on free blocks count.
Date: Mon, 25 Aug 2008 16:50:32 +0530
Message-ID: <1219663233-21849-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1219663233-21849-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1219663233-21849-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1219663233-21849-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1219663233-21849-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:39342 "EHLO
	e28esmtp05.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753236AbYHYLUm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Aug 2008 07:20:42 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28esmtp05.in.ibm.com (8.13.1/8.13.1) with ESMTP id m7PBKdYN025753
	for <linux-ext4@vger.kernel.org>; Mon, 25 Aug 2008 16:50:39 +0530
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7PBKbAW426056
	for <linux-ext4@vger.kernel.org>; Mon, 25 Aug 2008 16:50:38 +0530
Received: from d28av04.in.ibm.com (loopback [127.0.0.1])
	by d28av04.in.ibm.com (8.13.1/8.13.3) with ESMTP id m7PBKbkM014117
	for <linux-ext4@vger.kernel.org>; Mon, 25 Aug 2008 16:50:37 +0530
In-Reply-To: <1219663233-21849-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

delayed allocation allocate blocks during writepages. That also
means we cannot handle block allocation failures. Switch to
non - delalloc when we are running low on free blocks.
Delayed allocation need to do aggressive meta-data block reservation
considering that the requested blocks can all be discontiguous.
Switching to non-delalloc avoids that. Also we can satisfy
partial write in non-delalloc mode.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/inode.c |   48 ++++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 46 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 3f3ecc0..d923a14 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2482,6 +2482,29 @@ static int ext4_da_writepages(struct address_space *mapping,
 	return ret;
 }
 
+#define FALL_BACK_TO_NONDELALLOC 1
+static int ext4_nonda_switch(struct super_block *sb)
+{
+	s64 free_blocks, dirty_blocks;
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+
+	/*
+	 * switch to non delalloc mode if we are running low
+	 * on free block. The free block accounting via percpu
+	 * counters can get slightly wrong with FBC_BATCH getting
+	 * accumulated on each CPU without updating global counters
+	 * Delalloc need an accurate free block accounting. So switch
+	 * to non delalloc when we are near to error range.
+	 */
+	free_blocks  = percpu_counter_read_positive(&sbi->s_freeblocks_counter);
+	dirty_blocks = percpu_counter_read_positive(&sbi->s_dirtyblocks_counter);
+	if ( 2 * free_blocks < 3 * dirty_blocks) {
+		/* free block count is less that 150% of dirty blocks */
+		return 1;
+	}
+	return 0;
+}
+
 static int ext4_da_write_begin(struct file *file, struct address_space *mapping,
 				loff_t pos, unsigned len, unsigned flags,
 				struct page **pagep, void **fsdata)
@@ -2496,6 +2519,13 @@ static int ext4_da_write_begin(struct file *file, struct address_space *mapping,
 	index = pos >> PAGE_CACHE_SHIFT;
 	from = pos & (PAGE_CACHE_SIZE - 1);
 	to = from + len;
+
+	if (ext4_nonda_switch(inode->i_sb)) {
+		*fsdata = (void *)FALL_BACK_TO_NONDELALLOC;
+		return ext4_write_begin(file, mapping, pos,
+					len, flags, pagep, fsdata);
+	}
+	*fsdata = (void *)0;
 retry:
 	/*
 	 * With delayed allocation, we don't log the i_disksize update
@@ -2564,6 +2594,19 @@ static int ext4_da_write_end(struct file *file,
 	handle_t *handle = ext4_journal_current_handle();
 	loff_t new_i_size;
 	unsigned long start, end;
+	int write_mode = (int)fsdata;
+
+	if (write_mode == FALL_BACK_TO_NONDELALLOC) {
+		if (ext4_should_order_data(inode)) {
+			return ext4_ordered_write_end(file, mapping, pos,
+					len, copied, page, fsdata);
+		} else if (ext4_should_writeback_data(inode)) {
+			return ext4_writeback_write_end(file, mapping, pos,
+					len, copied, page, fsdata);
+		} else {
+			BUG();
+		}
+	}
 
 	start = pos & (PAGE_CACHE_SIZE - 1);
 	end = start + copied -1;
@@ -4901,6 +4944,7 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct page *page)
 	loff_t size;
 	unsigned long len;
 	int ret = -EINVAL;
+	void *fsdata;
 	struct file *file = vma->vm_file;
 	struct inode *inode = file->f_path.dentry->d_inode;
 	struct address_space *mapping = inode->i_mapping;
@@ -4939,11 +4983,11 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct page *page)
 	 * on the same page though
 	 */
 	ret = mapping->a_ops->write_begin(file, mapping, page_offset(page),
-			len, AOP_FLAG_UNINTERRUPTIBLE, &page, NULL);
+			len, AOP_FLAG_UNINTERRUPTIBLE, &page, &fsdata);
 	if (ret < 0)
 		goto out_unlock;
 	ret = mapping->a_ops->write_end(file, mapping, page_offset(page),
-			len, len, page, NULL);
+			len, len, page, fsdata);
 	if (ret < 0)
 		goto out_unlock;
 	ret = 0;
-- 
1.6.0.1.90.g27a6e

