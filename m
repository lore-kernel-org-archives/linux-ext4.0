From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V2 1/2] ext4: Add inode to the orphan list during block allocation failure
Date: Mon,  8 Jun 2009 10:05:14 +0530
Message-ID: <1244435715-6807-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <20090605234458.GG11650@duck.suse.cz>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Jan Kara <jack@suse.cz>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:55412 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbZFHEfY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Jun 2009 00:35:24 -0400
Received: from d23relay01.au.ibm.com (d23relay01.au.ibm.com [202.81.31.243])
	by e23smtp08.au.ibm.com (8.13.1/8.13.1) with ESMTP id n58EYcFQ008422
	for <linux-ext4@vger.kernel.org>; Tue, 9 Jun 2009 00:34:38 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay01.au.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n584ZLRc397750
	for <linux-ext4@vger.kernel.org>; Mon, 8 Jun 2009 14:35:23 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n584ZKQL016050
	for <linux-ext4@vger.kernel.org>; Mon, 8 Jun 2009 14:35:21 +1000
In-Reply-To: <20090605234458.GG11650@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We should add inode to the orphan list in the same transaction
as block allocation. This ensures that if we crash after a failed
block allocation and before we do a vmtruncate we don't leak block
(ie block marked as used in bitmap but not claimed by the inode).

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
CC:  Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c |   22 ++++++++++++++++++++--
 1 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 00ebc99..820cb58 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1459,7 +1459,7 @@ static int ext4_write_begin(struct file *file, struct address_space *mapping,
 				struct page **pagep, void **fsdata)
 {
 	struct inode *inode = mapping->host;
-	int ret, needed_blocks = ext4_writepage_trans_blocks(inode);
+	int ret, needed_blocks;
 	handle_t *handle;
 	int retries = 0;
 	struct page *page;
@@ -1470,6 +1470,11 @@ static int ext4_write_begin(struct file *file, struct address_space *mapping,
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
@@ -1503,14 +1508,20 @@ static int ext4_write_begin(struct file *file, struct address_space *mapping,
 
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
 
@@ -1519,6 +1530,13 @@ static int ext4_write_begin(struct file *file, struct address_space *mapping,
 out:
 	if (ret)
 		block_unlock_hole_extend(inode);
+	/*
+	 * if vmtruncate failed to remove the inode from
+	 * orphan list remove ourself
+	 */
+	if (inode->i_nlink)
+		ext4_orphan_del(NULL, inode);
+
 	return ret;
 }
 
-- 
1.6.3.1.244.gf9275

