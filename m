From: Shen Feng <shen@cn.fujitsu.com>
Subject: [PATCH 2/3] ext2: remove double definitions of xattr macros
Date: Thu, 29 May 2008 10:10:44 +0800
Message-ID: <483E10A4.6080303@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org, cmm@us.ibm.com,
	Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:54313 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751150AbYE2CNV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 28 May 2008 22:13:21 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

remove the definitions of macros:
XATTR_TRUSTED_PREFIX
XATTR_USER_PREFIX
since they are defined in linux/xattr.h

Signed-off-by: Shen Feng <shen@cn.fujitsu.com>
Signed-off-by: Mingming Cao <cmm@us.ibm.com>
---
 fs/ext2/xattr_security.c |    2 +-
 fs/ext2/xattr_trusted.c  |    4 +---
 fs/ext2/xattr_user.c     |    4 +---
 3 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/fs/ext2/xattr_security.c b/fs/ext2/xattr_security.c
index eaa23d2..70c0dbd 100644
--- a/fs/ext2/xattr_security.c
+++ b/fs/ext2/xattr_security.c
@@ -14,7 +14,7 @@ static size_t
 ext2_xattr_security_list(struct inode *inode, char *list, size_t list_size,
 			 const char *name, size_t name_len)
 {
-	const int prefix_len = sizeof(XATTR_SECURITY_PREFIX)-1;
+	const int prefix_len = XATTR_SECURITY_PREFIX_LEN;
 	const size_t total_len = prefix_len + name_len + 1;
 
 	if (list && total_len <= list_size) {
diff --git a/fs/ext2/xattr_trusted.c b/fs/ext2/xattr_trusted.c
index 83ee149..e8219f8 100644
--- a/fs/ext2/xattr_trusted.c
+++ b/fs/ext2/xattr_trusted.c
@@ -12,13 +12,11 @@
 #include <linux/ext2_fs.h>
 #include "xattr.h"
 
-#define XATTR_TRUSTED_PREFIX "trusted."
-
 static size_t
 ext2_xattr_trusted_list(struct inode *inode, char *list, size_t list_size,
 			const char *name, size_t name_len)
 {
-	const int prefix_len = sizeof(XATTR_TRUSTED_PREFIX)-1;
+	const int prefix_len = XATTR_TRUSTED_PREFIX_LEN;
 	const size_t total_len = prefix_len + name_len + 1;
 
 	if (!capable(CAP_SYS_ADMIN))
diff --git a/fs/ext2/xattr_user.c b/fs/ext2/xattr_user.c
index f383e7c..92495d2 100644
--- a/fs/ext2/xattr_user.c
+++ b/fs/ext2/xattr_user.c
@@ -11,13 +11,11 @@
 #include "ext2.h"
 #include "xattr.h"
 
-#define XATTR_USER_PREFIX "user."
