From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] libquota: fix invalid return in non-void function
Date: Mon, 20 Feb 2012 18:27:27 -0500
Message-ID: <1329780447-1824-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:34603 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753253Ab2BTX1a (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Feb 2012 18:27:30 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

quota_inode_truncate() returns an errcode_t, not void.

Addresses-SourceForge-Bug: #3468423

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/quota/quotaio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/quota/quotaio.c b/lib/quota/quotaio.c
index 3f434ca..481d5f5 100644
--- a/lib/quota/quotaio.c
+++ b/lib/quota/quotaio.c
@@ -143,7 +143,7 @@ errcode_t quota_inode_truncate(ext2_filsys fs, ext2_ino_t ino)
 
 	inode.i_dtime = fs->now ? fs->now : time(0);
 	if (!ext2fs_inode_has_valid_blocks2(fs, &inode))
-		return;
+		return 0;
 
 	ext2fs_block_iterate3(fs, ino, BLOCK_FLAG_READ_ONLY, NULL,
 			      release_blocks_proc, NULL);
-- 
1.7.9.107.g97f9a

