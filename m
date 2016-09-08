From: Eric Biggers <ebiggers@google.com>
Subject: [PATCH] fscrypto: add authorization check for setting encryption policy
Date: Thu,  8 Sep 2016 10:57:08 -0700
Message-ID: <1473357429-134444-1-git-send-email-ebiggers@google.com>
Cc: linux-ext4@vger.kernel.org, linux-f2fs@vger.kernel.org,
        tytso@mit.edu, jaegeuk@kernel.org,
        Eric Biggers <ebiggers@google.com>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On an ext4 or f2fs filesystem with file encryption supported, a user
could set an encryption policy on any empty directory(*) to which they
had readonly access.  This is obviously problematic, since such a
directory might be owned by another user and the new encryption policy
would prevent that other user from creating files in their own directory
(for example).

Fix this by requiring inode_owner_or_capable() permission to set an
encryption policy.  This means that either the caller must own the file,
or the caller must have the capability CAP_FOWNER.

(*) Or also on any regular file, for f2fs v4.6 and later and ext4
    v4.8-rc1 and later; a separate bug fix is coming for that.

Signed-off-by: Eric Biggers <ebiggers@google.com>
Cc: stable@vger.kernel.org # 4.1+; check fs/{ext4,f2fs}
---
 fs/crypto/policy.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
index 0f9961e..c9800b1 100644
--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -95,6 +95,9 @@ static int create_encryption_context_from_policy(struct inode *inode,
 int fscrypt_process_policy(struct inode *inode,
 				const struct fscrypt_policy *policy)
 {
+	if (!inode_owner_or_capable(inode))
+		return -EACCES;
+
 	if (policy->version != 0)
 		return -EINVAL;
 
-- 
2.8.0.rc3.226.g39d4020

