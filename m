From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V4 05/11] vfs: Add IS_RICHACL() test for richacl support
Date: Fri, 24 Sep 2010 18:18:08 +0530
Message-ID: <1285332494-12756-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1285332494-12756-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: aneesh.kumar@linux.vnet.ibm.com, linux-fsdevel@vger.kernel.org,
	nfsv4@linux-nfs.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: sfrench@us.ibm.com, ffilz@us.ibm.com, agruen@suse.de,
	adilger@sun.com, sandeen@redhat.com, tytso@mit.edu,
	bfields@citi.umich.edu, jlayton@redhat.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1285332494-12756-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Andreas Gruenbacher <agruen@suse.de>

Introduce a new MS_RICHACL super-block flag and a new IS_RICHACL() test
which file systems like nfs can use.  IS_ACL() is true if IS_POSIXACL()
or IS_RICHACL() is true.

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 include/linux/fs.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 485c697..d86e77c 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -208,6 +208,7 @@ struct inodes_stat_t {
 #define MS_KERNMOUNT	(1<<22) /* this is a kern_mount call */
 #define MS_I_VERSION	(1<<23) /* Update inode I_version field */
 #define MS_STRICTATIME	(1<<24) /* Always perform atime updates */
+#define MS_RICHACL	(1<<25) /* Supports richacls */
 #define MS_BORN		(1<<29)
 #define MS_ACTIVE	(1<<30)
 #define MS_NOUSER	(1<<31)
@@ -264,6 +265,7 @@ struct inodes_stat_t {
 #define IS_APPEND(inode)	((inode)->i_flags & S_APPEND)
 #define IS_IMMUTABLE(inode)	((inode)->i_flags & S_IMMUTABLE)
 #define IS_POSIXACL(inode)	__IS_FLG(inode, MS_POSIXACL)
+#define IS_RICHACL(inode)	__IS_FLG(inode, MS_RICHACL)
 
 #define IS_DEADDIR(inode)	((inode)->i_flags & S_DEAD)
 #define IS_NOCMTIME(inode)	((inode)->i_flags & S_NOCMTIME)
@@ -274,7 +276,7 @@ struct inodes_stat_t {
  * IS_ACL() tells the VFS to not apply the umask
  * and use iop->check_acl for acl permission checks when defined.
  */
-#define IS_ACL(inode)		__IS_FLG(inode, MS_POSIXACL)
+#define IS_ACL(inode)		__IS_FLG(inode, MS_POSIXACL | MS_RICHACL)
 
 /* the read-only stuff doesn't really belong here, but any other place is
    probably as bad and I don't want to create yet another include file. */
-- 
1.7.0.4

