From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext2fs_zero_blocks: Avoid clearing more blocks than requested
Date: Tue, 17 Jun 2008 02:06:31 -0400
Message-ID: <1213682792-4878-3-git-send-email-tytso@mit.edu>
References: <1213682792-4878-1-git-send-email-tytso@mit.edu>
 <1213682792-4878-2-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:33400 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751828AbYFQGGe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 17 Jun 2008 02:06:34 -0400
In-Reply-To: <1213682792-4878-2-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This could cause certain mke2fs feature combinations to result in the
initial blocks of the inode table getting wiped out when the journal
is created.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/mkjournal.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/lib/ext2fs/mkjournal.c b/lib/ext2fs/mkjournal.c
index ca8e733..e55dcbd 100644
--- a/lib/ext2fs/mkjournal.c
+++ b/lib/ext2fs/mkjournal.c
@@ -170,9 +170,11 @@ errcode_t ext2fs_zero_blocks(ext2_filsys fs, blk_t blk, int num,
 	/* OK, do the write loop */
 	j=0;
 	while (j < num) {
-		if (blk % STRIDE_LENGTH)
+		if (blk % STRIDE_LENGTH) {
 			count = STRIDE_LENGTH - (blk % STRIDE_LENGTH);
-		else {
+			if (count > (num - j))
+				count = num - j;
+		} else {
 			count = num - j;
 			if (count > STRIDE_LENGTH)
 				count = STRIDE_LENGTH;
-- 
1.5.6.rc3.1.g36b7.dirty

