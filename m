From: Eric Biggers <ebiggers@google.com>
Subject: [PATCH] fscrypto: only allow setting encryption policy on directories
Date: Thu,  8 Sep 2016 11:36:39 -0700
Message-ID: <1473359799-140042-1-git-send-email-ebiggers@google.com>
Cc: linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        tytso@mit.edu, jaegeuk@kernel.org,
        Eric Biggers <ebiggers@google.com>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The FS_IOC_SET_ENCRYPTION_POLICY ioctl allowed setting an encryption
policy on nondirectory files.  This was unintentional, and in the case
of nonempty regular files did not behave as expected because existing
data was not actually encrypted by the ioctl.

In the case of ext4, the user could also trigger filesystem errors in
->empty_dir(), e.g. due to mismatched "directory" checksums when the
kernel incorrectly tried to interpret a regular file as a directory.

This bug affected ext4 with kernels v4.8-rc1 or later and f2fs with
kernels v4.6 and later.  It appears that older kernels only permitted
directories and that the check was accidentally lost during the
refactoring to share the file encryption code between ext4 and f2fs.

This patch restores the !S_ISDIR() check that was present in older
kernels.

Signed-off-by: Eric Biggers <ebiggers@google.com>
Cc: stable@vger.kernel.org
---
 fs/crypto/policy.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
index 0f9961e..3872d2a 100644
--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -99,6 +99,8 @@ int fscrypt_process_policy(struct inode *inode,
 		return -EINVAL;
 
 	if (!inode_has_encryption_context(inode)) {
+		if (!S_ISDIR(inode->i_mode))
+			return -EINVAL;
 		if (!inode->i_sb->s_cop->empty_dir)
 			return -EOPNOTSUPP;
 		if (!inode->i_sb->s_cop->empty_dir(inode))
-- 
2.8.0.rc3.226.g39d4020

