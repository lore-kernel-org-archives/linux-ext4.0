From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [PATCH] ext4: preload block group descriptors
Date: Mon, 20 Feb 2017 19:45:53 +0300
Message-ID: <1487609153-3367-1-git-send-email-artem.blagodarenko@gmail.com>
Cc: alexey.lyashkov@gmail.com,
        Andrew Perepechko <andrew.perepechko@seagate.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:35172 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752846AbdBTQri (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 20 Feb 2017 11:47:38 -0500
Received: by mail-pg0-f68.google.com with SMTP id 1so6401325pgz.2
        for <linux-ext4@vger.kernel.org>; Mon, 20 Feb 2017 08:47:38 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Andrew Perepechko <andrew.perepechko@seagate.com>

With enabled meta_bg option block group descriptors
reading IO is not sequential and requires optimization.

Signed-off-by: Andrew Perepechko <andrew.perepechko@seagate.com>
---
 fs/ext4/super.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index a673558..0e52c91 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3879,6 +3879,12 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 
 	bgl_lock_init(sbi->s_blockgroup_lock);
 
+	/* Pre-read the descriptors into the buffer cache */
+	for (i = 0; i < db_count; i++) {
+		block = descriptor_loc(sb, logical_sb_block, i);
+		sb_breadahead(sb, block);
+	}
+
 	for (i = 0; i < db_count; i++) {
 		block = descriptor_loc(sb, logical_sb_block, i);
 		sbi->s_group_desc[i] = sb_bread_unmovable(sb, block);
-- 
1.8.3.1
