From: Tahsin Erdogan <tahsin@google.com>
Subject: [PATCH 10/28] ext4: change ext4_xattr_inode_iget() signature
Date: Wed, 31 May 2017 01:14:59 -0700
Message-ID: <20170531081517.11438-10-tahsin@google.com>
References: <20170531081517.11438-1-tahsin@google.com>
Cc: linux-kernel@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        reiserfs-devel@vger.kernel.org, Tahsin Erdogan <tahsin@google.com>
To: Jan Kara <jack@suse.com>, Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Dave Kleikamp <shaggy@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Mark Fasheh <mfasheh@versity.com>,
        Joel Becker <jlbec@evilplan.org>, Jens Axboe <axboe@fb.com>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        Mike Christie <mchristi@redhat.com>,
        Fabian Frederick <fabf@skynet.be>, linux-ext4@vger.kernel.org
Return-path: <reiserfs-devel-owner@vger.kernel.org>
In-Reply-To: <20170531081517.11438-1-tahsin@google.com>
Sender: reiserfs-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

In general, kernel functions indicate success/failure through their return
values. This function returns the status as an output parameter and reserves
the return value for the inode. Make it follow the general convention.

Signed-off-by: Tahsin Erdogan <tahsin@google.com>
---
 fs/ext4/xattr.c | 73 +++++++++++++++++++++++++++++++--------------------------
 fs/ext4/xattr.h |  2 --
 2 files changed, 40 insertions(+), 35 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 13daf634244b..d9477d01be9b 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -312,40 +312,47 @@ ext4_xattr_inode_read(struct inode *ea_inode, void *buf, size_t *size)
 	return 0;
 }
 
