From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH V2] fix type of "offset" in ext4_io_end
Date: Fri, 29 Jan 2010 14:28:23 -0600
Message-ID: <4B6344E7.9050503@redhat.com>
References: <4B6327C4.4000100@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Giel de Nijs <giel@vectorwise.com>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42394 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753367Ab0A2U20 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 29 Jan 2010 15:28:26 -0500
In-Reply-To: <4B6327C4.4000100@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The "offset" member in ext4_io_end holds bytes, not
blocks, so ext4_lblk_t is wrong - and too small (u32)

This caused the testcase "Possible ext4 data corruption
with large files and async I/O" sent by Giel to fail when it
wrapped around to 0.

Also fix up the type of arguments to
ext4_convert_unwritten_extents(), it gets ssize_t from
ext4_end_aio_dio_nolock() and ext4_ext_direct_IO()

Reported-by: Giel de Nijs <giel@vectorwise.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: Post-review Josef spotted another size_t in ext4_end_aio_dio_nolock()

---diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index d0a2afb..4a825c1 100644
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
 
@@ -1740,7 +1740,7 @@ extern void ext4_ext_release(struct super_block *);
 extern long ext4_fallocate(struct inode *inode, int mode, loff_t offset,
 			  loff_t len);
 extern int ext4_convert_unwritten_extents(struct inode *inode, loff_t offset,
-			  loff_t len);
+			  ssize_t len);
 extern int ext4_get_blocks(handle_t *handle, struct inode *inode,
 			   sector_t block, unsigned int max_blocks,
 			   struct buffer_head *bh, int flags);
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 8b8bae4..9333dc9 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3547,7 +3547,7 @@ retry:
  * Returns 0 on success.
  */
 int ext4_convert_unwritten_extents(struct inode *inode, loff_t offset,
-				    loff_t len)
+				    ssize_t len)
 {
 	handle_t *handle;
 	ext4_lblk_t block;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index e233879..4f36f7d 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3540,7 +3540,7 @@ static int ext4_end_aio_dio_nolock(ext4_io_end_t *io)
 {
 	struct inode *inode = io->inode;
 	loff_t offset = io->offset;
-	size_t size = io->size;
+	ssize_t size = io->size;
 	int ret = 0;
 
 	ext4_debug("end_aio_dio_onlock: io 0x%p from inode %lu,list->next 0x%p,"

