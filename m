From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/2] ext4: Fix hueristic which avoids group preallocation for closed files
Date: Mon, 28 Sep 2009 00:13:17 -0400
Message-ID: <1254111198-8552-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:55574 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910AbZI1ENS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Sep 2009 00:13:18 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The hueristic was designed to avoid using locality group preallocation
when writing the last segment of a closed file.  Fix it by move
setting size to the maximum of size and isize until after we check
whether size == isize.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/mballoc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index e9c6189..c73d439 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4189,7 +4189,6 @@ static void ext4_mb_group_or_file(struct ext4_allocation_context *ac)
 	size = ac->ac_o_ex.fe_logical + ac->ac_o_ex.fe_len;
 	isize = (i_size_read(ac->ac_inode) + ac->ac_sb->s_blocksize - 1)
 		>> bsbits;
-	size = max(size, isize);
 
 	if ((size == isize) &&
 	    !ext4_fs_is_busy(sbi) &&
@@ -4199,6 +4198,7 @@ static void ext4_mb_group_or_file(struct ext4_allocation_context *ac)
 	}
 
 	/* don't use group allocation for large files */
+	size = max(size, isize);
 	if (size >= sbi->s_mb_stream_request) {
 		ac->ac_flags |= EXT4_MB_STREAM_ALLOC;
 		return;
-- 
1.6.4.4.2.g31f8e.dirty

