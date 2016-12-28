From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: don't allow encrypted operations without keys
Date: Wed, 28 Dec 2016 00:22:52 -0500
Message-ID: <20161228052252.10314-1-tytso@mit.edu>
References: <20161228034812.ikoat5x3e7ucnac7@thunk.org>
Cc: Linux Filesystem Development List <linux-fsdevel@vger.kernel.org>,
        jaegeuk@kernel.org, richard@nod.at, ebiggers@google.com,
        Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50154 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750744AbcL1GUU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 28 Dec 2016 01:20:20 -0500
In-Reply-To: <20161228034812.ikoat5x3e7ucnac7@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

While we allow deletes without the key, the following should not be
permitted:

# cd /vdc/encrypted-dir-without-key
# ls -l
total 4
-rw-r--r-- 1 root root   0 Dec 27 22:35 6,LKNRJsp209FbXoSvJWzB
-rw-r--r-- 1 root root 286 Dec 27 22:35 uRJ5vJh9gE7vcomYMqTAyD
# mv uRJ5vJh9gE7vcomYMqTAyD  6,LKNRJsp209FbXoSvJWzB

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/namei.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index eadba919f26b..45a5ba558074 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3525,6 +3525,12 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 			EXT4_I(old_dentry->d_inode)->i_projid)))
 		return -EXDEV;
 
+	if ((ext4_encrypted_inode(old_dir) &&
+	     !fscrypt_has_encryption_key(old_dir)) ||
+	    (ext4_encrypted_inode(new_dir) &&
+	     !fscrypt_has_encryption_key(new_dir)))
+		return -ENOKEY;
+
 	retval = dquot_initialize(old.dir);
 	if (retval)
 		return retval;
@@ -3725,6 +3731,12 @@ static int ext4_cross_rename(struct inode *old_dir, struct dentry *old_dentry,
 	int retval;
 	struct timespec ctime;
 
+	if ((ext4_encrypted_inode(old_dir) &&
+	     !fscrypt_has_encryption_key(old_dir)) ||
+	    (ext4_encrypted_inode(new_dir) &&
+	     !fscrypt_has_encryption_key(new_dir)))
+		return -ENOKEY;
+
 	if ((ext4_encrypted_inode(old_dir) ||
 	     ext4_encrypted_inode(new_dir)) &&
 	    (old_dir != new_dir) &&
-- 
2.11.0.rc0.7.gbe5a750

