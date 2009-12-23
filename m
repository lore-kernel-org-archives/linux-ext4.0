From: Jan Kara <jack@suse.cz>
Subject: [PATCH 1/5] Add unlocked version of inode_add_bytes() function
Date: Wed, 23 Dec 2009 18:27:52 +0100
Message-ID: <1261589276-1380-2-git-send-email-jack@suse.cz>
References: <1261589276-1380-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu,
	Dmitry Monakhov <dmonakhov@openvz.org>, Jan Kara <jack@suse.cz>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52954 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752560AbZLWR2E (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Dec 2009 12:28:04 -0500
In-Reply-To: <1261589276-1380-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Dmitry Monakhov <dmonakhov@openvz.org>

Quota code requires unlocked version of this function. Off course
we can just copy-paste the code, but copy-pasting is always an evil.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/stat.c          |   10 ++++++++--
 include/linux/fs.h |    1 +
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/stat.c b/fs/stat.c
index 075694e..c4ecd52 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -401,9 +401,9 @@ SYSCALL_DEFINE4(fstatat64, int, dfd, char __user *, filename,
 }
 #endif /* __ARCH_WANT_STAT64 */
 
-void inode_add_bytes(struct inode *inode, loff_t bytes)
+/* Caller is here responsible for sufficient locking (ie. inode->i_lock) */
+void __inode_add_bytes(struct inode *inode, loff_t bytes)
 {
-	spin_lock(&inode->i_lock);
 	inode->i_blocks += bytes >> 9;
 	bytes &= 511;
 	inode->i_bytes += bytes;
@@ -411,6 +411,12 @@ void inode_add_bytes(struct inode *inode, loff_t bytes)
 		inode->i_blocks++;
 		inode->i_bytes -= 512;
 	}
+}
+
+void inode_add_bytes(struct inode *inode, loff_t bytes)
+{
+	spin_lock(&inode->i_lock);
+	__inode_add_bytes(inode, bytes);
 	spin_unlock(&inode->i_lock);
 }
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 73e9b64..e2eeaa5 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2296,6 +2296,7 @@ extern const struct inode_operations page_symlink_inode_operations;
 extern int generic_readlink(struct dentry *, char __user *, int);
 extern void generic_fillattr(struct inode *, struct kstat *);
 extern int vfs_getattr(struct vfsmount *, struct dentry *, struct kstat *);
+void __inode_add_bytes(struct inode *inode, loff_t bytes);
 void inode_add_bytes(struct inode *inode, loff_t bytes);
 void inode_sub_bytes(struct inode *inode, loff_t bytes);
 loff_t inode_get_bytes(struct inode *inode);
-- 
1.6.4.2

