From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 5/5] ext4 crypto: use dget_parent() in ext4_d_revalidate()
Date: Sat, 26 Mar 2016 17:10:00 -0400
Message-ID: <1459026600-9232-6-git-send-email-tytso@mit.edu>
References: <1459026600-9232-1-git-send-email-tytso@mit.edu>
Cc: dhowells@redhat.com, viro@ZenIV.linux.org.uk,
	Linux Filesystem Development List
	<linux-fsdevel@vger.kernel.org>, jaegeuk@kernel.org,
	Theodore Ts'o <tytso@mit.edu>, stable@vger.kernel.org
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1459026600-9232-1-git-send-email-tytso@mit.edu>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This avoids potential problems caused by a race where the inode gets
renamed out from its parent directory and the parent directory is
deleted while ext4_d_revalidate() is running.

Fixes: 28b4c263961c
Reported-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@vger.kernel.org
---
 fs/ext4/crypto.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/crypto.c b/fs/ext4/crypto.c
index 012fd32..ea69ce4 100644
--- a/fs/ext4/crypto.c
+++ b/fs/ext4/crypto.c
@@ -478,13 +478,16 @@ uint32_t ext4_validate_encryption_key_size(uint32_t mode, uint32_t size)
  */
 static int ext4_d_revalidate(struct dentry *dentry, unsigned int flags)
 {
-	struct inode *dir = d_inode(dentry->d_parent);
-	struct ext4_crypt_info *ci = EXT4_I(dir)->i_crypt_info;
+	struct dentry *dir;
+	struct ext4_crypt_info *ci;
 	int dir_has_key, cached_with_key;
 
-	if (!ext4_encrypted_inode(dir))
+	dir = dget_parent(dentry);
+	if (!ext4_encrypted_inode(d_inode(dir))) {
+		dput(dir);
 		return 0;
-
+	}
+	ci = EXT4_I(d_inode(dir))->i_crypt_info;
 	if (ci && ci->ci_keyring_key &&
 	    (ci->ci_keyring_key->flags & ((1 << KEY_FLAG_INVALIDATED) |
 					  (1 << KEY_FLAG_REVOKED) |
@@ -494,6 +497,7 @@ static int ext4_d_revalidate(struct dentry *dentry, unsigned int flags)
 	/* this should eventually be an flag in d_flags */
 	cached_with_key = dentry->d_fsdata != NULL;
 	dir_has_key = (ci != NULL);
+	dput(dir);
 
 	/*
 	 * If the dentry was cached without the key, and it is a
-- 
2.5.0
