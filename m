From: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH -V5 02/24] vfs: Pass all mask flags down to iop->check_acl
Date: Wed, 23 Feb 2011 19:21:49 +0530
Message-ID: <1298469131-16555-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1298469131-16555-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andreas Gruenbacher <agruen-l3A5Bk7waGM@public.gmane.org>
To: sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, agruen-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org, dilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org,
	sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org,
	jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1298469131-16555-1-git-send-email-aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

From: Andreas Gruenbacher <agruen-l3A5Bk7waGM@public.gmane.org>

Some file permission models differentiate between writing to a file
(MAY_WRITE) and appending to it (MAY_WRITE | MAY_APPEND).  Pass all the
mask flags down to iop->check_acl so that filesystems can distinguish
between writing and appending.

All users of iop->check_acl pass the mask value back into
posix_acl_permission(); strip off the additional mask flags there.

Signed-off-by: Andreas Gruenbacher <agruen-l3A5Bk7waGM@public.gmane.org>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 fs/namei.c     |    4 +---
 fs/posix_acl.c |    2 ++
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index b01eab8..f09ab1f 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -174,8 +174,6 @@ static int acl_permission_check(struct inode *inode, int mask, unsigned int flag
 {
 	umode_t			mode = inode->i_mode;
 
-	mask &= MAY_READ | MAY_WRITE | MAY_EXEC;
-
 	if (current_fsuid() == inode->i_uid)
 		mode >>= 6;
 	else {
@@ -192,7 +190,7 @@ static int acl_permission_check(struct inode *inode, int mask, unsigned int flag
 	/*
 	 * If the DACs are ok we don't need any capability check.
 	 */
-	if ((mask & ~mode) == 0)
+	if ((mask & (MAY_READ | MAY_WRITE | MAY_EXEC) & ~mode) == 0)
 		return 0;
 	return -EACCES;
 }
diff --git a/fs/posix_acl.c b/fs/posix_acl.c
index b1cf6bf..ad40df2 100644
--- a/fs/posix_acl.c
+++ b/fs/posix_acl.c
@@ -222,6 +222,8 @@ posix_acl_permission(struct inode *inode, const struct posix_acl *acl, int want)
 	const struct posix_acl_entry *pa, *pe, *mask_obj;
 	int found = 0;
 
+	want &= MAY_READ | MAY_WRITE | MAY_EXEC;
+
 	FOREACH_ACL_ENTRY(pa, acl, pe) {
                 switch(pa->e_tag) {
                         case ACL_USER_OBJ:
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
