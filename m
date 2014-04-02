From: Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH] ext4: Note the error in ext4_end_bio()
Date: Wed, 2 Apr 2014 10:35:07 -0400
Message-ID: <20140402143507.GA27299@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:4958 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758641AbaDBOfe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 2 Apr 2014 10:35:34 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


ext4_end_bio() currently throws away the error that it receives.  Chances
are this is part of a spate of errors, one of which will end up getting
the error returned to userspace somehow, but we shouldn't take that risk.
Also print out the errno to aid in debug.

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
---
 fs/ext4/page-io.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index ab95508..c18d95b 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -308,13 +308,14 @@ static void ext4_end_bio(struct bio *bio, int error)
 	if (error) {
 		struct inode *inode = io_end->inode;
 
-		ext4_warning(inode->i_sb, "I/O error writing to inode %lu "
+		ext4_warning(inode->i_sb, "I/O error %d writing to inode %lu "
 			     "(offset %llu size %ld starting block %llu)",
-			     inode->i_ino,
+			     error, inode->i_ino,
 			     (unsigned long long) io_end->offset,
 			     (long) io_end->size,
 			     (unsigned long long)
 			     bi_sector >> (inode->i_blkbits - 9));
+		mapping_set_error(inode->i_mapping, error);
 	}
 
 	if (io_end->flag & EXT4_IO_END_UNWRITTEN) {
-- 
1.9.0

