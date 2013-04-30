From: Paul Taysom <taysom@chromium.org>
Subject: [PATCH] fs: ext4: Printing debug is now configurable
Date: Tue, 30 Apr 2013 14:51:00 -0700
Message-ID: <1367358660-940-1-git-send-email-taysom@chromium.org>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	olofj@chromium.org, taysom@chromium.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:41585 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933839Ab3D3Vvt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Apr 2013 17:51:49 -0400
Received: by mail-qc0-f201.google.com with SMTP id o22so111479qcr.2
        for <linux-ext4@vger.kernel.org>; Tue, 30 Apr 2013 14:51:47 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Printing the "truncating inode" and "deleting unreferenced inode"
messages is now controlled by the "debug" option to mount.
These messages were filling the /var/log/messages file and
are normal for ext4 file system recovery.

Tested by opening several files, unlinking them, then
crashing the system, rebooting the system and examining
/var/log/messages.

Addresses the problem described in http://crbug.com/220976

Signed-off-by: Paul Taysom <taysom@chromium.org>
---
 fs/ext4/super.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 5d6d5357..ed246fc 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2163,9 +2163,10 @@ static void ext4_orphan_cleanup(struct super_block *sb,
 		list_add(&EXT4_I(inode)->i_orphan, &EXT4_SB(sb)->s_orphan);
 		dquot_initialize(inode);
 		if (inode->i_nlink) {
-			ext4_msg(sb, KERN_DEBUG,
-				"%s: truncating inode %lu to %lld bytes",
-				__func__, inode->i_ino, inode->i_size);
+			if (test_opt(sb, DEBUG))
+				ext4_msg(sb, KERN_DEBUG,
+					"%s: truncating inode %lu to %lld bytes",
+					__func__, inode->i_ino, inode->i_size);
 			jbd_debug(2, "truncating inode %lu to %lld bytes\n",
 				  inode->i_ino, inode->i_size);
 			mutex_lock(&inode->i_mutex);
@@ -2173,9 +2174,10 @@ static void ext4_orphan_cleanup(struct super_block *sb,
 			mutex_unlock(&inode->i_mutex);
 			nr_truncates++;
 		} else {
-			ext4_msg(sb, KERN_DEBUG,
-				"%s: deleting unreferenced inode %lu",
-				__func__, inode->i_ino);
+			if (test_opt(sb, DEBUG))
+				ext4_msg(sb, KERN_DEBUG,
+					"%s: deleting unreferenced inode %lu",
+					__func__, inode->i_ino);
 			jbd_debug(2, "deleting unreferenced inode %lu\n",
 				  inode->i_ino);
 			nr_orphans++;
-- 
1.8.2.1

