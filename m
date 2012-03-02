From: Saugata Das <saugata.das@stericsson.com>
Subject: [PATCH v2] REQ_META set during meta data write
Date: Fri, 2 Mar 2012 18:15:09 +0530
Message-ID: <1330692309-6187-1-git-send-email-saugata.das@stericsson.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <saugata.das@linaro.org>, <arnd.bergmann@linaro.org>,
	<tytso@mit.edu>, <adilger@whamcloud.com>, <venkat@linaro.org>
To: <linux-ext4@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:33094 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758012Ab2CBMpj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 2 Mar 2012 07:45:39 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Saugata Das <saugata.das@linaro.org>

Today, storage devices like eMMC has special features like data tagging
(introduced in MMC-4.5 version) in order to improve performance of some
specific writes. On MMC stack, data tagging is used for all writes which has
REQ_META flag set. On EXT4, however, currently REQ_META is set only for read.
This patch adds the capability to add REQ_META flag during meta data write.
This patch adds new function set_buffer_meta, which is used to set a bit
BH_Meta in the b_state field when meta data and super block is made dirty.

Signed-off-by: Saugata Das <saugata.das@linaro.org>
Acked-by: Arnd Bergmann <arnd.bergmann@linaro.org>

Changelog v2:
	- Removed check for WRITE when setting REQ_META in submit_bh
Changelog v1:
	- Introduction of REQ_META during write
---
 fs/buffer.c                 |    3 +++
 fs/ext4/ext4_jbd2.c         |    4 ++++
 fs/ext4/inode.c             |    4 +++-
 include/linux/buffer_head.h |    2 ++
 4 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 19d8eb7..6eaf492 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2926,6 +2926,9 @@ int submit_bh(int rw, struct buffer_head * bh)
 	if (test_set_buffer_req(bh) && (rw & WRITE))
 		clear_buffer_write_io_error(bh);
 
+	if (buffer_meta(bh))
+		rw |= REQ_META;
+
 	/*
 	 * from here on down, it's all bio -- do the initial mapping,
 	 * submit_bio -> generic_make_request may further map this bio around
diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
index aca1790..097c062 100644
--- a/fs/ext4/ext4_jbd2.c
+++ b/fs/ext4/ext4_jbd2.c
@@ -107,6 +107,8 @@ int __ext4_handle_dirty_metadata(const char *where, unsigned int line,
 {
 	int err = 0;
 
+	set_buffer_meta(bh);
+
 	if (ext4_handle_valid(handle)) {
 		err = jbd2_journal_dirty_metadata(handle, bh);
 		if (err) {
@@ -143,6 +145,8 @@ int __ext4_handle_dirty_super(const char *where, unsigned int line,
 	struct buffer_head *bh = EXT4_SB(sb)->s_sbh;
 	int err = 0;
 
+	set_buffer_meta(bh);
+
 	if (ext4_handle_valid(handle)) {
 		err = jbd2_journal_dirty_metadata(handle, bh);
 		if (err)
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 92655fd..105e1d0 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4144,8 +4144,10 @@ int ext4_write_inode(struct inode *inode, struct writeback_control *wbc)
 		err = __ext4_get_inode_loc(inode, &iloc, 0);
 		if (err)
 			return err;
-		if (wbc->sync_mode == WB_SYNC_ALL)
+		if (wbc->sync_mode == WB_SYNC_ALL) {
+			set_buffer_meta(iloc.bh);
 			sync_dirty_buffer(iloc.bh);
+		}
 		if (buffer_req(iloc.bh) && !buffer_uptodate(iloc.bh)) {
 			EXT4_ERROR_INODE_BLOCK(inode, iloc.bh->b_blocknr,
 					 "IO error syncing inode");
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index 458f497..13bba17 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -34,6 +34,7 @@ enum bh_state_bits {
 	BH_Write_EIO,	/* I/O error on write */
 	BH_Unwritten,	/* Buffer is allocated on disk but not written */
 	BH_Quiet,	/* Buffer Error Prinks to be quiet */
+	BH_Meta,	/* Is meta */
 
 	BH_PrivateStart,/* not a state bit, but the first bit available
 			 * for private allocation by other entities
@@ -124,6 +125,7 @@ BUFFER_FNS(Delay, delay)
 BUFFER_FNS(Boundary, boundary)
 BUFFER_FNS(Write_EIO, write_io_error)
 BUFFER_FNS(Unwritten, unwritten)
+BUFFER_FNS(Meta, meta)
 
 #define bh_offset(bh)		((unsigned long)(bh)->b_data & ~PAGE_MASK)
 #define touch_buffer(bh)	mark_page_accessed(bh->b_page)
-- 
1.7.4.3

