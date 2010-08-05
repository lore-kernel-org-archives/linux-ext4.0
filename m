From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/2] ext3: Fix dirtying of journalled buffers in data=journal mode
Date: Thu,  5 Aug 2010 18:42:16 +0200
Message-ID: <1281026536-10413-3-git-send-email-jack@suse.cz>
References: <1281026536-10413-1-git-send-email-jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, tytso@mit.edu,
	Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:49525 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933248Ab0HEQm7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 Aug 2010 12:42:59 -0400
In-Reply-To: <1281026536-10413-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In data=journal mode, we still use block_write_begin() to prepare page for
writing. This function can occasionally mark buffer dirty which violates
journalling assumptions - when a buffer is part of a transaction, it should be
dirty and a buffer can be already part of a forget list of some transaction
when block_write_begin() gets called. This violation of journalling assumptions
then results in "JBD: Spotted dirty metadata buffer..." warnings.

In fact, temporary dirtying the buffer while the page is still locked does not
really cause problems to the journalling because we won't write the buffer
until the page gets unlocked. So we just have to make sure to clear dirty bits
before unlocking the page.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext3/inode.c |   18 +++++++++++++++++-
 1 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 735f019..1a84abb 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -1149,9 +1149,25 @@ static int walk_page_buffers(	handle_t *handle,
 static int do_journal_get_write_access(handle_t *handle,
 					struct buffer_head *bh)
 {
+	int dirty = buffer_dirty(bh);
+	int ret;
+
 	if (!buffer_mapped(bh) || buffer_freed(bh))
 		return 0;
-	return ext3_journal_get_write_access(handle, bh);
+	/*
+	 * __block_prepare_write() could have dirtied some buffers. Clean
+	 * the dirty bit as jbd2_journal_get_write_access() could complain
+	 * otherwise about fs integrity issues. Setting of the dirty bit
+	 * by __block_prepare_write() isn't a real problem here as we clear
+	 * the bit before releasing a page lock and thus writeback cannot
+	 * ever write the buffer.
+	 */
+	if (dirty)
+		clear_buffer_dirty(bh);
+	ret = ext3_journal_get_write_access(handle, bh);
+	if (!ret && dirty)
+		ret = ext3_journal_dirty_metadata(handle, bh);
+	return ret;
 }
 
 /*
-- 
1.6.4.2

