From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 40/39] e2fsck: fix reporting of unknown htree block inode
 number
Date: Mon, 27 Oct 2014 16:31:09 -0700
Message-ID: <20141027233109.GE10057@birch.djwong.org>
References: <20141025205623.532.12119.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Sami Liedes <sami.liedes@iki.fi>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46195 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230AbaJ0Xb2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Oct 2014 19:31:28 -0400
Content-Disposition: inline
In-Reply-To: <20141025205623.532.12119.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Sami Liedes reports that e2fsck fails to report the correct directory
inode number during a pass2 check for unexpected HTREE blocks.
Provide the inode number in the problem report.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reported-by: Sami Liedes <sami.liedes@iki.fi>
---
 e2fsck/pass2.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index fa17f20..f645229 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -1006,6 +1006,7 @@ inline_read_fail:
 	dx_dir = e2fsck_get_dx_dir_info(ctx, ino);
 	if (dx_dir && dx_dir->numblocks) {
 		if (db->blockcnt >= dx_dir->numblocks) {
+			pctx.dir = ino;
 			if (fix_problem(ctx, PR_2_UNEXPECTED_HTREE_BLOCK,
 					&pctx)) {
 				clear_htree(ctx, ino);
