From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH RESEND 1/2] ext4: Add inode to the orphan list during block allocation failure
Date: Mon,  4 May 2009 14:43:00 +0530
Message-ID: <1241428381-13874-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Jan Kara <jack@suse.cz>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:36140 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737AbZEDJNG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 May 2009 05:13:06 -0400
Received: from d23relay01.au.ibm.com (d23relay01.au.ibm.com [202.81.31.243])
	by e23smtp04.au.ibm.com (8.13.1/8.13.1) with ESMTP id n449Atkv013823
	for <linux-ext4@vger.kernel.org>; Mon, 4 May 2009 19:10:55 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay01.au.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n449D5ME278998
	for <linux-ext4@vger.kernel.org>; Mon, 4 May 2009 19:13:05 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n449D4Xh003340
	for <linux-ext4@vger.kernel.org>; Mon, 4 May 2009 19:13:05 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We should add inode to the orphan list in the same transaction
as block allocation. This ensures that if we crash after a failed
block allocation and before we do a vmtruncate we don't leak block
(ie block marked as used in bitmap but not claimed by the inode).

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
CC:  Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 3e90965..28e95ee 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1426,7 +1426,7 @@ static int ext4_write_begin(struct file *file, struct address_space *mapping,
 				struct page **pagep, void **fsdata)
 {
 	struct inode *inode = mapping->host;
-	int ret, needed_blocks = ext4_writepage_trans_blocks(inode);
+	int ret, needed_blocks;
 	handle_t *handle;
 	int retries = 0;
 	struct page *page;
@@ -1437,6 +1437,11 @@ static int ext4_write_begin(struct file *file, struct address_space *mapping,
 		   "dev %s ino %lu pos %llu len %u flags %u",
 		   inode->i_sb->s_id, inode->i_ino,
 		   (unsigned long long) pos, len, flags);
+	/*
+	 * Reserve one block more for addition to orphan list in case
+	 * we allocate blocks but write fails for some reason
+	 */
+	needed_blocks = ext4_writepage_trans_blocks(inode) + 1;
  	index = pos >> PAGE_CACHE_SHIFT;
 	from = pos & (PAGE_CACHE_SIZE - 1);
 	to = from + len;
@@ -1470,14 +1475,20 @@ static int ext4_write_begin(struct file *file, struct address_space *mapping,
 
 	if (ret) {
 		unlock_page(page);
-		ext4_journal_stop(handle);
 		page_cache_release(page);
 		/*
 		 * block_write_begin may have instantiated a few blocks
 		 * outside i_size.  Trim these off again. Don't need
 		 * i_size_read because we hold i_mutex.
+		 *
+		 * Add inode to orphan list in case we crash before
+		 * truncate finishes
 		 */
 		if (pos + len > inode->i_size)
+			ext4_orphan_add(handle, inode);
+
+		ext4_journal_stop(handle);
+		if (pos + len > inode->i_size)
 			vmtruncate(inode, inode->i_size);
 	}
 
-- 
1.6.3.rc4

