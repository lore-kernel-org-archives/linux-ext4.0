From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 6/8] ext4 crypto: policies may only be set on directories
Date: Thu, 28 May 2015 19:47:45 -0400
Message-ID: <1432856867-5710-6-git-send-email-tytso@mit.edu>
References: <1432856867-5710-1-git-send-email-tytso@mit.edu>
Cc: jaegeuk@kernel.org, mhalcrow@google.com,
	Theodore Ts'o <tytso@mit.edu>, Chao Yu <chao2.yu@samsung.com>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35483 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755169AbbE1Xs1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 May 2015 19:48:27 -0400
In-Reply-To: <1432856867-5710-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks to Chao Yu <chao2.yu@samsung.com> for pointing out we were
missing this check.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/crypto_policy.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ext4/crypto_policy.c b/fs/ext4/crypto_policy.c
index 81980a15..a1d434d 100644
--- a/fs/ext4/crypto_policy.c
+++ b/fs/ext4/crypto_policy.c
@@ -93,6 +93,8 @@ int ext4_process_policy(const struct ext4_encryption_policy *policy,
 		return -EINVAL;
 
 	if (!ext4_inode_has_encryption_context(inode)) {
+		if (!S_ISDIR(inode->i_mode))
+			return -EINVAL;
 		if (!ext4_empty_dir(inode))
 			return -ENOTEMPTY;
 		return ext4_create_encryption_context_from_policy(inode,
-- 
2.3.0

