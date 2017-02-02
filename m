From: Theodore Ts'o <tytso@mit.edu>
Subject: [RFC/PATCH 3/3] ext4: add EXT4_IOC_GOINGDOWN ioctl
Date: Thu,  2 Feb 2017 17:59:24 -0500
Message-ID: <20170202225924.19301-4-tytso@mit.edu>
References: <20170202225924.19301-1-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54686 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751811AbdBBW7r (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 2 Feb 2017 17:59:47 -0500
In-Reply-To: <20170202225924.19301-1-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This ioctl is modeled after the xfs's XFS_IOC_GOINGDOWN ioctl.  (In
fact, it uses the same code points.)

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/ext4.h  | 10 ++++++++++
 fs/ext4/ioctl.c | 42 ++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/super.c |  2 +-
 3 files changed, 53 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 94064b7ce16c..eae92f1a52e1 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -679,6 +679,16 @@ struct fsxattr {
 #define EXT4_IOC_FSGETXATTR		FS_IOC_FSGETXATTR
 #define EXT4_IOC_FSSETXATTR		FS_IOC_FSSETXATTR
 
+#define EXT4_IOC_GOiNGDOWN _IOR ('X', 125, __u32)
+
+/*
+ * Flags for going down operation
+ */
+#define EXT4_GOING_FLAGS_DEFAULT		0x0	/* going down */
+#define EXT4_GOING_FLAGS_LOGFLUSH		0x1	/* flush log but not data */
+#define EXT4_GOING_FLAGS_NOLOGFLUSH		0x2	/* don't flush log nor data */
+
+
 #if defined(__KERNEL__) && defined(CONFIG_COMPAT)
 /*
  * ioctl commands in 32 bit emulation
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index d534399cf607..6d5443cf4a47 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -442,6 +442,45 @@ static inline unsigned long ext4_xflags_to_iflags(__u32 xflags)
 	return iflags;
 }
 
+int ext4_goingdown(struct super_block *sb, unsigned long arg)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	__u32 flags;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (get_user(flags, (__u32 __user *)arg))
+		return -EFAULT;
+
+	if (flags > EXT4_GOING_FLAGS_NOLOGFLUSH)
+		return -EINVAL;
+
+	if (ext4_forced_shutdown(sbi))
+		return 0;
+
+	switch (flags) {
+	case EXT4_GOING_FLAGS_DEFAULT:
+		freeze_bdev(sb->s_bdev);
+		set_bit(EXT4_FLAGS_SHUTDOWN, &sbi->s_ext4_flags);
+		thaw_bdev(sb->s_bdev, sb);
+		break;
+	case EXT4_GOING_FLAGS_LOGFLUSH:
+		if (sbi->s_journal && !is_journal_aborted(sbi->s_journal))
+		    (void) ext4_force_commit(sb);
+		/* fall through */
+	case EXT4_GOING_FLAGS_NOLOGFLUSH:
+		if (sbi->s_journal && !is_journal_aborted(sbi->s_journal))
+			(void) jbd2_journal_destroy(sbi->s_journal);
+		sbi->s_journal = NULL;
+		set_bit(EXT4_FLAGS_SHUTDOWN, &sbi->s_ext4_flags);
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
 long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	struct inode *inode = file_inode(filp);
@@ -893,6 +932,8 @@ long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 
 		return 0;
 	}
+	case EXT4_IOC_GOiNGDOWN:
+		return ext4_goingdown(sb, arg);
 	default:
 		return -ENOTTY;
 	}
@@ -959,6 +1000,7 @@ long ext4_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	case EXT4_IOC_SET_ENCRYPTION_POLICY:
 	case EXT4_IOC_GET_ENCRYPTION_PWSALT:
 	case EXT4_IOC_GET_ENCRYPTION_POLICY:
+	case EXT4_IOC_GOiNGDOWN:
 		break;
 	default:
 		return -ENOIOCTLCMD;
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 829e4a7b59e4..8db181c4dad6 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4797,7 +4797,7 @@ static int ext4_freeze(struct super_block *sb)
  */
 static int ext4_unfreeze(struct super_block *sb)
 {
-	if (sb->s_flags & MS_RDONLY)
+	if ((sb->s_flags & MS_RDONLY) || ext4_forced_shutdown(EXT4_SB(sb)))
 		return 0;
 
 	if (EXT4_SB(sb)->s_journal) {
-- 
2.11.0.rc0.7.gbe5a750
