From: Jan Kara <jack@suse.cz>
Subject: [PATCH 1/2] ext4: Fix block zeroing when punching holes in indirect block files
Date: Wed, 18 Jun 2014 21:33:03 +0200
Message-ID: <1403119984-3635-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50618 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753605AbaFRTdN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Jun 2014 15:33:13 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

free_holes_block() passed local variable as a block pointer
to ext4_clear_blocks(). Thus ext4_clear_blocks() zeroed out this local
variable instead of proper place in inode / indirect block. We later
zero out proper place in inode / indirect block but don't dirty the
inode / buffer again which can lead to subtle issues (some changes e.g.
to inode can be lost).

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/indirect.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index 8a57e9fcd1b9..9d381707a6fc 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -1329,8 +1329,8 @@ static int free_hole_blocks(handle_t *handle, struct inode *inode,
 		if (level == 0 ||
 		    (bh && all_zeroes((__le32 *)bh->b_data,
 				      (__le32 *)bh->b_data + addr_per_block))) {
-			ext4_free_data(handle, inode, parent_bh, &blk, &blk+1);
-			*i_data = 0;
+			ext4_free_data(handle, inode, parent_bh,
+				       i_data, i_data + 1);
 		}
 		brelse(bh);
 		bh = NULL;
-- 
1.8.1.4

