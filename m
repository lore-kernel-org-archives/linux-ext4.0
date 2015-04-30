From: Jan Kara <jack@suse.cz>
Subject: [PATCH v2] ext4: Fix growing of tiny filesystems
Date: Thu, 30 Apr 2015 09:06:01 +0200
Message-ID: <1430377561-6079-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
	=?UTF-8?q?Luk=C3=A1=C5=A1=20Czerner?= <lczerner@redhat.com>,
	Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50240 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125AbbD3HGI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 30 Apr 2015 03:06:08 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The estimate of necessary transaction credits in ext4_flex_group_add()
is too pessimistic. It reserves credit for sb, resize inode, and resize
inode dindirect block for each group added in a flex group although they
are always the same block and thus it is enough to account them only
once. Also the number of modified GDT block is overestimated since we
fit EXT4_DESC_PER_BLOCK(sb) descriptors in one block.

Make the estimation more precise. That reduces number of requested
credits enough that we can grow 20 MB filesystem (which has 1 MB
journal, 79 reserved GDT blocks, and flex group size 16 by default).

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/resize.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 8a8ec6293b19..cf0c472047e3 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1432,12 +1432,15 @@ static int ext4_flex_group_add(struct super_block *sb,
 		goto exit;
 	/*
 	 * We will always be modifying at least the superblock and  GDT
-	 * block.  If we are adding a group past the last current GDT block,
+	 * blocks.  If we are adding a group past the last current GDT block,
 	 * we will also modify the inode and the dindirect block.  If we
 	 * are adding a group with superblock/GDT backups  we will also
 	 * modify each of the reserved GDT dindirect blocks.
 	 */
-	credit = flex_gd->count * 4 + reserved_gdb;
+	credit = 3;	/* sb, resize inode, resize inode dindirect */
+	/* GDT blocks */
+	credit += 1 + DIV_ROUND_UP(flex_gd->count, EXT4_DESC_PER_BLOCK(sb));
+	credit += reserved_gdb;	/* Reserved GDT dindirect blocks */
 	handle = ext4_journal_start_sb(sb, EXT4_HT_RESIZE, credit);
 	if (IS_ERR(handle)) {
 		err = PTR_ERR(handle);
-- 
2.1.4

