From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/8] ext4 crypto: set up encryption info for new inodes in ext4_inherit_context()
Date: Thu, 28 May 2015 19:47:41 -0400
Message-ID: <1432856867-5710-2-git-send-email-tytso@mit.edu>
References: <1432856867-5710-1-git-send-email-tytso@mit.edu>
Cc: jaegeuk@kernel.org, mhalcrow@google.com,
	Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35482 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755049AbbE1Xs1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 May 2015 19:48:27 -0400
In-Reply-To: <1432856867-5710-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Set up the encryption information for newly created inodes immediately
after they inherit their encryption context from their parent
directories.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/crypto_policy.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ext4/crypto_policy.c b/fs/ext4/crypto_policy.c
index 683391f..81980a15 100644
--- a/fs/ext4/crypto_policy.c
+++ b/fs/ext4/crypto_policy.c
@@ -206,6 +206,7 @@ int ext4_inherit_context(struct inode *parent, struct inode *child)
 	if (!res) {
 		ext4_set_inode_flag(child, EXT4_INODE_ENCRYPT);
 		ext4_clear_inode_state(child, EXT4_STATE_MAY_INLINE_DATA);
+		res = ext4_get_encryption_info(child);
 	}
 	return res;
 }
-- 
2.3.0

