From: shilong wang <wangshilong1991@gmail.com>
Subject: [PATCH 1/2] Ext2: use unlikely to improve the efficiency of the kernel
Date: Sat, 12 Jan 2013 01:34:50 -0800
Message-ID: <CAP9B-Qkxe-hmCJN9dR1qbjqE35XyWn=KTa47j57Zn3ww2QBjeg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

Because the function 'sb_getblk' seldomly fails to return
NULL value. It will be better to use unlikely to optimize it.

Signed-off-by: Wang shilong <wangsl-fnst@cn.fujitsu.com>
---
 fs/ext2/super.c |    2 +-
 fs/ext2/xattr.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index af74d9e..c0f4fc6 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -1495,7 +1495,7 @@ static ssize_t ext2_quota_write(struct
super_block *sb, int type,
 			bh = sb_bread(sb, tmp_bh.b_blocknr);
 		else
 			bh = sb_getblk(sb, tmp_bh.b_blocknr);
-		if (!bh) {
+		if (unlikely(!bh)) {
 			err = -EIO;
 			goto out;
 		}
diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
index b6754db..06209ec 100644
--- a/fs/ext2/xattr.c
+++ b/fs/ext2/xattr.c
@@ -662,7 +662,7 @@ ext2_xattr_set2(struct inode *inode, struct
buffer_head *old_bh,
 			ea_idebug(inode, "creating block %d", block);

 			new_bh = sb_getblk(sb, block);
-			if (!new_bh) {
+			if (unlikely(!new_bh)) {
 				ext2_free_blocks(inode, block, 1);
 				mark_inode_dirty(inode);
 				error = -EIO;
-- 
1.7.7.6
