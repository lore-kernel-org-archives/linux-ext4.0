From: Jan Kara <jack@suse.cz>
Subject: [PATCH] ext4: Fix overflow when updating superblock backups after resize
Date: Wed, 22 Oct 2014 16:29:08 +0200
Message-ID: <1413988148-11433-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
	stable@vger.kernel.org
To: Ted Tso <tytso@mit.edu>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

When there are no meta block groups update_backups() will compute the
backup block in 32-bit arithmetics thus possibly overflowing the block
number and corrupting the filesystem. OTOH filesystems without meta
block groups larger than 16 TB should be rare. Fix the problem by doing
the counting in 64-bit arithmetics.

Coverity-id: 741252
CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/resize.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index f298c60f907d..ca4588388fc3 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1081,7 +1081,7 @@ static void update_backups(struct super_block *sb, int blk_off, char *data,
 			break;
 
 		if (meta_bg == 0)
-			backup_block = group * bpg + blk_off;
+			backup_block = ((ext4_fsblk_t)group) * bpg + blk_off;
 		else
 			backup_block = (ext4_group_first_block_no(sb, group) +
 					ext4_bg_has_super(sb, group));
-- 
1.8.1.4
