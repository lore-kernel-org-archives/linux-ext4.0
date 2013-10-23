From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] Fix noquota build
Date: Wed, 23 Oct 2013 12:53:08 -0400
Message-ID: <1382547188-30578-1-git-send-email-tytso@mit.edu>
References: <5267F952.5040402@redhat.com>
Cc: sandeen@redhat.com, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49767 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751849Ab3JWQxY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Oct 2013 12:53:24 -0400
In-Reply-To: <5267F952.5040402@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We need to build libquota even if the quota code is disabled.  This
fixes a build regression introduced by commit 43075b42bd: 'quota: fix
disabling quota, add quota tests".

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 Makefile.in | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile.in b/Makefile.in
index 95cbf1b..ef79482 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -26,7 +26,7 @@ export CHECK_CMD
 @DEBUGFS_CMT@DEBUGFS_DIR= debugfs
 @UUID_CMT@UUID_LIB_SUBDIR= lib/uuid
 @BLKID_CMT@BLKID_LIB_SUBDIR= lib/blkid
-@QUOTA_CMT@QUOTA_LIB_SUBDIR= lib/quota
+QUOTA_LIB_SUBDIR= lib/quota
 
 LIB_SUBDIRS=lib/et lib/ss lib/e2p $(UUID_LIB_SUBDIR) lib/ext2fs $(BLKID_LIB_SUBDIR) $(QUOTA_LIB_SUBDIR) intl
 PROG_SUBDIRS=e2fsck $(DEBUGFS_DIR) misc $(RESIZE_DIR) tests/progs po
-- 
1.7.12.rc0.22.gcdd159b

