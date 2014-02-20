From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: avoid possible overflow in ext4_map_blocks()
Date: Thu, 20 Feb 2014 00:50:54 -0500
Message-ID: <1392875454-4281-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:60277 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750705AbaBTFvB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Feb 2014 00:51:01 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The ext4_map_blocks() function returns the number of blocks which
satisfying the caller's request.  This number of blocks requested by
the caller is specified by an unsigned integer, but the return value
of ext4_map_blocks() is a signed integer (to accomodate error codes
per the kernel's standard error signalling convention).

Historically, overflows could never happen since mballoc() will refuse
to allocate more than 2048 blocks at a time (which is something we
should fix), and if the blocks were already allocated, the fact that
there would be some number of intervening metadata blocks pretty much
guaranteed that there could never be a contiguous region of data
blocks that was greater than 2**31 blocks.

However, this is now possible if there is a file system which is a bit
bigger than 8TB, and is created using the new mke2fs hugeblock
feature, which can create a perfectly contiguous file.  In that case,
if a userspace program attempted to call fallocate() on this already
fully allocated file, it's possible that ext4_map_blocks() could
return a number large enough that it would overflow a signed integer,
resultimg in a ext4 thinking that the ext4_map_blocks() call had
failed with some strange error code.

Since ext4_map_blocks() is always free to return a smaller number of
blocks than what was requested by the caller, fix this by capping the
number of blocks that ext4_map_blocks() will ever try to map to 2**31
- 1.  In practice this should never get hit, except by someone
deliberately trying to provke the above-described bug.

Thanks to the PaX team for asking whethre this could possibly happen
in some off-line discussions about using some static code checking
technology they are developing to find bugs in kernel code.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/inode.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 6e39895..e81244d 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -514,6 +514,9 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 		  "logical block %lu\n", inode->i_ino, flags, map->m_len,
 		  (unsigned long) map->m_lblk);
 
+	if (map->m_len >= (1UL << 31))
+		map->m_len = (1UL << 31) - 1;
+
 	/* Lookup extent status tree firstly */
 	if (ext4_es_lookup_extent(inode, map->m_lblk, &es)) {
 		ext4_es_lru_add(inode);
-- 
1.9.0

