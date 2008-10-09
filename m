From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 22/42] ext4: hook the ext3 migration interface to the EXT4_IOC_SETFLAGS ioctl
Date: Thu,  9 Oct 2008 00:05:40 -0400
Message-ID: <1223525160-9887-23-git-send-email-tytso@mit.edu>
References: <1223525160-9887-1-git-send-email-tytso@mit.edu>
 <1223525160-9887-2-git-send-email-tytso@mit.edu>
 <1223525160-9887-3-git-send-email-tytso@mit.edu>
 <1223525160-9887-4-git-send-email-tytso@mit.edu>
 <1223525160-9887-5-git-send-email-tytso@mit.edu>
 <1223525160-9887-6-git-send-email-tytso@mit.edu>
 <1223525160-9887-7-git-send-email-tytso@mit.edu>
 <1223525160-9887-8-git-send-email-tytso@mit.edu>
 <1223525160-9887-9-git-send-email-tytso@mit.edu>
 <1223525160-9887-10-git-send-email-tytso@mit.edu>
 <1223525160-9887-11-git-send-email-tytso@mit.edu>
 <1223525160-9887-12-git-send-email-tytso@mit.edu>
 <1223525160-9887-13-git-send-email-tytso@mit.edu>
 <1223525160-9887-14-git-send-email-tytso@mit.edu>
 <1223525160-9887-15-git-send-email-tytso@mit.edu>
 <1223525160-9887-16-git-send-email-tytso@mit.edu>
 <1223525160-9887-17-git-send-email-tytso@mit.edu>
 <1223525160-9887-18-git-send-email-tytso@mit.edu>
 <1223525160-9887-19-git-send-email-tytso@mit.edu>
 <1223525160-9887-20-git-send-email-tytso@mit.edu>
 <1223525160-9887-21-git-send-email-tytso@mit.edu>
 <1223525160-9887-22-git-send-email-tytso@mit.edu>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:54532 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757600AbYJIEGN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 9 Oct 2008 00:06:13 -0400
In-Reply-To: <1223525160-9887-22-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

This patch hooks the ext3 to ext4 migrate interface to
EXT4_IOC_SETFLAGS ioctl. The userspace interface is via chattr +e.  We
only allow setting extent flags.  Clearing extent flag (migrating from
ext4 to ext3) is not supported.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/ext4.h  |    2 +-
 fs/ext4/ioctl.c |   17 ++++++++++++++++-
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 9b6ad8f..068adc1 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -245,7 +245,7 @@ struct flex_groups {
 #define EXT4_RESERVED_FL		0x80000000 /* reserved for ext4 lib */
 
 #define EXT4_FL_USER_VISIBLE		0x000BDFFF /* User visible flags */
-#define EXT4_FL_USER_MODIFIABLE		0x000380FF /* User modifiable flags */
+#define EXT4_FL_USER_MODIFIABLE		0x000B80FF /* User modifiable flags */
 
 /*
  * Inode dynamic state flags
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 9f3044a..3e14060 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -34,7 +34,7 @@ long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		return put_user(flags, (int __user *) arg);
 	case EXT4_IOC_SETFLAGS: {
 		handle_t *handle = NULL;
-		int err;
+		int err, migrate = 0;
 		struct ext4_iloc iloc;
 		unsigned int oldflags;
 		unsigned int jflag;
@@ -82,6 +82,17 @@ long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 			if (!capable(CAP_SYS_RESOURCE))
 				goto flags_out;
 		}
+		if (oldflags & EXT4_EXTENTS_FL) {
+			/* We don't support clearning extent flags */
+			if (!(flags & EXT4_EXTENTS_FL)) {
+				err = -EOPNOTSUPP;
+				goto flags_out;
+			}
+		} else if (flags & EXT4_EXTENTS_FL) {
+			/* migrate the file */
+			migrate = 1;
+			flags &= ~EXT4_EXTENTS_FL;
+		}
 
 		handle = ext4_journal_start(inode, 1);
 		if (IS_ERR(handle)) {
@@ -109,6 +120,10 @@ flags_err:
 
 		if ((jflag ^ oldflags) & (EXT4_JOURNAL_DATA_FL))
 			err = ext4_change_inode_journal_flag(inode, jflag);
+		if (err)
+			goto flags_out;
+		if (migrate)
+			err = ext4_ext_migrate(inode);
 flags_out:
 		mutex_unlock(&inode->i_mutex);
 		mnt_drop_write(filp->f_path.mnt);
-- 
1.5.6.1.205.ge2c7.dirty

