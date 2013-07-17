From: Jan Kara <jack@suse.cz>
Subject: [PATCH] ext4: Remove extent tree purging from ext4_da_page_release_reservation()
Date: Thu, 18 Jul 2013 00:10:15 +0200
Message-ID: <1374099015-6829-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37134 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756419Ab3GQWKV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 17 Jul 2013 18:10:21 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4_da_page_release_reservation() gets called from
ext4_da_invalidatepage(). This function is used when we are truncating
page cache for punch hole or truncate operations. In either case these
operations take care of removing extents from the extent tree. This is
more efficient and the code in ext4_da_page_release_reservation() is
actually buggy anyway. So just remove it.

CC: Zheng Liu <wenqing.lz@taobao.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 0188e65..98a9972 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1388,11 +1388,6 @@ static void ext4_da_page_release_reservation(struct page *page,
 		curr_off = next_off;
 	} while ((bh = bh->b_this_page) != head);
 
-	if (to_release) {
-		lblk = page->index << (PAGE_CACHE_SHIFT - inode->i_blkbits);
-		ext4_es_remove_extent(inode, lblk, to_release);
-	}
