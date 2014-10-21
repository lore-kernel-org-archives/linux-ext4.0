From: Jan Kara <jack@suse.cz>
Subject: [PATCH 01/12] quota: Remove const from function declarations
Date: Tue, 21 Oct 2014 16:38:25 +0200
Message-ID: <1413902316-17997-2-git-send-email-jack@suse.cz>
References: <1413902316-17997-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
	xfs@oss.sgi.com, cluster-devel@redhat.com,
	Steven Whitehouse <swhiteho@redhat.com>,
	Mark Fasheh <mfasheh@suse.com>,
	Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com,
	reiserfs-devel@vger.kernel.org, Jeff Mahoney <jeffm@suse.de>,
	Dave Kleikamp <shaggy@kernel.org>,
	jfs-discussion@lists.sourceforge.net, tytso@mit.edu,
	viro@zeniv.linux.org.uk, hch@lst.de, Jan Kara <jack@suse.cz>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1413902316-17997-1-git-send-email-jack@suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

We don't use const through VFS too much so just remove it from quota
function declarations.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/quota/dquot.c         | 4 ++--
 include/linux/quotaops.h | 8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 8b663b2d9562..8a6b95e9bf3d 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -1643,7 +1643,7 @@ EXPORT_SYMBOL(__dquot_alloc_space);
 /*
  * This operation can block, but only after everything is updated
  */
-int dquot_alloc_inode(const struct inode *inode)
+int dquot_alloc_inode(struct inode *inode)
 {
 	int cnt, ret = 0, index;
 	struct dquot_warn warn[MAXQUOTAS];
@@ -1784,7 +1784,7 @@ EXPORT_SYMBOL(__dquot_free_space);
 /*
  * This operation can block, but only after everything is updated
  */
-void dquot_free_inode(const struct inode *inode)
+void dquot_free_inode(struct inode *inode)
 {
 	unsigned int cnt;
 	struct dquot_warn warn[MAXQUOTAS];
diff --git a/include/linux/quotaops.h b/include/linux/quotaops.h
index 1d3eee594cd6..f23538a6e411 100644
--- a/include/linux/quotaops.h
+++ b/include/linux/quotaops.h
@@ -64,10 +64,10 @@ void dquot_destroy(struct dquot *dquot);
 int __dquot_alloc_space(struct inode *inode, qsize_t number, int flags);
 void __dquot_free_space(struct inode *inode, qsize_t number, int flags);
 
-int dquot_alloc_inode(const struct inode *inode);
+int dquot_alloc_inode(struct inode *inode);
 
 int dquot_claim_space_nodirty(struct inode *inode, qsize_t number);
-void dquot_free_inode(const struct inode *inode);
+void dquot_free_inode(struct inode *inode);
 void dquot_reclaim_space_nodirty(struct inode *inode, qsize_t number);
 
 int dquot_disable(struct super_block *sb, int type, unsigned int flags);
@@ -213,12 +213,12 @@ static inline void dquot_drop(struct inode *inode)
 {
 }
 
-static inline int dquot_alloc_inode(const struct inode *inode)
+static inline int dquot_alloc_inode(struct inode *inode)
 {
 	return 0;
 }
 
-static inline void dquot_free_inode(const struct inode *inode)
+static inline void dquot_free_inode(struct inode *inode)
 {
 }
 
-- 
1.8.1.4

