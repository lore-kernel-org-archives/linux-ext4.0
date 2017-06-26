From: Tahsin Erdogan <tahsin@google.com>
Subject: [PATCH 04/12] e2fsck: do not early terminate extra space check
Date: Mon, 26 Jun 2017 06:43:40 -0700
Message-ID: <20170626134348.1240-4-tahsin@google.com>
References: <20170626134348.1240-1-tahsin@google.com>
Cc: Tahsin Erdogan <tahsin@google.com>
To: Andreas Dilger <adilger@dilger.ca>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f179.google.com ([209.85.192.179]:33170 "EHLO
        mail-pf0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752343AbdFZNoP (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Jun 2017 09:44:15 -0400
Received: by mail-pf0-f179.google.com with SMTP id e7so777387pfk.0
        for <linux-ext4@vger.kernel.org>; Mon, 26 Jun 2017 06:44:10 -0700 (PDT)
In-Reply-To: <20170626134348.1240-1-tahsin@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When check_inode_extra_space() detects a problem with the value of
i_extra_isize, it adjusts it and then returns without further validation
of contents in the inode body. Change this so that it will proceed to
check inline extended attributes.

Signed-off-by: Tahsin Erdogan <tahsin@google.com>
---
 e2fsck/pass1.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 32152f3ec926..1532fd2067f2 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -582,7 +582,6 @@ static void check_inode_extra_space(e2fsck_t ctx, struct problem_context *pctx)
 			inode->i_extra_isize = (inode->i_extra_isize + 3) & ~3;
 		e2fsck_write_inode_full(ctx, pctx->ino, pctx->inode,
 					EXT2_INODE_SIZE(sb), "pass1");
-		return;
 	}
 
 	/* check if there is no place for an EA header */
-- 
2.13.1.611.g7e3b11ae1-goog
