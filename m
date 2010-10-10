From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH] ext3: Cleanup ext3_setup_super()
Date: Sun, 10 Oct 2010 21:36:59 +0900
Message-ID: <1286714219-3183-1-git-send-email-namhyung@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56838 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754429Ab0JJMhL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 10 Oct 2010 08:37:11 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fix mount-count check to emit warning only if s_max_mnt_count
is greater than 0 according to man tune2fs(8). Also removes
unnecessary casts.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---

If this looks fine, I'll send the same patches for ext2 and ext4.
Thanks.

 fs/ext3/super.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 5dbf4db..4caeffa 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -1306,9 +1306,9 @@ static int ext3_setup_super(struct super_block *sb, struct ext3_super_block *es,
 		ext3_msg(sb, KERN_WARNING,
 			"warning: mounting fs with errors, "
 			"running e2fsck is recommended");
-	else if ((__s16) le16_to_cpu(es->s_max_mnt_count) >= 0 &&
+	else if ((__s16) le16_to_cpu(es->s_max_mnt_count) > 0 &&
 		 le16_to_cpu(es->s_mnt_count) >=
-		 (unsigned short) (__s16) le16_to_cpu(es->s_max_mnt_count))
+			le16_to_cpu(es->s_max_mnt_count))
 		ext3_msg(sb, KERN_WARNING,
 			"warning: maximal mount count reached, "
 			"running e2fsck is recommended");
@@ -1325,7 +1325,7 @@ static int ext3_setup_super(struct super_block *sb, struct ext3_super_block *es,
                    valid forever! :) */
 	es->s_state &= cpu_to_le16(~EXT3_VALID_FS);
 #endif
-	if (!(__s16) le16_to_cpu(es->s_max_mnt_count))
+	if (!le16_to_cpu(es->s_max_mnt_count))
 		es->s_max_mnt_count = cpu_to_le16(EXT3_DFL_MAX_MNT_COUNT);
 	le16_add_cpu(&es->s_mnt_count, 1);
 	es->s_mtime = cpu_to_le32(get_seconds());
-- 
1.7.0.4

