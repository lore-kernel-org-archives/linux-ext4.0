From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] e2fsck: Add superblock check to make sure s_first_ino is valid
Date: Thu, 22 Jan 2009 16:33:01 -0500
Message-ID: <1232659984-10183-1-git-send-email-tytso@mit.edu>
References: <20090122211224.GJ14966@mit.edu>
Cc: Eric Sesterhenn <snakebyte@gmx.de>, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:44594 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751070AbZAVVdH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 22 Jan 2009 16:33:07 -0500
In-Reply-To: <20090122211224.GJ14966@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

An deliberately corrupted filesystem with an insanely large
s_first_ino field could cause e2fsck to crash with a seg fault.

Thanks to Eric Sesterhenn for supplying test cases which demonstrated
this issue.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 e2fsck/super.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/e2fsck/super.c b/e2fsck/super.c
index cd2b9f0..24ec7a8 100644
--- a/e2fsck/super.c
+++ b/e2fsck/super.c
@@ -513,6 +513,10 @@ void check_super_block(e2fsck_t ctx)
 	check_super_value(ctx, "reserved_gdt_blocks",
 			  sb->s_reserved_gdt_blocks, MAX_CHECK, 0,
 			  fs->blocksize/4);
+	if (sb->s_rev_level > EXT2_GOOD_OLD_REV)
+		check_super_value(ctx, "first_ino", sb->s_first_ino,
+				  MIN_CHECK | MAX_CHECK,
+				  EXT2_GOOD_OLD_FIRST_INO, sb->s_inodes_count);
 	inode_size = EXT2_INODE_SIZE(sb);
 	check_super_value(ctx, "inode_size",
 			  inode_size, MIN_CHECK | MAX_CHECK,
-- 
1.6.0.4.8.g36f27.dirty

