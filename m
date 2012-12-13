From: Sami Liedes <sami.liedes@iki.fi>
Subject: [PATCH 3/8] e2fsck/pass1.c: Fix undefined behavior in check_blocks()
Date: Fri, 14 Dec 2012 00:04:15 +0200
Message-ID: <20121213220415.GK9713@sli.dy.fi>
References: <cover.1355435985.git.sami.liedes@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-2.hut.fi ([130.233.228.92]:33955 "EHLO smtp-2.hut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754985Ab2LMWiy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Dec 2012 17:38:54 -0500
Received: from localhost (katosiko.hut.fi [130.233.228.115])
	by smtp-2.hut.fi (8.13.6/8.12.10) with ESMTP id qBDM4OGS004484
	for <linux-ext4@vger.kernel.org>; Fri, 14 Dec 2012 00:04:24 +0200
Received: from smtp-2.hut.fi ([130.233.228.92])
 by localhost (katosiko.hut.fi [130.233.228.115]) (amavisd-new, port 10024)
 with LMTP id 09545-141 for <linux-ext4@vger.kernel.org>;
 Fri, 14 Dec 2012 00:04:24 +0200 (EET)
Received: from kosh.localdomain (kosh.hut.fi [130.233.228.12])
	by smtp-2.hut.fi (8.13.6/8.12.10) with ESMTP id qBDM4Frh004477
	for <linux-ext4@vger.kernel.org>; Fri, 14 Dec 2012 00:04:15 +0200
Content-Disposition: inline
In-Reply-To: <cover.1355435985.git.sami.liedes@iki.fi>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The offending code is this:

   pb.max_blocks = 1 << (31 - fs->super->s_log_block_size);

While pb.max_blocks is of type blk64_t, the intermediate result of the
expression '1 << 31' is int. However 1 << 31 does not fit in a 32-bit
signed int, causing undefined behavior.

Caught using clang -fsanitize=undefined.

Signed-off-by: Sami Liedes <sami.liedes@iki.fi>
---
 e2fsck/pass1.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index a4bd956..9cd8832 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -2095,7 +2095,7 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 	pb.previous_block = 0;
 	pb.is_dir = LINUX_S_ISDIR(inode->i_mode);
 	pb.is_reg = LINUX_S_ISREG(inode->i_mode);
-	pb.max_blocks = 1 << (31 - fs->super->s_log_block_size);
+	pb.max_blocks = ((blk64_t)1) << (31 - fs->super->s_log_block_size);
 	pb.inode = inode;
 	pb.pctx = pctx;
 	pb.ctx = ctx;
-- 
1.7.10.4
