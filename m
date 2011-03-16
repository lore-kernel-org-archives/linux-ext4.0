From: Jan Kara <jack@suse.cz>
Subject: [PATCH 1/2] ext4: Fix BUG_ON in ext4_da_block_invalidatepages()
Date: Wed, 16 Mar 2011 21:52:53 +0100
Message-ID: <1300308774-14140-2-git-send-email-jack@suse.cz>
References: <1300308774-14140-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37031 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753659Ab1CPUxG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Mar 2011 16:53:06 -0400
In-Reply-To: <1300308774-14140-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When an allocation of blocks fails in mpage_da_map_and_submit() e.g. because of
EIO we call ext4_da_block_invalidatepages() to invalidate pages we cannot write
but we fail to set mpd->io_done. Thus we continue searching for dirty pages and
add them to the current extent in mpd structure. Eventually we try to allocate
blocks for the extent again and strange things start happening. In particular
if the allocation fails again, we try to invalidate pages again and that
triggers BUG_ON in ext4_da_block_invalidatepages().

Fix the issue by setting mpd->io_done after the pages are invalidated.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 9f7f9e4..337d9ca 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2314,6 +2314,7 @@ static void mpage_da_map_and_submit(struct mpage_da_data *mpd)
 		/* invalidate all the pages */
 		ext4_da_block_invalidatepages(mpd, next,
 				mpd->b_size >> mpd->inode->i_blkbits);
+		mpd->io_done = 1;
 		return;
 	}
 	BUG_ON(blks == 0);
-- 
1.7.1

