From: fanchaoting <fanchaoting@cn.fujitsu.com>
Subject: [PATCH] Ext2: do not mark_inode_dirty to avoid BUG_ON
Date: Tue, 12 Mar 2013 13:06:37 +0800
Message-ID: <513EB7DD.3020103@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: tyhicks@canonical.com, linux-ext4@vger.kernel.org,
	wangshilong1991@gmail.com
To: jack@suse.cz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:20551 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751825Ab3CLFGe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Mar 2013 01:06:34 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

commit 8e3dffc651cb668e1ff4d8b89cc1c3dde7540d3b leads into
a regression that casue BUG_ON when unlinking inode.

Reported-by: tyhicks@canonical.com
Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
---
 fs/ext2/balloc.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/ext2/balloc.c b/fs/ext2/balloc.c
index 9f9992b..06d82fc 100644
--- a/fs/ext2/balloc.c
+++ b/fs/ext2/balloc.c
@@ -562,7 +562,6 @@ error_return:
 	if (freed) {
 		percpu_counter_add(&sbi->s_freeblocks_counter, freed);
 		dquot_free_block_nodirty(inode, freed);
-		mark_inode_dirty(inode);
 	}
 }
 
-- 1.7.7.6 




