From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 18/47] e2fsck: only complain about no-checksum directory
 blocks once
Date: Fri, 07 Nov 2014 13:52:45 -0800
Message-ID: <20141107215245.883.75701.stgit@birch.djwong.org>
References: <20141107215042.883.49888.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45613 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848AbaKGVwt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Nov 2014 16:52:49 -0500
In-Reply-To: <20141107215042.883.49888.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If a directory block lacks space for a checksum and the user directs
e2fsck to fix the directory block (by rehashing it), don't complain a
second time about the checksum verification failure when we get to the
end of the directory block.

Also, don't complain about broken HTREE directories if we're already
planning to rebuild the HTREE directory.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/pass2.c                |   11 ++++++++---
 tests/f_dir_bad_csum/expect.1 |    6 ------
 2 files changed, 8 insertions(+), 9 deletions(-)


diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index cd0762a..7aaebce 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -166,7 +166,8 @@ void e2fsck_pass2(e2fsck_t ctx)
 	for (i=0; (dx_dir = e2fsck_dx_dir_info_iter(ctx, &i)) != 0;) {
 		if (ctx->flags & E2F_FLAG_SIGNAL_MASK)
 			return;
-		if (dx_dir->numblocks == 0)
+		if (e2fsck_dir_will_be_rehashed(ctx, dx_dir->ino) ||
+		    dx_dir->numblocks == 0)
 			continue;
 		clear_problem_context(&pctx);
 		bad_dir = 0;
@@ -1022,11 +1023,15 @@ out_htree:
 	if (is_leaf && !inline_data_size && failed_csum &&
 	    !ext2fs_dirent_has_tail(fs, (struct ext2_dir_entry *)buf)) {
 		de_csum_size = 0;
-		if (e2fsck_dir_will_be_rehashed(ctx, ino) ||
-		    !fix_problem(cd->ctx, PR_2_LEAF_NODE_MISSING_CSUM,
+		if (e2fsck_dir_will_be_rehashed(ctx, ino)) {
+			failed_csum = 0;
+			goto skip_checksum;
+		}
+		if (!fix_problem(cd->ctx, PR_2_LEAF_NODE_MISSING_CSUM,
 				 &cd->pctx))
 			goto skip_checksum;
 		e2fsck_rehash_dir_later(ctx, ino);
+		failed_csum = 0;
 		goto skip_checksum;
 	}
 	/* htree nodes don't use fake dirents to store checksums */
diff --git a/tests/f_dir_bad_csum/expect.1 b/tests/f_dir_bad_csum/expect.1
index bbcbfcb..b2b2fae 100644
--- a/tests/f_dir_bad_csum/expect.1
+++ b/tests/f_dir_bad_csum/expect.1
@@ -6,15 +6,9 @@ Fix? yes
 Directory inode 13, block #0, offset 0: directory has no checksum.
 Fix? yes
 
-Directory inode 13, block #0, offset 1012: directory passes checks but fails checksum.
-Fix? yes
-
 Directory inode 14, block #0, offset 0: directory has no checksum.
 Fix? yes
 
-Directory inode 14, block #0, offset 12: directory passes checks but fails checksum.
-Fix? yes
