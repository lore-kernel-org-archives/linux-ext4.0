From: Shen Feng <shen@cn.fujitsu.com>
Subject: [PATCH] ext4: remove double definitions of xattr macros
Date: Fri, 23 May 2008 17:28:59 +0800
Message-ID: <48368E5B.7010909@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:56539 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757785AbYEWJbf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 23 May 2008 05:31:35 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

remove the definitions of macros:
XATTR_TRUSTED_PREFIX
XATTR_USER_PREFIX
since they are defined in linux/xattr.h

Signed-off-by: Shen Feng <shen@cn.fujitsu.com>
---
 fs/ext4/xattr_trusted.c |    4 +---
 fs/ext4/xattr_user.c    |    4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/xattr_trusted.c b/fs/ext4/xattr_trusted.c
index fff3338..ac1a52c 100644
--- a/fs/ext4/xattr_trusted.c
+++ b/fs/ext4/xattr_trusted.c
@@ -13,13 +13,11 @@
 #include "ext4.h"
 #include "xattr.h"

-#define XATTR_TRUSTED_PREFIX "trusted."
-
 static size_t
 ext4_xattr_trusted_list(struct inode *inode, char *list, size_t list_size,
 			const char *name, size_t name_len)
 {
-	const size_t prefix_len = sizeof(XATTR_TRUSTED_PREFIX)-1;
+	const size_t prefix_len = XATTR_TRUSTED_PREFIX_LEN;
 	const size_t total_len = prefix_len + name_len + 1;

 	if (!capable(CAP_SYS_ADMIN))
diff --git a/fs/ext4/xattr_user.c b/fs/ext4/xattr_user.c
index 67be723..d91aa61 100644
--- a/fs/ext4/xattr_user.c
+++ b/fs/ext4/xattr_user.c
@@ -12,13 +12,11 @@
 #include "ext4.h"
 #include "xattr.h"

-#define XATTR_USER_PREFIX "user."
