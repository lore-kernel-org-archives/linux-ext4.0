From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Fail migrate if we allocated new blocks via mmap write.
Date: Wed, 12 Mar 2008 14:23:46 +0530
Message-ID: <1205312026-9288-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:38493 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593AbYCLIxx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 12 Mar 2008 04:53:53 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp05.au.ibm.com (8.13.1/8.13.1) with ESMTP id m2C8rW6h007037
	for <linux-ext4@vger.kernel.org>; Wed, 12 Mar 2008 19:53:32 +1100
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m2C8roe04083868
	for <linux-ext4@vger.kernel.org>; Wed, 12 Mar 2008 19:53:50 +1100
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m2C8ruRZ028527
	for <linux-ext4@vger.kernel.org>; Wed, 12 Mar 2008 19:53:56 +1100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If we write to holes in the file via mmap, we endup allocating
new blocks. This block allocation happens without taking inode->i_mutex.
Since migrate is protected by i_mutex and migrate expect no
new blocks get allocated during migrate, count the total blocks
before and after migrate. If they differ fail migrate with EAGAIN.

We can't take inode->i_mutex in the mmap write path because that
would result in a locking order violation between i_mutex and mmap_sem.
Also adding a seprate rw_sempahore for protecion is really high overhead
for a rare operation such as migrate.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/inode.c   |    4 ----
 fs/ext4/migrate.c |   25 +++++++++++++++++++++++--
 2 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 059f2fc..a52904b 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3502,9 +3502,5 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct page *page)
 	 * access and zero out the page. The journal handle get initialized
 	 * in ext4_get_block.
 	 */
-	/* FIXME!! should we take inode->i_mutex ? Currently we can't because
-	 * it has a circular locking dependency with DIO. But migrate expect
-	 * i_mutex to ensure no i_data changes
-	 */
 	return block_page_mkwrite(vma, page, ext4_get_block);
 }
diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
index 5c1e27d..363f4f9 100644
--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -327,7 +327,7 @@ static int free_ind_block(handle_t *handle, struct inode *inode, __le32 *i_data)
 }
 
 static int ext4_ext_swap_inode_data(handle_t *handle, struct inode *inode,
-				struct inode *tmp_inode)
+				struct inode *tmp_inode, blkcnt_t total_blocks)
 {
 	int retval;
 	__le32	i_data[3];
@@ -351,6 +351,18 @@ static int ext4_ext_swap_inode_data(handle_t *handle, struct inode *inode,
 
 	down_write(&EXT4_I(inode)->i_data_sem);
 	/*
+	 * total number of blocks will be different if a mmap write
+	 * happened to holes in the file. We don't take
+	 * inode->i_lock spin lock here because block allocation
+	 * can't happen if we are holding i_data_sem
+	 */
+	if (total_blocks  != inode->i_blocks) {
+		retval = -EAGAIN;
+		up_write(&EXT4_I(inode)->i_data_sem);
+		goto err_out;
+
+	}
+	/*
 	 * We have the extent map build with the tmp inode.
 	 * Now copy the i_data across
 	 */
@@ -445,6 +457,7 @@ int ext4_ext_migrate(struct inode *inode, struct file *filp,
 	struct inode *tmp_inode = NULL;
 	struct list_blocks_struct lb;
 	unsigned long max_entries;
+	blkcnt_t total_blocks = 0;
 
 	if (!test_opt(inode->i_sb, EXTENTS))
 		/*
@@ -508,6 +521,14 @@ int ext4_ext_migrate(struct inode *inode, struct file *filp,
 	 * switch the inode format to prevent read.
 	 */
 	mutex_lock(&(inode->i_mutex));
+	/*
+	 * Even though we take i_mutex we can still cause block allocation
+	 * via mmap write to holes. If we have allocated new blocks we fail
+	 * migrate.
+	 */
+	spin_lock(&inode->i_lock);
+	total_blocks  = inode->i_blocks;
+	spin_unlock(&inode->i_lock);
 	handle = ext4_journal_start(inode, 1);
 
 	ei = EXT4_I(inode);
@@ -561,7 +582,7 @@ err_out:
 		free_ext_block(handle, tmp_inode);
 	else
 		retval = ext4_ext_swap_inode_data(handle, inode,
-							tmp_inode);
+						tmp_inode, total_blocks);
 
 	/* We mark the tmp_inode dirty via ext4_ext_tree_init. */
 	if (ext4_journal_extend(handle, 1) != 0)
-- 
1.5.4.4.481.g5075.dirty

