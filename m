From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH] ext4: correct comment references to ext4_ext_direct_IO()
Date: Fri, 14 Jul 2017 17:04:26 -0400
Message-ID: <20170714210426.GB12793@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:36582 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751029AbdGNVBI (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 14 Jul 2017 17:01:08 -0400
Received: by mail-qk0-f196.google.com with SMTP id v17so11298318qka.3
        for <linux-ext4@vger.kernel.org>; Fri, 14 Jul 2017 14:01:07 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Commit 914f82a32d0268847 "ext4: refactor direct IO code" deleted
ext4_ext_direct_IO(), but references to that function remain in
comments.  Update them to refer to ext4_direct_IO_write().

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
---
 fs/ext4/inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 3c600f0..2e6c022 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -892,7 +892,7 @@ static int ext4_dio_get_block_unwritten_async(struct inode *inode,
 /*
  * Get block function for non-AIO DIO writes when we create unwritten extent if
  * blocks are not allocated yet. The extent will be converted to written
- * after IO is complete from ext4_ext_direct_IO() function.
+ * after IO is complete by ext4_direct_IO_write().
  */
 static int ext4_dio_get_block_unwritten_sync(struct inode *inode,
 		sector_t iblock, struct buffer_head *bh_result,	int create)
@@ -907,7 +907,7 @@ static int ext4_dio_get_block_unwritten_sync(struct inode *inode,
 
 	/*
 	 * Mark inode as having pending DIO writes to unwritten extents.
-	 * ext4_ext_direct_IO() checks this flag and converts extents to
+	 * ext4_direct_IO_write() checks this flag and converts extents to
 	 * written.
 	 */
 	if (!ret && buffer_unwritten(bh_result))
-- 
2.1.4
