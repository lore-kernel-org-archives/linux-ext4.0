From: Eric Biggers <ebiggers@google.com>
Subject: [RFC PATCH 3/5] fscrypt: use EEXIST when file already uses different policy
Date: Mon,  5 Dec 2016 11:12:46 -0800
Message-ID: <1480965168-38747-4-git-send-email-ebiggers@google.com>
References: <1480965168-38747-1-git-send-email-ebiggers@google.com>
Cc: linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Richard Weinberger <richard@nod.at>,
        David Gstir <david@sigma-star.at>,
        Eric Biggers <ebiggers@google.com>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1480965168-38747-1-git-send-email-ebiggers@google.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

As part of an effort to clean up fscrypt-related error codes, make
FS_IOC_SET_ENCRYPTION_POLICY fail with EEXIST when the file already uses
a different encryption policy.  This is more descriptive than EINVAL,
which was ambiguous with some of the other error cases.

I am not aware of any users who might be relying on the previous error
code of EINVAL, which was never documented anywhere.

This failure case will be exercised by an xfstest.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/policy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
index 1118f3a..4811539 100644
--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -129,7 +129,7 @@ int fscrypt_ioctl_set_policy(struct file *filp, const void __user *arg)
 		printk(KERN_WARNING
 		       "%s: Policy inconsistent with encryption context\n",
 		       __func__);
-		ret = -EINVAL;
+		ret = -EEXIST;
 	}
 
 	inode_unlock(inode);
-- 
2.8.0.rc3.226.g39d4020

