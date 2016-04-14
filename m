From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: allow readdir()'s of large empty directories to be interrupted
Date: Thu, 14 Apr 2016 16:37:45 -0400
Message-ID: <1460666265-22596-1-git-send-email-tytso@mit.edu>
Cc: torvalds@linux-foundation.org, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:56160 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751694AbcDNUhw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 Apr 2016 16:37:52 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If a directory has a large number of empty blocks, iterating over all
of them can take a long time, leading to scheduler warnings and users
getting irritated when they can't kill a process in the middle of one
of these long-running readdir operations.  Fix this by adding checks to
ext4_readdir() and ext4_htree_fill_tree().

This was reverted earlier due to a typo in the original commit where I
experimented with using signal_pending() instead of
fatal_signal_pending().  The test was in the wrong place if we were
going to return signal_pending() since we would end up returning
duplicant entries.  See 9f2394c9be47 for a more detailed explanation.

As it turns out, we can't use signal_pending() anyway because there
are callers of readdir() that would be very cranky if we were to ever
return EINTR.  As a result, we can only allow ourselves to get
interrupted by a signal if it is a fatal one.  So Linus's proposal to
add "if (signal_pending(current)) return -EINTR;" to filldir64() would
probably cause more than a few userspace regressions.

Reported-by: Benjamin LaHaise <bcrl@kvack.org>
Google-Bug-Id: 27880676
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/dir.c   | 5 +++++
 fs/ext4/namei.c | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index 561d730..4173bfe 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -150,6 +150,11 @@ static int ext4_readdir(struct file *file, struct dir_context *ctx)
 	while (ctx->pos < inode->i_size) {
 		struct ext4_map_blocks map;
 
+		if (fatal_signal_pending(current)) {
+			err = -ERESTARTSYS;
+			goto errout;
+		}
+		cond_resched();
 		map.m_lblk = ctx->pos >> EXT4_BLOCK_SIZE_BITS(sb);
 		map.m_len = 1;
 		err = ext4_map_blocks(NULL, inode, &map, 0);
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 48e4b89..c07422d 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1107,6 +1107,11 @@ int ext4_htree_fill_tree(struct file *dir_file, __u32 start_hash,
 	}
 
 	while (1) {
+		if (fatal_signal_pending(current)) {
+			err = -ERESTARTSYS;
+			goto errout;
+		}
+		cond_resched();
 		block = dx_get_block(frame->at);
 		ret = htree_dirblock_to_tree(dir_file, dir, block, &hinfo,
 					     start_hash, start_minor_hash);
-- 
2.5.0

