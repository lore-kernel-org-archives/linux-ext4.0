From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH 01/25] VFS: move attr_kill logic from
	notify_change into helper function
Date: Mon, 6 Aug 2007 09:54:06 -0400
Message-ID: <200708061354.l76Ds6sq002260@dantu.rdu.redhat.com>
Cc: codalist@TELEMANN.coda.cs.cmu.edu, cluster-devel@redhat.com,
	jfs-discussion@lists.sourceforge.net,
	mikulas@artax.karlin.mff.cuni.cz, zippel@linux-m68k.org,
	xfs@oss.sgi.com, joel.becker@oracle.com, wli@holomorphy.com,
	reiserfs-devel@vger.kernel.org, dhowells@redhat.com,
	fuse-devel@lists.sourceforge.net, jffs-dev@axis.com,
	user-mode-linux-user@lists.sourceforge.net,
	v9fs-developer@lists.sourceforge.net, linux-ext4@vger.kernel.org,
	linux-cifs-client@lists.samba.org, ocfs2-devel@oss.oracle.com,
	bfennema@falcon.csc.calpoly.edu
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <cluster-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/cluster-devel>
List-Post: <mailto:cluster-devel@redhat.com>
List-Help: <mailto:cluster-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=subscribe>
Sender: cluster-devel-bounces@redhat.com
Errors-To: cluster-devel-bounces@redhat.com
List-Id: linux-ext4.vger.kernel.org

Separate the handling of the local ia_valid bitmask from the one in
attr->ia_valid. This allows us to hand off the actual handling of the
ATTR_KILL_* flags to the .setattr i_op when one is defined.

notify_change still needs to process those flags for the local ia_valid
variable, since it uses that to decide whether to return early, and to pass
a (hopefully) appropriate bitmask to fsnotify_change.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/attr.c          |   54 +++++++++++++++++++++++++++++++++------------------
 include/linux/fs.h |    1 +
 2 files changed, 36 insertions(+), 19 deletions(-)

diff --git a/fs/attr.c b/fs/attr.c
index f8dfc22..47015e0 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -100,15 +100,39 @@ int inode_setattr(struct inode * inode, struct iattr * attr)
 }
 EXPORT_SYMBOL(inode_setattr);
 
+void attr_kill_to_mode(struct inode *inode, struct iattr *attr)
+{
+	if (attr->ia_valid & ATTR_KILL_SUID) {
+		attr->ia_valid &= ~ATTR_KILL_SUID;
+		if (inode->i_mode & S_ISUID) {
+			if (!(attr->ia_valid & ATTR_MODE)) {
+				attr->ia_valid |= ATTR_MODE;
+				attr->ia_mode = inode->i_mode;
+			}
+			attr->ia_mode &= ~S_ISUID;
+		}
+	}
+	if (attr->ia_valid & ATTR_KILL_SGID) {
+		attr->ia_valid &= ~ATTR_KILL_SGID;
+		if ((inode->i_mode & (S_ISGID | S_IXGRP)) ==
+		    (S_ISGID | S_IXGRP)) {
+			if (!(attr->ia_valid & ATTR_MODE)) {
+				attr->ia_valid |= ATTR_MODE;
+				attr->ia_mode = inode->i_mode;
+			}
+			attr->ia_mode &= ~S_ISGID;
+		}
+	}
+}
+EXPORT_SYMBOL(attr_kill_to_mode);
+
 int notify_change(struct dentry * dentry, struct iattr * attr)
 {
 	struct inode *inode = dentry->d_inode;
-	mode_t mode;
 	int error;
 	struct timespec now;
 	unsigned int ia_valid = attr->ia_valid;
 
-	mode = inode->i_mode;
 	now = current_fs_time(inode->i_sb);
 
 	attr->ia_ctime = now;
@@ -117,26 +141,17 @@ int notify_change(struct dentry * dentry, struct iattr * attr)
 	if (!(ia_valid & ATTR_MTIME_SET))
 		attr->ia_mtime = now;
 	if (ia_valid & ATTR_KILL_SUID) {
-		attr->ia_valid &= ~ATTR_KILL_SUID;
-		if (mode & S_ISUID) {
-			if (!(ia_valid & ATTR_MODE)) {
-				ia_valid = attr->ia_valid |= ATTR_MODE;
-				attr->ia_mode = inode->i_mode;
-			}
-			attr->ia_mode &= ~S_ISUID;
-		}
+		ia_valid &= ~ATTR_KILL_SUID;
+		if (inode->i_mode & S_ISUID)
+			ia_valid |= ATTR_MODE;
 	}
 	if (ia_valid & ATTR_KILL_SGID) {
-		attr->ia_valid &= ~ ATTR_KILL_SGID;
-		if ((mode & (S_ISGID | S_IXGRP)) == (S_ISGID | S_IXGRP)) {
-			if (!(ia_valid & ATTR_MODE)) {
-				ia_valid = attr->ia_valid |= ATTR_MODE;
-				attr->ia_mode = inode->i_mode;
-			}
-			attr->ia_mode &= ~S_ISGID;
-		}
+		ia_valid &= ~ATTR_KILL_SGID;
+		if ((inode->i_mode & (S_ISGID | S_IXGRP)) ==
+		    (S_ISGID | S_IXGRP))
+			ia_valid |= ATTR_MODE;
 	}
-	if (!attr->ia_valid)
+	if (!ia_valid)
 		return 0;
 
 	if (ia_valid & ATTR_SIZE)
@@ -147,6 +162,7 @@ int notify_change(struct dentry * dentry, struct iattr * attr)
 		if (!error)
 			error = inode->i_op->setattr(dentry, attr);
 	} else {
+		attr_kill_to_mode(inode, attr);
 		error = inode_change_ok(inode, attr);
 		if (!error)
 			error = security_inode_setattr(dentry, attr);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index d33bead..f617b23 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1561,6 +1561,7 @@ extern int do_remount_sb(struct super_block *sb, int flags,
 #ifdef CONFIG_BLOCK
 extern sector_t bmap(struct inode *, sector_t);
 #endif
+extern void attr_kill_to_mode(struct inode *inode, struct iattr *attr);
 extern int notify_change(struct dentry *, struct iattr *);
 extern int permission(struct inode *, int, struct nameidata *);
 extern int generic_permission(struct inode *, int,
-- 
1.5.2.2
