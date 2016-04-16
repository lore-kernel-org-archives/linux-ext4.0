From: Nicolai Stange <nicstange@gmail.com>
Subject: [PATCH] fs/ext4: ext4_find_extent(): remove unmeetable inconsisteny check
Date: Sat, 16 Apr 2016 10:31:37 +0200
Message-ID: <1460795497-2530-1-git-send-email-nicstange@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Nicolai Stange <nicstange@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

ext4_find_extent(), stripped down to the parts relevant to this patch,
reads as

  ppos = 0;
  i = depth;
  while (i) {
    --i;
    ++ppos;
    if (unlikely(ppos > depth)) {
      ...
      ret = -EFSCORRUPTED;
      goto err;
    }
  }

Due to the loop's bounds, the condition ppos > depth can never be met.

Remove this dead code.

Signed-off-by: Nicolai Stange <nicstange@gmail.com>
---
 Applicable to linux-next-20150415.

 fs/ext4/extents.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 95bf467..d01a405 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -907,13 +907,6 @@ ext4_find_extent(struct inode *inode, ext4_lblk_t block,
 
 		eh = ext_block_hdr(bh);
 		ppos++;
-		if (unlikely(ppos > depth)) {
-			put_bh(bh);
-			EXT4_ERROR_INODE(inode,
-					 "ppos %d > depth %d", ppos, depth);
-			ret = -EFSCORRUPTED;
-			goto err;
-		}
 		path[ppos].p_bh = bh;
 		path[ppos].p_hdr = eh;
 	}
-- 
2.8.1
