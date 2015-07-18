From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/2] ext4 crypto: use a jbd2 transaction when adding a crypto policy
Date: Sat, 18 Jul 2015 08:50:29 -0400
Message-ID: <1437223830-28205-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47735 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750980AbbGRMug (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 18 Jul 2015 08:50:36 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Start a jbd2 transaction, and mark the inode dirty on the inode under
that transaction after setting the encrypt flag.  Otherwise if the
directory isn't modified after setting the crypto policy, the
encrypted flag might not survive the inode getting pushed out from
memory, or the the file system getting unmounted and remounted.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/crypto_policy.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/crypto_policy.c b/fs/ext4/crypto_policy.c
index 02c4e5d..a640ec2 100644
--- a/fs/ext4/crypto_policy.c
+++ b/fs/ext4/crypto_policy.c
@@ -12,6 +12,7 @@
 #include <linux/string.h>
 #include <linux/types.h>
 
+#include "ext4_jbd2.h"
 #include "ext4.h"
 #include "xattr.h"
 
@@ -49,7 +50,8 @@ static int ext4_create_encryption_context_from_policy(
 	struct inode *inode, const struct ext4_encryption_policy *policy)
 {
 	struct ext4_encryption_context ctx;
-	int res = 0;
+	handle_t *handle;
+	int res, res2;
 
 	res = ext4_convert_inline_data(inode);
 	if (res)
@@ -78,11 +80,22 @@ static int ext4_create_encryption_context_from_policy(
 	BUILD_BUG_ON(sizeof(ctx.nonce) != EXT4_KEY_DERIVATION_NONCE_SIZE);
 	get_random_bytes(ctx.nonce, EXT4_KEY_DERIVATION_NONCE_SIZE);
 
+	handle = ext4_journal_start(inode, EXT4_HT_MISC,
+				    ext4_jbd2_credits_xattr(inode));
+	if (IS_ERR(handle))
+		return PTR_ERR(handle);
 	res = ext4_xattr_set(inode, EXT4_XATTR_INDEX_ENCRYPTION,
 			     EXT4_XATTR_NAME_ENCRYPTION_CONTEXT, &ctx,
 			     sizeof(ctx), 0);
-	if (!res)
+	if (!res) {
 		ext4_set_inode_flag(inode, EXT4_INODE_ENCRYPT);
+		res = ext4_mark_inode_dirty(handle, inode);
+		if (res)
+			EXT4_ERROR_INODE(inode, "Failed to mark inode dirty");
+	}
+	res2 = ext4_journal_stop(handle);
+	if (!res)
+		res = res2;
 	return res;
 }
 
-- 
2.3.0

