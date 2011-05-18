From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 1/4] e2fsprogs: Add memory allocation and zero-out helpers
Date: Wed, 18 May 2011 13:36:52 +0200
Message-ID: <1305718615-5991-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, sandeen@redhat.com, adilger@dilger.ca,
	Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50537 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932648Ab1ERLhQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 May 2011 07:37:16 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add functions ext2fs_get_memzero() which will malloc() the memory
using ext2fs_get_mem(), but it will zero the allocated memory afterwards
with memset().

Add function ext2fs_get_arrayzero() which will use calloc() for
allocating and zero-out the array.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 lib/ext2fs/ext2fs.h |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index d3eb31d..4aff26d 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1404,6 +1404,17 @@ _INLINE_ errcode_t ext2fs_get_memalign(unsigned long size,
 	return 0;
 }
 
+_INLINE_ errcode_t ext2fs_get_memzero(unsigned long size, void *ptr)
+{
+	errcode_t retval;
+
+	retval = ext2fs_get_mem(size, ptr);
+	if (retval)
+		return retval;
+	memset(ptr, 0, size);
+	return 0;
+}
+
 _INLINE_ errcode_t ext2fs_get_array(unsigned long count, unsigned long size, void *ptr)
 {
 	if (count && (-1UL)/count<size)
@@ -1411,6 +1422,19 @@ _INLINE_ errcode_t ext2fs_get_array(unsigned long count, unsigned long size, voi
 	return ext2fs_get_mem(count*size, ptr);
 }
 
+_INLINE_ errcode_t ext2fs_get_arrayzero(unsigned long count, unsigned long size, void *ptr)
+{
+	void *pp;
+
+	if (count && (-1UL)/count<size)
+		return EXT2_ET_NO_MEMORY; //maybe define EXT2_ET_OVERFLOW ?
+	pp = calloc(count, size);
+	if (!pp)
+		return EXT2_ET_NO_MEMORY;
+	memcpy(ptr, &pp, sizeof (pp));
+	return 0;
+}
+
 /*
  * Free memory
  */
-- 
1.7.4.4

