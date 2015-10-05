From: Andy Leiserson <andy@leiserson.org>
Subject: [PATCH] fix calculation of meta_bg descriptor backups
Date: Mon,  5 Oct 2015 08:48:22 -0700
Message-ID: <1444060102-8296-1-git-send-email-andy@leiserson.org>
Cc: Andy Leiserson <andy@leiserson.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:35161 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600AbbJEPsp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Oct 2015 11:48:45 -0400
Received: by pacfv12 with SMTP id fv12so184053228pac.2
        for <linux-ext4@vger.kernel.org>; Mon, 05 Oct 2015 08:48:45 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

"group" is the group where the backup will be placed, and is initialized
to zero in the declaration. This meant that backups for meta_bg
descriptors were erroneously written to group 1 and group
(desc_per_block-1).

Signed-off-by: Andy Leiserson <andy@leiserson.org>
---
 fs/ext4/resize.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index cf0c472..c7c53fd 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1040,7 +1040,7 @@ exit_free:
  * do not copy the full number of backups at this time.  The resize
  * which changed s_groups_count will backup again.
  */
-static void update_backups(struct super_block *sb, int blk_off, char *data,
+static void update_backups(struct super_block *sb, sector_t blk_off, char *data,
 			   int size, int meta_bg)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
@@ -1065,7 +1065,7 @@ static void update_backups(struct super_block *sb, int blk_off, char *data,
 		group = ext4_list_backups(sb, &three, &five, &seven);
 		last = sbi->s_groups_count;
 	} else {
-		group = ext4_meta_bg_first_group(sb, group) + 1;
+		group = ext4_get_group_number(sb, blk_off) + 1;
 		last = (ext4_group_t)(group + EXT4_DESC_PER_BLOCK(sb) - 2);
 	}
 
-- 
2.5.3

