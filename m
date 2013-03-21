From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] ext4: Do not normalize request from fallocate
Date: Thu, 21 Mar 2013 16:50:45 +0100
Message-ID: <1363881045-21673-1-git-send-email-lczerner@redhat.com>
Cc: gharm@google.com, Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48407 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755886Ab3CUPu7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Mar 2013 11:50:59 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Block requests from fallocate has been normalized originally. Then it was
changed by 556b27abf73833923d5cd4be80006292e1b31662 not to normalize it.
And then it was changed by 3c6fe77017bc6ce489f231c35fed3220b6691836
again to normalize the request.

The fact is that we _never_ want to normalize the request from
fallocate. We know exactly how much space we're going to use and we do
not want anyone to mess with the request and there is no point in doing
so.

Commit 3c6fe77017bc6ce489f231c35fed3220b6691836 mentioned that
large fallocate requests were not physically contiguous. However it is
important to see why that is the case. Because the request is so big the
allocator will try to find free group to allocate from skipping block
groups which are used, which is fine. However it will only allocate
extents of 2^15-1 block (limitation of uninitialized extent size)
which will leave one block in each block group free which will make the
extent tree physically non-contiguous, however _only_ by one block which
is perfectly fine.

This will never happen when we normalize the request because for some
reason (maybe bug) it will be normalized to much smaller request (2048
blocks) and those extents will then be merged together not leaving any
free block in between - hence physically contiguous. However the fact
that we're splitting huge requests into ton of smaller ones and then
merging extents together is very _very_ bad for fallocate performance.

The situation is even worst since with commit
ec22ba8edb507395c95fbc617eea26a6b2d98797 we no longer merge
uninitialized extents so we end up with absolutely _huge_ extent tree
for bigger fallocate requests which is also bad for performance but not
only when fallocate itself, but even when working with the file
later on.

Fix this by disabling normalization for fallocate. From my simple testing
with this commit fallocate is much faster on non fragmented file
system. On my system fallocate 15T is almost 3x faster with this patch
and removing this file is almost 2x faster - tested on real hardware.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/extents.c |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index e2bb929..a40a602 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4422,16 +4422,18 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 		trace_ext4_fallocate_exit(inode, offset, max_blocks, ret);
 		return ret;
 	}
-	flags = EXT4_GET_BLOCKS_CREATE_UNINIT_EXT;
-	if (mode & FALLOC_FL_KEEP_SIZE)
-		flags |= EXT4_GET_BLOCKS_KEEP_SIZE;
+
 	/*
-	 * Don't normalize the request if it can fit in one extent so
-	 * that it doesn't get unnecessarily split into multiple
-	 * extents.
+	 * We do NOT want the requests from fallocate to be normalized
+	 * ever!. We know exactly how much we want to allocate and
+	 * we do not need to do any mumbo-jumbo with it. Requests bigger
+	 * than uninit extent size, will be divided automatically into
+	 * biggest possible extents.
 	 */
-	if (len <= EXT_UNINIT_MAX_LEN << blkbits)
-		flags |= EXT4_GET_BLOCKS_NO_NORMALIZE;
+	flags = EXT4_GET_BLOCKS_CREATE_UNINIT_EXT |
+		EXT4_GET_BLOCKS_NO_NORMALIZE;
+	if (mode & FALLOC_FL_KEEP_SIZE)
+		flags |= EXT4_GET_BLOCKS_KEEP_SIZE;
 
 retry:
 	while (ret >= 0 && ret < max_blocks) {
-- 
1.7.7.6