-struct inode *ext4_xattr_inode_iget(struct inode *parent, unsigned long ea_ino, int *err)
+static int ext4_xattr_inode_iget(struct inode *parent, unsigned long ea_ino,
+				 struct inode **ea_inode)
 {
-	struct inode *ea_inode = NULL;
+	struct inode *inode;
+	int err;
+
+	inode = ext4_iget(parent->i_sb, ea_ino);
+	if (IS_ERR(inode)) {
+		err = PTR_ERR(inode);
+		ext4_error(parent->i_sb, "error while reading EA inode %lu "
+			   "err=%d", ea_ino, err);
+		return err;
+	}
 
-	ea_inode = ext4_iget(parent->i_sb, ea_ino);
-	if (IS_ERR(ea_inode) || is_bad_inode(ea_inode)) {
-		int rc = IS_ERR(ea_inode) ? PTR_ERR(ea_inode) : 0;
+	if (is_bad_inode(inode)) {
 		ext4_error(parent->i_sb, "error while reading EA inode %lu "
-			   "/ %d %d", ea_ino, rc, is_bad_inode(ea_inode));
-		*err = rc != 0 ? rc : -EIO;
-		return NULL;
+			   "is_bad_inode", ea_ino);
+		err = -EIO;
+		goto error;
 	}
 
-	if (EXT4_XATTR_INODE_GET_PARENT(ea_inode) != parent->i_ino ||
-	    ea_inode->i_generation != parent->i_generation) {
+	if (EXT4_XATTR_INODE_GET_PARENT(inode) != parent->i_ino ||
+	    inode->i_generation != parent->i_generation) {
 		ext4_error(parent->i_sb, "Backpointer from EA inode %lu "
-			   "to parent invalid.", ea_ino);
-		*err = -EINVAL;
+			   "to parent is invalid.", ea_ino);
+		err = -EINVAL;
 		goto error;
 	}
 
-	if (!(EXT4_I(ea_inode)->i_flags & EXT4_EA_INODE_FL)) {
+	if (!(EXT4_I(inode)->i_flags & EXT4_EA_INODE_FL)) {
 		ext4_error(parent->i_sb, "EA inode %lu does not have "
 			   "EXT4_EA_INODE_FL flag set.\n", ea_ino);
-		*err = -EINVAL;
+		err = -EINVAL;
 		goto error;
 	}
 
-	*err = 0;
-	return ea_inode;
-
+	*ea_inode = inode;
+	return 0;
 error:
-	iput(ea_inode);
-	return NULL;
+	iput(inode);
+	return err;
 }
 
 /*
@@ -355,17 +362,17 @@ static int
 ext4_xattr_inode_get(struct inode *inode, unsigned long ea_ino, void *buffer,
 		     size_t *size)
 {
-	struct inode *ea_inode = NULL;
-	int err;
+	struct inode *ea_inode;
+	int ret;
 
-	ea_inode = ext4_xattr_inode_iget(inode, ea_ino, &err);
-	if (err)
-		return err;
+	ret = ext4_xattr_inode_iget(inode, ea_ino, &ea_inode);
+	if (ret)
+		return ret;
 
-	err = ext4_xattr_inode_read(ea_inode, buffer, size);
+	ret = ext4_xattr_inode_read(ea_inode, buffer, size);
 	iput(ea_inode);
 
-	return err;
+	return ret;
 }
 
 static int
@@ -868,7 +875,7 @@ int ext4_xattr_inode_unlink(struct inode *inode, unsigned long ea_ino)
 	struct inode *ea_inode = NULL;
 	int err;
 
-	ea_inode = ext4_xattr_inode_iget(inode, ea_ino, &err);
+	err = ext4_xattr_inode_iget(inode, ea_ino, &ea_inode);
 	if (err)
 		return err;
 
@@ -1948,7 +1955,7 @@ static int
 ext4_xattr_inode_orphan_add(handle_t *handle, struct inode *inode,
 			int credits, struct ext4_xattr_ino_array *lea_ino_array)
 {
-	struct inode *ea_inode = NULL;
+	struct inode *ea_inode;
 	int idx = 0, error = 0;
 
 	if (lea_ino_array == NULL)
@@ -1967,8 +1974,8 @@ ext4_xattr_inode_orphan_add(handle_t *handle, struct inode *inode,
 				return error;
 			}
 		}
-		ea_inode = ext4_xattr_inode_iget(inode,
-				lea_ino_array->xia_inodes[idx], &error);
+		error = ext4_xattr_inode_iget(inode,
+				lea_ino_array->xia_inodes[idx], &ea_inode);
 		if (error)
 			continue;
 		inode_lock(ea_inode);
@@ -2085,7 +2092,7 @@ void
 ext4_xattr_inode_array_free(struct inode *inode,
 			    struct ext4_xattr_ino_array *lea_ino_array)
 {
-	struct inode	*ea_inode = NULL;
+	struct inode	*ea_inode;
 	int		idx = 0;
 	int		err;
 
@@ -2093,8 +2100,8 @@ ext4_xattr_inode_array_free(struct inode *inode,
 		return;
 
 	for (; idx < lea_ino_array->xia_count; ++idx) {
-		ea_inode = ext4_xattr_inode_iget(inode,
-				lea_ino_array->xia_inodes[idx], &err);
+		err = ext4_xattr_inode_iget(inode,
+				lea_ino_array->xia_inodes[idx], &ea_inode);
 		if (err)
 			continue;
 		/* for inode's i_count get from ext4_xattr_delete_inode */
diff --git a/fs/ext4/xattr.h b/fs/ext4/xattr.h
index e8bef79bdc38..b6ef99d1a061 100644
--- a/fs/ext4/xattr.h
+++ b/fs/ext4/xattr.h
@@ -161,8 +161,6 @@ extern int ext4_xattr_get(struct inode *, int, const char *, void *, size_t);
 extern int ext4_xattr_set(struct inode *, int, const char *, const void *, size_t, int);
 extern int ext4_xattr_set_handle(handle_t *, struct inode *, int, const char *, const void *, size_t, int);
 
-extern struct inode *ext4_xattr_inode_iget(struct inode *parent, unsigned long ea_ino,
-					   int *err);
 extern int ext4_xattr_inode_unlink(struct inode *inode, unsigned long ea_ino);
 extern int ext4_xattr_delete_inode(handle_t *handle, struct inode *inode,
 				   struct ext4_xattr_ino_array **array);
-- 
2.13.0.219.gdb65acc882-goog

