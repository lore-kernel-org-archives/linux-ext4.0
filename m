From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 03/10] e2fsck: use blk_t instead of blk64_t in check_resize_inode()
Date: Tue,  3 Dec 2013 00:10:11 -0500
Message-ID: <1386047418-32431-4-git-send-email-tytso@mit.edu>
References: <20131203002503.GA18601@thunk.org>
 <1386047418-32431-1-git-send-email-tytso@mit.edu>
Cc: Kit Westneat <kwestneat@ddn.com>, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35858 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018Ab3LCFK1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Dec 2013 00:10:27 -0500
In-Reply-To: <1386047418-32431-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The resize inode only works on 32-bit block numbers, so use blk_t
instead of blk64_t.  This avoids some -Wconversion noise, and slims
the compiled code slightly, especially on 32-bit platforms.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 e2fsck/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/e2fsck/super.c b/e2fsck/super.c
index 352f16d..ce824f4 100644
--- a/e2fsck/super.c
+++ b/e2fsck/super.c
@@ -317,7 +317,7 @@ void check_resize_inode(e2fsck_t ctx)
 	struct problem_context	pctx;
 	int		i, gdt_off, ind_off;
 	dgrp_t		j;
-	blk64_t		blk, pblk;
+	blk_t		blk, pblk;
 	blk_t		expect;	/* for resize inode, which is 32-bit only */
 	__u32 		*dind_buf = 0, *ind_buf;
 	errcode_t	retval;
-- 
1.8.5.rc3.362.gdf10213

