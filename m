From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] ext4: use directio end_io error status to finish unwritten
 aio dio correctly
Date: Wed, 17 Feb 2016 21:45:57 -0800
Message-ID: <20160218054557.GH6338@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28325 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1425151AbcBRFqD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Feb 2016 00:46:03 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Use the new error code passed to the directio end_io function to
decide if we're going to remap the blocks.  If an IO error happened
during an AIO DIO, we must skip the unwritten extent conversion to
avoid exposing stale blocks.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/ext4/ext4.h    |    2 ++
 fs/ext4/inode.c   |   23 +++++++++++++++--------
 fs/ext4/page-io.c |    2 +-
 3 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 0662b28..363c701 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1523,6 +1523,8 @@ static inline void ext4_inode_aio_set(struct inode *inode, ext4_io_end_t *io)
 	inode->i_private = io;
 }
 
+extern void ext4_clear_io_unwritten_flag(ext4_io_end_t *io_end);
+
 /*
  * Inode dynamic state flags
  */
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 9db04dd..a302094 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3166,9 +3166,6 @@ static int ext4_end_io_dio(struct kiocb *iocb, loff_t offset,
 {
         ext4_io_end_t *io_end = iocb->private;
 
-	if (size <= 0)
-		return 0;
-
 	/* if not async direct IO just return */
 	if (!io_end)
 		return 0;
@@ -3179,11 +3176,21 @@ static int ext4_end_io_dio(struct kiocb *iocb, loff_t offset,
 		  size);
 
 	iocb->private = NULL;
-	io_end->offset = offset;
-	io_end->size = size;
-	ext4_put_io_end(io_end);
-
-	return 0;
+	/*
+	 * If an IO error happened, skip the unwritten extent conversion
+	 * to avoid disclosing old disk contents.
+	 */
+	if (size <= 0) {
+		if (io_end->flag & EXT4_IO_END_UNWRITTEN) {
+			ext4_clear_io_unwritten_flag(io_end);
+			if (ext4_handle_valid(io_end->handle))
+				ext4_journal_stop(io_end->handle);
+		}
+	} else {
+		io_end->offset = offset;
+		io_end->size = size;
+	}
+	return ext4_put_io_end(io_end);
 }
 
 /*
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 090b349..a0bc182b 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -139,7 +139,7 @@ static void ext4_release_io_end(ext4_io_end_t *io_end)
 	kmem_cache_free(io_end_cachep, io_end);
 }
 
-static void ext4_clear_io_unwritten_flag(ext4_io_end_t *io_end)
+void ext4_clear_io_unwritten_flag(ext4_io_end_t *io_end)
 {
 	struct inode *inode = io_end->inode;
 
