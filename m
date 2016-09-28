From: Eric Biggers <ebiggers@google.com>
Subject: [PATCH] fscrypto: lock inode while setting encryption policy
Date: Wed, 28 Sep 2016 11:34:48 -0700
Message-ID: <1475087688-4048-1-git-send-email-ebiggers@google.com>
Cc: linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        tytso@mit.edu, jaegeuk@kernel.org, richard@nod.at,
        Eric Biggers <ebiggers@google.com>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

i_rwsem needs to be acquired while setting an encryption policy so that
concurrent calls to FS_IOC_SET_ENCRYPTION_POLICY are correctly
serialized (especially the ->get_context() + ->set_context() pair), and
so that new files cannot be created in the directory during or after the
->empty_dir() check.

Signed-off-by: Eric Biggers <ebiggers@google.com>

---
Note: to be applied without conflict, this patch needs the changes from
v4.8-rc6.

---
 fs/crypto/policy.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
index ed115ac..6865663 100644
--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -109,6 +109,8 @@ int fscrypt_process_policy(struct file *filp,
 	if (ret)
 		return ret;
 
+	inode_lock(inode);
+
 	if (!inode_has_encryption_context(inode)) {
 		if (!S_ISDIR(inode->i_mode))
 			ret = -EINVAL;
@@ -127,6 +129,8 @@ int fscrypt_process_policy(struct file *filp,
 		ret = -EINVAL;
 	}
 
+	inode_unlock(inode);
+
 	mnt_drop_write_file(filp);
 	return ret;
 }
-- 
2.8.0.rc3.226.g39d4020

