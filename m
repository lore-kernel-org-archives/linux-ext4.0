From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 1/2] ext4: handle errors in ext4_rename
Date: Tue, 1 Mar 2011 14:17:21 +0200
Message-ID: <AANLkTinjSs=D0p-KHCn4WK5Hx979_AORPTVa6YgcXwT2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:59320 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551Ab1CAMRW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Mar 2011 07:17:22 -0500
Received: by qwd7 with SMTP id 7so3601210qwd.19
        for <linux-ext4@vger.kernel.org>; Tue, 01 Mar 2011 04:17:22 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Checking return code from ext4_journal_get_write_access() is important
with snapshots,
because this function invokes COW, so may return new errors, such as ENOSPC.

Getting write_access to dir_bh sooner, so rename operation can be
aborted sooner.

Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
---
 fs/ext4/namei.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 5485390..ad87584 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2409,6 +2409,10 @@ static int ext4_rename(struct inode *old_dir,
struct dentry *old_dentry,
 		if (!new_inode && new_dir != old_dir &&
 		    EXT4_DIR_LINK_MAX(new_dir))
 			goto end_rename;
+		BUFFER_TRACE(dir_bh, "get_write_access");
+		retval = ext4_journal_get_write_access(handle, dir_bh);
+		if (retval)
+			goto end_rename;
 	}
 	if (!new_bh) {
 		retval = ext4_add_entry(handle, new_dentry, old_inode);
@@ -2416,7 +2420,9 @@ static int ext4_rename(struct inode *old_dir,
struct dentry *old_dentry,
 			goto end_rename;
 	} else {
 		BUFFER_TRACE(new_bh, "get write access");
-		ext4_journal_get_write_access(handle, new_bh);
+		retval = ext4_journal_get_write_access(handle, new_bh);
+		if (retval)
+			goto end_rename;
 		new_de->inode = cpu_to_le32(old_inode->i_ino);
 		if (EXT4_HAS_INCOMPAT_FEATURE(new_dir->i_sb,
 					      EXT4_FEATURE_INCOMPAT_FILETYPE))
@@ -2477,8 +2483,6 @@ static int ext4_rename(struct inode *old_dir,
struct dentry *old_dentry,
 	old_dir->i_ctime = old_dir->i_mtime = ext4_current_time(old_dir);
 	ext4_update_dx_flag(old_dir);
 	if (dir_bh) {
-		BUFFER_TRACE(dir_bh, "get_write_access");
-		ext4_journal_get_write_access(handle, dir_bh);
 		PARENT_INO(dir_bh->b_data, new_dir->i_sb->s_blocksize) =
 						cpu_to_le32(new_dir->i_ino);
 		BUFFER_TRACE(dir_bh, "call ext4_handle_dirty_metadata");
-- 
1.7.0.4
