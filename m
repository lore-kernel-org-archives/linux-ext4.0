From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] ext2: use ktime_get_real_seconds for timestamps
Date: Wed, 20 Jun 2018 16:31:40 +0200
Message-ID: <20180620143203.42225-1-arnd@arndb.de>
Cc: y2038@lists.linaro.org, Arnd Bergmann <arnd@arndb.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Jan Kara <jack@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

get_seconds() is deprecated because of the y2038 overflow, so users
should migrate to 64-bit timestamps using ktime_get_real_seconds().
In ext2, the timestamps in the superblock and in the inode are all
limited to 32-bit, and this won't get fixed, so let's just stop
using the deprecated interface and keep truncating.

All users of ext2 should migrate to ext4 before 2038 to prevent this
from causing problems.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/ext2/inode.c | 2 +-
 fs/ext2/super.c | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 71635909df3b..7f7ee18fe179 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -86,7 +86,7 @@ void ext2_evict_inode(struct inode * inode)
 	if (want_delete) {
 		sb_start_intwrite(inode->i_sb);
 		/* set dtime */
-		EXT2_I(inode)->i_dtime	= get_seconds();
+		EXT2_I(inode)->i_dtime	= ktime_get_real_seconds();
 		mark_inode_dirty(inode);
 		__ext2_write_inode(inode, inode_needs_sync(inode));
 		/* truncate to 0 */
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 25ab1274090f..25e31afe961d 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -679,7 +679,7 @@ static int ext2_setup_super (struct super_block * sb,
 			"running e2fsck is recommended");
 	else if (le32_to_cpu(es->s_checkinterval) &&
 		(le32_to_cpu(es->s_lastcheck) +
-			le32_to_cpu(es->s_checkinterval) <= get_seconds()))
+			le32_to_cpu(es->s_checkinterval) <= ktime_get_real_seconds()))
 		ext2_msg(sb, KERN_WARNING,
 			"warning: checktime reached, "
 			"running e2fsck is recommended");
@@ -1245,7 +1245,7 @@ void ext2_sync_super(struct super_block *sb, struct ext2_super_block *es,
 	spin_lock(&EXT2_SB(sb)->s_lock);
 	es->s_free_blocks_count = cpu_to_le32(ext2_count_free_blocks(sb));
 	es->s_free_inodes_count = cpu_to_le32(ext2_count_free_inodes(sb));
-	es->s_wtime = cpu_to_le32(get_seconds());
+	es->s_wtime = cpu_to_le32(ktime_get_real_seconds());
 	/* unlock before we do IO */
 	spin_unlock(&EXT2_SB(sb)->s_lock);
 	mark_buffer_dirty(EXT2_SB(sb)->s_sbh);
@@ -1360,7 +1360,7 @@ static int ext2_remount (struct super_block * sb, int * flags, char * data)
 		 * the rdonly flag and then mark the partition as valid again.
 		 */
 		es->s_state = cpu_to_le16(sbi->s_mount_state);
-		es->s_mtime = cpu_to_le32(get_seconds());
+		es->s_mtime = cpu_to_le32(ktime_get_real_seconds());
 		spin_unlock(&sbi->s_lock);
 
 		err = dquot_suspend(sb, -1);
-- 
2.9.0
