From: Saugata Das <saugata.das@stericsson.com>
Subject: [PATCH 2/2] ext4: annotate all meta data requests
Date: Fri, 11 May 2012 20:32:57 +0530
Message-ID: <1336748577-9258-2-git-send-email-saugata.das@stericsson.com>
References: <1336748577-9258-1-git-send-email-saugata.das@stericsson.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <tytso@mit.edu>, <adilger@whamcloud.com>, <hch@infradead.org>,
	<arnd.bergmann@linaro.org>, <venkat@linaro.org>,
	Saugata Das <saugata.das@linaro.org>
To: <linux-ext4@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1336748577-9258-1-git-send-email-saugata.das@stericsson.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Saugata Das <saugata.das@linaro.org>

Today, storage devices like eMMC has special features like data tagging
(introduced in MMC-4.5 version) in order to improve performance of some
specific writes. On MMC stack, data tagging is used for all writes which has
REQ_META flag set. On EXT4, however, currently REQ_META is set only for read.
This patch adds the capability mark a meta-data buffer with set_buffer_meta
during meta data write. During submit_bh, this information is used to set
REQ_META flag.

Signed-off-by: Saugata Das <saugata.das@linaro.org>
---
 fs/ext4/ext4_jbd2.c |    4 ++++
 fs/ext4/inode.c     |    4 +++-
 2 files changed, 7 insertions(+), 1 deletions(-)

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
index c77b0bd..754fe77 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4035,8 +4035,10 @@ int ext4_write_inode(struct inode *inode, struct writeback_control *wbc)
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
-- 
1.7.4.3

