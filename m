From: Theodore Ts'o <tytso@mit.edu>
Subject: [FOR-STABLE 05/20] ext4: elevate write count for migrate ioctl
Date: Sun, 16 Nov 2008 11:05:25 -0500
Message-ID: <1226851540-8032-6-git-send-email-tytso@mit.edu>
References: <1226851540-8032-1-git-send-email-tytso@mit.edu>
 <1226851540-8032-2-git-send-email-tytso@mit.edu>
 <1226851540-8032-3-git-send-email-tytso@mit.edu>
 <1226851540-8032-4-git-send-email-tytso@mit.edu>
 <1226851540-8032-5-git-send-email-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:44747 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753123AbYKPQiU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 16 Nov 2008 11:38:20 -0500
In-Reply-To: <1226851540-8032-5-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

The migrate ioctl writes to the filsystem, so we need to elevate the
write count.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
(cherry picked from commit 2a43a878001cc5cb7c3c7be2e8dad0a1aeb939b0)
---
 fs/ext4/ext4.h    |    3 +--
 fs/ext4/ioctl.c   |   21 ++++++++++++++++++++-
 fs/ext4/migrate.c |   10 +---------
 3 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 2950032..9f62743 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1083,8 +1083,7 @@ extern long ext4_ioctl(struct file *, unsigned int, unsigned long);
 extern long ext4_compat_ioctl (struct file *, unsigned int, unsigned long);
 
 /* migrate.c */
-extern int ext4_ext_migrate(struct inode *, struct file *, unsigned int,
-		       unsigned long);
+extern int ext4_ext_migrate(struct inode *);
 /* namei.c */
 extern int ext4_orphan_add(handle_t *, struct inode *);
 extern int ext4_orphan_del(handle_t *, struct inode *);
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 7a6c2f1..306bfd4 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -267,7 +267,26 @@ setversion_out:
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
@@ -623,7 +616,6 @@ err_out:
 	tmp_inode->i_nlink = 0;
 
 	ext4_journal_stop(handle);
-	mutex_unlock(&(inode->i_mutex));
 
 	if (tmp_inode)
 		iput(tmp_inode);
-- 
1.6.0.4.8.g36f27.dirty

