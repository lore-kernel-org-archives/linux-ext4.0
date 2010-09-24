From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V4 03/11] vfs: Add a comment to inode_permission()
Date: Fri, 24 Sep 2010 18:18:06 +0530
Message-ID: <1285332494-12756-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
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

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/namei.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 7cadd07..bf822b8 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -167,7 +167,7 @@ EXPORT_SYMBOL(putname);
 #endif
 
 /*
- * This does basic POSIX ACL permission checking
+ * This does the basic permission checking
  */
 static int acl_permission_check(struct inode *inode, int mask,
 		int (*check_acl)(struct inode *inode, int mask))
@@ -212,7 +212,7 @@ int generic_permission(struct inode *inode, int mask,
 	int ret;
 
 	/*
-	 * Do the basic POSIX ACL permission checks.
+	 * Do the basic permission checks.
 	 */
 	ret = acl_permission_check(inode, mask, check_acl);
 	if (ret != -EACCES)
@@ -246,6 +246,8 @@ int generic_permission(struct inode *inode, int mask,
  * We use "fsuid" for this, letting us set arbitrary permissions
  * for filesystem access without changing the "normal" uids which
  * are used for other things.
+ *
+ * When checking for MAY_APPEND, MAY_WRITE must also be set in @mask.
  */
 int inode_permission(struct inode *inode, int mask)
 {
-- 
1.7.0.4
