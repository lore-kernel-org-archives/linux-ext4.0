From: Wang Shilong <wangshilong1991@gmail.com>
Subject: [PATCH 2/2] f2fs: fix setattr project check upon
 fssetxattr ioctl
Date: Tue,  4 Sep 2018 23:54:06 +0900
Message-ID: <1536072846-19361-2-git-send-email-wshilong@ddn.com>
References: <1536072846-19361-1-git-send-email-wshilong@ddn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: adilger@dilger.ca, wshilong@ddn.com, dchinner@redhat.com
To: linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
In-Reply-To: <1536072846-19361-1-git-send-email-wshilong@ddn.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
List-Id: linux-ext4.vger.kernel.org

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
---
 fs/f2fs/file.c | 41 ++++++++++++++++++++++++++++++++++-------
 1 file changed, 34 insertions(+), 7 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 5474aaa..cb63fe6 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -2736,6 +2736,32 @@ static int f2fs_ioc_fsgetxattr(struct file *filp, unsigned long arg)
 	return 0;
 }
 
+static int
+f2fs_ioctl_setattr_check_projid(struct inode *inode,
+				struct fsxattr *fa)
+{
+	/*
+	 * Project Quota ID state is only allowed to change from within the init
+	 * namespace. Enforce that restriction only if we are trying to change
+	 * the quota ID state. Everything else is allowed in user namespaces.
+	 */
+	if (current_user_ns() == &init_user_ns)
+		return 0;
+
+	if (__kprojid_val(F2FS_I(inode)->i_projid) != fa->fsx_projid)
+		return -EINVAL;
+
+	if (F2FS_I(inode)->i_flags & F2FS_PROJINHERIT_FL) {
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
 static int f2fs_ioc_fssetxattr(struct file *filp, unsigned long arg)
 {
 	struct inode *inode = file_inode(filp);
@@ -2763,19 +2789,20 @@ static int f2fs_ioc_fssetxattr(struct file *filp, unsigned long arg)
 		return err;
 
 	inode_lock(inode);
+	err = f2fs_ioctl_setattr_check_projid(inode, &fa);
+	if (err)
+		goto out;
 	flags = (fi->i_flags & ~F2FS_FL_XFLAG_VISIBLE) |
 				(flags & F2FS_FL_XFLAG_VISIBLE);
 	err = __f2fs_ioc_setflags(inode, flags);
-	inode_unlock(inode);
-	mnt_drop_write_file(filp);
 	if (err)
-		return err;
+		goto out;
 
 	err = f2fs_ioc_setproject(filp, fa.fsx_projid);
-	if (err)
-		return err;
-
-	return 0;
+out:
+	inode_unlock(inode);
+	mnt_drop_write_file(filp);
+	return err;
 }
 
 int f2fs_pin_file_control(struct inode *inode, bool inc)
-- 
1.8.3.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
