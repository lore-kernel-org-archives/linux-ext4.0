From: Miao Xie <miaoxie1984@gmail.com>
Subject: [PATCH 3/4] Ext4: use try_to_writeback_inodes_sb() instead of writeback_inodes_sb_if_idle()
Date: Thu, 26 Apr 2012 10:58:11 +0800
Message-ID: <4F98B9C3.7060809@gmail.com>
Reply-To: miaoxie1984@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Cc: Linux Ext4 <linux-ext4@vger.kernel.org>, miaox@cn.fujitsu.com,
	Linux FSDevel <linux-fsdevel@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f51.google.com ([209.85.210.51]:65426 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753336Ab2DZC60 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 25 Apr 2012 22:58:26 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If the s_umount is write locked, then the sb is not idle. IOWs,
writeback_inodes_sb...if_idle() should be doing down_read_trylock(),
not down_read(). So use try_to_writeback_inodes_sb() instead of
writeback_inodes_sb_if_idle().

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/ext4/inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c77b0bd..2dccb4d 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2380,7 +2380,7 @@ static int ext4_nonda_switch(struct super_block *sb)
 	 * start pushing delalloc when 1/2 of free blocks are dirty.
 	 */
 	if (free_blocks < 2 * dirty_blocks)
-		writeback_inodes_sb_if_idle(sb, WB_REASON_FS_FREE_SPACE);
+		try_to_writeback_inodes_sb(sb, WB_REASON_FS_FREE_SPACE);
 
 	return 0;
 }
-- 
1.7.6.5
