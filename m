From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 22/24] e2fsck: check return value of
 ext2fs_extent_fix_parents()
Date: Fri, 18 Jul 2014 15:55:28 -0700
Message-ID: <20140718225528.31374.87729.stgit@birch.djwong.org>
References: <20140718225200.31374.85411.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36060 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762607AbaGRWzh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Jul 2014 18:55:37 -0400
In-Reply-To: <20140718225200.31374.85411.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When fixing parent nodes in an extent tree, check the return value for
errors and bail out if problems happen.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Fixes-Coverity-Bug: 1193379
---
 e2fsck/pass1.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)


diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 1895ee4..c52b141 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -2074,7 +2074,10 @@ fix_problem_now:
 					pctx->str = "ext2fs_extent_delete";
 					return;
 				}
-				ext2fs_extent_fix_parents(ehandle);
+				pctx->errcode = ext2fs_extent_fix_parents(ehandle);
+				if (pctx->errcode &&
+				    pctx->errcode != EXT2_ET_NO_CURRENT_NODE)
+					break;
 				pctx->errcode = ext2fs_extent_get(ehandle,
 								  EXT2_EXTENT_CURRENT,
 								  &extent);

