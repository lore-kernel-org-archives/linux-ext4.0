From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH-v2 04/20] ext4 crypto: export ext4_empty_dir()
Date: Sun, 12 Apr 2015 23:16:20 -0400
Message-ID: <1428894996-7852-5-git-send-email-tytso@mit.edu>
References: <1428894996-7852-1-git-send-email-tytso@mit.edu>
Cc: mhalcrow@google.com, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35615 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752688AbbDMDRN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 12 Apr 2015 23:17:13 -0400
In-Reply-To: <1428894996-7852-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Michael Halcrow <mhalcrow@google.com>

Required for future encryption xattr changes.

Change-Id: Ib12fcceed8af6e2460bc387ec94434cf51b7befb
Signed-off-by: Michael Halcrow <mhalcrow@google.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/ext4.h  |  1 +
 fs/ext4/namei.c | 11 ++++++-----
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 2baab1e..41bb58a 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2187,6 +2187,7 @@ extern int ext4_generic_delete_entry(handle_t *handle,
 				     void *entry_buf,
 				     int buf_size,
 				     int csum_size);
+extern int ext4_empty_dir(struct inode *inode);
 
 /* resize.c */
 extern int ext4_group_add(struct super_block *sb,
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 2291923..2fb55fd 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2450,7 +2450,7 @@ out_stop:
 /*
  * routine to check that the specified directory is empty (for rmdir)
  */
-static int empty_dir(struct inode *inode)
+int ext4_empty_dir(struct inode *inode)
 {
 	unsigned int offset;
 	struct buffer_head *bh;
@@ -2718,7 +2718,7 @@ static int ext4_rmdir(struct inode *dir, struct dentry *dentry)
 		goto end_rmdir;
 
 	retval = -ENOTEMPTY;
-	if (!empty_dir(inode))
+	if (!ext4_empty_dir(inode))
 		goto end_rmdir;
 
 	handle = ext4_journal_start(dir, EXT4_HT_DIR,
@@ -3272,7 +3272,7 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 	if (S_ISDIR(old.inode->i_mode)) {
 		if (new.inode) {
 			retval = -ENOTEMPTY;
-			if (!empty_dir(new.inode))
+			if (!ext4_empty_dir(new.inode))
 				goto end_rename;
 		} else {
 			retval = -EMLINK;
@@ -3346,8 +3346,9 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 
 		ext4_dec_count(handle, old.dir);
 		if (new.inode) {
-			/* checked empty_dir above, can't have another parent,
-			 * ext4_dec_count() won't work for many-linked dirs */
+			/* checked ext4_empty_dir above, can't have another
+			 * parent, ext4_dec_count() won't work for many-linked
+			 * dirs */
 			clear_nlink(new.inode);
 		} else {
 			ext4_inc_count(handle, new.dir);
-- 
2.3.0

