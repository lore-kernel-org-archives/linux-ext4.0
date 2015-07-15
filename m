From: Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [PATCH] jfs: clean up jfs_rename and fix out of order unlock
Date: Wed, 15 Jul 2015 13:52:39 -0500
Message-ID: <55A6ABF7.9010302@oracle.com>
References: <1436964152-11203-1-git-send-email-jack@suse.com>
 <1436964152-11203-6-git-send-email-jack@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com,
	Mark Fasheh <mfasheh@suse.com>,
	Dave Kleikamp <shaggy@kernel.org>,
	jfs-discussion@lists.sourceforge.net,
	reiserfs-devel@vger.kernel.org
To: Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org
Return-path: <reiserfs-devel-owner@vger.kernel.org>
In-Reply-To: <1436964152-11203-6-git-send-email-jack@suse.com>
Sender: reiserfs-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Subject: [PATCH] jfs: clean up jfs_rename and fix out of order unlock

[ Jan, I'll push this right away. You can carry it along until it
gets merged. I want this pushed to stable as well.]

The end of jfs_rename(), which is also used by the error paths,
included a call to IWRITE_UNLOCK(new_ip) after labels out1, out2
and out3. If we come in through these labels, IWRITE_LOCK() has not
been called yet.

In moving that call to the correct spot, I also moved some
exceptional truncate code earlier as well, since the early error
paths don't need to deal with it, and I renamed out4: to out_tx: so
a future patch by Jan Kara doesn't need to deal with renumbering or
confusing out-of-order labels.

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
---
 fs/jfs/namei.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/fs/jfs/namei.c b/fs/jfs/namei.c
index e33be92..a5ac97b 100644
--- a/fs/jfs/namei.c
+++ b/fs/jfs/namei.c
@@ -1160,7 +1160,7 @@ static int jfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		rc = dtModify(tid, new_dir, &new_dname, &ino,
 			      old_ip->i_ino, JFS_RENAME);
 		if (rc)
-			goto out4;
+			goto out_tx;
 		drop_nlink(new_ip);
 		if (S_ISDIR(new_ip->i_mode)) {
 			drop_nlink(new_ip);
@@ -1185,7 +1185,7 @@ static int jfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 			if ((new_size = commitZeroLink(tid, new_ip)) < 0) {
 				txAbort(tid, 1);	/* Marks FS Dirty */
 				rc = new_size;
-				goto out4;
+				goto out_tx;
 			}
 			tblk = tid_to_tblock(tid);
 			tblk->xflag |= COMMIT_DELETE;
@@ -1203,7 +1203,7 @@ static int jfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		if (rc) {
 			jfs_err("jfs_rename didn't expect dtSearch to fail "
 				"w/rc = %d", rc);
-			goto out4;
+			goto out_tx;
 		}
 
 		ino = old_ip->i_ino;
@@ -1211,7 +1211,7 @@ static int jfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		if (rc) {
 			if (rc == -EIO)
 				jfs_err("jfs_rename: dtInsert returned -EIO");
-			goto out4;
+			goto out_tx;
 		}
 		if (S_ISDIR(old_ip->i_mode))
 			inc_nlink(new_dir);
@@ -1226,7 +1226,7 @@ static int jfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		jfs_err("jfs_rename did not expect dtDelete to return rc = %d",
 			rc);
 		txAbort(tid, 1);	/* Marks Filesystem dirty */
-		goto out4;
+		goto out_tx;
 	}
 	if (S_ISDIR(old_ip->i_mode)) {
 		drop_nlink(old_dir);
@@ -1285,7 +1285,7 @@ static int jfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 
 	rc = txCommit(tid, ipcount, iplist, commit_flag);
 
-      out4:
+      out_tx:
 	txEnd(tid);
 	if (new_ip)
 		mutex_unlock(&JFS_IP(new_ip)->commit_mutex);
@@ -1308,13 +1308,6 @@ static int jfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	}
 	if (new_ip && (new_ip->i_nlink == 0))
 		set_cflag(COMMIT_Nolink, new_ip);
-      out3:
-	free_UCSname(&new_dname);
-      out2:
-	free_UCSname(&old_dname);
-      out1:
-	if (new_ip && !S_ISDIR(new_ip->i_mode))
-		IWRITE_UNLOCK(new_ip);
 	/*
 	 * Truncating the directory index table is not guaranteed.  It
 	 * may need to be done iteratively
@@ -1325,7 +1318,13 @@ static int jfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 
 		clear_cflag(COMMIT_Stale, old_dir);
 	}
-
+	if (new_ip && !S_ISDIR(new_ip->i_mode))
+		IWRITE_UNLOCK(new_ip);
+      out3:
+	free_UCSname(&new_dname);
+      out2:
+	free_UCSname(&old_dname);
+      out1:
 	jfs_info("jfs_rename: returning %d", rc);
 	return rc;
 }
-- 
2.4.5

