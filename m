From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/4] ext3: Avoid false EIO errors
Date: Tue, 17 Mar 2009 18:33:53 +0100
Message-ID: <1237311235-13623-3-git-send-email-jack@suse.cz>
References: <n>
 <1237311235-13623-1-git-send-email-jack@suse.cz>
 <1237311235-13623-2-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47321 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752190AbZCQTn4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Mar 2009 15:43:56 -0400
In-Reply-To: <1237311235-13623-2-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Sometimes block_write_begin() can map buffers in a page but later we
fail to copy data into those buffers (because the source page has
been paged out in the mean time). We then end up with !uptodate mapped
buffers. We must not file such buffers into a transaction - firstly they
contain garbage and secondly it confuses the journaling code (it thinks
write has failed and complains about IO errors).

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext3/inode.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 62005c0..d351eab 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -1430,7 +1430,11 @@ static int bput_one(handle_t *handle, struct buffer_head *bh)
 
 static int journal_dirty_data_fn(handle_t *handle, struct buffer_head *bh)
 {
-	if (buffer_mapped(bh))
+	/*
+	 * Parallel write could have mapped the buffer but it didn't copy
+	 * the data in yet. So avoid filing such buffer into a transaction.
+	 */
+	if (buffer_mapped(bh) && buffer_uptodate(bh))
 		return ext3_journal_dirty_data(handle, bh);
 	return 0;
 }
-- 
1.6.0.2

