From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH] ext4: forbid encrypting root directory
Date: Wed, 14 Jun 2017 16:17:53 -0700
Message-ID: <20170614231753.113206-1-ebiggers3@gmail.com>
Cc: linux-fscrypt@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@google.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:35573 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752671AbdFNXTF (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 14 Jun 2017 19:19:05 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

Currently it's possible to encrypt all files and directories on an ext4
filesystem by deleting everything, including lost+found, then setting an
encryption policy on the root directory.  However, this is incompatible
with e2fsck because e2fsck expects to find, create, and/or write to
lost+found and does not have access to any encryption keys.  Especially
problematic is that if e2fsck can't find lost+found, it will create it
without regard for whether the root directory is encrypted.  This is
wrong for obvious reasons, and it causes a later run of e2fsck to
consider the lost+found directory entry to be corrupted.

It's not clear it would be useful to support encrypting the root
directory, because in that scenario dm-crypt might as well be used
instead.  But in any case, it's broken currently and must not be
allowed; so start returning an error if userspace tries to set an
encryption policy on the root directory.

For now do this in ext4 only, because f2fs and ubifs do not appear to
have the lost+found requirement.  We could move it into
fscrypt_ioctl_set_policy() later if desired, though.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ext4/super.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index d37c81f327e7..ed8eacdf61da 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1145,6 +1145,15 @@ static int ext4_set_context(struct inode *inode, const void *ctx, size_t len,
 	handle_t *handle = fs_data;
 	int res, res2, retries = 0;
 
+	/*
+	 * Encrypting the root directory is not allowed because e2fsck expects
+	 * lost+found to exist and be unencrypted, and encrypting the root
+	 * directory would imply encrypting the lost+found directory as well as
+	 * the filename "lost+found" itself.
+	 */
+	if (inode->i_ino == EXT4_ROOT_INO)
+		return -EBUSY;
+
 	res = ext4_convert_inline_data(inode);
 	if (res)
 		return res;
-- 
2.13.1.508.gb3defc5cc-goog
