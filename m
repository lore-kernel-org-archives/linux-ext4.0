From: Richard Weinberger <richard@nod.at>
Subject: [PATCH] ext4: Check for encryption feature before fscrypt_process_policy()
Date: Thu, 22 Sep 2016 08:50:54 +0200
Message-ID: <1474527054-24207-1-git-send-email-richard@nod.at>
Cc: adilger.kernel@dilger.ca, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org, david@sigma-star.at,
        Richard Weinberger <richard@nod.at>
To: tytso@mit.edu
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

...otherwise an user can enable encryption for certain files even
when the filesystem is unable to support it.
Such a case would be a filesystem created by mkfs.ext4's default
settings, 1KiB block size. Ext4 supports encyption only when block size
is equal to PAGE_SIZE.
But this constraint is only checked when the encryption feature flag
is set.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 fs/ext4/ioctl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 1bb7df5..9e9a73e 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -772,6 +772,9 @@ resizefs_out:
 #ifdef CONFIG_EXT4_FS_ENCRYPTION
 		struct fscrypt_policy policy;
 
+		if (!ext4_has_feature_encrypt(sb))
+			return -EOPNOTSUPP;
+
 		if (copy_from_user(&policy,
 				   (struct fscrypt_policy __user *)arg,
 				   sizeof(policy)))
-- 
2.7.3
