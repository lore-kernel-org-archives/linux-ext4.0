From: Dmitriy Monakhov <dmonakhov@openvz.org>
Subject: [PATCH] :EXT[3,4] jbd layer function called instead of fs specific one
Date: Sun, 28 Jan 2007 16:18:24 +0300
Message-ID: <873b5vmgrj.fsf@sw.ru>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Cc: ext4 development <linux-ext4@vger.kernel.org>, <devel@openvz.org>
To: linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.233.200]:6440 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932173AbXA1NSI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 28 Jan 2007 08:18:08 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

--=-=-=

jbd function called instead of fs specific one.

Signed-off-by: Dmitriy Monakhov <dmonakhov@openvz.org>
------

--=-=-=
Content-Disposition: inline; filename=diff-ms-fs-ext_3_4-cleanup

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index beaf25f..8a824f4 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -947,7 +947,7 @@ out:
 static int ext3_get_block(struct inode *inode, sector_t iblock,
 			struct buffer_head *bh_result, int create)
 {
-	handle_t *handle = journal_current_handle();
+	handle_t *handle = ext3_journal_current_handle();
 	int ret = 0;
 	unsigned max_blocks = bh_result->b_size >> inode->i_blkbits;
 
@@ -1717,7 +1717,7 @@ static ssize_t ext3_direct_IO(int rw, st
 	/*
 	 * Reacquire the handle: ext3_get_block() can restart the transaction
 	 */
-	handle = journal_current_handle();
+	handle = ext3_journal_current_handle();
 
 out_stop:
 	if (handle) {
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index a127cc0..fbff4b9 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -946,7 +946,7 @@ out:
 static int ext4_get_block(struct inode *inode, sector_t iblock,
 			struct buffer_head *bh_result, int create)
 {
-	handle_t *handle = journal_current_handle();
+	handle_t *handle = ext4_journal_current_handle();
 	int ret = 0;
 	unsigned max_blocks = bh_result->b_size >> inode->i_blkbits;
 
@@ -1716,7 +1716,7 @@ static ssize_t ext4_direct_IO(int rw, st
 	/*
 	 * Reacquire the handle: ext4_get_block() can restart the transaction
 	 */
-	handle = journal_current_handle();
+	handle = ext4_journal_current_handle();
 
 out_stop:
 	if (handle) {

--=-=-=--
