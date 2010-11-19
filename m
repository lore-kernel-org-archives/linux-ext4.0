From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH 2/2] ext3: Add journal error check into ext3_rename()
Date: Fri, 19 Nov 2010 16:28:36 +0900
Message-ID: <1290151716-4041-2-git-send-email-namhyung@gmail.com>
References: <1290151716-4041-1-git-send-email-namhyung@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:50442 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198Ab0KSH2q (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 19 Nov 2010 02:28:46 -0500
In-Reply-To: <1290151716-4041-1-git-send-email-namhyung@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Check return value of ext3_journal_get_write_access() and
ext3_journal_dirty_metadata(). 'new_bh' should be kept in
order to get revoked in case of journal error in dir_bh.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 fs/ext3/namei.c |   27 +++++++++++++++++++++------
 1 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index 672cea1..8061281 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -2371,7 +2371,9 @@ static int ext3_rename (struct inode * old_dir, struct dentry *old_dentry,
 			goto end_rename;
 	} else {
 		BUFFER_TRACE(new_bh, "get write access");
-		ext3_journal_get_write_access(handle, new_bh);
+		retval = ext3_journal_get_write_access(handle, new_bh);
+		if (retval)
+			goto journal_error1;
 		new_de->inode = cpu_to_le32(old_inode->i_ino);
 		if (EXT3_HAS_INCOMPAT_FEATURE(new_dir->i_sb,
 					      EXT3_FEATURE_INCOMPAT_FILETYPE))
@@ -2380,9 +2382,12 @@ static int ext3_rename (struct inode * old_dir, struct dentry *old_dentry,
 		new_dir->i_ctime = new_dir->i_mtime = CURRENT_TIME_SEC;
 		ext3_mark_inode_dirty(handle, new_dir);
 		BUFFER_TRACE(new_bh, "call ext3_journal_dirty_metadata");
-		ext3_journal_dirty_metadata(handle, new_bh);
-		brelse(new_bh);
-		new_bh = NULL;
+		retval = ext3_journal_dirty_metadata(handle, new_bh);
+		if (retval) {
+journal_error1:
+			ext3_std_error(new_dir->i_sb, retval);
+			goto end_rename;
+		}
 	}
 
 	/*
@@ -2429,10 +2434,20 @@ static int ext3_rename (struct inode * old_dir, struct dentry *old_dentry,
 	ext3_update_dx_flag(old_dir);
 	if (dir_bh) {
 		BUFFER_TRACE(dir_bh, "get_write_access");
-		ext3_journal_get_write_access(handle, dir_bh);
+		retval = ext3_journal_get_write_access(handle, dir_bh);
+		if (retval)
+			goto journal_error2;
 		PARENT_INO(dir_bh->b_data) = cpu_to_le32(new_dir->i_ino);
 		BUFFER_TRACE(dir_bh, "call ext3_journal_dirty_metadata");
-		ext3_journal_dirty_metadata(handle, dir_bh);
+		retval = ext3_journal_dirty_metadata(handle, dir_bh);
+		if (retval) {
+journal_error2:
+			if (new_bh)
+				ext3_journal_revoke(handle, new_bh->b_blocknr,
+						    new_bh);
+			ext3_std_error(new_dir->i_sb, retval);
+			goto end_rename;
+		}
 		drop_nlink(old_dir);
 		if (new_inode) {
 			drop_nlink(new_inode);
-- 
1.7.0.4

