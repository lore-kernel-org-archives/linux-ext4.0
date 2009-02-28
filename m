From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: Remove duplicate call to ext4_commit_super() in ext4_freeze()
Date: Sat, 28 Feb 2009 00:09:34 -0500
Message-ID: <1235797774-6279-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:53020 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750772AbZB1FJj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 28 Feb 2009 00:09:39 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Commit c4be0c1d added error checking to ext4_freeze() when calling
ext4_commit_super().  Unfortunately the patch failed to remove the
original call to ext4_commit_super(), with the net result that when
freezing the filesystem, the superblock gets written twice, the first
time without error checking.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/super.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index a5732c5..39d1993 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3091,7 +3091,6 @@ static int ext4_freeze(struct super_block *sb)
 
 		/* Journal blocked and flushed, clear needs_recovery flag. */
 		EXT4_CLEAR_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
-		ext4_commit_super(sb, EXT4_SB(sb)->s_es, 1);
 		error = ext4_commit_super(sb, EXT4_SB(sb)->s_es, 1);
 		if (error)
 			goto out;
-- 
1.5.6.3

