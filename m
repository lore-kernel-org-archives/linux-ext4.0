From: Jan Kara <jack@suse.cz>
Subject: writev corruption and 64-bit quota patches for 2.6.33-rc1?
Date: Tue, 8 Dec 2009 12:00:43 +0100
Message-ID: <20091208110043.GC4095@quack.suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="xHFwDpU9dbj6ez1V"
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:54568 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753632AbZLHLAn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Dec 2009 06:00:43 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

  Hi Ted,

  do you plan on merging my fixes for writev filesystem corruption and
64-bit quota patches? The writev patch is independent of any other patch
and should go in ASAP, 64-bit quota patch depends on generic quota code
change so either I can merge it or you can merge a bit later (it's a small
change for ext4).
  The patches were sent as:
http://marc.info/?l=linux-ext4&m=125978147226649&w=3
(writev corruption fix - it has a minor whitespace bug so I'm attaching a
version with that bug fixed)
http://marc.info/?l=linux-ext4&m=125978717902673&w=3
(64-bit quota support)


								Honza

--xHFwDpU9dbj6ez1V
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0002-ext4-Fix-data-filesystem-corruption-when-write-fails.patch"

>From 8bd74d5ced949f276e51d770092bff576d42fa79 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Wed, 2 Dec 2009 20:05:23 +0100
Subject: [PATCH 2/3] ext4: Fix data / filesystem corruption when write fails to copy data

When ext4_write_begin fails after allocating some blocks or
generic_perform_write fails to copy data to write, we truncate blocks already
instantiated beyond i_size. Although these blocks were never inside i_size, we
have to truncate pagecache of these blocks so that corresponding buffers get
unmapped. Otherwise subsequent __block_prepare_write (called because we are
retrying the write) will find the buffers mapped, not call ->get_block, and
thus the page will be backed by already freed blocks leading to filesystem and
data corruption.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c |   20 +++++++++++++++-----
 1 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 2c8caa5..e802988 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1534,6 +1534,16 @@ static int do_journal_get_write_access(handle_t *handle,
 	return ext4_journal_get_write_access(handle, bh);
 }
 
+/*
+ * Truncate blocks that were not used by write. We have to truncate the
+ * pagecache as well so that corresponding buffers get properly unmapped.
+ */
+static void ext4_truncate_failed_write(struct inode *inode)
+{
+	truncate_inode_pages(inode->i_mapping, inode->i_size);
+	ext4_truncate(inode);
+}
+
 static int ext4_write_begin(struct file *file, struct address_space *mapping,
 			    loff_t pos, unsigned len, unsigned flags,
 			    struct page **pagep, void **fsdata)
@@ -1599,7 +1609,7 @@ retry:
 
 		ext4_journal_stop(handle);
 		if (pos + len > inode->i_size) {
-			ext4_truncate(inode);
+			ext4_truncate_failed_write(inode);
 			/*
 			 * If truncate failed early the inode might
 			 * still be on the orphan list; we need to
@@ -1709,7 +1719,7 @@ static int ext4_ordered_write_end(struct file *file,
 		ret = ret2;
 
 	if (pos + len > inode->i_size) {
-		ext4_truncate(inode);
+		ext4_truncate_failed_write(inode);
 		/*
 		 * If truncate failed early the inode might still be
 		 * on the orphan list; we need to make sure the inode
@@ -1751,7 +1761,7 @@ static int ext4_writeback_write_end(struct file *file,
 		ret = ret2;
 
 	if (pos + len > inode->i_size) {
-		ext4_truncate(inode);
+		ext4_truncate_failed_write(inode);
 		/*
 		 * If truncate failed early the inode might still be
 		 * on the orphan list; we need to make sure the inode
@@ -1814,7 +1824,7 @@ static int ext4_journalled_write_end(struct file *file,
 	if (!ret)
 		ret = ret2;
 	if (pos + len > inode->i_size) {
-		ext4_truncate(inode);
+		ext4_truncate_failed_write(inode);
 		/*
 		 * If truncate failed early the inode might still be
 		 * on the orphan list; we need to make sure the inode
@@ -3091,7 +3101,7 @@ retry:
 		 * i_size_read because we hold i_mutex.
 		 */
 		if (pos + len > inode->i_size)
-			ext4_truncate(inode);
+			ext4_truncate_failed_write(inode);
 	}
 
 	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
-- 
1.6.4.2


--xHFwDpU9dbj6ez1V--
