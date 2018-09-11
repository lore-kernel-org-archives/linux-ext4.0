From: Wang Shilong <wangshilong1991@gmail.com>
Subject: [PATCH v3 1/3] ext4: fix setattr project check upon
 fssetxattr ioctl
Date: Wed, 12 Sep 2018 08:57:16 +0900
Message-ID: <1536710238-16858-1-git-send-email-wshilong1991@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: adilger@dilger.ca, Wang Shilong <wangshilong1991@gmail.com>,
 wshilong@ddn.com, dchinner@redhat.com
To: linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
List-Id: linux-ext4.vger.kernel.org

From: Wang Shilong <wangshilong1991@gmail.com>

Currently, project quota could be changed by fssetxattr
ioctl, and existed permission check inode_owner_or_capable()
is obviously not enough, just think that common users could
change project id of file, that could make users to
break project quota easily.

This patch try to follow same regular of xfs project
quota:

"Project Quota ID state is only allowed to change from
within the init namespace. Enforce that restriction only
if we are trying to change the quota ID state.
Everything else is allowed in user namespaces."

Besides that, check and set project id'state should
be an atomic operation, protect whole operation with
inode lock.

Signed-off-by: Wang Shilong <wshilong@ddn.com>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
---
v2->v3: change function declaration to one line.
v1->v2: rename ext4_ioctl_setattr_check_projid()
to ext4_ioctl_check_project()
---
 fs/ext4/ioctl.c | 60 ++++++++++++++++++++++++++++++-------------------
 1 file changed, 37 insertions(+), 23 deletions(-)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index a7074115d6f6..f81102bd3203 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -339,19 +339,14 @@ static int ext4_ioctl_setproject(struct file *filp, __u32 projid)
 	if (projid_eq(kprojid, EXT4_I(inode)->i_projid))
 		return 0;
 
-	err = mnt_want_write_file(filp);
-	if (err)
-		return err;
-
 	err = -EPERM;
-	inode_lock(inode);
 	/* Is it quota file? Do not allow user to mess with it */
 	if (ext4_is_quota_file(inode))
-		goto out_unlock;
+		return err;
 
 	err = ext4_get_inode_loc(inode, &iloc);
 	if (err)
-		goto out_unlock;
+		return err;
 
 	raw_inode = ext4_raw_inode(&iloc);
 	if (!EXT4_FITS_IN_INODE(raw_inode, ei, i_projid)) {
@@ -359,7 +354,7 @@ static int ext4_ioctl_setproject(struct file *filp, __u32 projid)
 					      EXT4_SB(sb)->s_want_extra_isize,
 					      &iloc);
 		if (err)
-			goto out_unlock;
+			return err;
 	} else {
 		brelse(iloc.bh);
 	}
@@ -369,10 +364,8 @@ static int ext4_ioctl_setproject(struct file *filp, __u32 projid)
 	handle = ext4_journal_start(inode, EXT4_HT_QUOTA,
 		EXT4_QUOTA_INIT_BLOCKS(sb) +
 		EXT4_QUOTA_DEL_BLOCKS(sb) + 3);
-	if (IS_ERR(handle)) {
-		err = PTR_ERR(handle);
-		goto out_unlock;
-	}
+	if (IS_ERR(handle))
+		return PTR_ERR(handle);
 
 	err = ext4_reserve_inode_write(handle, inode, &iloc);
 	if (err)
@@ -400,9 +393,6 @@ static int ext4_ioctl_setproject(struct file *filp, __u32 projid)
 		err = rc;
 out_stop:
 	ext4_journal_stop(handle);
-out_unlock:
-	inode_unlock(inode);
-	mnt_drop_write_file(filp);
 	return err;
 }
 #else
@@ -626,6 +616,30 @@ static long ext4_ioctl_group_add(struct file *file,
 	return err;
 }
 
+static int ext4_ioctl_check_project(struct inode *inode, struct fsxattr *fa)
+{
+	/*
+	 * Project Quota ID state is only allowed to change from within the init
+	 * namespace. Enforce that restriction only if we are trying to change
+	 * the quota ID state. Everything else is allowed in user namespaces.
+	 */
+	if (current_user_ns() == &init_user_ns)
+		return 0;
+
+	if (__kprojid_val(EXT4_I(inode)->i_projid) != fa->fsx_projid)
+		return -EINVAL;
+
+	if (ext4_test_inode_flag(inode, EXT4_INODE_PROJINHERIT)) {
+		if (!(fa->fsx_xflags & FS_XFLAG_PROJINHERIT))
+			return -EINVAL;
+	} else {
+		if (fa->fsx_xflags & FS_XFLAG_PROJINHERIT)
+			return -EINVAL;
+	}
+
+	return 0;
+}
+
 long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	struct inode *inode = file_inode(filp);
@@ -1025,19 +1039,19 @@ long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 			return err;
 
 		inode_lock(inode);
+		err = ext4_ioctl_check_project(inode, &fa);
+		if (err)
+			goto out;
 		flags = (ei->i_flags & ~EXT4_FL_XFLAG_VISIBLE) |
 			 (flags & EXT4_FL_XFLAG_VISIBLE);
 		err = ext4_ioctl_setflags(inode, flags);
-		inode_unlock(inode);
-		mnt_drop_write_file(filp);
 		if (err)
-			return err;
-
+			goto out;
 		err = ext4_ioctl_setproject(filp, fa.fsx_projid);
-		if (err)
-			return err;
-
-		return 0;
+out:
+		inode_unlock(inode);
+		mnt_drop_write_file(filp);
+		return err;
 	}
 	case EXT4_IOC_SHUTDOWN:
 		return ext4_shutdown(sb, arg);
-- 
2.17.1
