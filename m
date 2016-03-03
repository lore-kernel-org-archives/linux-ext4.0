From: Jan Kara <jack@suse.cz>
Subject: [PATCH 4/5] ext4: Cleanup handling of bh->b_state in DAX mmap
Date: Thu,  3 Mar 2016 11:23:50 +0100
Message-ID: <1457000631-10215-5-git-send-email-jack@suse.cz>
References: <1457000631-10215-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51042 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755980AbcCCKXj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 3 Mar 2016 05:23:39 -0500
In-Reply-To: <1457000631-10215-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4_dax_mmap_get_block() updates bh->b_state directly instead of using
ext4_update_bh_state(). This is mostly a cosmetic issue since DAX code
always passes on-stack buffer_head but clean this up to make code more
uniform.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index ef590607b4a7..e38c88b37e2e 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3180,13 +3180,12 @@ out:
 	WARN_ON_ONCE(ret == 0 && create);
 	if (ret > 0) {
 		map_bh(bh_result, inode->i_sb, map.m_pblk);
-		bh_result->b_state = (bh_result->b_state & ~EXT4_MAP_FLAGS) |
-					map.m_flags;
 		/*
 		 * At least for now we have to clear BH_New so that DAX code
 		 * doesn't attempt to zero blocks again in a racy way.
 		 */
-		bh_result->b_state &= ~(1 << BH_New);
+		map.m_flags &= ~EXT4_MAP_NEW;
+		ext4_update_bh_state(bh_result, map.m_flags);
 		bh_result->b_size = map.m_len << inode->i_blkbits;
 		ret = 0;
 	}
-- 
2.6.2

