From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 3/7] ext4: Remove unnecessary S_ISREG checks in fallocate operations
Date: Mon, 18 Sep 2017 17:52:23 +0200
Message-ID: <1505749947-26360-4-git-send-email-lczerner@redhat.com>
References: <1505749947-26360-1-git-send-email-lczerner@redhat.com>
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1505749947-26360-1-git-send-email-lczerner@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

vfs_fallocate() already has this check so there is not need to check for
this again in ext4.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Cc: linux-ext4@vger.kernel.org
---
 fs/ext4/extents.c | 9 ---------
 fs/ext4/inode.c   | 3 ---
 2 files changed, 12 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 91071b3..ce46d65 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4752,9 +4752,6 @@ static long ext4_zero_range(struct file *file, loff_t offset,
 
 	trace_ext4_zero_range(inode, offset, len, mode);
 
-	if (!S_ISREG(inode->i_mode))
-		return -EINVAL;
-
 	/* Call ext4_force_commit to flush all data in case of data=journal. */
 	if (ext4_should_journal_data(inode)) {
 		ret = ext4_force_commit(inode->i_sb);
@@ -5464,9 +5461,6 @@ int ext4_collapse_range(struct inode *inode, loff_t offset, loff_t len)
 	    len & (EXT4_CLUSTER_SIZE(sb) - 1))
 		return -EINVAL;
 
-	if (!S_ISREG(inode->i_mode))
-		return -EINVAL;
-
 	trace_ext4_collapse_range(inode, offset, len);
 
 	punch_start = offset >> EXT4_BLOCK_SIZE_BITS(sb);
@@ -5603,9 +5597,6 @@ int ext4_insert_range(struct inode *inode, loff_t offset, loff_t len)
 			len & (EXT4_CLUSTER_SIZE(sb) - 1))
 		return -EINVAL;
 
-	if (!S_ISREG(inode->i_mode))
-		return -EOPNOTSUPP;
-
 	trace_ext4_insert_range(inode, offset, len);
 
 	offset_lblk = offset >> EXT4_BLOCK_SIZE_BITS(sb);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 31db875..adda865 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4144,9 +4144,6 @@ int ext4_punch_hole(struct inode *inode, loff_t offset, loff_t length)
 	unsigned int credits;
 	int ret = 0;
 
-	if (!S_ISREG(inode->i_mode))
-		return -EOPNOTSUPP;
-
 	trace_ext4_punch_hole(inode, offset, length, 0);
 
 	/*
-- 
2.7.5
