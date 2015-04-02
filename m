From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 07/22] ext4 crypto: add ioctl to set encryption policy
Date: Thu,  2 Apr 2015 18:10:44 -0400
Message-ID: <1428012659-12709-8-git-send-email-tytso@mit.edu>
References: <1428012659-12709-1-git-send-email-tytso@mit.edu>
Cc: jaegeuk@kernel.org, mhalcrow@google.com,
	Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47984 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752357AbbDBWMi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 2 Apr 2015 18:12:38 -0400
In-Reply-To: <1428012659-12709-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Change-Id: I6da224be190c29d5315039f921229db92243f306
Signed-off-by: Michael Halcrow <mhalcrow@google.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/ext4.h  |  1 +
 fs/ext4/ioctl.c | 20 ++++++++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index fd2f3dd..2d7fcb6 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -611,6 +611,7 @@ enum {
 #define EXT4_IOC_RESIZE_FS		_IOW('f', 16, __u64)
 #define EXT4_IOC_SWAP_BOOT		_IO('f', 17)
 #define EXT4_IOC_PRECACHE_EXTENTS	_IO('f', 18)
+#define EXT4_IOC_ENCRYPTION_POLICY	_IOW('f', 19, struct ext4_encryption_policy)
 
 #if defined(__KERNEL__) && defined(CONFIG_COMPAT)
 /*
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index f58a0d1..e4ae8f9 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -615,7 +615,26 @@ resizefs_out:
 	}
 	case EXT4_IOC_PRECACHE_EXTENTS:
 		return ext4_ext_precache(inode);
+	case EXT4_IOC_ENCRYPTION_POLICY:
+#ifdef CONFIG_EXT4_FS_ENCRYPTION
+	{
+		struct ext4_encryption_policy policy;
+		int err = 0;
+
+		if (copy_from_user(&policy,
+				   (struct ext4_encryption_policy __user *)arg,
+				   sizeof(policy))) {
+			err = -EFAULT;
+			goto encryption_policy_out;
+		}
 
+		err = ext4_process_policy(&policy, inode);
+encryption_policy_out:
+		return err;
+	}
+#else
+		return -EOPNOTSUPP;
+#endif
 	default:
 		return -ENOTTY;
 	}
@@ -680,6 +699,7 @@ long ext4_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	case FITRIM:
 	case EXT4_IOC_RESIZE_FS:
 	case EXT4_IOC_PRECACHE_EXTENTS:
+	case EXT4_IOC_ENCRYPTION_POLICY:
 		break;
 	default:
 		return -ENOIOCTLCMD;
-- 
2.3.0

