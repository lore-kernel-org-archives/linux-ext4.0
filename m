From: akpm@linux-foundation.org
Subject: - jbd2-debug-code-cleanup.patch removed from -mm tree
Date: Thu, 11 Oct 2007 20:00:41 -0700
Message-ID: <200710120300.l9C30fjB028971@imap1.linux-foundation.org>
To: jrs@us.ibm.com, linux-ext4@vger.kernel.org,
	mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47285 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754736AbXJLDA7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Oct 2007 23:00:59 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     JBD2: debug code cleanup
has been removed from the -mm tree.  Its filename was
     jbd2-debug-code-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: JBD2: debug code cleanup
From: Jose R. Santos <jrs@us.ibm.com>

JBD2: debug code cleanup.

Mostly stolen from akpm's JBD cleanup patch.

- use `#ifdef foo' instead of `#if defined(foo)'

- Make journal_enable_debug __read_mostly just for the heck of it

- Make jbd_debugfs_dir and jbd_debug static

- debugfs_remove(NULL) is legal: remove unneeded tests

- remove unnecessary empty loops

Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN fs/jbd2/journal.c~jbd2-debug-code-cleanup fs/jbd2/journal.c
--- a/fs/jbd2/journal.c~jbd2-debug-code-cleanup
+++ a/fs/jbd2/journal.c
@@ -2199,16 +2199,14 @@ void jbd2_journal_put_journal_head(struc
 /*
  * debugfs tunables
  */
-#if defined(CONFIG_JBD2_DEBUG)
-u8 jbd2_journal_enable_debug;
+#ifdef CONFIG_JBD2_DEBUG
+u8 jbd2_journal_enable_debug __read_mostly;
 EXPORT_SYMBOL(jbd2_journal_enable_debug);
-#endif
-
-#if defined(CONFIG_JBD2_DEBUG) && defined(CONFIG_DEBUG_FS)
 
 #define JBD2_DEBUG_NAME "jbd2-debug"
 
-struct dentry *jbd2_debugfs_dir, *jbd2_debug;
+static struct dentry *jbd2_debugfs_dir;
+static struct dentry *jbd2_debug;
 
 static void __init jbd2_create_debugfs_entry(void)
 {
@@ -2221,24 +2219,18 @@ static void __init jbd2_create_debugfs_e
 
 static void __exit jbd2_remove_debugfs_entry(void)
 {
-	if (jbd2_debug)
-		debugfs_remove(jbd2_debug);
-	if (jbd2_debugfs_dir)
-		debugfs_remove(jbd2_debugfs_dir);
+	debugfs_remove(jbd2_debug);
+	debugfs_remove(jbd2_debugfs_dir);
 }
 
 #else
 
 static void __init jbd2_create_debugfs_entry(void)
 {
-	do {
-	} while (0);
 }
 
 static void __exit jbd2_remove_debugfs_entry(void)
 {
-	do {
-	} while (0);
 }
 
 #endif
_

Patches currently in -mm which might be from jrs@us.ibm.com are

ext4-flex_bg-kernel-support-v2.patch
jbd-config_jbd_debug-cannot-create-proc-entry.patch
jbd-config_jbd_debug-cannot-create-proc-entry-fix.patch
jbd-fix-jbd-warnings-when-compiling-with-config_jbd_debug.patch
