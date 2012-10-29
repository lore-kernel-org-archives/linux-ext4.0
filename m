From: Zhao Hongjiang <zhaohongjiang37@gmail.com>
Subject: [PATCH] ext3: get rid of the duplicate code on ext3_fill_super
Date: Mon, 29 Oct 2012 15:28:07 +0800
Message-ID: <508E3007.1070902@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: akpm@linux-foundation.org, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: jack@suse.cz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:40157 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432Ab2J2H3M (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Oct 2012 03:29:12 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zhao Hongjiang <zhaohongjiang@huawei.com>

Clean the duplicate code on ext3_fill_super cause the bellow
also have it.

Signed-off-by: Zhao Hongjiang <zhaohongjiang@huawei.com>
---
 fs/ext3/super.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 5366393..6e50223 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -1661,9 +1661,6 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
 		return -ENOMEM;
 	}
 	sb->s_fs_info = sbi;
-	sbi->s_mount_opt = 0;
-	sbi->s_resuid = make_kuid(&init_user_ns, EXT3_DEF_RESUID);
-	sbi->s_resgid = make_kgid(&init_user_ns, EXT3_DEF_RESGID);
 	sbi->s_sb_block = sb_block;

 	blocksize = sb_min_blocksize(sb, EXT3_MIN_BLOCK_SIZE);
-- 1.7.1
