From: Wang Shilong <wangshilong1991@gmail.com>
Subject: [PATCH] Ext4: remove a useless check for the function ext4_data_block_valid
Date: Thu, 26 Jan 2012 14:55:03 -0800
Message-ID: <4F21D9C7.1000303@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f52.google.com ([209.85.160.52]:54751 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014Ab3AZGwo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 26 Jan 2013 01:52:44 -0500
Received: by mail-pb0-f52.google.com with SMTP id uo5so605043pbc.25
        for <linux-ext4@vger.kernel.org>; Fri, 25 Jan 2013 22:52:44 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

Because it is no doubt 'start_blk + count < start_blk' always comes to
false. It is useless to have this check,remove it.

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
---
 fs/ext4/block_validity.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/ext4/block_validity.c b/fs/ext4/block_validity.c
index 3f11656..5ffce82 100644
--- a/fs/ext4/block_validity.c
+++ b/fs/ext4/block_validity.c
@@ -226,7 +226,6 @@ int ext4_data_block_valid(struct ext4_sb_info *sbi, ext4_fsblk_t start_blk,
 	struct rb_node *n = sbi->system_blks.rb_node;
 
 	if ((start_blk <= le32_to_cpu(sbi->s_es->s_first_data_block)) ||
-	    (start_blk + count < start_blk) ||
 	    (start_blk + count > ext4_blocks_count(sbi->s_es))) {
 		sbi->s_es->s_last_error_block = cpu_to_le64(start_blk);
 		return 0;
-- 1.7.11.7

