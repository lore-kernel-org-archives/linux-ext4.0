From: Theodore Ts'o <tytso@mit.edu>
Subject: [FOR STABLE 4.1 -v2] ext4 crypto: don't regenerate the per-inode
 encryption key unnecessarily
Date: Sun, 8 Oct 2017 17:55:30 -0400
Message-ID: <20171008215530.hnty5a7v6dsip45e@thunk.org>
References: <20171008180953.rpnxvpggqggc334m@thunk.org>
 <20171008191749.GA26458@zzz.localdomain>
 <20171008203449.ys4sg5xztbzxx6ik@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: stable@vger.kernel.org, linux-ext4@vger.kernel.org
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171008203449.ys4sg5xztbzxx6ik@thunk.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

>From 8912051518ca75a94670652722c72e412eafe674 Mon Sep 17 00:00:00 2001
From: Theodore Ts'o <tytso@mit.edu>
Date: Sun, 8 Oct 2017 13:32:21 -0400
Subject: [PATCH] ext4 crypto: don't regenerate the per-inode encryption key
 unnecessarily

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

If the file is already opened and actively being read, and there is a
racing open() after the user's master key has been revoked, there will
be the same net effect as the problem fixed by upstream commit
1b53cf9815bb --- the per-file key will be marked as invalid and this
will cause a BUG_ON.

In the AOSP 3.18 and 4.4 android-common kernels, the more modern
version of ext4 encryption have been backported, including a backport
of upstream commit 1b53cf9815bb.  This is a dozen plus commits, and
isn't really suitable for the Upstream LTS kernel.  So instead, this
is the simplest bug which fixes the same high-level issue as the
upstream commit, without dragging in all of the other non-bug fixes
improvements to the ext4 encryption code found in newer kernels.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/crypto_key.c | 15 ++++++++++++---
 fs/ext4/ext4.h       |  1 +
 fs/ext4/super.c      |  3 +++
 3 files changed, 16 insertions(+), 3 deletions(-)

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
index 97aa8be40175..683eb88863dc 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -946,6 +946,9 @@ static void init_once(void *foo)
 	init_rwsem(&ei->xattr_sem);
 	init_rwsem(&ei->i_data_sem);
 	init_rwsem(&ei->i_mmap_sem);
+#ifdef CONFIG_EXT4_FS_ENCRYPTION
+	mutex_init(&ei->i_encryption_lock);
+#endif
 	inode_init_once(&ei->vfs_inode);
 }
 
-- 
2.11.0.rc0.7.gbe5a750
