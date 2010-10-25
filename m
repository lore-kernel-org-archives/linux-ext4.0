From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH] ext4: optimize orphan_list handling for ext4_setattr
Date: Mon, 25 Oct 2010 11:06:42 +0400
Message-ID: <87r5fevji5.fsf@dmon-lap.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org, Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:59454 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804Ab0JYHGw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Oct 2010 03:06:52 -0400
Received: by eye27 with SMTP id 27so3861648eye.19
        for <linux-ext4@vger.kernel.org>; Mon, 25 Oct 2010 00:06:51 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Surprisingly chown() on ext4 is not SMP scalable operation. 
Due to unconditional orphan_del(NULL, inode) in ext4_setattr()
result in significant performance overhead because of global orphan
mutex, especially in no-journal mode (where orphan_add() is noop).
It is possible to skip explicit orphan_del if possible.
Results of fchown() micro-benchmark in no-journal mode
while (1) {
   iteration++;
   fchown(fd, uid, gid);
   fchown(fd, uid + 1, gid + 1)
}
measured: iterations per millisecond
| nr_tasks | w/o patch | with patch |
|        1 |       142 |        185 |
|        4 |       109 |        642 |

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/inode.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 18eed80..a16097b 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5540,6 +5540,7 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 {
 	struct inode *inode = dentry->d_inode;
 	int error, rc = 0;
+	int orphan = 0;
 	const unsigned int ia_valid = attr->ia_valid;
 
 	error = inode_change_ok(inode, attr);
@@ -5595,8 +5596,10 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 			error = PTR_ERR(handle);
 			goto err_out;
 		}
-
-		error = ext4_orphan_add(handle, inode);
+		if (ext4_handle_valid(handle)) {
+			error = ext4_orphan_add(handle, inode);
+			orphan = 1;
+		}
 		EXT4_I(inode)->i_disksize = attr->ia_size;
 		rc = ext4_mark_inode_dirty(handle, inode);
 		if (!error)
@@ -5608,6 +5611,7 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 							    attr->ia_size);
 			if (error) {
 				/* Do as much error cleanup as possible */
+				orphan = 0;
 				handle = ext4_journal_start(inode, 3);
 				if (IS_ERR(handle)) {
 					ext4_orphan_del(NULL, inode);
@@ -5636,7 +5640,7 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 	 * If the call to ext4_truncate failed to get a transaction handle at
 	 * all, we need to clean up the in-core orphan list manually.
 	 */
-	if (inode->i_nlink)
+	if (orphan && inode->i_nlink)
 		ext4_orphan_del(NULL, inode);
 
 	if (!rc && (ia_valid & ATTR_MODE))
-- 
1.6.6.1

