From: Shen Feng <shen@cn.fujitsu.com>
Subject: [PATCH 2/2] ext4: Make ext4_ext_find_extent fills ext_path completely
Date: Wed, 11 Jun 2008 13:55:10 +0800
Message-ID: <484F68BE.8040203@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org, Theodore Tso <tytso@MIT.EDU>,
	Mingming Cao <cmm@us.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:50312 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752070AbYFKF6e (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Jun 2008 01:58:34 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When pos=0 or depth, the fields of ext4_ext_path is not
completely filled.
This patch also removes some unnecessary code.

Signed-off-by: Shen Feng <shen@cn.fujitsu.com>
---
 fs/ext4/extents.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index d4f76d7..ff609df 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -524,6 +524,7 @@ ext4_ext_find_extent(struct inode *inode, ext4_lblk_t block,
 		alloc = 1;
 	}
 	path[0].p_hdr = eh;
+	path[0].p_bh = NULL;
 
 	i = depth;
 	/* walk through the tree */
@@ -552,12 +553,11 @@ ext4_ext_find_extent(struct inode *inode, ext4_lblk_t block,
 	}
 
 	path[ppos].p_depth = i;
-	path[ppos].p_hdr = eh;
-	path[ppos].p_ext = NULL;
 	path[ppos].p_idx = NULL;
 
 	/* find extent */
 	ext4_ext_binsearch(inode, path + ppos, block);
+	path[ppos].p_block = ext4_ext_pblock(path[ppos].p_ext);
 
 	ext4_ext_show_path(inode, path);
 
-- 
1.5.4.5

