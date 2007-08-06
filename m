From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH 08/25] ext234: have setattr functions call attr_kill_to_mode
Date: Mon, 6 Aug 2007 09:54:28 -0400
Message-ID: <200708061354.l76DsSDg002295@dantu.rdu.redhat.com>
Cc: linux-ext4@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

.. and only save off ia_valid once it returns

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/ext2/inode.c |    1 +
 fs/ext3/inode.c |    5 ++++-
 fs/ext4/inode.c |    5 ++++-
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 0079b2c..33dfc48 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -1311,6 +1311,7 @@ int ext2_setattr(struct dentry *dentry, struct iattr *iattr)
 	struct inode *inode = dentry->d_inode;
 	int error;
 
+	attr_kill_to_mode(inode, iattr);
 	error = inode_change_ok(inode, iattr);
 	if (error)
 		return error;
diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index de4e316..5ca1085 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -2919,7 +2919,10 @@ int ext3_setattr(struct dentry *dentry, struct iattr *attr)
 {
 	struct inode *inode = dentry->d_inode;
 	int error, rc = 0;
-	const unsigned int ia_valid = attr->ia_valid;
+	unsigned int ia_valid;
+
+	attr_kill_to_mode(inode, attr);
+	ia_valid = attr->ia_valid;
 
 	error = inode_change_ok(inode, attr);
 	if (error)
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index a4848e0..9a51e44 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2935,7 +2935,10 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 {
 	struct inode *inode = dentry->d_inode;
 	int error, rc = 0;
-	const unsigned int ia_valid = attr->ia_valid;
+	unsigned int ia_valid;
+
+	attr_kill_to_mode(inode, attr);
+	ia_valid = attr->ia_valid;
 
 	error = inode_change_ok(inode, attr);
 	if (error)
-- 
1.5.2.2

