From: Behan Webster <behanw@converseincode.com>
Subject: [PATCH V2] Remove VLAIS usage from JBD2 code
Date: Tue, 30 Oct 2012 17:50:08 -0400
Message-ID: <1351633808-8720-1-git-send-email-behanw@converseincode.com>
Cc: linux-ext4@vger.kernel.org, Mark Charlebois <charlebm@gmail.com>,
	Behan Webster <behanw@converseincode.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:58615 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934562Ab2J3Vt6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Oct 2012 17:49:58 -0400
Received: by mail-ie0-f174.google.com with SMTP id k13so1162129iea.19
        for <linux-ext4@vger.kernel.org>; Tue, 30 Oct 2012 14:49:58 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Mark Charlebois <charlebm@gmail.com>

The use of variable length arrays in structs (VLAIS) in the Linux Kernel code
precludes the use of compilers which don't implement VLAIS (for instance the
Clang compiler). Since ctx is always a 32-bit CRC, hard coding a size of 4
bytes accomplishes the same thing without the use of VLAIS. This is the same
technique already employed in fs/ext4/ext4.h

Signed-off-by: Mark Charlebois <charlebm@gmail.com>
[Used a #define to specify the fixed size of ctx]
Signed-off-by: Behan Webster <behanw@converseincode.com>
---
 include/linux/jbd2.h |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 3efc43f..93b323f 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -1303,15 +1303,21 @@ static inline int jbd_space_needed(journal_t *journal)
 
 extern int jbd_blocks_per_page(struct inode *inode);
 
+/* JBD uses a CRC32 checksum */
+#define JBD_MAX_CHECKSUM_SIZE 4
+
 static inline u32 jbd2_chksum(journal_t *journal, u32 crc,
 			      const void *address, unsigned int length)
 {
 	struct {
 		struct shash_desc shash;
-		char ctx[crypto_shash_descsize(journal->j_chksum_driver)];
+		char ctx[JBD_MAX_CHECKSUM_SIZE];
 	} desc;
 	int err;
 
+	BUG_ON(crypto_shash_descsize(journal->j_chksum_driver) >
+		JBD_MAX_CHECKSUM_SIZE);
+
 	desc.shash.tfm = journal->j_chksum_driver;
 	desc.shash.flags = 0;
 	*(u32 *)desc.ctx = crc;
-- 
1.7.9.5

