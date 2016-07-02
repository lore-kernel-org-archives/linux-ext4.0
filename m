From: Vegard Nossum <vegard.nossum@oracle.com>
Subject: [PATCH] ext4: don't call ext4_should_journal_data() on the journal inode
Date: Sat,  2 Jul 2016 23:42:42 +0200
Message-ID: <1467495762-25353-1-git-send-email-vegard.nossum@oracle.com>
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Certain combinations of mount options in the superblock will cause
set_journal_csum_feature_set() in ext4_fill_super() to fail after the
journal has been created. When iput() is called on the journal inode,
we will hit the BUG() in ext4_should_journal_data(). We can prevent
this by only calling ext4_should_journal_data() if we already know
that it's not the journal inode.

Fixes: 2d859db3e4 ("ext4: fix data corruption in inodes with journalled data")
Fixes: 2b405bfa84 ("ext4: fix data=journal fast mount/umount hang")
Cc: Jan Kara <jack@suse.cz>
Cc: stable@vger.kernel.org
Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 fs/ext4/inode.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 91b66db..2591236 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -207,9 +207,9 @@ void ext4_evict_inode(struct inode *inode)
 		 * Note that directories do not have this problem because they
 		 * don't use page cache.
 		 */
-		if (ext4_should_journal_data(inode) &&
-		    (S_ISLNK(inode->i_mode) || S_ISREG(inode->i_mode)) &&
-		    inode->i_ino != EXT4_JOURNAL_INO) {
+		if (inode->i_ino != EXT4_JOURNAL_INO &&
+		    ext4_should_journal_data(inode) &&
+		    (S_ISLNK(inode->i_mode) || S_ISREG(inode->i_mode))) {
 			journal_t *journal = EXT4_SB(inode->i_sb)->s_journal;
 			tid_t commit_tid = EXT4_I(inode)->i_datasync_tid;
 
-- 
1.9.1

