From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 11/22] ext4 crypto: inherit encryption policies on inode and directory create
Date: Thu,  2 Apr 2015 18:10:48 -0400
Message-ID: <1428012659-12709-12-git-send-email-tytso@mit.edu>
References: <1428012659-12709-1-git-send-email-tytso@mit.edu>
Cc: jaegeuk@kernel.org, mhalcrow@google.com,
	Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47942 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887AbbDBWMX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 2 Apr 2015 18:12:23 -0400
In-Reply-To: <1428012659-12709-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Michael Halcrow <mhalcrow@google.com>

Change-Id: Ibeeafc70352b39d1d5b3b17158a41d8fb54ed136
Signed-off-by: Michael Halcrow <mhalcrow@google.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/namei.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 12d2592..262aa1c 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -48,6 +48,8 @@
 #define NAMEI_RA_BLOCKS  4
 #define NAMEI_RA_SIZE	     (NAMEI_RA_CHUNKS * NAMEI_RA_BLOCKS)
 
+static int ext4_unlink(struct inode *dir, struct dentry *dentry);
+
 static struct buffer_head *ext4_append(handle_t *handle,
 					struct inode *inode,
 					ext4_lblk_t *block)
@@ -2247,6 +2249,13 @@ retry:
 		err = ext4_add_nondir(handle, dentry, inode);
 		if (!err && IS_DIRSYNC(dir))
 			ext4_handle_sync(handle);
+#ifdef CONFIG_EXT4_FS_ENCRYPTION
+		if (!err && ext4_encrypted_inode(dir)) {
+			err = ext4_inherit_context(dir, inode);
+			if (err)
+				ext4_unlink(dir, dentry);
+		}
+#endif
 	}
 	if (handle)
 		ext4_journal_stop(handle);
@@ -2445,6 +2454,13 @@ out_clear_inode:
 	d_instantiate(dentry, inode);
 	if (IS_DIRSYNC(dir))
 		ext4_handle_sync(handle);
+#ifdef CONFIG_EXT4_FS_ENCRYPTION
+	if (ext4_encrypted_inode(dir)) {
+		err = ext4_inherit_context(dir, inode);
+		if (err)
+			ext4_unlink(dir, dentry);
+	}
+#endif
 
 out_stop:
 	if (handle)
-- 
2.3.0

