From: Shen Feng <shen@cn.fujitsu.com>
Subject: [PATCH 1/3] reiserfs: remove double definitions of xattr macros
Date: Thu, 29 May 2008 10:09:12 +0800
Message-ID: <483E1048.6070307@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>, cmm@us.ibm.com,
	reiserfs-dev@namesys.com, reiserfs-devel@vger.kernel.org
To: linux-ext4@vger.kernel.org
Return-path: <reiserfs-devel-owner@vger.kernel.org>
Sender: reiserfs-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

remove the definitions of macros:
XATTR_SECURITY_PREFIX
XATTR_TRUSTED_PREFIX
XATTR_USER_PREFIX
since they are defined in linux/xattr.h

Signed-off-by: Shen Feng <shen@cn.fujitsu.com>
Signed-off-by: Mingming Cao <cmm@us.ibm.com>
---
 fs/reiserfs/xattr_security.c |    2 --
 fs/reiserfs/xattr_trusted.c  |    2 --
 fs/reiserfs/xattr_user.c     |    2 --
 3 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/fs/reiserfs/xattr_security.c b/fs/reiserfs/xattr_security.c
index 5e90a95..056008d 100644
--- a/fs/reiserfs/xattr_security.c
+++ b/fs/reiserfs/xattr_security.c
@@ -6,8 +6,6 @@
 #include <linux/reiserfs_xattr.h>
 #include <asm/uaccess.h>
 
-#define XATTR_SECURITY_PREFIX "security."
-
 static int
 security_get(struct inode *inode, const char *name, void *buffer, size_t size)
 {
diff --git a/fs/reiserfs/xattr_trusted.c b/fs/reiserfs/xattr_trusted.c
index 024a938..60abe2b 100644
--- a/fs/reiserfs/xattr_trusted.c
+++ b/fs/reiserfs/xattr_trusted.c
@@ -7,8 +7,6 @@
 #include <linux/reiserfs_xattr.h>
 #include <asm/uaccess.h>
 
-#define XATTR_TRUSTED_PREFIX "trusted."
-
 static int
 trusted_get(struct inode *inode, const char *name, void *buffer, size_t size)
 {
diff --git a/fs/reiserfs/xattr_user.c b/fs/reiserfs/xattr_user.c
index 073f393..1384efc 100644
--- a/fs/reiserfs/xattr_user.c
+++ b/fs/reiserfs/xattr_user.c
@@ -10,8 +10,6 @@
 # include <linux/reiserfs_acl.h>
 #endif
 
-#define XATTR_USER_PREFIX "user."
-
 static int
 user_get(struct inode *inode, const char *name, void *buffer, size_t size)
 {
-- 
1.5.4.5
