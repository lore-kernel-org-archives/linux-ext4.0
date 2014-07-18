From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 09/24] e2fsck: clear i_block if there are too many bad block
 mappings
Date: Fri, 18 Jul 2014 15:53:21 -0700
Message-ID: <20140718225321.31374.48416.stgit@birch.djwong.org>
References: <20140718225200.31374.85411.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35554 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945991AbaGRWx1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Jul 2014 18:53:27 -0400
In-Reply-To: <20140718225200.31374.85411.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If there are too many bad block mappings in a file and the user says
to zap it, erase i_block before clearing the inode.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/pass1.c |    1 +
 1 file changed, 1 insertion(+)


diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index b696d02..18980f1 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -2329,6 +2329,7 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 	}
 
 	if (pb.clear) {
+		memset(inode->i_block, 0, sizeof(inode->i_block));
 		e2fsck_clear_inode(ctx, ino, inode, E2F_FLAG_RESTART,
 				   "check_blocks");
 		return;

