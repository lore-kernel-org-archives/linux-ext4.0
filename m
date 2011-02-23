From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V5 06/24] vfs: Optimize out IS_RICHACL() if CONFIG_FS_RICHACL is not defined
Date: Wed, 23 Feb 2011 19:21:53 +0530
Message-ID: <1298469131-16555-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1298469131-16555-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: aneesh.kumar@linux.vnet.ibm.com, linux-fsdevel@vger.kernel.org,
	linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, Andreas Gruenbacher <agruen@suse.de>
To: sfrench@us.ibm.com, agruen@linbit.com, dilger.kernel@dilger.ca,
	sandeen@redhat.com, tytso@mit.edu, bfields@fieldses.org,
	jlayton@redhat.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1298469131-16555-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Andreas Gruenbacher <agruen@suse.de>

if CONFIG_FS_RICHACL is not defined optimize out
the ACL check function.

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/Kconfig         |    3 +++
 include/linux/fs.h |    5 +++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index 3db9caa..753b194 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -46,6 +46,9 @@ endif # BLOCK
 config FS_POSIX_ACL
 	def_bool n
 
+config FS_RICHACL
+	def_bool n
+
 config EXPORTFS
 	tristate
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index e542157..1dc6e72 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -273,7 +273,12 @@ struct inodes_stat_t {
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
1.7.1
