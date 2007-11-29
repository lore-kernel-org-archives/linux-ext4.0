From: akpm@linux-foundation.org
Subject: [patch 6/8] ext4/super.c: fix #ifdef's
Date: Thu, 29 Nov 2007 12:52:51 -0800
Message-ID: <200711292052.lATKqqIm006840@imap1.linux-foundation.org>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org,
	akpm@linux-foundation.org, bunk@kernel.org, rpjday@mindspring.com
To: cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55910 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759521AbXK2UyT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 29 Nov 2007 15:54:19 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Adrian Bunk <bunk@kernel.org>

Fix the names of two variables in #ifdef's.

Based on a report by Robert P. J. Day.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/super.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/ext4/super.c~ext4-superc-fix-ifdefs fs/ext4/super.c
--- a/fs/ext4/super.c~ext4-superc-fix-ifdefs
+++ a/fs/ext4/super.c
@@ -709,7 +709,7 @@ static int ext4_show_options(struct seq_
 		seq_puts(seq, ",debug");
 	if (test_opt(sb, OLDALLOC))
 		seq_puts(seq, ",oldalloc");
-#ifdef CONFIG_EXT4_FS_XATTR
+#ifdef CONFIG_EXT4DEV_FS_XATTR
 	if (test_opt(sb, XATTR_USER))
 		seq_puts(seq, ",user_xattr");
 	if (!test_opt(sb, XATTR_USER) &&
@@ -717,7 +717,7 @@ static int ext4_show_options(struct seq_
 		seq_puts(seq, ",nouser_xattr");
 	}
 #endif
-#ifdef CONFIG_EXT4_FS_POSIX_ACL
+#ifdef CONFIG_EXT4DEV_FS_POSIX_ACL
 	if (test_opt(sb, POSIX_ACL))
 		seq_puts(seq, ",acl");
 	if (!test_opt(sb, POSIX_ACL) && (def_mount_opts & EXT4_DEFM_ACL))
_
