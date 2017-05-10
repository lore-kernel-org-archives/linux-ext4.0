From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH] e2fsck: fix multiply-claimed block quota accounting when
 deleting files
Date: Wed, 10 May 2017 18:04:40 -0400
Message-ID: <20170510220440.GA26875@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:33116 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751039AbdEJWCi (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 10 May 2017 18:02:38 -0400
Received: by mail-qt0-f196.google.com with SMTP id a46so650428qte.0
        for <linux-ext4@vger.kernel.org>; Wed, 10 May 2017 15:02:38 -0700 (PDT)
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

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
---
 e2fsck/pass1b.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/e2fsck/pass1b.c b/e2fsck/pass1b.c
index b40f026..8744fad 100644
--- a/e2fsck/pass1b.c
+++ b/e2fsck/pass1b.c
@@ -636,11 +636,13 @@ static int delete_file_block(ext2_filsys fs,
 	lc = EXT2FS_B2C(fs, blockcnt);
 	if (ext2fs_test_block_bitmap2(ctx->block_dup_map, *block_nr)) {
 		n = dict_lookup(&clstr_dict, INT_TO_VOIDPTR(c));
-		if (n) {
-			p = (struct dup_cluster *) dnode_get(n);
-			if (lc != pb->cur_cluster)
+		if (n)
+			if (lc != pb->cur_cluster) {
+				p = (struct dup_cluster *) dnode_get(n);
 				decrement_badcount(ctx, *block_nr, p);
-		} else
+				pb->dup_blocks++;
+			}
+		else
 			com_err("delete_file_block", 0,
 			    _("internal error: can't find dup_blk for %llu\n"),
 				*block_nr);
-- 
2.1.4
