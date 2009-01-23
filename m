From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: [PATCH] ext4: fix oops when online resizing a filesystem with flex_bg
Date: Fri, 23 Jan 2009 18:41:49 -0200
Message-ID: <1232743309-3929-1-git-send-email-cascardo@holoscopio.com>
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from liberdade.minaslivre.org ([72.232.18.203]:40589 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600AbZAWUlW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 23 Jan 2009 15:41:22 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://kerneloops.org/raw.php?rawid=176715 and
http://bugzilla.kernel.org/show_bug.cgi?id=12433 report a bug when
resizing a mounted ext4 filesystem. I could easily reproduce it using
2.6.29-rc2, 2.6.28 and 2.6.27.

ext4_error was called just before the NULL derefence from
ext4_get_group_desc, indicating a block group beyond s_groups_count.
This function returned a NULL. The requested block group was beyond
s_groups_count because this is the last changed bit when resizing.

The caller, ext4_group_used_meta_blocks, did not check the returned
pointer. It needs the gdp anyway. Fortunately, its only caller,
ext4_init_block_bitmap, has a gdp and it was simply a matter of adding
this parameter to ext4_group_used_meta_blocks and use it.

Tested and the oops is gone.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
---
 fs/ext4/balloc.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 9a50b80..d7dc22a 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -55,7 +55,7 @@ static int ext4_block_in_group(struct super_block *sb, ext4_fsblk_t block,
 }
 
 static int ext4_group_used_meta_blocks(struct super_block *sb,
-				ext4_group_t block_group)
+		ext4_group_t block_group, struct ext4_group_desc *gdp)
 {
 	ext4_fsblk_t tmp;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
@@ -63,10 +63,6 @@ static int ext4_group_used_meta_blocks(struct super_block *sb,
 	int used_blocks = sbi->s_itb_per_group + 2;
 
 	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FLEX_BG)) {
-		struct ext4_group_desc *gdp;
-		struct buffer_head *bh;
