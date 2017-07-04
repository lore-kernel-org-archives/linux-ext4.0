From: Wang Shilong <wangshilong1991@gmail.com>
Subject: [PATCH v2 1/2] ext4, project: expand inode extra size if possible
Date: Tue,  4 Jul 2017 15:42:10 +0800
Message-ID: <20170704074210.77918-1-wshilong@ddn.com>
Cc: tytso@mit.edu, lixi@ddn.com, yi.zhang@huawei.com,
        miaoxie@huawei.com, adilger@dilger.ca, wshilong@ddn.com,
        sihara@ddn.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:32892 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751614AbdGDHmX (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Jul 2017 03:42:23 -0400
Received: by mail-pf0-f194.google.com with SMTP id e199so28566744pfh.0
        for <linux-ext4@vger.kernel.org>; Tue, 04 Jul 2017 00:42:23 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

when upgrading from old format, try to set project id
to old file first time, it will return EOVERFLOW, but if
that file is dirtied(touch etc), changing project id will
be allowed, this might be confusing for users, we could
try to expand @i_extra_iszie here too.

Reported-by: zhangyi(F) <yi.zhang@huawei.com>
Signed-off-by: Wang Shilong <wshilong@ddn.com>
---
v1->v2:
ext4_expand_extra_isize should be invoked after ext4_reserve_inode_write
---
 fs/ext4/ext4.h  |  3 +++
 fs/ext4/inode.c |  8 ++++----
 fs/ext4/ioctl.c | 17 +++++++++++++++--
 3 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 3219154..640f006 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2453,6 +2453,9 @@ int ext4_walk_page_buffers(handle_t *handle,
 			   int *partial,
 			   int (*fn)(handle_t *handle,
 				     struct buffer_head *bh));
+int ext4_expand_extra_isize(struct inode *inode,
+			    unsigned int new_extra_isize,
+			    struct ext4_iloc iloc, handle_t *handle);
 int do_journal_get_write_access(handle_t *handle,
 				struct buffer_head *bh);
 #define FALL_BACK_TO_NONDELALLOC 1
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 5cf82d0..9d07554 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5632,10 +5632,10 @@ ext4_reserve_inode_write(handle_t *handle, struct inode *inode,
  * Expand an inode by new_extra_isize bytes.
  * Returns 0 on success or negative error number on failure.
  */
-static int ext4_expand_extra_isize(struct inode *inode,
-				   unsigned int new_extra_isize,
-				   struct ext4_iloc iloc,
-				   handle_t *handle)
+int ext4_expand_extra_isize(struct inode *inode,
+			    unsigned int new_extra_isize,
+			    struct ext4_iloc iloc,
+			    handle_t *handle)
 {
 	struct ext4_inode *raw_inode;
 	struct ext4_xattr_ibody_header *header;
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 0c21e22..d413008 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -319,6 +319,7 @@ static int ext4_ioctl_setproject(struct file *filp, __u32 projid)
 	struct ext4_iloc iloc;
 	struct ext4_inode *raw_inode;
 	struct dquot *transfer_to[MAXQUOTAS] = { };
+	bool need_expand = false;
 
 	if (!ext4_has_feature_project(sb)) {
 		if (projid != EXT4_DEF_PROJID)
@@ -350,7 +351,10 @@ static int ext4_ioctl_setproject(struct file *filp, __u32 projid)
 		goto out_unlock;
 
 	raw_inode = ext4_raw_inode(&iloc);
-	if (!EXT4_FITS_IN_INODE(raw_inode, ei, i_projid)) {
+	if (!EXT4_FITS_IN_INODE(raw_inode, ei, i_projid) &&
+	    !ext4_test_inode_state(inode, EXT4_STATE_NO_EXPAND)) {
+		need_expand = true;
+	} else if (!EXT4_FITS_IN_INODE(raw_inode, ei, i_projid)) {
 		err = -EOVERFLOW;
 		brelse(iloc.bh);
 		goto out_unlock;
@@ -361,7 +365,8 @@ static int ext4_ioctl_setproject(struct file *filp, __u32 projid)
 
 	handle = ext4_journal_start(inode, EXT4_HT_QUOTA,
 		EXT4_QUOTA_INIT_BLOCKS(sb) +
-		EXT4_QUOTA_DEL_BLOCKS(sb) + 3);
+		EXT4_QUOTA_DEL_BLOCKS(sb) + 3 +
+		need_expand ? EXT4_DATA_TRANS_BLOCKS(sb) : 0);
 	if (IS_ERR(handle)) {
 		err = PTR_ERR(handle);
 		goto out_unlock;
@@ -371,6 +376,14 @@ static int ext4_ioctl_setproject(struct file *filp, __u32 projid)
 	if (err)
 		goto out_stop;
 
+	if (need_expand) {
+		err = ext4_expand_extra_isize(inode,
+				      EXT4_SB(sb)->s_want_extra_isize,
+				      iloc, handle);
+		if (err)
+			goto out_stop;
+	}
+
 	transfer_to[PRJQUOTA] = dqget(sb, make_kqid_projid(kprojid));
 	if (!IS_ERR(transfer_to[PRJQUOTA])) {
 		err = __dquot_transfer(inode, transfer_to);
-- 
2.9.3
