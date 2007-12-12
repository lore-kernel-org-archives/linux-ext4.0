From: akpm@linux-foundation.org
Subject: + ext3-ext4-avoid-divide-by-zero.patch added to -mm tree
Date: Wed, 12 Dec 2007 02:27:28 -0800
Message-ID: <200712121027.lBCARSKQ005179@imap1.linux-foundation.org>
Cc: Andries.Brouwer@cwi.nl, alan@redhat.com, linux-ext4@vger.kernel.org
To: mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34965 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758910AbXLLK2W (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Dec 2007 05:28:22 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The patch titled
     ext3, ext4: avoid divide by zero
has been added to the -mm tree.  Its filename is
     ext3-ext4-avoid-divide-by-zero.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ext3, ext4: avoid divide by zero
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

Patches currently in -mm which might be from Andries.Brouwer@cwi.nl are

ext3-ext4-avoid-divide-by-zero.patch
mnt_unbindable-fix.patch
