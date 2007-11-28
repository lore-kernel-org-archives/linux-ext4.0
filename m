From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] fix up vfs inode version patch for modules
Date: Wed, 28 Nov 2007 14:33:42 -0600
Message-ID: <474DD0A6.9010809@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:57521 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917AbXK1Udo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 28 Nov 2007 15:33:44 -0500
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.1) with ESMTP id lASKXhuQ018190
	for <linux-ext4@vger.kernel.org>; Wed, 28 Nov 2007 15:33:43 -0500
Received: from lacrosse.corp.redhat.com (lacrosse.corp.redhat.com [172.16.52.154])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id lASKXhDS016312
	for <linux-ext4@vger.kernel.org>; Wed, 28 Nov 2007 15:33:43 -0500
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by lacrosse.corp.redhat.com (8.12.11.20060308/8.11.6) with ESMTP id lASKXgKV005947
	for <linux-ext4@vger.kernel.org>; Wed, 28 Nov 2007 15:33:42 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

ext4 calls inode_inc_iversion(), but it's not exported, so modular ext4
has trouble.  Any reason not to just make it an inline, as below?

Signed-off-by: Eric Sandeen <sandeen@redhat.com>

---

Index: linux-2.6.24-rc1/fs/inode.c
===================================================================
--- linux-2.6.24-rc1.orig/fs/inode.c
+++ linux-2.6.24-rc1/fs/inode.c
@@ -1243,23 +1243,6 @@ void touch_atime(struct vfsmount *mnt, s
 EXPORT_SYMBOL(touch_atime);
 
 /**
- *     inode_inc_iversion      -       increments i_version
- *     @inode: inode that need to be updated
- *
- *     Every time the inode is modified, the i_version field
- *     will be incremented.
- *     The filesystem has to be mounted with i_version flag
- *
- */
-
-void inode_inc_iversion(struct inode *inode)
-{
-	spin_lock(&inode->i_lock);
-	inode->i_version++;
-	spin_unlock(&inode->i_lock);
-}
-
-/**
  *	file_update_time	-	update mtime and ctime time
  *	@file: file accessed
  *
Index: linux-2.6.24-rc1/include/linux/fs.h
===================================================================
--- linux-2.6.24-rc1.orig/include/linux/fs.h
+++ linux-2.6.24-rc1/include/linux/fs.h
@@ -1396,7 +1396,21 @@ static inline void inode_dec_link_count(
 	mark_inode_dirty(inode);
 }
 
-extern void inode_inc_iversion(struct inode *inode);
+/**
+ * inode_inc_iversion - increments i_version
+ * @inode: inode that need to be updated
+ *
+ * Every time the inode is modified, the i_version field will be incremented.
+ * The filesystem has to be mounted with i_version flag
+ */
+
+static inline void inode_inc_iversion(struct inode *inode)
+{
+       spin_lock(&inode->i_lock);
+       inode->i_version++;
+       spin_unlock(&inode->i_lock);
+}
+
 extern void touch_atime(struct vfsmount *mnt, struct dentry *dentry);
 static inline void file_accessed(struct file *file)
 {
