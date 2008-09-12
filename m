From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: ext4: elevate write count for migrate ioctl
Date: Fri, 12 Sep 2008 14:33:46 +0530
Message-ID: <1221210226-26435-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1221210226-26435-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:58400 "EHLO
	e28esmtp07.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752364AbYILJEY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 12 Sep 2008 05:04:24 -0400
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28esmtp07.in.ibm.com (8.13.1/8.13.1) with ESMTP id m8C94KDv016646
	for <linux-ext4@vger.kernel.org>; Fri, 12 Sep 2008 14:34:20 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m8C94KFJ1638496
	for <linux-ext4@vger.kernel.org>; Fri, 12 Sep 2008 14:34:20 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.13.1/8.13.3) with ESMTP id m8C93qoA001935
	for <linux-ext4@vger.kernel.org>; Fri, 12 Sep 2008 14:33:53 +0530
In-Reply-To: <1221210226-26435-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

This patch hooks the ext3 to ext4 migrate interface to
EXT4_IOC_SETFLAGS ioctl. The userspace interface is via
chattr +e. We only allow setting extent flags. Clearing
extent flag (migrating from ext4 to ext3) is not supported.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/ext4.h  |    2 +-
 fs/ext4/ioctl.c |   17 ++++++++++++++++-
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 103892b..70e8486 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -250,7 +250,7 @@ struct flex_groups {
 #define EXT4_RESERVED_FL		0x80000000 /* reserved for ext4 lib */
 
 #define EXT4_FL_USER_VISIBLE		0x000BDFFF /* User visible flags */
-#define EXT4_FL_USER_MODIFIABLE		0x000380FF /* User modifiable flags */
+#define EXT4_FL_USER_MODIFIABLE		0x000B80FF /* User modifiable flags */
 
 /*
  * Inode dynamic state flags
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 6e02967..94cdd02 100644
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
@@ -109,6 +120,10 @@ long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 
 		if ((jflag ^ oldflags) & (EXT4_JOURNAL_DATA_FL))
 			err = ext4_change_inode_journal_flag(inode, jflag);
+		if (err)
+			goto flags_out;
+		if (migrate)
+			err = ext4_ext_migrate(inode);
 flags_out:
 		mutex_unlock(&inode->i_mutex);
 		mnt_drop_write(filp->f_path.mnt);
