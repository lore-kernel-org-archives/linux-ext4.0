From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 1/2] ext4: Recalculate journal credits as inode depth changes
Date: Tue,  9 Jun 2015 08:58:45 +0200
Message-ID: <1433833126-28575-1-git-send-email-lczerner@redhat.com>
Cc: Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45822 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752105AbbFIG6x (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Jun 2015 02:58:53 -0400
Received: from int-mx13.intmail.prod.int.phx2.redhat.com (int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id 6439EBAEF2
	for <linux-ext4@vger.kernel.org>; Tue,  9 Jun 2015 06:58:53 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently in ext4_alloc_file_blocks() the number of credits is
calculated only once before we enter the allocation loop. However within
the allocation loop the extent tree depth can change, hence the number
of credits needed can increase potentially exceeding the number of credits
reserved in the handle which can cause journal failures.

Fix this by recalculating number of credits when the inode depth
changes. Note that even though ext4_alloc_file_blocks() is only
currently used by extent base inodes we will avoid recalculating number
of credits unnecessarily in the case of indirect based inodes.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/extents.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index e003a1e..13c5ebf 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4663,6 +4663,7 @@ static int ext4_alloc_file_blocks(struct file *file, ext4_lblk_t offset,
 	int ret = 0;
 	int ret2 = 0;
 	int retries = 0;
+	int depth = 0;
 	struct ext4_map_blocks map;
 	unsigned int credits;
 	loff_t epos;
@@ -4681,9 +4682,24 @@ static int ext4_alloc_file_blocks(struct file *file, ext4_lblk_t offset,
 	 * credits to insert 1 extent into extent tree
 	 */
 	credits = ext4_chunk_trans_blocks(inode, len);
+	/*
+	 * We can only call ext_depth() on extent based inodes
+	 */
+	if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
+		depth = ext_depth(inode);
+	else
+		depth = -1;
 
 retry:
 	while (ret >= 0 && len) {
+		/*
+		 * Recalculate credits when extent tree depth changes.
+		 */
+		if (depth >= 0 && depth != ext_depth(inode)) {
+			credits = ext4_chunk_trans_blocks(inode, len);
+			depth = ext_depth(inode);
+		}
+
 		handle = ext4_journal_start(inode, EXT4_HT_MAP_BLOCKS,
 					    credits);
 		if (IS_ERR(handle)) {
-- 
1.8.3.1

