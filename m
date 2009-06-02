From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH,STABLE 2.6.27 24/24] ext4: Fix race in ext4_inode_info.i_cached_extent
Date: Tue,  2 Jun 2009 08:09:36 -0400
Message-ID: <1243944576-20915-24-git-send-email-tytso@mit.edu>
References: <1243944576-20915-1-git-send-email-tytso@mit.edu>
 <1243944576-20915-2-git-send-email-tytso@mit.edu>
 <1243944576-20915-3-git-send-email-tytso@mit.edu>
 <1243944576-20915-4-git-send-email-tytso@mit.edu>
 <1243944576-20915-5-git-send-email-tytso@mit.edu>
 <1243944576-20915-6-git-send-email-tytso@mit.edu>
 <1243944576-20915-7-git-send-email-tytso@mit.edu>
 <1243944576-20915-8-git-send-email-tytso@mit.edu>
 <1243944576-20915-9-git-send-email-tytso@mit.edu>
 <1243944576-20915-10-git-send-email-tytso@mit.edu>
 <1243944576-20915-11-git-send-email-tytso@mit.edu>
 <1243944576-20915-12-git-send-email-tytso@mit.edu>
 <1243944576-20915-13-git-send-email-tytso@mit.edu>
 <1243944576-20915-14-git-send-email-tytso@mit.edu>
 <1243944576-20915-15-git-send-email-tytso@mit.edu>
 <1243944576-20915-16-git-send-email-tytso@mit.edu>
 <1243944576-20915-17-git-send-email-tytso@mit.edu>
 <1243944576-20915-18-git-send-email-tytso@mit.edu>
 <1243944576-20915-19-git-send-email-tytso@mit.edu>
 <1243944576-20915-20-git-send-email-tytso@mit.edu>
 <1243944576-20915-21-git-send-email-tytso@mit.edu>
 <1243944576-20915-22-git-send-email-tytso@mit.edu>
 <1243944576-20915-23-git-send-email-tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:59262 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752181AbZFBMJp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Jun 2009 08:09:45 -0400
In-Reply-To: <1243944576-20915-23-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If two CPU's simultaneously call ext4_ext_get_blocks() at the same
time, there is nothing protecting the i_cached_extent structure from
being used and updated at the same time.  This could potentially cause
the wrong location on disk to be read or written to, including
potentially causing the corruption of the block group descriptors
and/or inode table.

This bug has been in the ext4 code since almost the very beginning of
ext4's development.  Fortunately once the data is stored in the page
cache cache, ext4_get_blocks() doesn't need to be called, so trying to
replicate this problem to the point where we could identify its root
cause was *extremely* difficult.  Many thanks to Kevin Shanahan for
working over several months to be able to reproduce this easily so we
could finally nail down the cause of the corruption.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Reviewed-by: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
(cherry picked from commit 2ec0ae3acec47f628179ee95fe2c4da01b5e9fc4)
---
 fs/ext4/extents.c |   17 ++++++++++++-----
 1 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 067cbc0..41dadd4 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1633,11 +1633,13 @@ ext4_ext_put_in_cache(struct inode *inode, ext4_lblk_t block,
 {
 	struct ext4_ext_cache *cex;
 	BUG_ON(len == 0);
+	spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
 	cex = &EXT4_I(inode)->i_cached_extent;
 	cex->ec_type = type;
 	cex->ec_block = block;
 	cex->ec_len = len;
 	cex->ec_start = start;
+	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
 }
 
 /*
@@ -1694,12 +1696,17 @@ ext4_ext_in_cache(struct inode *inode, ext4_lblk_t block,
 			struct ext4_extent *ex)
 {
 	struct ext4_ext_cache *cex;
+	int ret = EXT4_EXT_CACHE_NO;
 
+	/* 
+	 * We borrow i_block_reservation_lock to protect i_cached_extent
+	 */
+	spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
 	cex = &EXT4_I(inode)->i_cached_extent;
 
 	/* has cache valid data? */
 	if (cex->ec_type == EXT4_EXT_CACHE_NO)
-		return EXT4_EXT_CACHE_NO;
+		goto errout;
 
 	BUG_ON(cex->ec_type != EXT4_EXT_CACHE_GAP &&
 			cex->ec_type != EXT4_EXT_CACHE_EXTENT);
@@ -1710,11 +1717,11 @@ ext4_ext_in_cache(struct inode *inode, ext4_lblk_t block,
 		ext_debug("%u cached by %u:%u:%llu\n",
 				block,
 				cex->ec_block, cex->ec_len, cex->ec_start);
-		return cex->ec_type;
+		ret = cex->ec_type;
 	}
