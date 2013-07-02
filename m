From: Jan Kara <jack@suse.cz>
Subject: [PATCH] ext4: Silence warning in ext4_writepages()
Date: Tue,  2 Jul 2013 20:14:29 +0200
Message-ID: <1372788869-24456-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58034 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753455Ab3GBSOd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Jul 2013 14:14:33 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The loop in mpage_map_and_submit_extent() is guaranteed to always run at
least once since the caller of mpage_map_and_submit_extent() makes sure
map->m_len > 0. So make that explicit using do-while instead of pure
while which also silences the compiler warning about uninitialized 'err'
variable.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 0188e65..19a1643 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2163,7 +2163,7 @@ static int mpage_map_and_submit_extent(handle_t *handle,
 
 	mpd->io_submit.io_end->offset =
 				((loff_t)map->m_lblk) << inode->i_blkbits;
-	while (map->m_len) {
+	do {
 		err = mpage_map_one_extent(handle, mpd);
 		if (err < 0) {
 			struct super_block *sb = inode->i_sb;
@@ -2201,7 +2201,7 @@ static int mpage_map_and_submit_extent(handle_t *handle,
 		err = mpage_map_and_submit_buffers(mpd);
 		if (err < 0)
 			return err;
-	}
+	} while (map->m_len);
 
 	/* Update on-disk size after IO is submitted */
 	disksize = ((loff_t)mpd->first_page) << PAGE_CACHE_SHIFT;
-- 
1.8.1.4

