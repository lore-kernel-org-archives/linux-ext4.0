From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH, resend] ext4: remove timebomb in ext4_decode_extra_time()
Date: Mon, 21 Aug 2017 10:11:15 +0200
Message-ID: <20170821081115.2722-1-hch@lst.de>
To: tytso@mit.edu, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:51762 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751718AbdHUILU (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Aug 2017 04:11:20 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Changing behavior based on the version code is a timebomb waiting to
happen, and not easily bisectable.  Drop it and leave any removal
to explicit developer action. (And I don't think file system
should _ever_ remove backwards compatibility that has no explicit
flag, but I'll leave that to the ext4 folks).

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Eric Biggers <ebiggers@google.com>
---

This was first sent on June 14, but kept getting ignored..

 fs/ext4/ext4.h | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 32191548abed..d35749e7cf9f 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -838,21 +838,15 @@ static inline void ext4_decode_extra_time(struct timespec *time, __le32 extra)
 {
 	if (unlikely(sizeof(time->tv_sec) > 4 &&
 			(extra & cpu_to_le32(EXT4_EPOCH_MASK)))) {
-#if LINUX_VERSION_CODE < KERNEL_VERSION(4,20,0)
+
 		/* Handle legacy encoding of pre-1970 dates with epoch
-		 * bits 1,1.  We assume that by kernel version 4.20,
-		 * everyone will have run fsck over the affected
-		 * filesystems to correct the problem.  (This
-		 * backwards compatibility may be removed before this
-		 * time, at the discretion of the ext4 developers.)
+		 * bits 1,1. (This backwards compatibility may be removed
+		 * at the discretion of the ext4 developers.)
 		 */
 		u64 extra_bits = le32_to_cpu(extra) & EXT4_EPOCH_MASK;
 		if (extra_bits == 3 && ((time->tv_sec) & 0x80000000) != 0)
 			extra_bits = 0;
 		time->tv_sec += extra_bits << 32;
-#else
-		time->tv_sec += (u64)(le32_to_cpu(extra) & EXT4_EPOCH_MASK) << 32;
-#endif
 	}
 	time->tv_nsec = (le32_to_cpu(extra) & EXT4_NSEC_MASK) >> EXT4_EPOCH_BITS;
 }
-- 
2.11.0
