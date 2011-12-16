From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] e2fsck: fix use of uninitialized value in the MMP code
Date: Fri, 16 Dec 2011 15:37:52 -0500
Message-ID: <1324067872-7455-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:57504 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030223Ab1LPUh4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Dec 2011 15:37:56 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 e2fsck/pass1.c  |    2 +-
 e2fsck/pass1b.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 00e46d0..d225026 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -545,7 +545,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 	int	i;
 	__u64	max_sizes;
 	ext2_filsys fs = ctx->fs;
-	ext2_ino_t	ino;
+	ext2_ino_t	ino = 0;
 	struct ext2_inode *inode;
 	ext2_inode_scan	scan;
 	char		*block_buf;
diff --git a/e2fsck/pass1b.c b/e2fsck/pass1b.c
index f7ce8e4..a9eecd2 100644
--- a/e2fsck/pass1b.c
+++ b/e2fsck/pass1b.c
@@ -267,7 +267,7 @@ struct process_block_struct {
 static void pass1b(e2fsck_t ctx, char *block_buf)
 {
 	ext2_filsys fs = ctx->fs;
-	ext2_ino_t ino;
+	ext2_ino_t ino = 0;
 	struct ext2_inode inode;
 	ext2_inode_scan	scan;
 	struct process_block_struct pb;
-- 
1.7.8.11.gefc1f.dirty

