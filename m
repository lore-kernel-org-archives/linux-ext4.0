From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: sparse fixes
Date: Thu,  4 Oct 2007 01:50:59 -0400
Message-ID: <1191477059-5357-25-git-send-email-tytso@mit.edu>
References: <1191477059-5357-1-git-send-email-tytso@mit.edu>
 <1191477059-5357-2-git-send-email-tytso@mit.edu>
 <1191477059-5357-3-git-send-email-tytso@mit.edu>
 <1191477059-5357-4-git-send-email-tytso@mit.edu>
 <1191477059-5357-5-git-send-email-tytso@mit.edu>
 <1191477059-5357-6-git-send-email-tytso@mit.edu>
 <1191477059-5357-7-git-send-email-tytso@mit.edu>
 <1191477059-5357-8-git-send-email-tytso@mit.edu>
 <1191477059-5357-9-git-send-email-tytso@mit.edu>
 <1191477059-5357-10-git-send-email-tytso@mit.edu>
 <1191477059-5357-11-git-send-email-tytso@mit.edu>
 <1191477059-5357-12-git-send-email-tytso@mit.edu>
 <1191477059-5357-13-git-send-email-tytso@mit.edu>
 <1191477059-5357-14-git-send-email-tytso@mit.edu>
 <1191477059-5357-15-git-send-email-tytso@mit.edu>
 <1191477059-5357-16-git-send-email-tytso@mit.edu>
 <1191477059-5357-17-git-send-email-tytso@mit.edu>
 <1191477059-5357-18-git-send-email-tytso@mit.edu>
 <1191477059-5357-19-git-send-email-tytso@mit.edu>
 <1191477059-5357-20-git-send-email-tytso@mit.edu>
 <1191477059-5357-21-git-send-email-tytso@mit.edu>
 <1191477059-5357-22-git-send-email-tytso@mit.edu>
 <1191477059-5357-23-git-send-email-tytso@mit.edu>
 <1191477059-5357-24-git-send-email-tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:44823 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753312AbXJDFvK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Oct 2007 01:51:10 -0400
In-Reply-To: <1191477059-5357-24-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/fsync.c |    2 +-
 fs/ext4/inode.c |    2 +-
 fs/ext4/xattr.c |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index 2a167d7..8d50879 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -47,7 +47,7 @@ int ext4_sync_file(struct file * file, struct dentry *dentry, int datasync)
 	struct inode *inode = dentry->d_inode;
 	int ret = 0;
 
-	J_ASSERT(ext4_journal_current_handle() == 0);
+	J_ASSERT(ext4_journal_current_handle() == NULL);
 
 	/*
 	 * data=writeback:
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index a2e1ea4..07afd4a 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1027,7 +1027,7 @@ struct buffer_head *ext4_getblk(handle_t *handle, struct inode *inode,
 		}
 		if (buffer_new(&dummy)) {
 			J_ASSERT(create != 0);
-			J_ASSERT(handle != 0);
+			J_ASSERT(handle != NULL);
 
 			/*
 			 * Now that we do not always journal data, we should
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 12c7d65..8638730 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1120,7 +1120,7 @@ int ext4_expand_extra_isize_ea(struct inode *inode, int new_extra_isize,
 	int total_ino, total_blk;
 	void *base, *start, *end;
 	int extra_isize = 0, error = 0, tried_min_extra_isize = 0;
-	int s_min_extra_isize = EXT4_SB(inode->i_sb)->s_es->s_min_extra_isize;
+	int s_min_extra_isize = le16_to_cpu(EXT4_SB(inode->i_sb)->s_es->s_min_extra_isize);
 
 	down_write(&EXT4_I(inode)->xattr_sem);
 retry:
@@ -1292,7 +1292,7 @@ retry:
 
 		i.name = b_entry_name;
 		i.value = buffer;
-		i.value_len = cpu_to_le32(size);
+		i.value_len = size;
 		error = ext4_xattr_block_find(inode, &i, bs);
 		if (error)
 			goto cleanup;
-- 
1.5.3.2.81.g17ed
