From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 03/42] ext4: Fix long long checkpatch warnings
Date: Thu,  9 Oct 2008 00:05:21 -0400
Message-ID: <1223525160-9887-4-git-send-email-tytso@mit.edu>
References: <1223525160-9887-1-git-send-email-tytso@mit.edu>
 <1223525160-9887-2-git-send-email-tytso@mit.edu>
 <1223525160-9887-3-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:54448 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757230AbYJIEGE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 9 Oct 2008 00:06:04 -0400
In-Reply-To: <1223525160-9887-3-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/super.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index ee86954..c10aaf7 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1716,9 +1716,9 @@ static void ext4_orphan_cleanup(struct super_block *sb,
 		DQUOT_INIT(inode);
 		if (inode->i_nlink) {
 			printk(KERN_DEBUG
-				"%s: truncating inode %lu to %Ld bytes\n",
+				"%s: truncating inode %lu to %lld bytes\n",
 				__func__, inode->i_ino, inode->i_size);
-			jbd_debug(2, "truncating inode %lu to %Ld bytes\n",
+			jbd_debug(2, "truncating inode %lu to %lld bytes\n",
 				  inode->i_ino, inode->i_size);
 			ext4_truncate(inode);
 			nr_truncates++;
@@ -2554,7 +2554,7 @@ static journal_t *ext4_get_journal(struct super_block *sb,
 		return NULL;
 	}
 
-	jbd_debug(2, "Journal inode found at %p: %Ld bytes\n",
+	jbd_debug(2, "Journal inode found at %p: %lld bytes\n",
 		  journal_inode, journal_inode->i_size);
 	if (!S_ISREG(journal_inode->i_mode)) {
 		printk(KERN_ERR "EXT4-fs: invalid journal inode.\n");
@@ -3439,7 +3439,7 @@ static ssize_t ext4_quota_write(struct super_block *sb, int type,
 	handle_t *handle = journal_current_handle();
 
 	if (!handle) {
-		printk(KERN_WARNING "EXT4-fs: Quota write (off=%Lu, len=%Lu)"
+		printk(KERN_WARNING "EXT4-fs: Quota write (off=%llu, len=%llu)"
 			" cancelled because transaction is not started.\n",
 			(unsigned long long)off, (unsigned long long)len);
 		return -EIO;
-- 
1.5.6.1.205.ge2c7.dirty

