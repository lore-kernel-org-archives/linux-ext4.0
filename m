From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V4 02/11] vfs: Pass all mask flags down to iop->check_acl
Date: Fri, 24 Sep 2010 18:18:05 +0530
Message-ID: <1285332494-12756-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1285332494-12756-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: aneesh.kumar@linux.vnet.ibm.com, linux-fsdevel@vger.kernel.org,
	nfsv4@linux-nfs.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: sfrench@us.ibm.com, ffilz@us.ibm.com, agruen@suse.de,
	adilger@sun.com, sandeen@redhat.com, tytso@mit.edu,
	bfields@citi.umich.edu, jlayton@redhat.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1285332494-12756-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Andreas Gruenbacher <agruen@suse.de>

Some file permission models differentiate between writing to a file
(MAY_WRITE) and appending to it (MAY_WRITE | MAY_APPEND).  Pass all the
mask flags down to iop->check_acl so that filesystems can distinguish
between writing and appending.

All users of iop->check_acl pass the mask value back into
posix_acl_permission(); strip off the additional mask flags there.

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/namei.c     |    4 +---
 fs/posix_acl.c |    2 ++
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index c5920b5..7cadd07 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -174,8 +174,6 @@ static int acl_permission_check(struct inode *inode, int mask,
 {
 	umode_t			mode = inode->i_mode;
 
-	mask &= MAY_READ | MAY_WRITE | MAY_EXEC;
-
 	if (current_fsuid() == inode->i_uid)
 		mode >>= 6;
 	else {
@@ -192,7 +190,7 @@ static int acl_permission_check(struct inode *inode, int mask,
 	/*
 	 * If the DACs are ok we don't need any capability check.
 	 */
-	if ((mask & ~mode) == 0)
+	if ((mask & (MAY_READ | MAY_WRITE | MAY_EXEC) & ~mode) == 0)
 		return 0;
 	return -EACCES;
 }
diff --git a/fs/posix_acl.c b/fs/posix_acl.c
index 39df95a..c60bddf 100644
--- a/fs/posix_acl.c
+++ b/fs/posix_acl.c
@@ -213,6 +213,8 @@ posix_acl_permission(struct inode *inode, const struct posix_acl *acl, int want)
 	const struct posix_acl_entry *pa, *pe, *mask_obj;
 	int found = 0;
 
+	want &= MAY_READ | MAY_WRITE | MAY_EXEC;
+
 	FOREACH_ACL_ENTRY(pa, acl, pe) {
                 switch(pa->e_tag) {
                         case ACL_USER_OBJ:
-- 
1.7.0.4
