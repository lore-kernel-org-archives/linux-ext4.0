From: Eric Biggers <ebiggers@google.com>
Subject: [RFC PATCH 1/5] fscrypt: use ENOKEY when file cannot be created w/o key
Date: Mon,  5 Dec 2016 11:12:44 -0800
Message-ID: <1480965168-38747-2-git-send-email-ebiggers@google.com>
References: <1480965168-38747-1-git-send-email-ebiggers@google.com>
Cc: linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Richard Weinberger <richard@nod.at>,
        David Gstir <david@sigma-star.at>,
        Eric Biggers <ebiggers@google.com>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f53.google.com ([74.125.83.53]:36769 "EHLO
        mail-pg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751327AbcLETNd (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Dec 2016 14:13:33 -0500
Received: by mail-pg0-f53.google.com with SMTP id f188so139151436pgc.3
        for <linux-ext4@vger.kernel.org>; Mon, 05 Dec 2016 11:13:32 -0800 (PST)
In-Reply-To: <1480965168-38747-1-git-send-email-ebiggers@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

As part of an effort to clean up fscrypt-related error codes, make
attempting to create a file in an encrypted directory that hasn't been
"unlocked" fail with ENOKEY.  Previously, several error codes were used
for this case, including ENOENT, EACCES, and EPERM, and they were not
consistent between and within filesystems.  ENOKEY is a better choice
because it expresses that the failure is due to lacking the encryption
key.  It also matches the error code returned when trying to open an
encrypted regular file without the key.

I am not aware of any users who might be relying on the previous
inconsistent error codes, which were never documented anywhere.

This failure case will be exercised by an xfstest.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/fname.c | 4 ++--
 fs/ext4/ialloc.c  | 2 +-
 fs/ext4/namei.c   | 4 +++-
 fs/f2fs/dir.c     | 5 ++++-
 fs/f2fs/namei.c   | 4 ++--
 5 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/fs/crypto/fname.c b/fs/crypto/fname.c
index 6b45d9c..c902b1a 100644
--- a/fs/crypto/fname.c
+++ b/fs/crypto/fname.c
@@ -332,7 +332,7 @@ int fscrypt_fname_usr_to_disk(struct inode *inode,
 	 * in a directory. Consequently, a user space name cannot be mapped to
 	 * a disk-space name
 	 */
-	return -EACCES;
+	return -ENOKEY;
 }
 EXPORT_SYMBOL(fscrypt_fname_usr_to_disk);
 
@@ -367,7 +367,7 @@ int fscrypt_setup_filename(struct inode *dir, const struct qstr *iname,
 		return 0;
 	}
 	if (!lookup)
-		return -EACCES;
+		return -ENOKEY;
 
 	/*
 	 * We don't have the key and we are doing a lookup; decode the
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index e57e8d9..f372fc4 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -771,7 +771,7 @@ struct inode *__ext4_new_inode(handle_t *handle, struct inode *dir,
 		if (err)
 			return ERR_PTR(err);
 		if (!fscrypt_has_encryption_key(dir))
-			return ERR_PTR(-EPERM);
+			return ERR_PTR(-ENOKEY);
 		if (!handle)
 			nblocks += EXT4_DATA_TRANS_BLOCKS(dir->i_sb);
 		encrypt = 1;
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index eadba91..80b8afa 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1378,6 +1378,8 @@ static struct buffer_head * ext4_find_entry (struct inode *dir,
 		return NULL;
 
 	retval = ext4_fname_setup_filename(dir, d_name, 1, &fname);
+	if (retval == -ENOENT)
+		return NULL;
 	if (retval)
 		return ERR_PTR(retval);
 
@@ -3088,7 +3090,7 @@ static int ext4_symlink(struct inode *dir,
 		if (err)
 			return err;
 		if (!fscrypt_has_encryption_key(dir))
-			return -EPERM;
+			return -ENOKEY;
 		disk_link.len = (fscrypt_fname_encrypted_size(dir, len) +
 				 sizeof(struct fscrypt_symlink_data));
 		sd = kzalloc(disk_link.len, GFP_KERNEL);
diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index 369f451..60656b2 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -268,7 +268,10 @@ struct f2fs_dir_entry *f2fs_find_entry(struct inode *dir,
 
 	err = fscrypt_setup_filename(dir, child, 1, &fname);
 	if (err) {
-		*res_page = ERR_PTR(err);
+		if (err == -ENOENT)
+			*res_page = NULL;
+		else
+			*res_page = ERR_PTR(err);
 		return NULL;
 	}
 
diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index 489fa0d..9a2b1f8 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -403,7 +403,7 @@ static int f2fs_symlink(struct inode *dir, struct dentry *dentry,
 			return err;
 
 		if (!fscrypt_has_encryption_key(dir))
-			return -EPERM;
+			return -ENOKEY;
 
 		disk_link.len = (fscrypt_fname_encrypted_size(dir, len) +
 				sizeof(struct fscrypt_symlink_data));
@@ -447,7 +447,7 @@ static int f2fs_symlink(struct inode *dir, struct dentry *dentry,
 			goto err_out;
 
 		if (!fscrypt_has_encryption_key(inode)) {
-			err = -EPERM;
+			err = -ENOKEY;
 			goto err_out;
 		}
 
-- 
2.8.0.rc3.226.g39d4020

