From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/2] libext2fs: use ~0UL instead of -1UL to avoid static checker warnings
Date: Sun, 21 Sep 2014 15:37:40 -0400
Message-ID: <1411328260-8665-2-git-send-email-tytso@mit.edu>
References: <1411328260-8665-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39834 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751463AbaIUThs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 21 Sep 2014 15:37:48 -0400
In-Reply-To: <1411328260-8665-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 lib/ext2fs/ext2fs.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index d931fff..fef6910 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1712,7 +1712,7 @@ _INLINE_ errcode_t ext2fs_get_memzero(unsigned long size, void *ptr)
 
 _INLINE_ errcode_t ext2fs_get_array(unsigned long count, unsigned long size, void *ptr)
 {
-	if (count && (-1UL)/count<size)
+	if (count && (~0UL)/count < size)
 		return EXT2_ET_NO_MEMORY;
 	return ext2fs_get_mem(count*size, ptr);
 }
@@ -1722,7 +1722,7 @@ _INLINE_ errcode_t ext2fs_get_arrayzero(unsigned long count,
 {
 	void *pp;
 
-	if (count && (-1UL)/count<size)
+	if (count && (~0UL)/count < size)
 		return EXT2_ET_NO_MEMORY;
 	pp = calloc(count, size);
 	if (!pp)
-- 
2.1.0

