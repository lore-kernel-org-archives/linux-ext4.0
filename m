From: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] ext4: Use symbolic constants for well-known pow 2 sizes
Date: Fri, 29 Sep 2017 16:58:50 +0300
Message-ID: <1506693530-11800-1-git-send-email-nborisov@suse.com>
Cc: tytso@mit.edu, Nikolay Borisov <nborisov@suse.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47451 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751224AbdI2N7B (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 29 Sep 2017 09:59:01 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

No functional changes, just makes the code a bit more readable. Also fix 1
trailing whitespace

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/ext4/mballoc.c | 43 ++++++++++++++++++++++---------------------
 1 file changed, 22 insertions(+), 21 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 701085620cd8..27d77bf9f766 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -28,6 +28,7 @@
 #include <linux/slab.h>
 #include <linux/backing-dev.h>
 #include <trace/events/ext4.h>
+#include <linux/sizes.h>
 
 #ifdef CONFIG_EXT4_DEBUG
 ushort ext4_mballoc_debug __read_mostly;
@@ -2407,7 +2408,7 @@ int ext4_mb_alloc_groupinfo(struct super_block *sb, ext4_group_t ngroups)
 	}
 	sbi->s_group_info = new_groupinfo;
 	sbi->s_group_info_size = size / sizeof(*sbi->s_group_info);
-	ext4_debug("allocated s_groupinfo array for %d meta_bg's\n", 
+	ext4_debug("allocated s_groupinfo array for %d meta_bg's\n",
 		   sbi->s_group_info_size);
 	return 0;
 }
@@ -3136,33 +3137,33 @@ ext4_mb_normalize_request(struct ext4_allocation_context *ac,
 	/* first, try to predict filesize */
 	/* XXX: should this table be tunable? */
 	start_off = 0;
-	if (size <= 16 * 1024) {
-		size = 16 * 1024;
-	} else if (size <= 32 * 1024) {
-		size = 32 * 1024;
-	} else if (size <= 64 * 1024) {
-		size = 64 * 1024;
-	} else if (size <= 128 * 1024) {
-		size = 128 * 1024;
-	} else if (size <= 256 * 1024) {
-		size = 256 * 1024;
-	} else if (size <= 512 * 1024) {
-		size = 512 * 1024;
-	} else if (size <= 1024 * 1024) {
-		size = 1024 * 1024;
-	} else if (NRL_CHECK_SIZE(size, 4 * 1024 * 1024, max, 2 * 1024)) {
+	if (size <= SZ_16) {
+		size = SZ_16;
+	} else if (size <= SZ_32) {
+		size = SZ_32;
+	} else if (size <= SZ_64) {
+		size = SZ_64;
+	} else if (size <= SZ_128) {
+		size = SZ_128;
+	} else if (size <= SZ_256) {
+		size = SZ_256;
+	} else if (size <= SZ_512) {
+		size = SZ_512;
+	} else if (size <= SZ_1K) {
+		size = SZ_1K;
+	} else if (NRL_CHECK_SIZE(size, SZ_4M, max, SZ_2K)) {
 		start_off = ((loff_t)ac->ac_o_ex.fe_logical >>
 						(21 - bsbits)) << 21;
-		size = 2 * 1024 * 1024;
-	} else if (NRL_CHECK_SIZE(size, 8 * 1024 * 1024, max, 4 * 1024)) {
+		size = SZ_2M;
+	} else if (NRL_CHECK_SIZE(size, SZ_8M, max, SZ_4K)) {
 		start_off = ((loff_t)ac->ac_o_ex.fe_logical >>
 							(22 - bsbits)) << 22;
-		size = 4 * 1024 * 1024;
+		size = SZ_4M;
 	} else if (NRL_CHECK_SIZE(ac->ac_o_ex.fe_len,
-					(8<<20)>>bsbits, max, 8 * 1024)) {
+					(8<<20)>>bsbits, max, SZ_8K)) {
 		start_off = ((loff_t)ac->ac_o_ex.fe_logical >>
 							(23 - bsbits)) << 23;
-		size = 8 * 1024 * 1024;
+		size = SZ_8M;
 	} else {
 		start_off = (loff_t) ac->ac_o_ex.fe_logical << bsbits;
 		size	  = (loff_t) EXT4_C2B(EXT4_SB(ac->ac_sb),
-- 
2.7.4
