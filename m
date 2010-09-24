From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V4 06/11] vfs: Optimize out IS_RICHACL() if CONFIG_FS_RICHACL is not defined
Date: Fri, 24 Sep 2010 18:18:09 +0530
Message-ID: <1285332494-12756-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
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

if CONFIG_FS_RICHACL is not defined optimize out
the ACL check function.

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/Kconfig         |    4 ++++
 include/linux/fs.h |    5 +++++
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index 3d18530..cd283dc 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -39,6 +39,10 @@ config FS_POSIX_ACL
 	bool
 	default n
 
+config FS_RICHACL
+	bool
+	default n
+
 source "fs/xfs/Kconfig"
 source "fs/gfs2/Kconfig"
 source "fs/ocfs2/Kconfig"
diff --git a/include/linux/fs.h b/include/linux/fs.h
index d86e77c..26fc8ae 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -265,7 +265,12 @@ struct inodes_stat_t {
 #define IS_APPEND(inode)	((inode)->i_flags & S_APPEND)
 #define IS_IMMUTABLE(inode)	((inode)->i_flags & S_IMMUTABLE)
 #define IS_POSIXACL(inode)	__IS_FLG(inode, MS_POSIXACL)
+
+#ifdef CONFIG_FS_RICHACL
 #define IS_RICHACL(inode)	__IS_FLG(inode, MS_RICHACL)
+#else
+#define IS_RICHACL(inode)	0
+#endif
 
 #define IS_DEADDIR(inode)	((inode)->i_flags & S_DEAD)
 #define IS_NOCMTIME(inode)	((inode)->i_flags & S_NOCMTIME)
-- 
1.7.0.4
