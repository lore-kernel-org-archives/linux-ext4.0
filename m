From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [PATCH] JBD2: debug code cleanup.
Date: Thu, 27 Sep 2007 08:39:06 -0500
Message-ID: <20070927133906.11422.12001.stgit@toolssf2>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:55501 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755164AbXI0NmZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 27 Sep 2007 09:42:25 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Jose R. Santos <jrs@us.ibm.com>

JBD2: debug code cleanup.

Mostly stolen from akpm's JBD cleanup patch.

- use `#ifdef foo' instead of `#if defined(foo)'

- Make journal_enable_debug __read_mostly just for the heck of it

- Make jbd_debugfs_dir and jbd_debug static

- debugfs_remove(NULL) is legal: remove unneeded tests

- remove unnecessary empty loops

Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
--

 fs/jbd2/journal.c |   20 ++++++--------------
 1 files changed, 6 insertions(+), 14 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index f37324a..9a7187f 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1953,16 +1953,14 @@ void jbd2_journal_put_journal_head(struct journal_head *jh)
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
@@ -1975,24 +1973,18 @@ static void __init jbd2_create_debugfs_entry(void)
 
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
