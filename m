From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: [PATCH RFC v2 6/6] ext4: mangle statfs results accourding to
 project quota usage and limits
Date: Tue, 10 Mar 2015 20:22:12 +0300
Message-ID: <20150310172212.23081.64204.stgit@buzz>
References: <20150310171133.23081.49616.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Dmitry Monakhov <dmonakhov@openvz.org>,
	Andy Lutomirski <luto@amacapital.net>,
	linux-kernel@vger.kernel.org, Li Xi <pkuelelixi@gmail.com>
To: linux-fsdevel@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
	Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150310171133.23081.49616.stgit@buzz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This patch adds helper function dquot_mangle_statfs() which fills statfs
result with information from project quota counters. XFS does the same
thing in function xfs_fill_statvfs_from_dquot().

As a result subtree under project quota acts like separate filesystem,
for example 'df' inside chroot or container will show expected numbers.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
---
 fs/ext4/super.c          |    2 +-
 fs/quota/dquot.c         |   51 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/quotaops.h |    7 ++++++
 3 files changed, 59 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 6a6506bce53c..09ffa4905651 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5154,7 +5154,7 @@ static int ext4_statfs(struct dentry *dentry, struct kstatfs *buf)
 	buf->f_fsid.val[0] = fsid & 0xFFFFFFFFUL;
 	buf->f_fsid.val[1] = (fsid >> 32) & 0xFFFFFFFFUL;
 
-	return 0;
+	return dquot_mangle_statfs(dentry, buf);
 }
 
 /* Helper function for writing quotas on sync - we need to start transaction
diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 0b61357554ed..b05ebbcb4d5e 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -2025,6 +2025,57 @@ int dquot_file_open(struct inode *inode, struct file *file)
 EXPORT_SYMBOL(dquot_file_open);
 
 /*
+ * Update statfs results accourding to project quota limits.
+ */
+int dquot_mangle_statfs(struct dentry *dentry, struct kstatfs *buf)
+{
+	u64 blimit = 0, ilimit = 0, busage, iusage, bfree, ifree;
+	struct inode *inode = dentry->d_inode;
+	struct super_block *sb = dentry->d_sb;
+	struct dquot *dquot;
+
+	if (!sb_has_quota_limits_enabled(sb, PRJQUOTA))
+		return 0;
+
+	__dquot_initialize(inode, PRJQUOTA);
+
+	spin_lock(&dq_data_lock);
+	dquot = i_dquot(inode)[PRJQUOTA];
+	if (dquot) {
+		struct mem_dqblk *dm = &(dquot->dq_dqb);
+
+		blimit = dm->dqb_bsoftlimit ?: dm->dqb_bhardlimit;
+		busage = dm->dqb_curspace + dm->dqb_rsvspace;
+		ilimit = dm->dqb_isoftlimit ?: dm->dqb_ihardlimit;
+		iusage = dm->dqb_curinodes;
+	}
+	spin_unlock(&dq_data_lock);
+
+	if (blimit) {
+		blimit = div_u64(blimit, buf->f_bsize);
+		busage = div_u64(busage, buf->f_bsize);
+		bfree = (blimit <= busage) ? 0 : (blimit - busage);
+		if (buf->f_blocks > blimit)
+			buf->f_blocks = blimit;
+		if (buf->f_bfree > bfree)
+			buf->f_bfree = bfree;
+		if (buf->f_bavail > bfree)
+			buf->f_bavail = bfree;
+	}
+
+	if (ilimit) {
+		ifree = (ilimit <= iusage) ? 0 : (ilimit - iusage);
+		if (buf->f_files > ilimit)
+			buf->f_files = ilimit;
+		if (buf->f_ffree > ifree)
+			buf->f_ffree = ifree;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(dquot_mangle_statfs);
+
+/*
  * Turn quota off on a device. type == -1 ==> quotaoff for all types (umount)
  */
 int dquot_disable(struct super_block *sb, int type, unsigned int flags)
diff --git a/include/linux/quotaops.h b/include/linux/quotaops.h
index 810b88c69c5b..cd4c02e3d17e 100644
--- a/include/linux/quotaops.h
+++ b/include/linux/quotaops.h
@@ -8,6 +8,7 @@
 #define _LINUX_QUOTAOPS_
 
 #include <linux/fs.h>
+#include <linux/statfs.h>
 
 /*
  * Flags for functions __dquot_alloc_space() and __dquot_free_space()
@@ -93,6 +94,7 @@ int dquot_commit_info(struct super_block *sb, int type);
 int dquot_mark_dquot_dirty(struct dquot *dquot);
 
 int dquot_file_open(struct inode *inode, struct file *file);
+int dquot_mangle_statfs(struct dentry *dentry, struct kstatfs *buf);
 
 int dquot_enable(struct inode *inode, int type, int format_id,
 	unsigned int flags);
@@ -283,6 +285,11 @@ static inline int dquot_resume(struct super_block *sb, int type)
 
 #define dquot_file_open		generic_file_open
 
+static inline int dquot_mangle_statfs(struct dentry *d, struct kstatfs *buf)
+{
+	return 0;
+}
+
 static inline int dquot_writeback_dquots(struct super_block *sb, int type)
 {
 	return 0;
