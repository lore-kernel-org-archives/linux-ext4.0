From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH v2.6.32.y 11/53] ext4: Handle -EDQUOT error on write
Date: Sun, 30 May 2010 22:49:24 -0400
Message-ID: <1275274206-3900-11-git-send-email-tytso@mit.edu>
References: <1275274206-3900-1-git-send-email-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:44739 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755540Ab0EaCua (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 30 May 2010 22:50:30 -0400
In-Reply-To: <1275274206-3900-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

commit 1db913823c0f8360fccbd24ca67eb073966a5ffd upstream (as of v2.6.33-rc6)

We need to release the journal before we do a write_inode.  Otherwise
we could deadlock.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/inode.c |   32 ++++++++++++++++++--------------
 1 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 2e3f422..af9b185 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1877,24 +1877,12 @@ repeat:
 	 * later. Real quota accounting is done at pages writeout
 	 * time.
 	 */
-	if (vfs_dq_reserve_block(inode, md_needed + 1)) {
-		/* 
-		 * We tend to badly over-estimate the amount of
-		 * metadata blocks which are needed, so if we have
-		 * reserved any metadata blocks, try to force out the
-		 * inode and see if we have any better luck.
-		 */
-		if (md_reserved && retries++ <= 3)
-			goto retry;
+	if (vfs_dq_reserve_block(inode, md_needed + 1))
 		return -EDQUOT;
-	}
 
 	if (ext4_claim_free_blocks(sbi, md_needed + 1)) {
 		vfs_dq_release_reservation_block(inode, md_needed + 1);
 		if (ext4_should_retry_alloc(inode->i_sb, &retries)) {
-		retry:
-			if (md_reserved)
-				write_inode_now(inode, (retries == 3));
 			yield();
 			goto repeat;
 		}
@@ -3075,7 +3063,7 @@ static int ext4_da_write_begin(struct file *file, struct address_space *mapping,
 			       loff_t pos, unsigned len, unsigned flags,
 			       struct page **pagep, void **fsdata)
 {
-	int ret, retries = 0;
+	int ret, retries = 0, quota_retries = 0;
 	struct page *page;
 	pgoff_t index;
 	unsigned from, to;
@@ -3134,6 +3122,22 @@ retry:
 
 	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
 		goto retry;
+
+	if ((ret == -EDQUOT) &&
+	    EXT4_I(inode)->i_reserved_meta_blocks &&
+	    (quota_retries++ < 3)) {
+		/*
+		 * Since we often over-estimate the number of meta
+		 * data blocks required, we may sometimes get a
+		 * spurios out of quota error even though there would
+		 * be enough space once we write the data blocks and
+		 * find out how many meta data blocks were _really_
+		 * required.  So try forcing the inode write to see if
+		 * that helps.
+		 */
+		write_inode_now(inode, (quota_retries == 3));
+		goto retry;
+	}
 out:
 	return ret;
 }
-- 
1.6.6.1.1.g974db.dirty

