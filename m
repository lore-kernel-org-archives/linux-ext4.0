From: Jan Kara <jack@suse.cz>
Subject: [PATCH 08/12] ext4: Remove __ext4_journalled_writepage() from mpage_da_submit_io()
Date: Fri, 18 Jan 2013 13:00:42 +0100
Message-ID: <1358510446-19174-9-git-send-email-jack@suse.cz>
References: <1358510446-19174-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35013 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753288Ab3ARMA6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Jan 2013 07:00:58 -0500
In-Reply-To: <1358510446-19174-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We don't support delayed allocation in data=journal mode. So checking for it in
mpage_da_submit_io() doesn't make really sence. If we ever decide to extend
delayed allocation support to data=journal mode, adding
__ext4_journalled_writepage() call will be the least of problems we have to
solve. Most likely we'd have to implement separate writepages call anyways
because we don't have transaction credits for writing more than a single page
so mapping of page buffers would have to be done differently.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c |   13 ++-----------
 1 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index f95b511..359d06e 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1354,7 +1354,6 @@ static int mpage_da_submit_io(struct mpage_da_data *mpd,
 	loff_t size = i_size_read(inode);
 	unsigned int len, block_start;
 	struct buffer_head *bh, *page_bufs = NULL;
-	int journal_data = ext4_should_journal_data(inode);
 	sector_t pblock = 0, cur_logical = 0;
 	struct ext4_io_submit io_submit;
 
@@ -1453,16 +1452,8 @@ static int mpage_da_submit_io(struct mpage_da_data *mpd,
 				block_commit_write(page, 0, len);
 
 			clear_page_dirty_for_io(page);
-			/*
-			 * Delalloc doesn't support data journalling,
-			 * but eventually maybe we'll lift this
-			 * restriction.
-			 */
-			if (unlikely(journal_data && PageChecked(page)))
-				err = __ext4_journalled_writepage(page, len);
-			else
-				err = ext4_bio_write_page(&io_submit, page,
-							  len, mpd->wbc);
+			err = ext4_bio_write_page(&io_submit, page, len,
+						  mpd->wbc);
 			if (!err)
 				mpd->pages_written++;
 			/*
-- 
1.7.1

