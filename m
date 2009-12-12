From: rjevskiy@gmail.com
Subject: [PATCH 1/3] Add unlocked version of inode_add_bytes() function
Date: Sat, 12 Dec 2009 19:19:45 +0300
Message-ID: <1260634787-29370-1-git-send-email-rjevskiy@gmail.com>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:63285 "HELO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750943AbZLMBjQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 12 Dec 2009 20:39:16 -0500
Received: by bwz27 with SMTP id 27so1360658bwz.21
        for <linux-ext4@vger.kernel.org>; Sat, 12 Dec 2009 17:39:13 -0800 (PST)
CC: linux-fsdevel@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Dmitry Monakhov <dmonakhov@openvz.org>

Quota code requires unlocked version of this function. Off course
we can just copy-paste the code, but copy-pasting is always an evil.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
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
index 2620a8c..98ea200 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2314,6 +2314,7 @@ extern const struct inode_operations page_symlink_inode_operations;
 extern int generic_readlink(struct dentry *, char __user *, int);
 extern void generic_fillattr(struct inode *, struct kstat *);
 extern int vfs_getattr(struct vfsmount *, struct dentry *, struct kstat *);
+void __inode_add_bytes(struct inode *inode, loff_t bytes);
 void inode_add_bytes(struct inode *inode, loff_t bytes);
 void inode_sub_bytes(struct inode *inode, loff_t bytes);
 loff_t inode_get_bytes(struct inode *inode);
-- 
1.6.0.4

