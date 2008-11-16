From: Theodore Ts'o <tytso@mit.edu>
Subject: [FOR-STABLE 20/20] ext4: add checksum calculation when clearing UNINIT flag in ext4_new_inode
Date: Sun, 16 Nov 2008 11:05:40 -0500
Message-ID: <1226851540-8032-21-git-send-email-tytso@mit.edu>
References: <1226851540-8032-1-git-send-email-tytso@mit.edu>
 <1226851540-8032-2-git-send-email-tytso@mit.edu>
 <1226851540-8032-3-git-send-email-tytso@mit.edu>
 <1226851540-8032-4-git-send-email-tytso@mit.edu>
 <1226851540-8032-5-git-send-email-tytso@mit.edu>
 <1226851540-8032-6-git-send-email-tytso@mit.edu>
 <1226851540-8032-7-git-send-email-tytso@mit.edu>
 <1226851540-8032-8-git-send-email-tytso@mit.edu>
 <1226851540-8032-9-git-send-email-tytso@mit.edu>
 <1226851540-8032-10-git-send-email-tytso@mit.edu>
 <1226851540-8032-11-git-send-email-tytso@mit.edu>
 <1226851540-8032-12-git-send-email-tytso@mit.edu>
 <1226851540-8032-13-git-send-email-tytso@mit.edu>
 <1226851540-8032-14-git-send-email-tytso@mit.edu>
 <1226851540-8032-15-git-send-email-tytso@mit.edu>
 <1226851540-8032-16-git-send-email-tytso@mit.edu>
 <1226851540-8032-17-git-send-email-tytso@mit.edu>
 <1226851540-8032-18-git-send-email-tytso@mit.edu>
 <1226851540-8032-19-git-send-email-tytso@mit.edu>
 <1226851540-8032-20-git-send-email-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Frederic Bohe <frederic.bohe@bull.net>,
	"Theodore Ts'o" <tytso@mit.edu>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:58996 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753422AbYKPQXh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 16 Nov 2008 11:23:37 -0500
In-Reply-To: <1226851540-8032-20-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Frederic Bohe <frederic.bohe@bull.net>

When initializing an uninitialized block group in ext4_new_inode(),
its block group checksum must be re-calculated.  This fixes a race
when several threads try to allocate a new inode in an UNINIT'd group.

There is some question whether we need to be initializing the block
bitmap in ext4_new_inode() at all, but for now, if we are going to
init the block group, let's eliminate the race.

Signed-off-by: Frederic Bohe <frederic.bohe@bull.net>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
(cherry picked from commit 23712a9c28b9f80a8cf70c8490358d5f562d2465)
---
 fs/ext4/ialloc.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 84e5bbf..13efb5f 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -717,6 +717,8 @@ got:
 			gdp->bg_flags &= cpu_to_le16(~EXT4_BG_BLOCK_UNINIT);
 			free = ext4_free_blocks_after_init(sb, group, gdp);
 			gdp->bg_free_blocks_count = cpu_to_le16(free);
+			gdp->bg_checksum = ext4_group_desc_csum(sbi, group,
+								gdp);
 		}
 		spin_unlock(sb_bgl_lock(sbi, group));
 
-- 
1.6.0.4.8.g36f27.dirty

