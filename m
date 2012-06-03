From: Ashish Sangwan <ashishsangwan2@gmail.com>
Subject: [PATCH 1/1] ext4: fix hole punch failure when depth is greater than 0
Date: Sun,  3 Jun 2012 18:14:49 +0530
Message-ID: <1338727489-16867-1-git-send-email-ashish.sangwan2@gmail.com>
Cc: Ted Tso <tytso@mit.edu>,
	Ashish Sangwan <ashish.sangwan2@gmail.com>,
	Namjae Jeon <linkinjeon@gmail.com>
To: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Currently, hole punch will not succeed in case the depth of extent tree is 
greater than 0 and the last block to be removed is part of the extent which belongs
to any but the last extent index.

The current implementation of hole punch uses the same code path as for truncate in which 
the block removal starts from the end of the file and continues backwards removing 
extents and in the process decreases the count of valid entries in the extent header of extent index.
If all the extents under current extent index are removed than this index is also removed 
and the number of valid entries in the "depth -1" extent header is decreased by 1.

Whether to continue removing extents or not is decided by the return value of function
ext4_ext_more_to_rm() which checks 2 conditions a) if the number of entries are decreased 
in the header of "depth -1" or b) if there are no more indexes to process.

In case of hole punch, if the last block to be removed is not part of the last extent index
than this index will not be deleted, hence the number of valid entries in the extent
header of "depth - 1" will remain as it is and ext4_ext_more_to_rm will return 0 and the control
would come out of ext4_ext_remove_space although the required blocks are not yet removed.

This patch fixes the above mentioned problem as instead of starting removing the extents from the 
end of file, it starts removing the blocks from the particular extent from which removing blocks is
actually required and continues backward until done.

Signed-off-by: Ashish Sangwan <ashish.sangwan2@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
---
 fs/ext4/extents.c |   36 +++++++++++++++++++++---------------
 1 files changed, 21 insertions(+), 15 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 91341ec..68e57ad 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2570,10 +2570,10 @@ static int ext4_ext_remove_space(struct inode *inode, ext4_lblk_t start,
 {
 	struct super_block *sb = inode->i_sb;
 	int depth = ext_depth(inode);
-	struct ext4_ext_path *path;
+	struct ext4_ext_path *path = NULL;
 	ext4_fsblk_t partial_cluster = 0;
 	handle_t *handle;
-	int i, err;
+	int i = 0, err;
 
 	ext_debug("truncate since %u to %u\n", start, end);
 
@@ -2637,8 +2637,6 @@ again:
 			if (err < 0)
 				goto out;
 		}
-		ext4_ext_drop_refs(path);
-		kfree(path);
 	}
 cont:
 
@@ -2647,19 +2645,27 @@ cont:
 	 * after i_size and walking into the tree depth-wise.
 	 */
 	depth = ext_depth(inode);
-	path = kzalloc(sizeof(struct ext4_ext_path) * (depth + 1), GFP_NOFS);
-	if (path == NULL) {
-		ext4_journal_stop(handle);
-		return -ENOMEM;
-	}
-	path[0].p_depth = depth;
-	path[0].p_hdr = ext_inode_hdr(inode);
+	if (path) {
+		i = depth;
+		if (depth > 0)
+			path[depth - 1].p_block =
+			le16_to_cpu(path[depth - 1].p_hdr->eh_entries)+1;
+	} else {
+		path =
+		kzalloc(sizeof(struct ext4_ext_path) * (depth + 1), GFP_NOFS);
+		if (path == NULL) {
+			ext4_journal_stop(handle);
+			return -ENOMEM;
+		}
+		path[0].p_depth = depth;
+		path[0].p_hdr = ext_inode_hdr(inode);
 
-	if (ext4_ext_check(inode, path[0].p_hdr, depth)) {
-		err = -EIO;
-		goto out;
+		if (ext4_ext_check(inode, path[0].p_hdr, depth)) {
+			err = -EIO;
+			goto out;
+		}
 	}
-	i = err = 0;
+	err = 0;
 
 	while (i >= 0 && err == 0) {
 		if (i == depth) {
-- 
1.7.7
