From: Theodore Ts'o <tytso@mit.edu>
Subject: [FOR-STABLE 08/20] ext4: fix initialization of UNINIT bitmap blocks
Date: Sun, 16 Nov 2008 11:05:28 -0500
Message-ID: <1226851540-8032-9-git-send-email-tytso@mit.edu>
References: <1226851540-8032-1-git-send-email-tytso@mit.edu>
 <1226851540-8032-2-git-send-email-tytso@mit.edu>
 <1226851540-8032-3-git-send-email-tytso@mit.edu>
 <1226851540-8032-4-git-send-email-tytso@mit.edu>
 <1226851540-8032-5-git-send-email-tytso@mit.edu>
 <1226851540-8032-6-git-send-email-tytso@mit.edu>
 <1226851540-8032-7-git-send-email-tytso@mit.edu>
 <1226851540-8032-8-git-send-email-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Frederic Bohe <frederic.bohe@bull.net>,
	"Theodore Ts'o" <tytso@mit.edu>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:44736 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753484AbYKPQh1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 16 Nov 2008 11:37:27 -0500
In-Reply-To: <1226851540-8032-8-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Frederic Bohe <frederic.bohe@bull.net>

This fixes a bug which caused on-line resizing of filesystems with a
1k blocksize to fail.  The root cause of this bug was the fact that if
an uninitalized bitmap block gets read in by userspace (which
e2fsprogs does try to avoid, but can happen when the blocksize is less
than the pagesize and an adjacent blocks is read into memory)
ext4_read_block_bitmap() was erroneously depending on the buffer
uptodate flag to decide whether it needed to initialize the bitmap
block in memory --- i.e., to set the standard set of blocks in use by
a block group (superblock, bitmaps, inode table, etc.).  Essentially,
ext4_read_block_bitmap() assumed it was the only routine that might
try to read a block containing a block bitmap, which is simply not
true.

To fix this, ext4_read_block_bitmap() and ext4_read_inode_bitmap()
must always initialize uninitialized bitmap blocks.  Once a block or
inode is allocated out of that bitmap, it will be marked as
initialized in the block group descriptor, so in general this won't
result any extra unnecessary work.

Signed-off-by: Frederic Bohe <frederic.bohe@bull.net>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
(cherry picked from commit c806e68f5647109350ec546fee5b526962970fd2)
---
 fs/ext4/balloc.c  |    4 +++-
 fs/ext4/ialloc.c  |    4 +++-
 fs/ext4/mballoc.c |    4 +++-
 3 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index e9fa960..c2e4b89 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -318,9 +318,11 @@ ext4_read_block_bitmap(struct super_block *sb, ext4_group_t block_group)
 			    block_group, bitmap_blk);
 		return NULL;
 	}
-	if (bh_uptodate_or_lock(bh))
+	if (buffer_uptodate(bh) &&
+	    !(desc->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)))
 		return bh;
 
+	lock_buffer(bh);
 	spin_lock(sb_bgl_lock(EXT4_SB(sb), block_group));
 	if (desc->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
 		ext4_init_block_bitmap(sb, bh, block_group, desc);
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index f344834..84e5bbf 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -115,9 +115,11 @@ ext4_read_inode_bitmap(struct super_block *sb, ext4_group_t block_group)
 			    block_group, bitmap_blk);
 		return NULL;
 	}
-	if (bh_uptodate_or_lock(bh))
+	if (buffer_uptodate(bh) &&
+	    !(desc->bg_flags & cpu_to_le16(EXT4_BG_INODE_UNINIT)))
 		return bh;
 
+	lock_buffer(bh);
 	spin_lock(sb_bgl_lock(EXT4_SB(sb), block_group));
 	if (desc->bg_flags & cpu_to_le16(EXT4_BG_INODE_UNINIT)) {
 		ext4_init_inode_bitmap(sb, bh, block_group, desc);
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 0d51106..b9b6dbd 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -784,9 +784,11 @@ static int ext4_mb_init_cache(struct page *page, char *incore)
 		if (bh[i] == NULL)
 			goto out;
 
-		if (bh_uptodate_or_lock(bh[i]))
+		if (buffer_uptodate(bh[i]) &&
+		    !(desc->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)))
 			continue;
 
+		lock_buffer(bh[i]);
 		spin_lock(sb_bgl_lock(EXT4_SB(sb), first_group + i));
 		if (desc->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
 			ext4_init_block_bitmap(sb, bh[i],
-- 
1.6.0.4.8.g36f27.dirty

