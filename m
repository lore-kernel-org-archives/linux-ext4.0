Return-Path: <SRS0=geXL=QZ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 255DAC43381
	for <linux-ext4@archiver.kernel.org>; Mon, 18 Feb 2019 01:02:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E5A06218AD
	for <linux-ext4@archiver.kernel.org>; Mon, 18 Feb 2019 01:02:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727885AbfBRBCz (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 17 Feb 2019 20:02:55 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:53588 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727872AbfBRBCy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 17 Feb 2019 20:02:54 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id CCB723DA13DF2EEF1459;
        Mon, 18 Feb 2019 09:02:52 +0800 (CST)
Received: from RH5885H-V3.huawei.com (10.90.53.225) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.408.0; Mon, 18 Feb 2019 09:02:45 +0800
From:   yangerkun <yangerkun@huawei.com>
To:     <jack@suse.com>
CC:     <yi.zhang@huawei.com>, <houtao1@huawei.com>, <miaoxie@huawei.com>,
        <yangerkun@huawei.com>, <linux-ext4@vger.kernel.org>
Subject: [PATCH] ext2: support statx syscall
Date:   Mon, 18 Feb 2019 09:07:02 +0800
Message-ID: <20190218010702.101058-1-yangerkun@huawei.com>
X-Mailer: git-send-email 2.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Since statx, every filesystem should fill the attributes/attributes_mask
in routine getattr. But the generic_fillattr has not fill that, so add
ext2_getattr to do this. This can fix generic/424 while testing ext2.

Reviewed-by: zhangyi (F) <yi.zhang@huawei.com>
Signed-off-by: yangerkun <yangerkun@huawei.com>
---
 fs/ext2/ext2.h    |  1 +
 fs/ext2/file.c    |  1 +
 fs/ext2/inode.c   | 26 ++++++++++++++++++++++++++
 fs/ext2/namei.c   |  2 ++
 fs/ext2/symlink.c |  2 ++
 5 files changed, 32 insertions(+)

diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
index e770cd1..ae0cd9e 100644
--- a/fs/ext2/ext2.h
+++ b/fs/ext2/ext2.h
@@ -774,6 +774,7 @@ extern int ext2_write_inode (struct inode *, struct writeback_control *);
 extern void ext2_evict_inode(struct inode *);
 extern int ext2_get_block(struct inode *, sector_t, struct buffer_head *, int);
 extern int ext2_setattr (struct dentry *, struct iattr *);
+extern int ext2_getattr (const struct path *, struct kstat *, u32, unsigned int);
 extern void ext2_set_inode_flags(struct inode *inode);
 extern int ext2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		       u64 start, u64 len);
diff --git a/fs/ext2/file.c b/fs/ext2/file.c
index 28b2609..39c4772 100644
--- a/fs/ext2/file.c
+++ b/fs/ext2/file.c
@@ -199,6 +199,7 @@ const struct inode_operations ext2_file_inode_operations = {
 #ifdef CONFIG_EXT2_FS_XATTR
 	.listxattr	= ext2_listxattr,
 #endif
+	.getattr	= ext2_getattr,
 	.setattr	= ext2_setattr,
 	.get_acl	= ext2_get_acl,
 	.set_acl	= ext2_set_acl,
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index e4bb938..8e6f3ca 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -1635,6 +1635,32 @@ int ext2_write_inode(struct inode *inode, struct writeback_control *wbc)
 	return __ext2_write_inode(inode, wbc->sync_mode == WB_SYNC_ALL);
 }
 
+int ext2_getattr(const struct path *path, struct kstat *stat,
+		u32 request_mask, unsigned int query_falgs)
+{
+	struct inode *inode = d_inode(path->dentry);
+	struct ext2_inode_info *ei = EXT2_I(inode);
+	unsigned int flags;
+
+	flags = ei->i_flags & EXT2_FL_USER_VISIBLE;
+	if (flags & EXT2_APPEND_FL)
+		stat->attributes |= STATX_ATTR_APPEND;
+	if (flags & EXT2_COMPR_FL)
+		stat->attributes |= STATX_ATTR_COMPRESSED;
+	if (flags & EXT2_IMMUTABLE_FL)
+		stat->attributes |= STATX_ATTR_IMMUTABLE;
+	if (flags & EXT2_NODUMP_FL)
+		stat->attributes |= STATX_ATTR_NODUMP;
+	stat->attributes_mask |= (STATX_ATTR_APPEND |
+			STATX_ATTR_COMPRESSED |
+			STATX_ATTR_ENCRYPTED |
+			STATX_ATTR_IMMUTABLE |
+			STATX_ATTR_NODUMP);
+
+	generic_fillattr(inode, stat);
+	return 0;
+}
+
 int ext2_setattr(struct dentry *dentry, struct iattr *iattr)
 {
 	struct inode *inode = d_inode(dentry);
diff --git a/fs/ext2/namei.c b/fs/ext2/namei.c
index 0c26dcc..ccfbbf5 100644
--- a/fs/ext2/namei.c
+++ b/fs/ext2/namei.c
@@ -416,6 +416,7 @@ const struct inode_operations ext2_dir_inode_operations = {
 #ifdef CONFIG_EXT2_FS_XATTR
 	.listxattr	= ext2_listxattr,
 #endif
+	.getattr	= ext2_getattr,
 	.setattr	= ext2_setattr,
 	.get_acl	= ext2_get_acl,
 	.set_acl	= ext2_set_acl,
@@ -426,6 +427,7 @@ const struct inode_operations ext2_special_inode_operations = {
 #ifdef CONFIG_EXT2_FS_XATTR
 	.listxattr	= ext2_listxattr,
 #endif
+	.getattr	= ext2_getattr,
 	.setattr	= ext2_setattr,
 	.get_acl	= ext2_get_acl,
 	.set_acl	= ext2_set_acl,
diff --git a/fs/ext2/symlink.c b/fs/ext2/symlink.c
index d5589dd..00cdb86 100644
--- a/fs/ext2/symlink.c
+++ b/fs/ext2/symlink.c
@@ -23,6 +23,7 @@
 
 const struct inode_operations ext2_symlink_inode_operations = {
 	.get_link	= page_get_link,
+	.getattr	= ext2_getattr,
 	.setattr	= ext2_setattr,
 #ifdef CONFIG_EXT2_FS_XATTR
 	.listxattr	= ext2_listxattr,
@@ -31,6 +32,7 @@ const struct inode_operations ext2_symlink_inode_operations = {
  
 const struct inode_operations ext2_fast_symlink_inode_operations = {
 	.get_link	= simple_get_link,
+	.getattr	= ext2_getattr,
 	.setattr	= ext2_setattr,
 #ifdef CONFIG_EXT2_FS_XATTR
 	.listxattr	= ext2_listxattr,
-- 
2.9.5

