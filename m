From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: [PATCH] ext4: remove needs_recovery in ext4_mb_init()
Date: Fri, 13 Apr 2012 10:52:44 +0900
Message-ID: <4F8786EC.1000302@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:50357 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757797Ab2DMBx1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Apr 2012 21:53:27 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

needs_recovery in ext4_mb_init() is not used,
remove it.

Signed-off-by: Akira Fujita <a-fujita@rs.jp.ne.com>
---
 fs/ext4/ext4.h    |    2 +-
 fs/ext4/mballoc.c |    2 +-
 fs/ext4/super.c   |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index ab2594a..00afad8 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1867,7 +1867,7 @@ extern void ext4_end_bitmap_read(struct buffer_head *bh, int uptodate);
 /* mballoc.c */
 extern long ext4_mb_stats;
 extern long ext4_mb_max_to_scan;
-extern int ext4_mb_init(struct super_block *, int);
+extern int ext4_mb_init(struct super_block *);
 extern int ext4_mb_release(struct super_block *);
 extern ext4_fsblk_t ext4_mb_new_blocks(handle_t *,
 				struct ext4_allocation_request *, int *);
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 99ab428..90792dc 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2375,7 +2375,7 @@ static int ext4_groupinfo_create_slab(size_t size)
 	return 0;
 }
 
-int ext4_mb_init(struct super_block *sb, int needs_recovery)
+int ext4_mb_init(struct super_block *sb)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	unsigned i, j;
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index ceebaf8..0c6ded5 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3643,7 +3643,7 @@ no_journal:
 	}
 
 	ext4_ext_init(sb);
-	err = ext4_mb_init(sb, needs_recovery);
+	err = ext4_mb_init(sb);
 	if (err) {
 		ext4_msg(sb, KERN_ERR, "failed to initialize mballoc (%d)",
 			 err);
