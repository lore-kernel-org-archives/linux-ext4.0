From: akpm@linux-foundation.org
Subject: + jbd2-debug-code-cleanup.patch added to -mm tree
Date: Thu, 27 Sep 2007 16:33:27 -0700
Message-ID: <200709272333.l8RNXRWh000861@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Cc: jrs@us.ibm.com, linux-ext4@vger.kernel.org
To: mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     JBD2: debug code cleanup
has been added to the -mm tree.  Its filename is
     jbd2-debug-code-cleanup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

jbd-config_jbd_debug-cannot-create-proc-entry.patch
jbd-config_jbd_debug-cannot-create-proc-entry-fix.patch
jbd-fix-jbd-warnings-when-compiling-with-config_jbd_debug.patch
ext4-flex_bg-kernel-support-v2.patch
jbd2-debug-code-cleanup.patch
