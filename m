From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 3/3] ext4: optimize quota write locking
Date: Sat, 27 Mar 2010 15:15:40 +0300
Message-ID: <1269692140-5375-4-git-send-email-dmonakhov@openvz.org>
References: <1269692140-5375-1-git-send-email-dmonakhov@openvz.org>
 <1269692140-5375-2-git-send-email-dmonakhov@openvz.org>
 <1269692140-5375-3-git-send-email-dmonakhov@openvz.org>
Cc: linux-fsdevel@vger.kernel.org, jack@suse.cz,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1269692140-5375-3-git-send-email-dmonakhov@openvz.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Quota inode is append only. In most cases writes performed
to allocated blocks before i_size. Currently we grup i_mutex
for each quota write to protect i_size and i_mtime. But in most
cases i_size not changed. And i_mtime is not that important
as for regular files. So let's update it only when quota file
increased. This allow us to avoid i_mutex in most cases.

Some day quota file will be hiden completly, so i_mtime hack
will disappear.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/super.c |   22 +++++++++++++++-------
 1 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index b7b5707..5a378e3 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4039,6 +4039,7 @@ static ssize_t ext4_quota_write(struct super_block *sb, int type,
 	ext4_lblk_t blk = off >> EXT4_BLOCK_SIZE_BITS(sb);
 	int err = 0;
 	int offset = off & (sb->s_blocksize - 1);
+	int is_locked = 0;
 	int journal_quota = EXT4_SB(sb)->s_qf_names[type] != NULL;
 	struct buffer_head *bh;
 	handle_t *handle = journal_current_handle();
@@ -4059,8 +4060,14 @@ static ssize_t ext4_quota_write(struct super_block *sb, int type,
 			(unsigned long long)off, (unsigned long long)len);
 		return -EIO;
 	}
-
-	mutex_lock_nested(&inode->i_mutex, I_MUTEX_QUOTA);
+	/*
+	 * Inode file is append only. It is not necessery to hold i_mutex
+	 * if quota block is allocated already. Optimize that case.
+	 */
+	if (off + len > i_size_read(inode)) {
+		mutex_lock_nested(&inode->i_mutex, I_MUTEX_QUOTA);
+		is_locked = 1;
+	}
 	bh = ext4_bread(handle, inode, blk, 1, &err);
 	if (!bh)
 		goto out;
@@ -4085,16 +4092,17 @@ static ssize_t ext4_quota_write(struct super_block *sb, int type,
 	brelse(bh);
 out:
 	if (err) {
-		mutex_unlock(&inode->i_mutex);
+		if (is_locked)
+			mutex_unlock(&inode->i_mutex);
 		return err;
 	}
-	if (inode->i_size < off + len) {
+	if (is_locked) {
 		i_size_write(inode, off + len);
 		EXT4_I(inode)->i_disksize = inode->i_size;
+		inode->i_mtime = inode->i_ctime = CURRENT_TIME;
+		ext4_mark_inode_dirty(handle, inode);
+		mutex_unlock(&inode->i_mutex);
 	}
-	inode->i_mtime = inode->i_ctime = CURRENT_TIME;
-	ext4_mark_inode_dirty(handle, inode);
-	mutex_unlock(&inode->i_mutex);
 	return len;
 }
 
-- 
1.6.6.1

