From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH] quota: manage reserved space when quota is not active [v2]
Date: Thu, 17 Dec 2009 18:25:55 +0300
Message-ID: <1261063555-17868-1-git-send-email-dmonakhov@openvz.org>
References: <20091217142807.GA3544@quack.suse.cz>
Content-Transfer-Encoding: 7BIT
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-reply-to: <20091217142807.GA3544@quack.suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Since we implemented generic reserved space management interface,
then it is possible to account reserved space even when quota
is not active (similar to i_blocks/i_bytes).

Without this patch following testcase result in massive comlain from
WARN_ON in dquot_claim_space()

TEST_CASE:
mount /dev/sdb /mnt -oquota
dd if=/dev/zero of=/mnt/test bs=1M count=1
quotaon /mnt
# fs_reserved_spave == 1Mb
# quota_reserved_space == 0, because quota was disabled
dd if=/dev/zero of=/mnt/test seek=1 bs=1M count=1
# fs_reserved_spave == 2Mb
# quota_reserved_space == 1Mb
sync  # ->dquot_claim_space() -> WARN_ON

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/quota/dquot.c         |   10 ++++++----
 include/linux/quotaops.h |   11 +++++++++--
 2 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index dea86ab..a532d44 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -1351,28 +1351,30 @@ static qsize_t *inode_reserved_space(struct inode * inode)
 	return inode->i_sb->dq_op->get_reserved_space(inode);
 }
 
-static void inode_add_rsv_space(struct inode *inode, qsize_t number)
+void inode_add_rsv_space(struct inode *inode, qsize_t number)
 {
 	spin_lock(&inode->i_lock);
 	*inode_reserved_space(inode) += number;
 	spin_unlock(&inode->i_lock);
 }
+EXPORT_SYMBOL(inode_add_rsv_space);
 
-
-static void inode_claim_rsv_space(struct inode *inode, qsize_t number)
+void inode_claim_rsv_space(struct inode *inode, qsize_t number)
 {
 	spin_lock(&inode->i_lock);
 	*inode_reserved_space(inode) -= number;
 	__inode_add_bytes(inode, number);
 	spin_unlock(&inode->i_lock);
 }
+EXPORT_SYMBOL(inode_claim_rsv_space);
 
-static void inode_sub_rsv_space(struct inode *inode, qsize_t number)
+void inode_sub_rsv_space(struct inode *inode, qsize_t number)
 {
 	spin_lock(&inode->i_lock);
 	*inode_reserved_space(inode) -= number;
 	spin_unlock(&inode->i_lock);
 }
+EXPORT_SYMBOL(inode_sub_rsv_space);
 
 static qsize_t inode_get_rsv_space(struct inode *inode)
 {
diff --git a/include/linux/quotaops.h b/include/linux/quotaops.h
index 3ebb231..a529d86 100644
--- a/include/linux/quotaops.h
+++ b/include/linux/quotaops.h
@@ -26,6 +26,10 @@ static inline void writeout_quota_sb(struct super_block *sb, int type)
 		sb->s_qcop->quota_sync(sb, type);
 }
 
+void inode_add_rsv_space(struct inode *inode, qsize_t number);
+void inode_claim_rsv_space(struct inode *inode, qsize_t number);
+void inode_sub_rsv_space(struct inode *inode, qsize_t number);
+
 int dquot_initialize(struct inode *inode, int type);
 int dquot_drop(struct inode *inode);
 struct dquot *dqget(struct super_block *sb, unsigned int id, int type);
@@ -42,7 +46,6 @@ int dquot_alloc_inode(const struct inode *inode, qsize_t number);
 int dquot_reserve_space(struct inode *inode, qsize_t number, int prealloc);
 int dquot_claim_space(struct inode *inode, qsize_t number);
 void dquot_release_reserved_space(struct inode *inode, qsize_t number);
-qsize_t dquot_get_reserved_space(struct inode *inode);
 
 int dquot_free_space(struct inode *inode, qsize_t number);
 int dquot_free_inode(const struct inode *inode, qsize_t number);
@@ -199,6 +202,8 @@ static inline int vfs_dq_reserve_space(struct inode *inode, qsize_t nr)
 		if (inode->i_sb->dq_op->reserve_space(inode, nr, 0) == NO_QUOTA)
 			return 1;
 	}
+	else
+		inode_add_rsv_space(inode, nr);
 	return 0;
 }
 
@@ -221,7 +226,7 @@ static inline int vfs_dq_claim_space(struct inode *inode, qsize_t nr)
 		if (inode->i_sb->dq_op->claim_space(inode, nr) == NO_QUOTA)
 			return 1;
 	} else
-		inode_add_bytes(inode, nr);
+		inode_claim_rsv_space(inode, nr);
 
 	mark_inode_dirty(inode);
 	return 0;
@@ -235,6 +240,8 @@ void vfs_dq_release_reservation_space(struct inode *inode, qsize_t nr)
 {
 	if (sb_any_quota_active(inode->i_sb))
 		inode->i_sb->dq_op->release_rsv(inode, nr);
+	else
+		inode_sub_rsv_space(inode, nr);
 }
 
 static inline void vfs_dq_free_space_nodirty(struct inode *inode, qsize_t nr)
-- 
1.6.0.4

