From: Jan Kara <jack@suse.cz>
Subject: [PATCH] ext4: Fix oops when loading block bitmap failed
Date: Thu, 23 Oct 2014 15:05:27 +0200
Message-ID: <1414069527-29803-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60181 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755495AbaJWNFa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 23 Oct 2014 09:05:30 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When we fail to load block bitmap in __ext4_new_inode() we will
dereference NULL pointer in ext4_journal_get_write_access(). So check
for error from ext4_read_block_bitmap().

Coverity-id: 989065
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/ialloc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 8012a5daf401..ac644c31ca67 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -887,6 +887,10 @@ got:
 		struct buffer_head *block_bitmap_bh;
 
 		block_bitmap_bh = ext4_read_block_bitmap(sb, group);
+		if (!block_bitmap_bh) {
+			err = -EIO;
+			goto out;
+		}
 		BUFFER_TRACE(block_bitmap_bh, "get block bitmap access");
 		err = ext4_journal_get_write_access(handle, block_bitmap_bh);
 		if (err) {
-- 
1.8.1.4

