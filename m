From: Sami Liedes <sami.liedes@iki.fi>
Subject: [PATCH 4/8] lib/ext2fs/block.c: Fix undefined behavior in
 block_iterate_tind()
Date: Fri, 14 Dec 2012 00:04:22 +0200
Message-ID: <20121213220422.GL9713@sli.dy.fi>
References: <cover.1355435985.git.sami.liedes@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-4.hut.fi ([130.233.228.94]:52319 "EHLO smtp-4.hut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753877Ab2LMWjK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Dec 2012 17:39:10 -0500
Received: from localhost (katosiko.hut.fi [130.233.228.115])
	by smtp-4.hut.fi (8.13.6/8.12.10) with ESMTP id qBDM4dlk022307
	for <linux-ext4@vger.kernel.org>; Fri, 14 Dec 2012 00:04:39 +0200
Received: from smtp-4.hut.fi ([130.233.228.94])
 by localhost (katosiko.hut.fi [130.233.228.115]) (amavisd-new, port 10024)
 with LMTP id 03890-62 for <linux-ext4@vger.kernel.org>;
 Fri, 14 Dec 2012 00:04:39 +0200 (EET)
Received: from kosh.localdomain (kosh.hut.fi [130.233.228.12])
	by smtp-4.hut.fi (8.13.6/8.12.10) with ESMTP id qBDM4Njp022298
	for <linux-ext4@vger.kernel.org>; Fri, 14 Dec 2012 00:04:23 +0200
Content-Disposition: inline
In-Reply-To: <cover.1355435985.git.sami.liedes@iki.fi>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The intermediate result of limit*limit*limit is too big to fit in a
32-bit integer, causing undefined behavior. Fix by casting one of the
limits to the result type of e2_blkcnt_t.

Caught using clang -fsanitize=undefined.

Signed-off-by: Sami Liedes <sami.liedes@iki.fi>
---
 lib/ext2fs/block.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/ext2fs/block.c b/lib/ext2fs/block.c
index 68dcb03..dd3911d 100644
--- a/lib/ext2fs/block.c
+++ b/lib/ext2fs/block.c
@@ -251,7 +251,7 @@ static int block_iterate_tind(blk_t *tind_block, blk_t ref_block,
 	}
 	check_for_ro_violation_return(ctx, ret);
 	if (!*tind_block || (ret & BLOCK_ABORT)) {
-		ctx->bcount += limit*limit*limit;
+		ctx->bcount += ((e2_blkcnt_t)limit)*limit*limit;
 		return ret;
 	}
 	if (*tind_block >= ext2fs_blocks_count(ctx->fs->super) ||
-- 
1.7.10.4
