From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH] ext4: improve ext4_fill_flex_info() a bit
Date: Thu, 24 Jul 2008 09:30:20 +0800
Message-ID: <4887DB2C.1080403@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:50204 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750836AbYGXBbx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Jul 2008 21:31:53 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

- use kzalloc() instead of kmalloc() + memset()
- improve a printk info

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/ext4/super.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 1cb371d..33eab31 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1506,14 +1506,13 @@ static int ext4_fill_flex_info(struct super_block *sb)
 
 	flex_group_count = (sbi->s_groups_count + groups_per_flex - 1) /
 		groups_per_flex;
-	sbi->s_flex_groups = kmalloc(flex_group_count *
+	sbi->s_flex_groups = kzalloc(flex_group_count *
 				     sizeof(struct flex_groups), GFP_KERNEL);
 	if (sbi->s_flex_groups == NULL) {
-		printk(KERN_ERR "EXT4-fs: not enough memory\n");
+		printk(KERN_ERR "EXT4-fs: not enough memory for "
+				"%lu flex groups\n", flex_group_count);
 		goto failed;
 	}
-	memset(sbi->s_flex_groups, 0, flex_group_count *
-	       sizeof(struct flex_groups));
 
 	gdp = ext4_get_group_desc(sb, 1, &bh);
 	block_bitmap = ext4_block_bitmap(sb, gdp) - 1;
-- 
1.5.4.rc3

