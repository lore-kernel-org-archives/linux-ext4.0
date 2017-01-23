From: Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 1/1 linux-next] ext4: atomically read inode size
Date: Mon, 23 Jan 2017 18:56:09 +0100
Message-ID: <20170123175609.6032-1-fabf@skynet.be>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        fabf@skynet.be
To: tytso@mit.edu
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

See i_size_read() comments in include/linux/fs.h

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/ext4/super.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 9d15a62..3746f77 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3798,7 +3798,8 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		goto cantfind_ext4;
 
 	/* check blocks count against device size */
-	blocks_count = sb->s_bdev->bd_inode->i_size >> sb->s_blocksize_bits;
+	blocks_count = i_size_read(sb->s_bdev->bd_inode) >>
+		       sb->s_blocksize_bits;
 	if (blocks_count && ext4_blocks_count(es) > blocks_count) {
 		ext4_msg(sb, KERN_WARNING, "bad geometry: block count %llu "
 		       "exceeds size of device (%llu blocks)",
-- 
2.9.3
