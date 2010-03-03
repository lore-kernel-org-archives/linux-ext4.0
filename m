From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 3/3] ext4: consolidate in_range() definisions
Date: Wed,  3 Mar 2010 23:40:46 +0900
Message-ID: <1267627246-12863-3-git-send-email-akinobu.mita@gmail.com>
References: <1267627246-12863-1-git-send-email-akinobu.mita@gmail.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
	Andreas Dilger <adilger@sun.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:55030 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754424Ab0CCOlz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Mar 2010 09:41:55 -0500
Received: by mail-bw0-f209.google.com with SMTP id 1so57421bwz.21
        for <linux-ext4@vger.kernel.org>; Wed, 03 Mar 2010 06:41:55 -0800 (PST)
In-Reply-To: <1267627246-12863-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

There are same in_range() macro definisions in mballoc.h and
balloc.c. This consolidates these in_range() definisions and
use it in extents.c, too

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Andreas Dilger <adilger@sun.com>
Cc: linux-ext4@vger.kernel.org
Cc: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/balloc.c  |    3 ---
 fs/ext4/ext4.h    |    2 ++
 fs/ext4/extents.c |    4 ++--
 fs/ext4/mballoc.h |    2 --
 4 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 89733a5..c35c937 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -188,9 +188,6 @@ unsigned ext4_init_block_bitmap(struct super_block *sb, struct buffer_head *bh,
  * when a file system is mounted (see ext4_fill_super).
  */
 
-
-#define in_range(b, first, len)	((b) >= (first) && (b) <= (first) + (len) - 1)
-
 /**
  * ext4_get_group_desc() -- load group descriptor from disk
  * @sb:			super block
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 874d169..3424afb 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1773,6 +1773,8 @@ static inline void set_bitmap_uptodate(struct buffer_head *bh)
 	set_bit(BH_BITMAP_UPTODATE, &(bh)->b_state);
 }
 
+#define in_range(b, first, len)	((b) >= (first) && (b) <= (first) + (len) - 1)
+
 #endif	/* __KERNEL__ */
 
 #endif	/* _EXT4_H */
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 11eaaa9..69b96cd 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1951,7 +1951,7 @@ ext4_ext_in_cache(struct inode *inode, ext4_lblk_t block,
 
 	BUG_ON(cex->ec_type != EXT4_EXT_CACHE_GAP &&
 			cex->ec_type != EXT4_EXT_CACHE_EXTENT);
-	if (block >= cex->ec_block && block < cex->ec_block + cex->ec_len) {
+	if (in_range(block, cex->ec_block, cex->ec_len)) {
 		ex->ee_block = cpu_to_le32(cex->ec_block);
 		ext4_ext_store_pblock(ex, cex->ec_start);
 		ex->ee_len = cpu_to_le16(cex->ec_len);
@@ -3257,7 +3257,7 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 		 */
 		ee_len = ext4_ext_get_actual_len(ex);
 		/* if found extent covers block, simply return it */
-		if (iblock >= ee_block && iblock < ee_block + ee_len) {
+		if (in_range(iblock, ee_block, ee_len)) {
 			newblock = iblock - ee_block + ee_start;
 			/* number of remaining blocks in the extent */
 			allocated = ee_len - (iblock - ee_block);
diff --git a/fs/ext4/mballoc.h b/fs/ext4/mballoc.h
index 9b2deed..b619322 100644
--- a/fs/ext4/mballoc.h
+++ b/fs/ext4/mballoc.h
@@ -220,8 +220,6 @@ struct ext4_buddy {
 #define EXT4_MB_BITMAP(e4b)	((e4b)->bd_bitmap)
 #define EXT4_MB_BUDDY(e4b)	((e4b)->bd_buddy)
 
-#define in_range(b, first, len)	((b) >= (first) && (b) <= (first) + (len) - 1)
