From: Eric Biggers <ebiggers@google.com>
Subject: [RFC PATCH 2/5] fscrypt: use ENOTDIR when setting encryption policy on nondirectory
Date: Mon,  5 Dec 2016 11:12:45 -0800
Message-ID: <1480965168-38747-3-git-send-email-ebiggers@google.com>
References: <1480965168-38747-1-git-send-email-ebiggers@google.com>
Cc: linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Richard Weinberger <richard@nod.at>,
        David Gstir <david@sigma-star.at>,
        Eric Biggers <ebiggers@google.com>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f46.google.com ([74.125.83.46]:33942 "EHLO
        mail-pg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751427AbcLETNf (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Dec 2016 14:13:35 -0500
Received: by mail-pg0-f46.google.com with SMTP id x23so139662008pgx.1
        for <linux-ext4@vger.kernel.org>; Mon, 05 Dec 2016 11:13:34 -0800 (PST)
In-Reply-To: <1480965168-38747-1-git-send-email-ebiggers@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

As part of an effort to clean up fscrypt-related error codes, make
FS_IOC_SET_ENCRYPTION_POLICY fail with ENOTDIR when the file descriptor
does not refer to a directory.  This is more descriptive than EINVAL,
which was ambiguous with some of the other error cases.

I am not aware of any users who might be relying on the previous error
code of EINVAL, which was never documented anywhere, and in some buggy
kernels did not exist at all as the S_ISDIR() check was missing.

This failure case will be exercised by an xfstest.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/policy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
index b96a10e..1118f3a 100644
--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -116,7 +116,7 @@ int fscrypt_ioctl_set_policy(struct file *filp, const void __user *arg)
 
 	if (!inode_has_encryption_context(inode)) {
 		if (!S_ISDIR(inode->i_mode))
-			ret = -EINVAL;
+			ret = -ENOTDIR;
 		else if (!inode->i_sb->s_cop->empty_dir)
 			ret = -EOPNOTSUPP;
 		else if (!inode->i_sb->s_cop->empty_dir(inode))
-- 
2.8.0.rc3.226.g39d4020

