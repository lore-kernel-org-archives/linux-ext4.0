From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/2] ext4: Fix hole punching for files with indirect blocks
Date: Wed, 18 Jun 2014 21:33:04 +0200
Message-ID: <1403119984-3635-2-git-send-email-jack@suse.cz>
References: <1403119984-3635-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
	stable@vger.kernel.org
To: Ted Tso <tytso@mit.edu>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1403119984-3635-1-git-send-email-jack@suse.cz>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hole punching code for files with indirect blocks wrongly computed
number of blocks which need to be cleared when traversing the indirect
block tree. That could result in punching more blocks than actually
requested and thus effectively cause a data loss. For example:

fallocate -n -p 10240000 4096

will punch the range 10240000 - 12632064 instead of the range 1024000 -
10244096. Fix the calculation.

CC: stable@vger.kernel.org
Fixes: 8bad6fc813a3a5300f51369c39d315679fd88c72
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/indirect.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index 9d381707a6fc..771949c82715 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -1310,16 +1310,24 @@ static int free_hole_blocks(handle_t *handle, struct inode *inode,
 		blk = *i_data;
 		if (level > 0) {
 			ext4_lblk_t first2;
+			ext4_lblk_t count2;
+
 			bh = sb_bread(inode->i_sb, le32_to_cpu(blk));
 			if (!bh) {
 				EXT4_ERROR_INODE_BLOCK(inode, le32_to_cpu(blk),
 						       "Read failure");
 				return -EIO;
 			}
-			first2 = (first > offset) ? first - offset : 0;
+			if (first > offset) {
+				first2 = first - offset;
+				count2 = count;
+			} else {
+				first2 = 0;
+				count2 = count - (offset - first);
+			}
 			ret = free_hole_blocks(handle, inode, bh,
 					       (__le32 *)bh->b_data, level - 1,
-					       first2, count - offset,
+					       first2, count2,
 					       inode->i_sb->s_blocksize >> 2);
 			if (ret) {
 				brelse(bh);
-- 
1.8.1.4
