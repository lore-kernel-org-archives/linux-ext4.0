From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: don't pass freed handle to ext4_walk_page_buffers
Date: Tue,  7 Jan 2014 13:08:59 -0500
Message-ID: <1389118139-19784-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46665 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753215AbaAGSJG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 7 Jan 2014 13:09:06 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is harmless, since ext4_walk_page_buffers only passes the handle
onto the callback function, and in this call site the function in
question, bput_one(), doesn't actually use the handle.  But there's no
point passing in an invalid handle, and it creates a Coverity warning,
so let's just clean it up.

Addresses-Coverity-Id: #1091168

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 8454ebe..f33b4eb 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1772,7 +1772,7 @@ static int __ext4_journalled_writepage(struct page *page,
 		ret = err;
 
 	if (!ext4_has_inline_data(inode))
-		ext4_walk_page_buffers(handle, page_bufs, 0, len,
+		ext4_walk_page_buffers(NULL, page_bufs, 0, len,
 				       NULL, bput_one);
 	ext4_set_inode_state(inode, EXT4_STATE_JDATA);
 out:
-- 
1.8.5.rc3.362.gdf10213

