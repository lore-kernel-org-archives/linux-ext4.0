From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH v2.6.34.y 15/28] quota: add the option to not fail with EDQUOT in block
Date: Tue,  1 Jun 2010 12:13:02 -0400
Message-ID: <1275408795-17487-15-git-send-email-tytso@mit.edu>
References: <1275408795-17487-1-git-send-email-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Eric Sandeen <sandeen@redhat.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: stable@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:56950 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757168Ab0FAQNY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Jun 2010 12:13:24 -0400
In-Reply-To: <1275408795-17487-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Eric Sandeen <sandeen@redhat.com>

commit 0e05842bc117ea70ceb979cca798fd026879951b upstream (as of 2.6.34-git13)

To simplify metadata tracking for delalloc writes, ext4
will simply claim metadata blocks at allocation time, without
first speculatively reserving the worst case and then freeing
what was not used.

To do this, we need a mechanism to track allocations in
the quota subsystem, but potentially allow that allocation
to actually go over quota.

This patch adds a DQUOT_SPACE_NOFAIL flag and function
variants for this purpose.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/quota/dquot.c         |    3 ++-
 include/linux/quotaops.h |   12 ++++++++++++
 2 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 8c40c07..df6832e 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -1494,6 +1494,7 @@ int __dquot_alloc_space(struct inode *inode, qsize_t number, int flags)
 	char warntype[MAXQUOTAS];
 	int warn = flags & DQUOT_SPACE_WARN;
 	int reserve = flags & DQUOT_SPACE_RESERVE;
+	int nofail = flags & DQUOT_SPACE_NOFAIL;
 
 	/*
 	 * First test before acquiring mutex - solves deadlocks when we
@@ -1514,7 +1515,7 @@ int __dquot_alloc_space(struct inode *inode, qsize_t number, int flags)
 			continue;
 		ret = check_bdq(inode->i_dquot[cnt], number, !warn,
 				warntype+cnt);
-		if (ret) {
+		if (ret && !nofail) {
 			spin_unlock(&dq_data_lock);
 			goto out_flush_warn;
 		}
diff --git a/include/linux/quotaops.h b/include/linux/quotaops.h
index 9edd53c..f8dbeb0 100644
--- a/include/linux/quotaops.h
+++ b/include/linux/quotaops.h
@@ -11,6 +11,7 @@
 
 #define DQUOT_SPACE_WARN	0x1
 #define DQUOT_SPACE_RESERVE	0x2
+#define DQUOT_SPACE_NOFAIL	0x4
 
 static inline struct quota_info *sb_dqopt(struct super_block *sb)
 {
@@ -262,6 +263,12 @@ static inline int dquot_alloc_space_nodirty(struct inode *inode, qsize_t nr)
 	return __dquot_alloc_space(inode, nr, DQUOT_SPACE_WARN);
 }
 
+static inline void dquot_alloc_space_nofail(struct inode *inode, qsize_t nr)
+{
+	__dquot_alloc_space(inode, nr, DQUOT_SPACE_WARN|DQUOT_SPACE_NOFAIL);
+	mark_inode_dirty(inode);
+}
+
 static inline int dquot_alloc_space(struct inode *inode, qsize_t nr)
 {
 	int ret;
@@ -277,6 +284,11 @@ static inline int dquot_alloc_block_nodirty(struct inode *inode, qsize_t nr)
 	return dquot_alloc_space_nodirty(inode, nr << inode->i_blkbits);
 }
 
+static inline void dquot_alloc_block_nofail(struct inode *inode, qsize_t nr)
+{
+	dquot_alloc_space_nofail(inode, nr << inode->i_blkbits);
+}
+
 static inline int dquot_alloc_block(struct inode *inode, qsize_t nr)
 {
 	return dquot_alloc_space(inode, nr << inode->i_blkbits);
-- 
1.6.6.1.1.g974db.dirty

