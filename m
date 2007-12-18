From: akpm@linux-foundation.org
Subject: [patch 11/32] ext3, ext4: avoid divide by zero
Date: Mon, 17 Dec 2007 16:19:55 -0800
Message-ID: <200712180019.lBI0JuhJ009834@imap1.linux-foundation.org>
Cc: akpm@linux-foundation.org, Andries.Brouwer@cwi.nl, alan@redhat.com,
	linux-ext4@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44891 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753585AbXLRAUs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 Dec 2007 19:20:48 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>

As it turns out, the kernel divides by EXT3_INODES_PER_GROUP(s) when
mounting an ext3 filesystem.  If that number is zero, a crash follows. 
Below a patch.

This crash was reported by Joeri de Ruiter, Carst Tankink and Pim Vullers.

Cc: <linux-ext4@vger.kernel.org>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/super.c |    2 +-
 fs/ext4/super.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/ext3/super.c~ext3-ext4-avoid-divide-by-zero fs/ext3/super.c
--- a/fs/ext3/super.c~ext3-ext4-avoid-divide-by-zero
+++ a/fs/ext3/super.c
@@ -1676,7 +1676,7 @@ static int ext3_fill_super (struct super
 	sbi->s_blocks_per_group = le32_to_cpu(es->s_blocks_per_group);
 	sbi->s_frags_per_group = le32_to_cpu(es->s_frags_per_group);
 	sbi->s_inodes_per_group = le32_to_cpu(es->s_inodes_per_group);
-	if (EXT3_INODE_SIZE(sb) == 0)
+	if (EXT3_INODE_SIZE(sb) == 0 || EXT3_INODES_PER_GROUP(sb) == 0)
 		goto cantfind_ext3;
 	sbi->s_inodes_per_block = blocksize / EXT3_INODE_SIZE(sb);
 	if (sbi->s_inodes_per_block == 0)
diff -puN fs/ext4/super.c~ext3-ext4-avoid-divide-by-zero fs/ext4/super.c
--- a/fs/ext4/super.c~ext3-ext4-avoid-divide-by-zero
+++ a/fs/ext4/super.c
@@ -1797,7 +1797,7 @@ static int ext4_fill_super (struct super
 		sbi->s_desc_size = EXT4_MIN_DESC_SIZE;
 	sbi->s_blocks_per_group = le32_to_cpu(es->s_blocks_per_group);
 	sbi->s_inodes_per_group = le32_to_cpu(es->s_inodes_per_group);
-	if (EXT4_INODE_SIZE(sb) == 0)
+	if (EXT4_INODE_SIZE(sb) == 0 || EXT4_INODES_PER_GROUP(sb) == 0)
 		goto cantfind_ext4;
 	sbi->s_inodes_per_block = blocksize / EXT4_INODE_SIZE(sb);
 	if (sbi->s_inodes_per_block == 0)
_
