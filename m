From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: [PATCH 2/2] ext4: update donor file's ctime/mtime
Date: Thu, 08 Oct 2009 17:04:20 +0900
Message-ID: <4ACD9D04.40503@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org, Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:36540 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754396AbZJHIHg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 8 Oct 2009 04:07:36 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

EXT4_IOC_MOVE_EXT changes donor file data, but doesn't update ctime/mtime.
This patch fixes this problem.

Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
---

 move_extent.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)
diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index e2e99fd..1cb2609 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -1210,6 +1210,7 @@ ext4_move_extents(struct file *o_filp, struct file *d_filp,
 	ext4_lblk_t block_end, seq_start, add_blocks, file_end, seq_blocks = 0;
 	ext4_lblk_t rest_blocks;
 	pgoff_t orig_page_offset = 0, seq_end_page;
+	handle_t *handle;
 	int ret1, ret2, depth, last_extent = 0;
 	int blocks_per_page = PAGE_CACHE_SIZE >> orig_inode->i_blkbits;
 	int data_offset_in_page;
@@ -1406,6 +1407,25 @@ ext4_move_extents(struct file *o_filp, struct file *d_filp,
 
 	}
 out:
+	/*
+	 * Note that ctime/mtime will not be updated if power failure is
+	 * detected during block replacing.
+	 */
+	if (*moved_len) {
+		handle = ext4_journal_start(donor_inode, 1);
+		if (IS_ERR(handle))
+			ret2 = PTR_ERR(handle);
+		else {
+			donor_inode->i_ctime = donor_inode->i_mtime =
+					ext4_current_time(donor_inode);
+			ret2 = ext4_mark_inode_dirty(handle, donor_inode);
+			ext4_journal_stop(handle);
+		}
+
+		if (!ret1)
+			ret1 = ret2;
+	}
+
 	if (orig_path) {
 		ext4_ext_drop_refs(orig_path);
 		kfree(orig_path);

