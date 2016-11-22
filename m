From: Eric Biggers <ebiggers@google.com>
Subject: [PATCH] ext4: disable pwsalt ioctl when encryption disabled by config
Date: Mon, 21 Nov 2016 16:23:12 -0800
Message-ID: <1479774192-11528-1-git-send-email-ebiggers@google.com>
Cc: Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Richard Weinberger <richard@nod.at>,
        Eric Biggers <ebiggers@google.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f170.google.com ([209.85.192.170]:32882 "EHLO
        mail-pf0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753973AbcKVAXX (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Nov 2016 19:23:23 -0500
Received: by mail-pf0-f170.google.com with SMTP id d2so434061pfd.0
        for <linux-ext4@vger.kernel.org>; Mon, 21 Nov 2016 16:23:22 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On a CONFIG_EXT4_FS_ENCRYPTION=n kernel, the ioctls to get and set
encryption policies were disabled but EXT4_IOC_GET_ENCRYPTION_PWSALT was
not.  But there's no good reason to expose the pwsalt ioctl if the
kernel doesn't support encryption.  The pwsalt ioctl was also disabled
pre-4.8 (via ext4_sb_has_crypto() previously returning 0 when encryption
was disabled by config) and seems to have been enabled by mistake when
ext4 encryption was refactored to use fs/crypto/.  So let's disable it
again.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ext4/ioctl.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index a0db5d9..a8957d9 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -191,6 +191,7 @@ static long swap_inode_boot_loader(struct super_block *sb,
 	return err;
 }
 
+#ifdef CONFIG_EXT4_FS_ENCRYPTION
 static int uuid_is_zero(__u8 u[16])
 {
 	int	i;
@@ -200,6 +201,7 @@ static int uuid_is_zero(__u8 u[16])
 			return 0;
 	return 1;
 }
+#endif
 
 static int ext4_ioctl_setflags(struct inode *inode,
 			       unsigned int flags)
@@ -782,6 +784,7 @@ long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 #endif
 	}
 	case EXT4_IOC_GET_ENCRYPTION_PWSALT: {
+#ifdef CONFIG_EXT4_FS_ENCRYPTION
 		int err, err2;
 		struct ext4_sb_info *sbi = EXT4_SB(sb);
 		handle_t *handle;
@@ -816,6 +819,9 @@ long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 				 sbi->s_es->s_encrypt_pw_salt, 16))
 			return -EFAULT;
 		return 0;
+#else
+		return -EOPNOTSUPP;
+#endif
 	}
 	case EXT4_IOC_GET_ENCRYPTION_POLICY: {
 #ifdef CONFIG_EXT4_FS_ENCRYPTION
-- 
2.8.0.rc3.226.g39d4020

