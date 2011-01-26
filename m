From: Wang Shilong <wangshilong1991@gmail.com>
Subject: [PATCH 1/2] Ext2: remove a useless check for the function ext2_free_blocks
Date: Wed, 26 Jan 2011 14:47:12 -0800
Message-ID: <4D40A470.7050601@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: jack@suse.cz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45860 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066Ab3AZGoh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 26 Jan 2013 01:44:37 -0500
Received: by mail-pb0-f46.google.com with SMTP id uo15so601374pbc.19
        for <linux-ext4@vger.kernel.org>; Fri, 25 Jan 2013 22:44:37 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

Because 'block + count < block' always comes to false, it is useles to
have this check,just remove it.

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
---
 fs/ext2/balloc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/ext2/balloc.c b/fs/ext2/balloc.c
index 2616d0e..081929c 100644
--- a/fs/ext2/balloc.c
+++ b/fs/ext2/balloc.c
@@ -498,7 +498,6 @@ void ext2_free_blocks (struct inode * inode, unsigned long block,
 	unsigned freed = 0, group_freed;
 
 	if (block < le32_to_cpu(es->s_first_data_block) ||
-	    block + count < block ||
 	    block + count > le32_to_cpu(es->s_blocks_count)) {
 		ext2_error (sb, "ext2_free_blocks",
 			    "Freeing blocks not in datazone - "
-- 1.7.11.7

