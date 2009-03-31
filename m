From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 1/2] [PATCH] ext4: Add inode to the orphan list during block allocation failure
Date: Tue, 31 Mar 2009 14:59:25 +0530
Message-ID: <1238491766-13182-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <20090331044544.GB5979@skywalker>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Jan Kara <jack@suse.cz>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:56357 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbZCaJ3q (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 31 Mar 2009 05:29:46 -0400
Received: from d23relay01.au.ibm.com (d23relay01.au.ibm.com [202.81.31.243])
	by e23smtp02.au.ibm.com (8.13.1/8.13.1) with ESMTP id n2V9SKK1031458
	for <linux-ext4@vger.kernel.org>; Tue, 31 Mar 2009 20:28:20 +1100
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay01.au.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n2V9TgFX450940
	for <linux-ext4@vger.kernel.org>; Tue, 31 Mar 2009 20:29:43 +1100
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n2V9TgWD022639
	for <linux-ext4@vger.kernel.org>; Tue, 31 Mar 2009 20:29:42 +1100
In-Reply-To: <20090331044544.GB5979@skywalker>
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
index 2231a65..074185f 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1424,7 +1424,7 @@ static int ext4_write_begin(struct file *file, struct address_space *mapping,
 				struct page **pagep, void **fsdata)
 {
 	struct inode *inode = mapping->host;
-	int ret, needed_blocks = ext4_writepage_trans_blocks(inode);
+	int ret, needed_blocks;
 	handle_t *handle;
 	int retries = 0;
 	struct page *page;
@@ -1435,6 +1435,11 @@ static int ext4_write_begin(struct file *file, struct address_space *mapping,
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
@@ -1468,14 +1473,20 @@ static int ext4_write_begin(struct file *file, struct address_space *mapping,
 
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
1.6.2.1.404.gb0085.dirty

