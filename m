From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 5/5] e2fsck: Try to update on-disk bitmap in e2fsck_get_alloc_block() callback
Date: Sun, 29 Nov 2009 15:33:29 -0500
Message-ID: <1259526809-23697-5-git-send-email-tytso@mit.edu>
References: <1259526809-23697-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:35146 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752823AbZK2Ue2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 29 Nov 2009 15:34:28 -0500
In-Reply-To: <1259526809-23697-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The e2fsck_get_alloc_block() callback is used so that if the ext2fs
library needs to allocate blocks internally (most notably by the
extents functions), e2fsck's internal block usage map is consulted
since it is the only thing that can be trusted during a large part of
e2fsck's operation.

Change it to update the on-disk bitmap if it is loaded.  This reduces
the number of spurious differences found in pass #5.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 e2fsck/pass1.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index a241c23..0cb3fda 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -2628,6 +2628,10 @@ static errcode_t e2fsck_get_alloc_block(ext2_filsys fs, blk64_t goal,
 					  ctx->block_found_map, &new_block);
 		if (retval)
 			return retval;
+		if (fs->block_map) {
+			ext2fs_mark_block_bitmap(fs->block_map, new_block);
+			ext2fs_mark_bb_dirty(fs);
+		}
 	} else {
 		if (!fs->block_map) {
 			retval = ext2fs_read_block_bitmap(fs);
-- 
1.6.5.216.g5288a.dirty

