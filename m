From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 01/28] ext4: fix async i/o writes beyond 4GB to a sparse file
Date: Tue,  2 Mar 2010 13:18:18 -0500
Message-ID: <1267553925-6308-2-git-send-email-tytso@mit.edu>
References: <1267553925-6308-1-git-send-email-tytso@mit.edu>
Cc: Eric Sandeen <sandeen@redhat.com>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:43023 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753294Ab0CBSSu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Mar 2010 13:18:50 -0500
In-Reply-To: <1267553925-6308-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Eric Sandeen <sandeen@redhat.com>

The "offset" member in ext4_io_end holds bytes, not blocks, so
ext4_lblk_t is wrong - and too small (u32).

This caused the async i/o writes to sparse files beyond 4GB to fail
when they wrapped around to 0.

Also fix up the type of arguments to ext4_convert_unwritten_extents(),
it gets ssize_t from ext4_end_aio_dio_nolock() and
ext4_ext_direct_IO().

Reported-by: Giel de Nijs <giel@vectorwise.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/ext4/ext4.h    |    6 +++---
 fs/ext4/extents.c |    2 +-
 fs/ext4/inode.c   |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 874d169..602d5ad 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -139,8 +139,8 @@ typedef struct ext4_io_end {
 	struct inode		*inode;		/* file being written to */
 	unsigned int		flag;		/* unwritten or not */
 	int			error;		/* I/O error code */
-	ext4_lblk_t		offset;		/* offset in the file */
-	size_t			size;		/* size of the extent */
+	loff_t			offset;		/* offset in the file */
+	ssize_t			size;		/* size of the extent */
 	struct work_struct	work;		/* data work queue */
 } ext4_io_end_t;
 
@@ -1744,7 +1744,7 @@ extern void ext4_ext_release(struct super_block *);
 extern long ext4_fallocate(struct inode *inode, int mode, loff_t offset,
 			  loff_t len);
 extern int ext4_convert_unwritten_extents(struct inode *inode, loff_t offset,
-			  loff_t len);
+			  ssize_t len);
 extern int ext4_get_blocks(handle_t *handle, struct inode *inode,
 			   sector_t block, unsigned int max_blocks,
 			   struct buffer_head *bh, int flags);
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 765a482..c568779 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3603,7 +3603,7 @@ retry:
  * Returns 0 on success.
  */
 int ext4_convert_unwritten_extents(struct inode *inode, loff_t offset,
-				    loff_t len)
+				    ssize_t len)
 {
 	handle_t *handle;
 	ext4_lblk_t block;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index e119524..2059c34 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3551,7 +3551,7 @@ static int ext4_end_aio_dio_nolock(ext4_io_end_t *io)
 {
 	struct inode *inode = io->inode;
 	loff_t offset = io->offset;
-	size_t size = io->size;
+	ssize_t size = io->size;
 	int ret = 0;
 
 	ext4_debug("end_aio_dio_onlock: io 0x%p from inode %lu,list->next 0x%p,"
-- 
1.6.6.1.1.g974db.dirty

