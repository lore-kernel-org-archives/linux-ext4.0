From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 3/8] ext4 crypto: make sure the encryption info is initialized on opendir(2)
Date: Thu, 28 May 2015 19:47:42 -0400
Message-ID: <1432856867-5710-3-git-send-email-tytso@mit.edu>
References: <1432856867-5710-1-git-send-email-tytso@mit.edu>
Cc: jaegeuk@kernel.org, mhalcrow@google.com,
	Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35480 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754794AbbE1Xs1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 May 2015 19:48:27 -0400
In-Reply-To: <1432856867-5710-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/dir.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index e11e6ae..f9e1491 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -593,6 +593,13 @@ finished:
 	return 0;
 }
 
+static int ext4_dir_open(struct inode * inode, struct file * filp)
+{
+	if (ext4_encrypted_inode(inode))
+		return ext4_get_encryption_info(inode) ? -EACCES : 0;
+	return 0;
+}
+
 static int ext4_release_dir(struct inode *inode, struct file *filp)
 {
 	if (filp->private_data)
@@ -635,5 +642,6 @@ const struct file_operations ext4_dir_operations = {
 	.compat_ioctl	= ext4_compat_ioctl,
 #endif
 	.fsync		= ext4_sync_file,
+	.open		= ext4_dir_open,
 	.release	= ext4_release_dir,
 };
-- 
2.3.0

