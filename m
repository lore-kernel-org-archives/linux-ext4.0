From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: ext4: elevate write count for migrate ioctl
Date: Fri, 12 Sep 2008 14:33:45 +0530
Message-ID: <1221210226-26435-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:60370 "EHLO
	e28esmtp05.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752360AbYILJEU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 12 Sep 2008 05:04:20 -0400
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28esmtp05.in.ibm.com (8.13.1/8.13.1) with ESMTP id m8C94HSD005566
	for <linux-ext4@vger.kernel.org>; Fri, 12 Sep 2008 14:34:17 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m8C94Hcj1712284
	for <linux-ext4@vger.kernel.org>; Fri, 12 Sep 2008 14:34:17 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.13.1/8.13.3) with ESMTP id m8C93nxn001883
	for <linux-ext4@vger.kernel.org>; Fri, 12 Sep 2008 14:33:50 +0530
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

migrate ioctl writes to the filsystem. So we need to
elevate the write count.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/ext4.h    |    3 +--
 fs/ext4/ioctl.c   |   21 ++++++++++++++++++++-
 fs/ext4/migrate.c |   10 +---------
 3 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index bc856e3..103892b 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1165,8 +1165,7 @@ extern long ext4_ioctl(struct file *, unsigned int, unsigned long);
 extern long ext4_compat_ioctl (struct file *, unsigned int, unsigned long);
 
 /* migrate.c */
-extern int ext4_ext_migrate(struct inode *, struct file *, unsigned int,
-		       unsigned long);
+extern int ext4_ext_migrate(struct inode *);
 /* namei.c */
 extern int ext4_orphan_add(handle_t *, struct inode *);
 extern int ext4_orphan_del(handle_t *, struct inode *);
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 9daa40a..6e02967 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -277,7 +277,26 @@ long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	}
 
 	case EXT4_IOC_MIGRATE:
-		return ext4_ext_migrate(inode, filp, cmd, arg);
+	{
+		int err;
+		if (!is_owner_or_cap(inode))
+			return -EACCES;
+
+		err = mnt_want_write(filp->f_path.mnt);
+		if (err)
+			return err;
+		/*
+		 * inode_mutex prevent write and truncate on the file.
+		 * Read still goes through. We take i_data_sem in
+		 * ext4_ext_swap_inode_data before we switch the
+		 * inode format to prevent read.
+		 */
+		mutex_lock(&(inode->i_mutex));
+		err = ext4_ext_migrate(inode);
+		mutex_unlock(&(inode->i_mutex));
+		mnt_drop_write(filp->f_path.mnt);
+		return err;
+	}
 
 	default:
 		return -ENOTTY;
diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
index 46fc0b5..f2a9cf4 100644
--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -447,8 +447,7 @@ static int free_ext_block(handle_t *handle, struct inode *inode)
 
 }
 
-int ext4_ext_migrate(struct inode *inode, struct file *filp,
-				unsigned int cmd, unsigned long arg)
+int ext4_ext_migrate(struct inode *inode)
 {
 	handle_t *handle;
 	int retval = 0, i;
@@ -516,12 +515,6 @@ int ext4_ext_migrate(struct inode *inode, struct file *filp,
 	 * when we add extents we extent the journal
 	 */
 	/*
-	 * inode_mutex prevent write and truncate on the file. Read still goes
-	 * through. We take i_data_sem in ext4_ext_swap_inode_data before we
-	 * switch the inode format to prevent read.
-	 */
-	mutex_lock(&(inode->i_mutex));
-	/*
 	 * Even though we take i_mutex we can still cause block allocation
 	 * via mmap write to holes. If we have allocated new blocks we fail
 	 * migrate.  New block allocation will clear EXT4_EXT_MIGRATE flag.
@@ -623,7 +616,6 @@ int ext4_ext_migrate(struct inode *inode, struct file *filp,
 	tmp_inode->i_nlink = 0;
 
 	ext4_journal_stop(handle);
-	mutex_unlock(&(inode->i_mutex));
 
 	if (tmp_inode)
 		iput(tmp_inode);
