From: shilong wang <wangshilong1991@gmail.com>
Subject: [PATCH 2/2] Ext3: use unlikely to improve the efficiency of the kernel
Date: Sat, 12 Jan 2013 01:36:17 -0800
Message-ID: <CAP9B-Q=GiV8fBk5cqR+yySUGidaFy=XKyNvZW=kQAKpqYsat4w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

Because the function 'sb_getblk' seldomly fails to return
NULL value,it will be better to use unlikely to check it.

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
---
 fs/ext3/inode.c  |    6 +++---
 fs/ext3/resize.c |    6 +++---
 fs/ext3/xattr.c  |    2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 61bc8bd..7338a76 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -1083,7 +1083,7 @@ struct buffer_head *ext3_getblk(handle_t
*handle, struct inode *inode,
 	if (!err && buffer_mapped(&dummy)) {
 		struct buffer_head *bh;
 		bh = sb_getblk(inode->i_sb, dummy.b_blocknr);
-		if (!bh) {
+		if (unlikely(!bh)) {
 			*errp = -EIO;
 			goto err;
 		}
@@ -2734,7 +2734,7 @@ static int __ext3_get_inode_loc(struct inode *inode,
 		return -EIO;

 	bh = sb_getblk(inode->i_sb, block);
-	if (!bh) {
+	if (unlikely(!bh)) {
 		ext3_error (inode->i_sb, "ext3_get_inode_loc",
 				"unable to read inode block - "
 				"inode=%lu, block="E3FSBLK,
@@ -2788,7 +2788,7 @@ static int __ext3_get_inode_loc(struct inode *inode,

 			bitmap_bh = sb_getblk(inode->i_sb,
 					le32_to_cpu(desc->bg_inode_bitmap));
-			if (!bitmap_bh)
+			if (unlikely(!bitmap_bh))
 				goto make_io;

 			/*
diff --git a/fs/ext3/resize.c b/fs/ext3/resize.c
index 0f814f3..704e8ce 100644
--- a/fs/ext3/resize.c
+++ b/fs/ext3/resize.c
@@ -116,7 +116,7 @@ static struct buffer_head *bclean(handle_t
*handle, struct super_block *sb,
 	int err;

 	bh = sb_getblk(sb, blk);
-	if (!bh)
+	if (unlikely(!bh))
 		return ERR_PTR(-EIO);
 	if ((err = ext3_journal_get_write_access(handle, bh))) {
 		brelse(bh);
@@ -234,7 +234,7 @@ static int setup_new_group_blocks(struct super_block *sb,
 			goto exit_bh;

 		gdb = sb_getblk(sb, block);
-		if (!gdb) {
+		if (unlikely(!gdb)) {
 			err = -EIO;
 			goto exit_bh;
 		}
@@ -722,7 +722,7 @@ static void update_backups(struct super_block *sb,
 			break;

 		bh = sb_getblk(sb, group * bpg + blk_off);
-		if (!bh) {
+		if (unlikely(!bh)) {
 			err = -EIO;
 			break;
 		}
diff --git a/fs/ext3/xattr.c b/fs/ext3/xattr.c
index d22ebb7..9f57470 100644
--- a/fs/ext3/xattr.c
+++ b/fs/ext3/xattr.c
@@ -813,7 +813,7 @@ inserted:
 			ea_idebug(inode, "creating block %d", block);

 			new_bh = sb_getblk(sb, block);
-			if (!new_bh) {
+			if (unlikely(!new_bh)) {
 getblk_failed:
 				ext3_free_blocks(handle, inode, block, 1);
 				error = -EIO;
-- 
1.7.7.6
