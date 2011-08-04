From: Julia Lawall <julia@diku.dk>
Subject: [PATCH 1/4] fs/ext3/balloc.c: delete useless initialization
Date: Thu,  4 Aug 2011 12:29:31 +0200
Message-ID: <1312453774-23333-2-git-send-email-julia@diku.dk>
References: <1312453774-23333-1-git-send-email-julia@diku.dk>
Cc: kernel-janitors@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mgw2.diku.dk ([130.225.96.92]:59163 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753635Ab1HDK3l (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Aug 2011 06:29:41 -0400
In-Reply-To: <1312453774-23333-1-git-send-email-julia@diku.dk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Julia Lawall <julia@diku.dk>

Delete nontrivial initialization that is immediately overwritten by the
result of an allocation function.

The semantic match that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
type T;
identifier i;
expression e;
@@

(
T i = \(0\|NULL\|ERR_PTR(...)\);
|
-T i = e;
+T i;
)
... when != i
i = \(kzalloc\|kcalloc\|kmalloc\)(...);

// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 fs/ext3/balloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/fs/ext3/balloc.c b/fs/ext3/balloc.c
--- a/fs/ext3/balloc.c
+++ b/fs/ext3/balloc.c
@@ -427,7 +427,7 @@ static inline int rsv_is_empty(struct ex
 void ext3_init_block_alloc_info(struct inode *inode)
 {
 	struct ext3_inode_info *ei = EXT3_I(inode);
-	struct ext3_block_alloc_info *block_i = ei->i_block_alloc_info;
+	struct ext3_block_alloc_info *block_i;
 	struct super_block *sb = inode->i_sb;
 
 	block_i = kmalloc(sizeof(*block_i), GFP_NOFS);

