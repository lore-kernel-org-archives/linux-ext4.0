From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH v2] ext3: Add journal error check into ext3_rename()
Date: Tue, 23 Nov 2010 13:30:33 +0900
Message-ID: <1290486633-4534-1-git-send-email-namhyung@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:43475 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923Ab0KWEak (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Nov 2010 23:30:40 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Check return value of ext3_journal_get_write_access() and
ext3_journal_dirty_metadata().

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 fs/ext3/namei.c |   19 +++++++++++++++----
 1 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index 672cea1..c8415e7 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -2371,7 +2371,9 @@ static int ext3_rename (struct inode * old_dir, struct dentry *old_dentry,
 			goto end_rename;
 	} else {
 		BUFFER_TRACE(new_bh, "get write access");
-		ext3_journal_get_write_access(handle, new_bh);
+		retval = ext3_journal_get_write_access(handle, new_bh);
+		if (retval)
+			goto journal_error;
 		new_de->inode = cpu_to_le32(old_inode->i_ino);
 		if (EXT3_HAS_INCOMPAT_FEATURE(new_dir->i_sb,
 					      EXT3_FEATURE_INCOMPAT_FILETYPE))
@@ -2380,7 +2382,9 @@ static int ext3_rename (struct inode * old_dir, struct dentry *old_dentry,
 		new_dir->i_ctime = new_dir->i_mtime = CURRENT_TIME_SEC;
 		ext3_mark_inode_dirty(handle, new_dir);
 		BUFFER_TRACE(new_bh, "call ext3_journal_dirty_metadata");
-		ext3_journal_dirty_metadata(handle, new_bh);
+		retval = ext3_journal_dirty_metadata(handle, new_bh);
+		if (retval)
+			goto journal_error;
 		brelse(new_bh);
 		new_bh = NULL;
 	}
@@ -2429,10 +2433,17 @@ static int ext3_rename (struct inode * old_dir, struct dentry *old_dentry,
 	ext3_update_dx_flag(old_dir);
 	if (dir_bh) {
 		BUFFER_TRACE(dir_bh, "get_write_access");
-		ext3_journal_get_write_access(handle, dir_bh);
+		retval = ext3_journal_get_write_access(handle, dir_bh);
+		if (retval)
+			goto journal_error;
 		PARENT_INO(dir_bh->b_data) = cpu_to_le32(new_dir->i_ino);
 		BUFFER_TRACE(dir_bh, "call ext3_journal_dirty_metadata");
-		ext3_journal_dirty_metadata(handle, dir_bh);
+		retval = ext3_journal_dirty_metadata(handle, dir_bh);
+		if (retval) {
+journal_error:
+			ext3_std_error(new_dir->i_sb, retval);
+			goto end_rename;
+		}
 		drop_nlink(old_dir);
 		if (new_inode) {
 			drop_nlink(new_inode);
-- 
1.7.0.4

