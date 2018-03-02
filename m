From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH 4.1 3/3] ext4 crypto: don't regenerate the per-inode encryption key unnecessarily
Date: Fri,  2 Mar 2018 14:21:13 -0800
Message-ID: <20180302222113.85389-4-ebiggers3@gmail.com>
References: <20180302222113.85389-1-ebiggers3@gmail.com>
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        Eric Biggers <ebiggers@google.com>
To: stable@vger.kernel.org, Sasha Levin <Alexander.Levin@microsoft.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180302222113.85389-1-ebiggers3@gmail.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>

[ Relevant upstream commit: 1b53cf9815bb4744958d41f3795d5d5a1d365e2d ]

This fixes the same problem as upstream commit 1b53cf9815bb: "fscrypt:
remove broken support for detecting keyring key revocation".
Specifically, key revocations racing with readpage operations will
cause the kernel to crash and burn with a BUG_ON or a NULL pointer
dereference in a block I/O callback stemming from an ext4_readpage()
operation.

This fix is needed to fix prevent xfstests test runs from crashing
while running the generic/421 test.

The root cause is different in the 4.1 kernel, however, since the
4.1's encryption handling is so _primitive_ compared to later kernels.
The code isn't actually explicitly checking for revoked keys.
Instead, the code is neededly regenerating the per-file encryption key
on every mmap() or open() or directory operation (in the case of a
directory inode).  Yelch!

If the file is already opened and actively being read, and while an
open() is racing with the read operations, after the user's master key
has been revoked, there will be the same net effect as the problem
fixed by upstream commit 1b53cf9815bb --- the per-file key will be
marked as invalid and this will cause a BUG_ON.

The AOSP 3.18 and 4.4 android-common kernels have a much more modern
version of ext4 encryption have been backported, which incldes a
backport of upstream commit 1b53cf9815bb.  This is a (at least)
dozen-plus commits, and isn't really suitable for the Upstream LTS
kernel.  So instead, this is the simplest bug which fixes the same
high-level issue as the upstream commit, without dragging in all of
the other non-bug-fix improvements to ext4 encryption found in newer
kernels.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ext4/crypto_fname.c |  5 +++--
 fs/ext4/crypto_key.c   | 15 ++++++++++++---
 fs/ext4/ext4.h         |  1 +
 fs/ext4/super.c        |  3 +++
 4 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/crypto_fname.c b/fs/ext4/crypto_fname.c
index fded02f72299..b7a39a185d01 100644
--- a/fs/ext4/crypto_fname.c
+++ b/fs/ext4/crypto_fname.c
@@ -346,8 +346,9 @@ struct ext4_fname_crypto_ctx *ext4_get_fname_crypto_ctx(
 	if (res == 0)
 		return NULL;
 
-	if (!ext4_has_encryption_key(inode))
-		ext4_generate_encryption_key(inode);
+	res = ext4_generate_encryption_key(inode);
+	if (res)
+		return ERR_PTR(res);
 
 	/* Get a crypto context based on the key.
 	 * A new context is allocated if no context matches the requested key.
diff --git a/fs/ext4/crypto_key.c b/fs/ext4/crypto_key.c
index 52170d0b7c40..4f9818719d61 100644
--- a/fs/ext4/crypto_key.c
+++ b/fs/ext4/crypto_key.c
@@ -99,9 +99,17 @@ int ext4_generate_encryption_key(struct inode *inode)
 	struct ext4_encryption_context ctx;
 	struct user_key_payload *ukp;
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
-	int res = ext4_xattr_get(inode, EXT4_XATTR_INDEX_ENCRYPTION,
-				 EXT4_XATTR_NAME_ENCRYPTION_CONTEXT,
-				 &ctx, sizeof(ctx));
+	int res;
+
+	mutex_lock(&ei->i_encryption_lock);
+	if (ext4_has_encryption_key(inode)) {
+		mutex_unlock(&ei->i_encryption_lock);
+		return 0;
+	}
+
+	res = ext4_xattr_get(inode, EXT4_XATTR_INDEX_ENCRYPTION,
+			     EXT4_XATTR_NAME_ENCRYPTION_CONTEXT,
+			     &ctx, sizeof(ctx));
 
 	if (res != sizeof(ctx)) {
 		if (res > 0)
@@ -154,6 +162,7 @@ out:
 		key_put(keyring_key);
 	if (res < 0)
 		crypt_key->mode = EXT4_ENCRYPTION_MODE_INVALID;
+	mutex_unlock(&ei->i_encryption_lock);
 	return res;
 }
 
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index df67a6f8582a..01771ed4529d 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -989,6 +989,7 @@ struct ext4_inode_info {
 #ifdef CONFIG_EXT4_FS_ENCRYPTION
 	/* Encryption params */
 	struct ext4_encryption_key i_encryption_key;
+	struct mutex i_encryption_lock;
 #endif
 };
 
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index b29a7ef4953e..0787cb5d6e9b 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -948,6 +948,9 @@ static void init_once(void *foo)
 	init_rwsem(&ei->xattr_sem);
 	init_rwsem(&ei->i_data_sem);
 	init_rwsem(&ei->i_mmap_sem);
+#ifdef CONFIG_EXT4_FS_ENCRYPTION
+	mutex_init(&ei->i_encryption_lock);
+#endif
 	inode_init_once(&ei->vfs_inode);
 }
 
-- 
2.16.2.395.g2e18187dfd-goog
