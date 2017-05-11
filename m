From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH V2] e2fsck: fix multiply-claimed block quota accounting when
 deleting files
Date: Thu, 11 May 2017 11:46:32 -0400
Message-ID: <20170511154632.GB11505@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:35972 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757186AbdEKPoi (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 11 May 2017 11:44:38 -0400
Received: by mail-qk0-f194.google.com with SMTP id y128so4181683qka.3
        for <linux-ext4@vger.kernel.org>; Thu, 11 May 2017 08:44:38 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

As e2fsck processes each file in pass1, the actual file system quota is
increased by the number of blocks discovered in the file.  This can
include both non-multiply-claimed and multiply-claimed blocks, if the
latter exist.  However, if a file containing multiply-claimed blocks
is then deleted in pass1b, those blocks are not taken into account when
decreasing the actual quota.  In this case, the new quota values written
to the file system by e2fsck overstate the space actually consumed.
And, e2fsck must be run twice on the file system to fully correct
quota.

Fix this by counting multiply-claimed blocks as a debit to quota when
deleting files in pass1b.

[V2] Correct a dangling else bug in the original patch.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
---
 e2fsck/pass1b.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/e2fsck/pass1b.c b/e2fsck/pass1b.c
index b40f026..d22cffd 100644
--- a/e2fsck/pass1b.c
+++ b/e2fsck/pass1b.c
@@ -637,9 +637,11 @@ static int delete_file_block(ext2_filsys fs,
 	if (ext2fs_test_block_bitmap2(ctx->block_dup_map, *block_nr)) {
 		n = dict_lookup(&clstr_dict, INT_TO_VOIDPTR(c));
 		if (n) {
-			p = (struct dup_cluster *) dnode_get(n);
-			if (lc != pb->cur_cluster)
+			if (lc != pb->cur_cluster) {
+				p = (struct dup_cluster *) dnode_get(n);
 				decrement_badcount(ctx, *block_nr, p);
+				pb->dup_blocks++;
+			}
 		} else
 			com_err("delete_file_block", 0,
 			    _("internal error: can't find dup_blk for %llu\n"),
-- 
2.1.4
