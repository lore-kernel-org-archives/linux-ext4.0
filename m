From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/4] e2fsck: fix build under dietlibc
Date: Fri, 19 Sep 2014 01:50:56 -0400
Message-ID: <1411105858-21120-2-git-send-email-tytso@mit.edu>
References: <1411105858-21120-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:36941 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755565AbaISFvE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Sep 2014 01:51:04 -0400
In-Reply-To: <1411105858-21120-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The asm_types.h file needs to include stdio.h and stdlib.h in order to
get integer types included.  So add those includes into jfs_user.h to
avoid a build faliure under dietlibc.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 e2fsck/jfs_user.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/e2fsck/jfs_user.h b/e2fsck/jfs_user.h
index adb8ae9..cbc14e8 100644
--- a/e2fsck/jfs_user.h
+++ b/e2fsck/jfs_user.h
@@ -12,6 +12,8 @@
 #define _JFS_USER_H
 
 #ifdef DEBUGFS
+#include <stdio.h>
+#include <stdlib.h>
 #if EXT2_FLAT_INCLUDES
 #include "ext2_fs.h"
 #include "ext2fs.h"
-- 
2.1.0

