From: amir73il@users.sourceforge.net
Subject: [PATCH RFC 28/30] ext4: snapshot cleanup
Date: Mon,  9 May 2011 19:41:46 +0300
Message-ID: <1304959308-11122-29-git-send-email-amir73il@users.sourceforge.net>
References: <1304959308-11122-1-git-send-email-amir73il@users.sourceforge.net>
Cc: tytso@mit.edu, Amir Goldstein <amir73il@users.sf.net>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35313 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684Ab1EIQod (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 May 2011 12:44:33 -0400
Received: by mail-ww0-f44.google.com with SMTP id 36so5955868wwa.1
        for <linux-ext4@vger.kernel.org>; Mon, 09 May 2011 09:44:32 -0700 (PDT)
In-Reply-To: <1304959308-11122-1-git-send-email-amir73il@users.sourceforge.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Amir Goldstein <amir73il@users.sf.net>

Cleanup snapshots list and reclaim unused blocks of deleted snapshots.
Oldest snapshot can be removed from list and its blocks can be freed.
Non-oldest snapshots have to be shrunk and merged before they can be
removed from the list.  All snapshot blocks must be excluded in order
to properly shrink/merge deleted old snapshots.

Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/ext4.h  |   16 ++++++++++++++++
 fs/ext4/inode.c |   19 +++++++++++--------
 2 files changed, 27 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 37c608b..7650515 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1748,6 +1748,12 @@ struct ext4_features {
 	struct completion f_kobj_unregister;
 };
 
+typedef struct {
+	__le32	*p;
+	__le32	key;
+	struct buffer_head *bh;
+} Indirect;
+
 /*
  * Function prototypes
  */
@@ -1889,6 +1895,16 @@ extern void ext4_da_update_reserve_space(struct inode *inode,
 /* snapshot_inode.c */
 extern int ext4_snapshot_readpage(struct file *file, struct page *page);
 
+extern int ext4_block_to_path(struct inode *inode,
+			      ext4_lblk_t i_block,
+			      ext4_lblk_t offsets[4], int *boundary);
+extern Indirect *ext4_get_branch(struct inode *inode, int depth,
+				 ext4_lblk_t  *offsets,
+				 Indirect chain[4], int *err);
+extern void ext4_free_branches(handle_t *handle, struct inode *inode,
+				struct buffer_head *parent_bh,
+				__le32 *first, __le32 *last,
+				int depth);
 /* ioctl.c */
 extern long ext4_ioctl(struct file *, unsigned int, unsigned long);
 extern long ext4_compat_ioctl(struct file *, unsigned int, unsigned long);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 794b29f..d46da6a 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -176,6 +176,14 @@ int ext4_truncate_restart_trans(handle_t *handle, struct inode *inode,
 	 */
 	BUG_ON(EXT4_JOURNAL(inode) == NULL);
 	jbd_debug(2, "restarting handle %p\n", handle);
+	/*
+	 * Snapshot shrink/merge/clean do not take i_data_sem, so we cannot
+	 * release it here. Luckily, snapshot files are not writable,
+	 * so deadlock with ext4_map_blocks on writepage is impossible.
+	 * Snapshot files also don't have preallocations.
+	 */
+	if (ext4_snapshot_file(inode))
+		return ext4_journal_restart(handle, nblocks);
 	up_write(&EXT4_I(inode)->i_data_sem);
 	ret = ext4_journal_restart(handle, nblocks);
 	down_write(&EXT4_I(inode)->i_data_sem);
@@ -281,11 +289,6 @@ no_delete:
 	ext4_clear_inode(inode);	/* We must guarantee clearing of inode... */
 }
 
-typedef struct {
-	__le32	*p;
-	__le32	key;
-	struct buffer_head *bh;
-} Indirect;
 
 static inline void add_chain(Indirect *p, struct buffer_head *bh, __le32 *v)
 {
@@ -324,7 +327,7 @@ static inline void add_chain(Indirect *p, struct buffer_head *bh, __le32 *v)
  * get there at all.
  */
 
-static int ext4_block_to_path(struct inode *inode,
+int ext4_block_to_path(struct inode *inode,
 			      ext4_lblk_t i_block,
 			      ext4_lblk_t offsets[4], int *boundary)
 {
@@ -440,7 +443,7 @@ static int __ext4_check_blockref(const char *function, unsigned int line,
  *      Need to be called with
  *      down_read(&EXT4_I(inode)->i_data_sem)
  */
-static Indirect *ext4_get_branch(struct inode *inode, int depth,
+Indirect *ext4_get_branch(struct inode *inode, int depth,
 				 ext4_lblk_t  *offsets,
 				 Indirect chain[4], int *err)
 {
@@ -4702,7 +4705,7 @@ static void ext4_free_data(handle_t *handle, struct inode *inode,
  *	stored as little-endian 32-bit) and updating @inode->i_blocks
  *	appropriately.
  */
-static void ext4_free_branches(handle_t *handle, struct inode *inode,
+void ext4_free_branches(handle_t *handle, struct inode *inode,
 			       struct buffer_head *parent_bh,
 			       __le32 *first, __le32 *last, int depth)
 {
-- 
1.7.0.4

