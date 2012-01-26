From: Wang Shilong <wangshilong1991@gmail.com>
Subject: [PATCH 2/2] Ext3: remove a useless check for the function ext3_free_blocks_sb
Date: Thu, 26 Jan 2012 14:55:32 -0800
Message-ID: <4F21D9E4.9040109@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: jack@suse.cz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:35550 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014Ab3AZGxQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 26 Jan 2013 01:53:16 -0500
Received: by mail-pa0-f54.google.com with SMTP id bi5so663152pad.41
        for <linux-ext4@vger.kernel.org>; Fri, 25 Jan 2013 22:53:15 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

Because 'block + count < block' always comes to false, it is useless
to have this check, just remove it.

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
---
 fs/ext3/balloc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
index 22548f5..c557f22 100644
--- a/fs/ext3/balloc.c
+++ b/fs/ext3/balloc.c
@@ -507,7 +507,6 @@ void ext3_free_blocks_sb(handle_t *handle, struct super_block *sb,
 	sbi = EXT3_SB(sb);
 	es = sbi->s_es;
 	if (block < le32_to_cpu(es->s_first_data_block) ||
-	    block + count < block ||
 	    block + count > le32_to_cpu(es->s_blocks_count)) {
 		ext3_error (sb, "ext3_free_blocks",
 			    "Freeing blocks not in datazone - "
-- 1.7.11.7

