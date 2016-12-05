From: Eric Biggers <ebiggers@google.com>
Subject: [RFC PATCH 4/5] fscrypt: remove user-triggerable warning messages
Date: Mon,  5 Dec 2016 11:12:47 -0800
Message-ID: <1480965168-38747-5-git-send-email-ebiggers@google.com>
References: <1480965168-38747-1-git-send-email-ebiggers@google.com>
Cc: linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Richard Weinberger <richard@nod.at>,
        David Gstir <david@sigma-star.at>,
        Eric Biggers <ebiggers@google.com>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f44.google.com ([74.125.83.44]:36782 "EHLO
        mail-pg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751741AbcLETNi (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Dec 2016 14:13:38 -0500
Received: by mail-pg0-f44.google.com with SMTP id f188so139152110pgc.3
        for <linux-ext4@vger.kernel.org>; Mon, 05 Dec 2016 11:13:38 -0800 (PST)
In-Reply-To: <1480965168-38747-1-git-send-email-ebiggers@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Several warning messages were not rate limited and were user-triggerable
from FS_IOC_SET_ENCRYPTION_POLICY.  These shouldn't really have been
there in the first place, but either way they aren't as useful now that
the error codes have been improved.  So just remove them.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/policy.c | 15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
index 4811539..a9f11b3 100644
--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -66,20 +66,12 @@ static int create_encryption_context_from_policy(struct inode *inode,
 					FS_KEY_DESCRIPTOR_SIZE);
 
 	if (!fscrypt_valid_contents_enc_mode(
-				policy->contents_encryption_mode)) {
-		printk(KERN_WARNING
-		       "%s: Invalid contents encryption mode %d\n", __func__,
-			policy->contents_encryption_mode);
+				policy->contents_encryption_mode))
 		return -EINVAL;
-	}
 
 	if (!fscrypt_valid_filenames_enc_mode(
-				policy->filenames_encryption_mode)) {
-		printk(KERN_WARNING
-			"%s: Invalid filenames encryption mode %d\n", __func__,
-			policy->filenames_encryption_mode);
+				policy->filenames_encryption_mode))
 		return -EINVAL;
-	}
 
 	if (policy->flags & ~FS_POLICY_FLAGS_VALID)
 		return -EINVAL;
@@ -126,9 +118,6 @@ int fscrypt_ioctl_set_policy(struct file *filp, const void __user *arg)
 								    &policy);
 	} else if (!is_encryption_context_consistent_with_policy(inode,
 								 &policy)) {
-		printk(KERN_WARNING
-		       "%s: Policy inconsistent with encryption context\n",
-		       __func__);
 		ret = -EEXIST;
 	}
 
-- 
2.8.0.rc3.226.g39d4020

